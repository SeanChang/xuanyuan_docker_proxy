# 服务器没有桌面？Docker 跑个 Chrome，浏览器就能远程用

![服务器没有桌面？Docker 跑个 Chrome，浏览器就能远程用](https://img.xuanyuan.dev/docker/blog/docker-linuxserver-chrome.png)

*分类: linuxserver,chrome,远程浏览器,Docker部署,端口冲突 | 标签: linuxserver,chrome,远程浏览器,Docker部署,端口冲突 | 发布时间: 2026-06-16 03:02:27*

> 手把手教你用轩辕镜像拉取 linuxserver/chrome，docker run 启动远程 Chrome，并解决 3000 端口占用问题。

云服务器、VPS、家里的小主机——很多时候只有 SSH，没有图形桌面。但你可能仍然需要：调试一个网页、登录只能内网访问的管理后台、在隔离环境里随便浏览、或者给自动化测试准备一个标准 Chrome 环境。

这时候，[linuxserver/chrome](https://xuanyuan.cloud/zh/r/linuxserver/chrome) 就派上用场了。它是 LinuxServer.io 团队维护的 Docker 镜像，在容器里跑完整的 Google Chrome，并通过 Web 界面远程操作——不用装桌面环境，打开浏览器就能用。

本文基于真实部署过程，手把手带你完成：**镜像拉取 → 容器启动 → 浏览器访问 → 端口冲突排查**。全程可复制命令，踩过的坑也一并说明。

---

## 一、镜像拉取

先通过轩辕镜像加速拉取（国内速度更稳）：

```bash
docker pull docker.xuanyuan.run/linuxserver/chrome:latest
```

拉取成功后，终端会显示各 Layer 下载完成，并输出镜像摘要（Digest）：

![通过轩辕镜像拉取chrome镜像](https://img.xuanyuan.dev/docker/blog/docker-linuxserver-chrome-4.png)

想提前了解环境变量、端口说明、GPU 加速等配置？可以打开 [linuxserver/chrome 中文镜像页](https://xuanyuan.cloud/zh/r/linuxserver/chrome)，里面有完整的中文文档和一键拉取命令。

**这个镜像适合什么场景？**

- 远程浏览器：在无桌面服务器上跑 Chrome，浏览器访问即可操作
- 自动化测试：提供标准化的 Chrome 环境
- 隔离浏览：在容器沙箱里访问网页，与宿主机隔离
- 开发调试：临时需要一个完整浏览器，又不想装桌面

---

## 二、一键启动容器

创建配置目录（用于持久化 Chrome 用户数据和设置）：

```bash
mkdir -p /opt/chrome/config
```

执行以下 `docker run` 命令启动：

```bash
docker run -d \
  --name=chrome \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e LC_ALL=zh_CN.UTF-8 \
  -e CUSTOM_USER=admin \
  -e PASSWORD=你的强密码 \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /opt/chrome/config:/config \
  --shm-size=1gb \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/chrome:latest
```

### 关键参数说明

| 参数 | 作用 |
|------|------|
| `-p 3000:3000` | HTTP 端口（一般需反向代理，日常访问建议用 3001） |
| `-p 3001:3001` | **HTTPS 端口，推荐用这个访问远程 Chrome** |
| `-v /opt/chrome/config:/config` | 持久化配置、书签、登录状态等 |
| `--shm-size=1gb` | 共享内存，看 YouTube 等站点建议设置，避免页面卡死 |
| `PUID` / `PGID` | 与宿主机用户 ID 一致，避免卷权限问题（用 `id` 命令查看） |
| `TZ=Asia/Shanghai` | 时区设为国内 |
| `LC_ALL=zh_CN.UTF-8` | 中文界面 |
| `CUSTOM_USER` / `PASSWORD` | 启用 HTTP 基本认证，**强烈建议设置** |

> **权限提示**：如果 `/opt/chrome/config` 出现权限问题，执行 `sudo chown -R 1000:1000 /opt/chrome/config`（将 1000 换成你的 PUID/PGID）。

可选：指定 Chrome 启动时打开的网页：

```bash
-e CHROME_CLI=https://www.baidu.com
```

---

## 三、浏览器访问远程 Chrome

容器启动后，在本机浏览器打开：

```
https://你的服务器IP:3001/
```

首次访问浏览器可能提示「连接不安全」（自签名证书），选择「继续访问」即可。若设置了 `CUSTOM_USER` 和 `PASSWORD`，会弹出登录框——输入后即可看到 Chrome 桌面。

![浏览器访问远程 Chrome 桌面，登录界面](https://img.xuanyuan.dev/docker/blog/docker-linuxserver-chrome-1.png)

![浏览器访问远程 Chrome 桌面，浏览器打开界面](https://img.xuanyuan.dev/docker/blog/docker-linuxserver-chrome-2.png)

![浏览器访问远程 Chrome 桌面，搜索结果界面](https://img.xuanyuan.dev/docker/blog/docker-linuxserver-chrome-3.png)

**常用运维命令：**

```bash
docker ps                  # 确认容器在运行
docker logs -f chrome      # 查看启动日志
docker exec -it chrome /bin/bash   # 进入容器 Shell
```

---

## 四、踩坑实录：3000 端口被占用

按上面的命令启动时，你可能遇到这样的报错：

```
docker: Error response from daemon: failed to set up container networking:
driver failed programming external connectivity on endpoint chrome (...):
failed to bind host port 0.0.0.0:3000/tcp: address already in use
```

意思是宿主机的 **3000 端口已被其他程序占用**（常见是 Node 服务、Grafana、其他 Web 应用等）。容器虽然创建了，但网络没绑成功，实际上并没有正常运行。

### 排查占用

```bash
sudo ss -tlnp | grep :3000
# 或
sudo lsof -i :3000
```

同时建议检查 3001 是否也被占用：

```bash
sudo ss -tlnp | grep :3001
```

### 解决方案：换宿主机端口（推荐）

删掉失败的容器，把端口映射改成未占用的端口，例如 `13000` 和 `13001`：

```bash
docker rm -f chrome

docker run -d \
  --name=chrome \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e LC_ALL=zh_CN.UTF-8 \
  -e CUSTOM_USER=admin \
  -e PASSWORD=你的强密码 \
  -p 13000:3000 \
  -p 13001:3001 \
  -v /opt/chrome/config:/config \
  --shm-size=1gb \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/chrome:latest
```

访问地址改为：

```
https://你的服务器IP:13001/
```

若从外网访问，记得在防火墙放行对应端口：

```bash
sudo ufw allow 13001/tcp
```

---

## 五、安全提醒

linuxserver/chrome 功能强大，但安全配置不能省：

1. **默认无密码时不要暴露到公网**。至少设置 `CUSTOM_USER` + `PASSWORD`。
2. **Web 界面内含终端**，有 GUI 访问权限的用户可在容器内获得较高权限，不要给不可信的人开放。
3. **完整功能需要 HTTPS**。现代 Web API（如 WebCodecs）在 HTTP 下可能不可用，所以优先用 3001（或映射后的 HTTPS 端口）。
4. **公网部署建议**放在 Nginx、Caddy 等反向代理后面，并配置更强的认证机制。

更多安全说明见 [linuxserver/chrome 镜像文档](https://xuanyuan.cloud/zh/r/linuxserver/chrome)。

---

## 六、延伸阅读

- [linuxserver/chrome 中文镜像页](https://xuanyuan.cloud/zh/r/linuxserver/chrome) — 环境变量、GPU 加速、Docker Compose 示例
- [Docker Run 在线助手](https://xuanyuan.cloud/docker/run) — 选镜像、配端口/环境变量，自动生成 `docker run` 命令
- 相关镜像：`browserless/chrome`（无头 Chrome，适合截图和自动化）、`linuxserver/firefox`（Firefox 远程浏览器版）

---

## 总结

三步搞定远程 Chrome：

1. **拉取**：`docker pull docker.xuanyuan.run/linuxserver/chrome:latest`
2. **运行**：`docker run` 映射 3001 端口，挂载 `/config`，设置密码
3. **访问**：浏览器打开 `https://服务器IP:端口/`

端口冲突时，换一组宿主机端口（如 `13001:3001`）即可，不必和 3000 死磕。

更多 Docker 镜像的中文文档、部署教程和在线工具，欢迎访问 [轩辕镜像](https://xuanyuan.cloud)。


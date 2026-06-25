# 10 分钟上手 OpenCode：Docker 一键部署，浏览器里用 AI 写代码

![10 分钟上手 OpenCode：Docker 一键部署，浏览器里用 AI 写代码](https://img.xuanyuan.dev/docker/blog/opencode.png)

*分类: OpenCode,人工智能,AI,AI编程 | 标签: OpenCode,Docker,轩辕镜像,AI编程,openEuler,WSL | 发布时间: 2026-06-21 16:38:36*

> 零基础教程：Docker 一键安装、轩辕镜像加速拉取 openeuler/opencode、Web 部署、打开项目、AI 生成 hello-world 主页。含 WSL 与 Linux 服务器差异说明与常见问题排错。

*基于 [openeuler/opencode](https://xuanyuan.cloud/zh/r/openeuler/opencode) 镜像，WSL 与 Linux 服务器双场景实测*

想在浏览器里用 AI 帮你写代码、改项目？**OpenCode** 是一款开源 AI 编码代理，支持终端 TUI、Web 界面和 IDE 扩展等多种使用方式。本文带你完成一次完整的 **OpenCode Docker 部署**：从环境准备到在浏览器里用自然语言生成第一个 hello-world 主页，全程约 10 分钟，零基础可跟做。

关于 OpenCode 的更多能力，请参阅 [OpenCode 中文文档](https://opencode.ai/docs/zh-cn)。国内用户拉取官方镜像（如 `ghcr.io/anomalyco/opencode`）可能较慢或超时，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速的 [openeuler/opencode](https://xuanyuan.cloud/zh/r/openeuler/opencode)——由 openEuler 基础设施 SIG 维护，经 `docker.xuanyuan.run` 提供 Docker 镜像加速，下文命令均已实测通过。

---

## 一、环境准备：Docker 一键安装

开始之前，请确保机器上已安装 Docker。若尚未安装，可使用轩辕镜像提供的一键脚本（适用于 Linux 及常见国内云服务器）：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

安装完成后，执行以下命令验证：

```bash
docker --version
docker compose version
```

若本机已有 Docker，可跳过此步。更多安装与镜像加速配置，可参考 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 二、拉取 OpenCode 镜像

使用轩辕镜像加速域拉取 `openeuler/opencode` 最新版：

```bash
docker pull docker.xuanyuan.run/openeuler/opencode:latest
```

成功时终端会显示类似输出：

```
Status: Downloaded newer image for docker.xuanyuan.run/openeuler/opencode:latest
```

对应官方源与轩辕镜像页如下（二者为**不同仓库**，请勿混用）：

| 官方镜像 | 仓库类型 | 轩辕镜像加速拉取 | 镜像说明 |
|----------|----------|------------------|----------|
| `openeuler/opencode` | Docker Hub | `docker pull docker.xuanyuan.run/openeuler/opencode:latest` | [openeuler/opencode](https://xuanyuan.cloud/zh/r/openeuler/opencode) |
| `ghcr.io/anomalyco/opencode` | GitHub Container Registry（GHCR） | `docker pull ***-ghcr.xuanyuan.run/anomalyco/opencode:latest` | [ghcr.io/anomalyco/opencode](https://xuanyuan.cloud/ghcr.io/anomalyco/opencode) |

本文采用 Docker Hub 的 **openeuler/opencode**（由 openEuler 基础设施 SIG 维护，基于 openEuler），支持通过挂载配置目录实现数据持久化。若你更习惯 OpenCode 官方 GHCR 镜像，可改用上表第二行的拉取命令，部署步骤与下文相同。

---

## 三、创建目录并启动容器

### 3.1 准备持久化目录

OpenCode 需要三类数据：项目代码、配置文件、API Key 与会话数据。建议统一放在同一父目录下：

```bash
sudo mkdir -p /www/wwwroot/opencode/{workspace,config,data}
sudo mkdir -p /www/wwwroot/opencode/workspace/my-testapp
```

> **踩坑提示**：若出现 `mkdir: Permission denied`，说明当前用户对 `/www` 无写权限，需加 `sudo`。创建完成后，建议执行 `sudo chown -R $USER:$USER /www/wwwroot/opencode/workspace`，方便后续直接编辑项目文件。若不想使用 `/www`，也可改为 `$HOME/opencode/{workspace,config,data}`，下文路径同步替换即可。

### 3.2 启动 Web 服务

以 **Web 模式**在后台运行 OpenCode，并绑定 `0.0.0.0` 以便局域网或远程访问：

```bash
docker run -d \
  --name opencode \
  --restart unless-stopped \
  -p 4096:4096 \
  -v /www/wwwroot/opencode/workspace:/workspace \
  -v /www/wwwroot/opencode/config:/root/.config/opencode \
  -v /www/wwwroot/opencode/data:/root/.local/share/opencode \
  -e OPENCODE_SERVER_PASSWORD='请改为强密码' \
  -e OPENCODE_SERVER_USERNAME='opencode' \
  docker.xuanyuan.run/openeuler/opencode:latest \
  web --hostname 0.0.0.0 --port 4096
```

各参数说明如下：

| 配置 | 说明 |
|------|------|
| `workspace → /workspace` | 项目代码目录，容器内「打开项目」的路径前缀 |
| `config` | OpenCode 配置文件 |
| `data` | API Key、会话数据（含 `auth.json`） |
| `--hostname 0.0.0.0` | **必须添加**，否则服务只监听 127.0.0.1，局域网无法访问 |
| `OPENCODE_SERVER_PASSWORD` | HTTP 基础认证密码，公网或局域网部署务必设为强密码 |

### 3.3 验证启动状态

```bash
docker logs opencode
docker ps | grep opencode
```

日志中应出现 OpenCode ASCII Logo 以及 `Local access: http://localhost:4096`，表示服务已正常启动。

### 3.4 WSL 与 Linux 服务器的差异

部署命令完全相同，差异主要体现在访问方式和网络配置上：

| 项目 | WSL2（本文实测环境） | Linux 服务器 |
|------|------------------------|--------------|
| 本机访问 | `http://localhost:4096` 或 `http://127.0.0.1:4096` | 同左 |
| 局域网 / 远程访问 | 一般使用 localhost 即可；WSL2 端口会自动转发到 Windows | 使用 `http://服务器IP:4096`，需 `--hostname 0.0.0.0` |
| 防火墙 | 通常无需额外配置 | 执行 `ufw allow 4096`，或在宝塔 / 云安全组中放行 |
| 访问超时排错 | 检查容器是否 Up、端口是否正确映射 | 同上，另需检查云厂商安全组 |
| 预览 HTML 页面 | `explorer.exe index.html` 或 `python3 -m http.server` | `python3 -m http.server` 或 Nginx |

---

## 四、访问 Web 界面并登录

在浏览器中打开对应地址：

- **WSL / 本机**：`http://localhost:4096`
- **Linux 服务器**：`http://你的服务器IP:4096`

首次访问会弹出 HTTP 基础认证对话框，输入环境变量中配置的用户名（默认 `opencode`）和密码。

![OpenCode 登录认证](https://img.xuanyuan.dev/docker/blog/opencode-1.png)

*图 1：首次访问需输入 HTTP 基础认证的用户名与密码*

登录成功后进入 OpenCode 控制台。若首页显示「未找到会话」，说明尚未打开项目或创建会话，属于正常现象。

![OpenCode 控制台首页](https://img.xuanyuan.dev/docker/blog/opencode-2.png)

*图 2：登录后首页显示「未找到会话」，表示尚未创建项目或会话*

---

## 五、打开项目

在 OpenCode 中，「项目」指的是磁盘上的**代码目录**，而非 IDE 式的空工程向导。按以下步骤打开我们在上一节创建的测试目录：

1. 点击左上角 **「+」**，或左侧 **「项目」** 旁的文件夹加号图标，也可使用快捷键 `Ctrl+O`
2. 在「打开项目」对话框中，**手动输入**绝对路径：`/workspace/my-testapp`
3. 在搜索结果中选中 `/workspace/my-testapp/` 并确认

> **为什么必须手输路径？** Docker 挂载的 `/workspace` 目录经常不会出现在浏览列表中（社区已知行为），直接输入绝对路径是最可靠的方式。

可用以下命令确认目录已在容器内正确挂载：

```bash
docker exec opencode ls -la /workspace/my-testapp
```

![打开项目对话框](https://img.xuanyuan.dev/docker/blog/opencode-3.png)

*图 3：在搜索框输入 `/workspace/my-testapp` 并选择对应目录*

---

## 六、选择 AI 模型并新建会话

项目打开后，先选择 AI 模型，再新建会话开始对话。

1. 点击模型选择入口（界面下拉或设置菜单）
2. 新手可先使用内置**免费模型**，如 **Big Pickle**、**MiMo V2.5 Free**、**DeepSeek V4 Flash Free**（以界面实际列表为准）
3. 若有付费 API Key，可在设置中通过 `/connect` 接入 [OpenCode Zen](https://opencode.ai/docs/zh-cn) 等提供商
4. 点击 **「+」** 新建会话，确认底部显示当前项目为 `my-testapp`

![选择 AI 模型](https://img.xuanyuan.dev/docker/blog/opencode-7.png)

*图 4：OpenCode 内置多款免费模型，新手可先选 Big Pickle 或 MiMo V2.5*

![新建会话界面](https://img.xuanyuan.dev/docker/blog/opencode-5.png)

*图 5：新建会话后，底部显示当前工作项目 my-testapp*

---

## 七、用 AI 生成第一个页面

在会话输入框中，用自然语言描述你的需求。本文示例：

```
新建一个 html 个人主页项目，页面上只有一行大字：hello-world
```

发送后，OpenCode 会显示「写入 index.html」「思考中」等状态，右侧「审查」面板可实时查看文件变更。你也可以选择「创建 Git 仓库」来跟踪后续修改。

![输入 AI 需求](https://img.xuanyuan.dev/docker/blog/opencode-6.png)

*图 6：用自然语言描述需求，OpenCode 自动创建并写入文件*

![AI 写入代码](https://img.xuanyuan.dev/docker/blog/opencode-8.png)

*图 7：AI 执行「写入 index.html」，右侧审查面板展示变更*

稍等片刻，AI 会提示生成完成：`index.html 是一个全屏居中展示 "hello-world" 大字效果的简单个人主页。`

![生成完成](https://img.xuanyuan.dev/docker/blog/opencode-9.png)

*图 8：生成完成，会话中确认 index.html 已创建*

> **进阶提示**：在项目目录中运行 `/init`，OpenCode 会分析项目结构并生成 `AGENTS.md` 文件，帮助 AI 更好地理解你的代码库。详见 [官方初始化说明](https://opencode.ai/docs/zh-cn)。

---

## 八、在浏览器预览 HTML

需要特别说明的是：**OpenCode 是 AI 编程环境，不是静态网站服务器**，它不会自动托管你的 HTML 文件。要在浏览器中看到页面效果，需要单独启动预览。

**WSL 用户**（任选其一）：

```bash
cd /www/wwwroot/opencode/workspace/my-testapp
python3 -m http.server 8080
```

浏览器访问 `http://localhost:8080` 即可。也可以直接执行 `explorer.exe index.html`，用 Windows 默认浏览器打开文件。

**Linux 服务器用户**：

```bash
cd /www/wwwroot/opencode/workspace/my-testapp
python3 -m http.server 8080 --bind 0.0.0.0
```

通过 `http://服务器IP:8080` 访问（需在防火墙中放行 8080 端口）。

![hello-world 预览效果](https://img.xuanyuan.dev/docker/blog/opencode-10.png)

*图 9：浏览器中全屏居中显示的 hello-world 个人主页*

---

## 九、常见问题

**Q1：`mkdir: Permission denied` 怎么办？**

`/www` 目录需要 root 权限创建，请加 `sudo`；或改用 `$HOME/opencode` 作为挂载根目录，避免权限问题。

**Q2：局域网访问 `http://192.168.x.x:4096` 超时？**

依次检查：① 启动命令是否包含 `web --hostname 0.0.0.0`；② `docker ps` 中端口是否为 `0.0.0.0:4096->4096/tcp`；③ 服务器防火墙、宝塔面板或云安全组是否放行 4096 端口；④ 容器是否处于 Running 状态。

**Q3：打开项目时找不到目录？**

在对话框中手输 `/workspace/项目名`；同时用 `docker exec opencode ls /workspace` 确认目录确实存在。

**Q4：创建了 my-testapp 但 `cd my-app` 失败？**

目录名需保持一致，本文示例使用的是 **my-testapp**，不是 my-app。

**Q5：`sudo cd` 报 command not found？**

`cd` 是 shell 内置命令，不能作为独立程序执行。可改用 `sudo -s` 进入 root shell，或始终使用绝对路径操作文件。

**Q6：如何更新 OpenCode 镜像？**

```bash
docker pull docker.xuanyuan.run/openeuler/opencode:latest
docker stop opencode && docker rm opencode
# 然后重新执行 docker run（volume 挂载的数据会保留）
```

**Q7：API Key 存在哪里？**

保存在挂载的 `data` 目录中，容器重建后不会丢失。可通过 Web 设置界面或对话中的 `/connect` 命令配置。

---

## 附录：使用 docker-compose 管理

若需要频繁启停容器，或在团队中统一部署方式，可以使用 docker-compose 替代较长的 `docker run` 命令。在 `/www/wwwroot/opencode/` 目录下创建 `docker-compose.yml`：

```yaml
services:
  opencode:
    image: docker.xuanyuan.run/openeuler/opencode:latest
    container_name: opencode
    restart: unless-stopped
    ports:
      - "4096:4096"
    volumes:
      - ./workspace:/workspace
      - ./config:/root/.config/opencode
      - ./data:/root/.local/share/opencode
    environment:
      OPENCODE_SERVER_USERNAME: opencode
      OPENCODE_SERVER_PASSWORD: 请改为强密码
    command: web --hostname 0.0.0.0 --port 4096
```

启动与管理：

```bash
cd /www/wwwroot/opencode
docker compose up -d
docker compose logs -f
docker compose down   # 停止容器，volume 数据不会丢失
```

配置与 `docker run` 完全等价，但更便于版本控制和重复部署。

---

## 总结

本文完成了 OpenCode 从 Docker 环境准备到第一个 AI 项目的完整流程：

- 使用轩辕镜像一键安装 Docker，加速拉取 `openeuler/opencode` 镜像
- 以 Web 模式部署 OpenCode，在浏览器中获得 AI 编程助手
- 挂载 workspace 目录，手输路径打开项目
- 用自然语言生成 hello-world 主页，并独立预览 HTML 效果

**延伸阅读：**

- [OpenCode 中文文档](https://opencode.ai/docs/zh-cn)
- [OpenCode Web 模式](https://opencode.ai/docs/web)
- [openeuler/opencode 镜像页](https://xuanyuan.cloud/zh/r/openeuler/opencode)
- [Docker 一键安装脚本](https://xuanyuan.cloud/docker.sh)

如果你在拉取 Docker 镜像时遇到速度慢、超时等问题，可以试试 [轩辕镜像](https://xuanyuan.cloud) 的加速服务；镜像页支持一键复制拉取命令，也提供镜像助手等工具方便排查。欢迎收藏 [openeuler/opencode](https://xuanyuan.cloud/zh/r/openeuler/opencode) 镜像页，获取最新标签与更新说明。



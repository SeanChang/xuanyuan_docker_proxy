# Docker 部署 IT Tools：轻松搭建开发者在线工具箱平台

![Docker 部署 IT Tools：轻松搭建开发者在线工具箱平台](https://img.xuanyuan.dev/docker/blog/it-tools.webp)

*分类: Docker部署教程 | 标签: IT Tools,Docker,轩辕镜像,开发者工具,在线工具箱,私有化部署,部署教程 | 发布时间: 2026-08-05 04:23:35*

> 写代码、查接口、改配置时，经常要临时算哈希、加解密一段文本、美化 SQL / YAML / JSON、生成 UUID 或二维码。很多人随手打开搜索引擎里的「在线工具」：站点一多难记，更麻烦的是 Token、密钥、内网 URL 一旦贴进公网页，等于把敏感串交给未知第三方。

*本文基于 [corentinth/it-tools:latest](https://xuanyuan.cloud/zh/r/corentinth/it-tools)，实测版本 **v2024.10.22-7ca5933**，Nginx **1.26.2**，测试平台 **Ubuntu 24.04** Linux。*

写代码、查接口、改配置时，经常要临时算哈希、加解密一段文本、美化 SQL / YAML / JSON、生成 UUID 或二维码。很多人随手打开搜索引擎里的「在线工具」：站点一多难记，更麻烦的是 Token、密钥、内网 URL 一旦贴进公网页，等于把敏感串交给未知第三方。

内网与小团队更常见的诉求是：**工具箱跑在自己服务器上、浏览器打开即用，且不必再维护数据库和账号体系**。商业开发者门户过重；自己拼一堆静态页又难统一体验。

**IT Tools**（[it-tools.tech](https://it-tools.tech)）是面向开发者与 IT 从业者的开源工具集合：加密、转换、开发与文本类小工具集中在一个 Web 界面。镜像 **`corentinth/it-tools`**（见 [镜像页](https://xuanyuan.cloud/zh/r/corentinth/it-tools)）把前端放进 **Nginx**，容器内监听 **80**——静态站、无数据库、无登录，适合个人与小团队自托管。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 个人 / 实验室工具箱 | 浏览器打开 `http://服务器IP:8080`，切中文后搜索或分类进入工具 |
| 内网敏感串处理 | 在自家实例上做哈希、加解密、密码强度评估 |
| Compose / 配置整理 | 用 SQL / YAML / JSON 美化、文本比较处理粘贴片段 |
| 临时运维辅助 | 二维码、RSA 密钥对、Emoji 等随手生成 |

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`corentinth/it-tools:latest`**，**Docker Compose** 映射宿主机 **8080 → 容器 80**，浏览器切换简体中文并演示常用工具；另附 **`docker run` 备选**。文内附 **13** 张实测界面截图。

> **上手要点**  
> - **部署**：默认 **Compose**（第五节）；临时试玩见 **第八节 docker run**  
> - **端口**：宿主机 **8080** → 容器 **80**  
> - **数据卷**：默认 **无需挂载**（静态站；收藏等偏好多在浏览器本地）  
> - **账号**：无登录——打开即用  
> - **标签**：跟做用 **`latest`**（实测 **v2024.10.22-7ca5933**）；生产钉同款日期标签  
> - **暴露**：公网建议反代 + HTTPS；敏感内容只用测试串演示  

镜像说明见 [corentinth/it-tools](https://xuanyuan.cloud/zh/r/corentinth/it-tools)，标签列表见 [tags](https://xuanyuan.cloud/r/corentinth/it-tools/tags)。项目：[GitHub · CorentinTh/it-tools](https://github.com/CorentinTh/it-tools)。许可证：**GNU GPLv3**。

---

## 一、IT Tools 是什么？

| 类别 | 典型工具 |
|------|----------|
| 加密 | Hash 文本、加解密文本、RSA 密钥对、密码强度分析、Token / UUID / ULID、Bcrypt |
| 转换 / 开发 | 日期时间与进制转换、SQL / YAML / JSON 美化、Crontab、Docker run→Compose、正则 |
| 文本 / 图片 | 文本比较、Emoji、二维码、Lorem Ipsum |

| | IT Tools（本文） | 公网零散在线工具 |
|--|------------------|------------------|
| 数据 | 自托管；多数运算在浏览器本地 | 可能经第三方服务器 |
| 入口 | 一个 IP:端口或域名 | 每个功能换一个网站 |
| 运维 | 单容器静态站，无库无账号 | 无需自维，但隐私不可控 |

```text
浏览器  ──:8080──▶  Nginx（容器内 :80）── 静态前端
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 内存 | ≥ **256～512 MB** 可用 |
| 磁盘 | CONTENT SIZE 约 **22.6 MB**（DISK USAGE 约 **83.8 MB**） |
| 端口 | 宿主机 **8080**（可改；保持 `宿主机:80`） |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

> 8080 已被占用时，Compose 改为 `"18080:80"`，访问 `http://IP:18080`。

---

## 三、标签怎么选

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`latest`** | 稳定发布线（实测 **v2024.10.22-7ca5933**） | 跟做 / 实验室（本文） |
| **`2024.10.22-7ca5933`** 等日期标签 | 固定构建 | **生产钉版本** |
| **`nightly`** | 较新构建 | 仅尝鲜 |

完整列表：[tags](https://xuanyuan.cloud/r/corentinth/it-tools/tags)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/corentinth/it-tools:latest
```

Ubuntu 24.04 实测：

```text
latest: Pulling from corentinth/it-tools
45a30f47e80f: Pull complete
9dc0279166b1: Pull complete
4c64d3291c88: Pull complete
d3b17590914c: Pull complete
43c4264eed91: Pull complete
50d6cfdb81c6: Pull complete
c5f5268086b8: Pull complete
6592d833752c: Pull complete
65e7766bfa53: Pull complete
f4cab7bcfad1: Pull complete
343a00c2f45a: Download complete
Digest: sha256:8b8128748339583ca951af03dfe02a9a4d7363f61a216226fc28030731a5a61f
Status: Downloaded newer image for docker.xuanyuan.run/corentinth/it-tools:latest
docker.xuanyuan.run/corentinth/it-tools:latest
```

```bash
docker images docker.xuanyuan.run/corentinth/it-tools:latest
```

```text
IMAGE                                            ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/corentinth/it-tools:latest   8b8128748339       83.8MB         22.6MB
```

生产把 Compose 与命令中的 `latest` 换成日期标签（如 `2024.10.22-7ca5933`）。

---

## 五、Docker Compose 部署（推荐）

工作目录：`/www/wwwroot/it-tools`（可改 `$HOME/it-tools`）。

### 5.1 创建目录

```bash
mkdir -p /www/wwwroot/it-tools
chown -R "$USER:$USER" /www/wwwroot/it-tools
cd /www/wwwroot/it-tools
```

非 root 时给 `mkdir` / `chown` 加 `sudo`。

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  it-tools:
    image: docker.xuanyuan.run/corentinth/it-tools:latest
    container_name: it-tools
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      - TZ=Asia/Shanghai
EOF
```

| 项 | 说明 |
|----|------|
| `ports` | 宿主机 **8080** → 容器 **80** |
| 无 `volumes` | 静态站默认不需要持久化卷 |
| `TZ` | 可选 |

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 50
```

Ubuntu 24.04 实测：

```text
[+] Running 2/2
 ✔ Network it-tools_default  Created
 ✔ Container it-tools        Started
```

```text
NAME       IMAGE                                            COMMAND                  SERVICE    CREATED         STATUS         PORTS
it-tools   docker.xuanyuan.run/corentinth/it-tools:latest   "/docker-entrypoint.…"   it-tools   5 seconds ago   Up 5 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
```

日志关键行：

```text
it-tools  | /docker-entrypoint.sh: Configuration complete; ready for start up
it-tools  | 2026/08/05 12:03:21 [notice] 1#1: nginx/1.26.2
it-tools  | 2026/08/05 12:03:21 [notice] 1#1: start worker processes
```

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
```

```text
200
```

---

## 六、浏览器首次访问

浏览器打开（将 `YOUR_SERVER_IP` 换成服务器 IP）：

```text
http://YOUR_SERVER_IP:8080
```

本机可用 `http://127.0.0.1:8080`。无需注册、登录。

### 6.1 首页（默认英文）

首次多为英文界面：顶栏搜索（`Ctrl + K`）、左侧分类、中间工具卡片。页面能打开即说明端口映射正常。

![IT Tools 首次访问：英文首页，搜索框与工具卡片网格](https://img.xuanyuan.dev/docker/blog/it-tools-1.webp)

### 6.2 切换简体中文

右上角语言从 **English** 改为 **中文**。首页变为「全部工具」，侧栏出现「加密」「转换器」等分类。

![IT Tools 切换简体中文：全部工具与加密分类侧栏](https://img.xuanyuan.dev/docker/blog/it-tools-2.webp)

### 6.3 搜索进入工具

顶栏搜索输入 `hash`，下拉匹配 **Hash text** 等（工具内部名可能仍为英文）；点选进入，或直接点侧栏 / 首页卡片。

![IT Tools 搜索 hash：下拉匹配 Hash text 等工具](https://img.xuanyuan.dev/docker/blog/it-tools-3.webp)

---

## 七、常用工具演示

演示请用测试串，不要粘贴仍有效的生产密钥或 Token。

### 7.1 Hash 文本

**加密 → Hash 文本**。输入例如 `https://xuanyuan.cloud/`，Digest encoding 选 Hexadecimal，下方即时给出 MD5、SHA1、SHA256 等摘要，可复制。

![IT Tools Hash 文本：输入 URL 后输出 MD5/SHA 等摘要](https://img.xuanyuan.dev/docker/blog/it-tools-4.webp)

### 7.2 加密 / 解密文本

**加密 → 加密/解密文本**。左侧选 AES（或其它算法）与密钥加密，右侧用同一密钥解密，确认还原一致。

![IT Tools 加密解密文本：AES 左右对照加解密](https://img.xuanyuan.dev/docker/blog/it-tools-5.webp)

### 7.3 RSA 密钥对生成器

**加密 → RSA 密钥对生成器**。位数选 **2048**，Refresh 后复制 PEM 公钥 / 私钥。测试密钥勿提交到公共仓库。

![IT Tools RSA 密钥对生成器：2048 位 PEM 公钥与私钥](https://img.xuanyuan.dev/docker/blog/it-tools-6.webp)

### 7.4 密码强度分析仪

**加密 → 密码强度分析仪**。输入口令后查看估时、熵与分数；弱口令会提示 **Instantly**。结果侧重暴力估算，不含字典攻击。

![IT Tools 密码强度分析仪：弱口令评分与熵信息](https://img.xuanyuan.dev/docker/blog/it-tools-7.webp)

### 7.5 SQL / YAML / JSON 美化

**开发** 分类下三个格式化工具用法相同：粘贴原文 → 调选项 → 复制右侧结果。

- **SQL 美化和格式化**：单行 SQL 可按方言与关键字大小写展开。

![IT Tools SQL 美化：单行查询格式化为多行](https://img.xuanyuan.dev/docker/blog/it-tools-8.webp)

- **YAML美化和格式化**：可粘贴第五节的 `docker-compose.yml`。开启 **Sort keys** 时键会按字母重排，仅便于阅读，不必原样写回生产文件。

![IT Tools YAML 美化：格式化 it-tools 的 docker-compose.yml](https://img.xuanyuan.dev/docker/blog/it-tools-9.webp)

- **JSON美化和格式化**：压缩 JSON 展开；Sort keys 同样会重排键名。

![IT Tools JSON 美化：压缩 JSON 格式化并按键排序](https://img.xuanyuan.dev/docker/blog/it-tools-12.webp)

### 7.6 文本比较

**文本 → 文本比较**。左右粘贴两段文本，差异红绿高亮（示例：`https://` 与 `http://`）。

![IT Tools 文本比较：https 与 http 差异高亮](https://img.xuanyuan.dev/docker/blog/it-tools-11.webp)

### 7.7 Emoji 与二维码

- **文本 → Emoji 选择器**：按分类浏览，复制 Unicode / code points。

![IT Tools Emoji 选择器：Smileys 分类与 code points](https://img.xuanyuan.dev/docker/blog/it-tools-10.webp)

- **图片和视频 → 二维码生成器**：输入 URL 或文本，调颜色与容错后下载。

![IT Tools 二维码生成器：为轩辕镜像站点生成 QR 码](https://img.xuanyuan.dev/docker/blog/it-tools-13.webp)

JWT 解析、UUID、Crontab、正则等路径相同：**侧栏选工具 → 输入 → 复制结果**。

---

## 八、备选：docker run

仅临时试玩或没有 Compose 时使用；日常跟做仍用第五节。

```bash
docker run -d \
  --name it-tools \
  --restart unless-stopped \
  -p 8080:80 \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/corentinth/it-tools:latest
```

访问同样是 `http://IP:8080`。与 Compose 容器重名时先 `docker compose down` 或换 `--name`。

```bash
docker ps | grep it-tools
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
```

---

## 九、生产加固与升级

| 项 | 建议 |
|----|------|
| 版本 | `image:` 钉日期标签，避免 `latest` 静默变化 |
| HTTPS | 前置 Nginx / Caddy / Traefik |
| 暴露面 | 优先内网或 VPN；公网评估扫描与滥用风险 |
| 升级 | 改标签或 `docker compose pull && docker compose up -d` |
| 备份 | 无业务库；保留 `docker-compose.yml` 与反代配置即可 |

```bash
cd /www/wwwroot/it-tools
docker compose pull
docker compose up -d
```

---

## 十、常见问题 FAQ

**Q1：打不开 :8080？**  
看 `docker compose ps` 是否 Up、本机 `curl` 是否 **200**、安全组 / 防火墙是否放行；冲突则改 `"18080:80"`。

**Q2：镜像页命令带 `-it`？**  
官方 Self-host 推荐 `-d --restart unless-stopped -p 8080:80`。跟做用后台运行即可，不必依赖 `-it`。

**Q3：要挂数据卷吗？**  
默认不用。静态站；收藏等多在浏览器本地。

**Q4：有默认账号吗？**  
没有，打开即用。

**Q5：`latest` 还是 `nightly`？**  
跟做与生产用 **`latest` 或日期标签**；`nightly` 仅尝鲜。`latest` 不一定每天更新。

**Q6：ARM 拉取失败？**  
若报 `no matching manifest`，到 [标签页](https://xuanyuan.cloud/r/corentinth/it-tools/tags) 确认该 tag 是否支持你的架构。

**Q7：能映射到宿主机 3000 吗？**  
容器内是 **80**。宿主机可映射任意空闲口；本系列默认避开宿主机 **3000**（常与前端开发冲突）。

**Q8：和 sharevb/it-tools 等增强版？**  
本文只讲官方 **`corentinth/it-tools`**，端口与功能勿与社区分支混用。

**Q9：日志出现 `default.conf differs from the packaged version`？**  
镜像内置了项目 `nginx.conf`，属入口脚本提示。只要有 `Configuration complete` 与 `nginx/1.26.2` 启动 worker，可忽略。

---

## 十一、命令速查

```bash
docker pull docker.xuanyuan.run/corentinth/it-tools:latest

cd /www/wwwroot/it-tools
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
# 浏览器 http://服务器IP:8080

docker compose down
```

备选：

```bash
docker run -d --name it-tools --restart unless-stopped -p 8080:80 \
  docker.xuanyuan.run/corentinth/it-tools:latest
```

---

## 十二、延伸阅读

- [corentinth/it-tools 镜像页](https://xuanyuan.cloud/zh/r/corentinth/it-tools) · [标签列表](https://xuanyuan.cloud/r/corentinth/it-tools/tags)
- [GitHub · CorentinTh/it-tools](https://github.com/CorentinTh/it-tools) · [在线演示 it-tools.tech](https://it-tools.tech)
- [Docker Hub · corentinth/it-tools](https://hub.docker.com/r/corentinth/it-tools)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

---

## 总结

- Compose 拉起 **`corentinth/it-tools:latest`**：**8080→80**，`curl` 返回 **200**，日志为 **nginx/1.26.2**。  
- 无库无登录；切中文后即可用哈希、加解密、格式化、二维码等工具。  
- 生产钉日期标签，公网加 HTTPS / 访问控制。

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/it-tools-docker-deploy



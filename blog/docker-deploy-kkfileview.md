# Docker 部署 kkFileView：轻松搭建在线万能文件预览平台

![Docker 部署 kkFileView：轻松搭建在线万能文件预览平台](https://imgs.xuanyuan.cloud/docker/blog/kkfileview1.webp)

*分类: Docker部署教程 | 标签: kkFileView,Docker,轩辕镜像,文件预览,Office,PDF,私有化部署,部署教程 | 发布时间: 2026-07-23 07:32:05*

> kkFileView 是开源的文件在线预览服务，浏览器里可以查看 Office、PDF、图片和压缩包。本文用 Docker Compose 部署 wangbowen/kkfileview 之后，可以在内网打开预览页，并把业务系统里的文件 URL 接进预览接口。适合 OA 附件、合同与课件在线查看，以及对象存储旁路预览。

*本文基于 [wangbowen/kkfileview:5.1.0](https://xuanyuan.cloud/zh/r/wangbowen/kkfileview)，以 **5.1.0** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

合同 PDF 躺在 OA 附件里，点「预览」，浏览器只弹出下载。财务把 Excel 报价单放进网盘，同事还得先装 WPS，才能看单元格里的公式。教培课件是一叠 pptx，手机上没有 Office，课前只能转到微信再打开。压缩包里的图纸更绕：先下到电脑，解压，再找能打开 dwg 的软件。采购问过商业预览 SDK，按页或按坐席计费，文件还要先传到对方的云。

内网里的合同、学籍和标书，不适合先出域再预览。给每台电脑装一套 Office，版本还不齐，没有桌面的服务器和手机照样打不开。自己从源码编译转换服务，LibreOffice、字体和 Java 都要自己装。更想要的是浏览器能打开的预览服务：文件留在自己的机器或对象存储上，业务系统只交出一个 URL。

**kkFileView**（上游 [kekingcn/file-online-preview](https://gitee.com/kekingcn/file-online-preview)，官网 [kkview.cn](https://kkview.cn)）是基于 Spring Boot 的在线预览服务。首页可以上传文件，或粘贴链接，在浏览器里看 Word、Excel、PDF、图片，以及压缩包里的文件。业务系统把文件地址做成 Base64，请求 `/onlinePreview` 就能嵌进现有页面。本文使用 **`wangbowen/kkfileview:5.1.0`** 版本实测（[镜像页](https://xuanyuan.cloud/zh/r/wangbowen/kkfileview)，维护仓库 [iwangbowen/kkFileView](https://github.com/iwangbowen/kkFileView)）。

跑通之后，浏览器里可以直接翻合同 Word 和扫描 PDF。压缩包不必先解到本机，也能点开里面的文件。

---

## 一、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2**（`docker compose`） |
| 内存 | 建议 ≥ **2～4 GB** 可用。镜像内置 LibreOffice，转换时占用较高 |
| 磁盘 | ≥ **3 GB**。镜像压缩体积约 **1.3 GB** 这一量级，再加上预览缓存 |
| 端口 | 宿主机 **8012** → 容器 **8012** |
| 工作目录 | `/www/wwwroot/kkfileview`。macOS 上改为 `~/docker/kkfileview` |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见[轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 二、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/wangbowen/kkfileview:5.1.0
```

官方镜像 `keking/kkfileview` 约两年未更新。镜像页「基本使用」示例写成过 `iwangbowen/kkfileview:latest`，拉取坐标是 **`wangbowen/kkfileview:5.1.0`**。

Ubuntu 24.04 实测（节选）：

```text
5.1.0: Pulling from wangbowen/kkfileview
9050f9ffcf48: Pull complete
…
Digest: sha256:3bda282b1e9542f173203d18c0772be7e634b7cf269f09aa06dd2646df31c021
Status: Downloaded newer image for docker.xuanyuan.run/wangbowen/kkfileview:5.1.0
docker.xuanyuan.run/wangbowen/kkfileview:5.1.0
```

| Docker Hub | 轩辕镜像 |
|------------|----------|
| `wangbowen/kkfileview:5.1.0` | `docker.xuanyuan.run/wangbowen/kkfileview:5.1.0` |

---

## 三、Docker Compose 部署

本镜像把 `file.upload.disable` 写成字面量 `true`，配置里没有 `${KK_FILE_UPLOAD_DISABLE:...}`。`-e KK_FILE_UPLOAD_DISABLE=false` 不会打开上传。演示页要能上传，得先改 `application.properties`，再只读挂进容器。

内网试「文件链接预览」时，源地址的主机还要写进 `trust.host`。实验室可以暂时写成 `*`。生产环境保持 `file.upload.disable = true`，并把 `trust.host` 收成业务域名或 IP，不要长期使用 `*`。

容器里的安装目录是 `/opt/kkFileView-5.0.0`。目录名带 **5.0.0**，和镜像标签 **5.1.0** 不是同一套编号，挂载路径按容器内目录写。

### 3.1 准备目录

工作目录用 `/www/wwwroot/kkfileview`。macOS 上改为 `~/docker/kkfileview`。

```bash
sudo mkdir -p /www/wwwroot/kkfileview/file /www/wwwroot/kkfileview/config
cd /www/wwwroot/kkfileview

# macOS：mkdir -p ~/docker/kkfileview/file ~/docker/kkfileview/config && cd ~/docker/kkfileview
```

### 3.2 先启动一次，拷出配置

配置文件在镜像里面。先只挂预览缓存目录，把默认 `application.properties` 拷到宿主机。

```bash
cd /www/wwwroot/kkfileview

cat > docker-compose.yml <<'EOF'
services:
  kkfileview:
    image: docker.xuanyuan.run/wangbowen/kkfileview:5.1.0
    container_name: kkfileview
    restart: unless-stopped
    ports:
      - "8012:8012"
    volumes:
      - ./file:/opt/kkFileView-5.0.0/file
    environment:
      KK_FILE_DIR: /opt/kkFileView-5.0.0/file
    mem_limit: 2g
EOF

docker compose up -d
docker compose ps
curl -sI http://127.0.0.1:8012/ | head -n 5
```

成功时日志里能看到 Java 21、Spring Boot 3.x，Tomcat 监听 **8012**，以及 LibreOffice 进程连接成功。`curl` 返回 `HTTP/1.1 200`。

```bash
docker cp kkfileview:/opt/kkFileView-5.0.0/config/application.properties ./config/application.properties
```

### 3.3 打开演示上传，并信任预览源主机

演示页要上传本地文件时，把 `file.upload.disable` 改成 `false`。生产环境请改回 `true`。

实验室把 `trust.host` 设为 `*`，让内网链接能预览。生产环境改成业务域名或 IP 白名单。同时把 `not.trust.host` 设为 `default`。若内网地址仍被拒绝，再看这一项有没有写上 `192.168.*`。

```bash
cd /www/wwwroot/kkfileview

sed -i 's/^file.upload.disable.*/file.upload.disable = false/' ./config/application.properties
sed -i 's/^trust.host.*/trust.host = */' ./config/application.properties
sed -i 's/^not.trust.host.*/not.trust.host = default/' ./config/application.properties

grep -E '^(file.upload.disable|trust.host|not.trust.host)' ./config/application.properties
```

### 3.4 挂载配置，并让容器回连本机演示地址

演示页生成的文件 URL 常带宿主机局域网 IP，例如 `http://192.168.1.10:8012/demo/...`。容器走 bridge 网络回连这个 IP 时，会出现 `Connect timed out`。用 `extra_hosts` 把该 IP 指到 `host-gateway`。下面的 `192.168.1.10` 换成你的局域网地址。

```bash
cd /www/wwwroot/kkfileview

cat > docker-compose.yml <<'EOF'
services:
  kkfileview:
    image: docker.xuanyuan.run/wangbowen/kkfileview:5.1.0
    container_name: kkfileview
    restart: unless-stopped
    ports:
      - "8012:8012"
    extra_hosts:
      - "192.168.1.10:host-gateway"
    volumes:
      - ./file:/opt/kkFileView-5.0.0/file
      - ./config/application.properties:/opt/kkFileView-5.0.0/config/application.properties:ro
    environment:
      KK_FILE_DIR: /opt/kkFileView-5.0.0/file
    mem_limit: 2g
EOF

docker compose up -d --force-recreate

docker exec kkfileview grep -E '^(file.upload.disable|trust.host)' 
  /opt/kkFileView-5.0.0/config/application.properties
```

| 配置 | 说明 |
|------|------|
| `8012:8012` | 宿主机 **8012** → 容器 **8012** |
| `./file` → `/opt/kkFileView-5.0.0/file` | 预览缓存和演示上传目录 |
| 配置只读挂载 | 保留上传开关和 `trust.host` |
| `extra_hosts` | 让容器能下载「本机 IP」上的演示文件 |
| `mem_limit: 2g` | 限制内存，可按机器调大 |

浏览器访问 `http://<服务器 IP>:8012/`。

### 3.5 备选：host 网络

改用 `network_mode: host` 时，不要写 `ports:`。host 模式下 Docker 不会替你放行防火墙。启用了 UFW 时，先放行 **8012**，再启动容器。

```bash
sudo ufw allow 8012/tcp comment 'kkfileview'
```

实测里，本机 `curl 127.0.0.1:8012` 正常，从 Windows 访问超时。原因是 UFW 默认拒绝，规则里没有 **8012**。

---

## 四、在浏览器里预览

打开 `http://<服务器 IP>:8012/`。首页分成「文件链接预览」和「上传文件预览」。

| 类别 | 说明 | 常见格式 |
|------|------|----------|
| Office 办公文档 | 日常业务里的 Office、WPS、LibreOffice | doc/docx、xls/xlsx、ppt/pptx、csv/tsv、wps/dps/et、odt/ods/odp |
| CAD 与 3D | 图纸与模型 | dwg/dxf/dwf、obj/3ds/stl/gltf/glb/fbx、ifc/step/iges |
| 图片与图像 | 位图、多页图、矢量 | jpg/png/gif/webp/heic、tif/tga/svg；支持翻转、缩放、镜像 |
| 压缩与文本 | 压缩包目录、纯文本与源码高亮 | zip/rar/7z/tar、txt/md/xml/java/js/py |
| 音视频与邮件等 | 媒体、邮件归档和其它业务格式 | mp3/wav/mp4、eml/msg、epub/ofd/xmind/bpmn/drawio/dcm |
| 接入能力 | 首页即可试的控制项 | AES、Basic Auth、FTP 参数、页码/高亮/水印、上传与目录浏览 |

### 4.1 首页

首页标题是「开源的万能文件预览系统」，下面是 Office、CAD 与 3D、图片、压缩与文本、音视频与邮件、接入能力这几块。

![kkFileView 首页展示开源万能文件预览系统与格式能力地图](https://img.xuanyuan.dev/docker/blog/kkfileview-1.webp)

### 4.2 上传前的安全提示

选择本地文件时，页面会弹出提示：不要上传机密或个人敏感文件，用完可以删除。内网演示请自行评估风险。

![kkFileView 上传文件时弹出勿上传机密文档的安全提示对话框](https://img.xuanyuan.dev/docker/blog/kkfileview-2.webp)

### 4.3 上传成功：列表出现 docx

`file.upload.disable = false` 生效后，可以上传例如「开户确认书.docx」。列表里会出现「预览」和「删除」。

![kkFileView 本地源列表显示已上传的开户确认书 docx](https://img.xuanyuan.dev/docker/blog/kkfileview-3.webp)

### 4.4 Office 预览：docx 转成 PDF 阅读器

点「预览」后，LibreOffice 转换完成，进入 PDF.js 风格的阅读器，侧栏有缩略图、缩放和页码。

![kkFileView 在线预览开户确认书 docx 成功显示文档内容](https://img.xuanyuan.dev/docker/blog/kkfileview-4.webp)

### 4.5 多文件列表：docx 与大体积 PDF

可以继续上传扫描件 PDF。列表里同时放着多种格式。

![kkFileView 文件列表同时包含金刚经 PDF 与开户确认书 docx](https://img.xuanyuan.dev/docker/blog/kkfileview-5.webp)

### 4.6 大图 PDF：高清缩放

百页级扫描 PDF（如摩崖石刻图录）可以在侧栏翻页，并放大看细节。

![kkFileView PDF 阅读器高清预览金刚经摩崖石刻扫描件](https://img.xuanyuan.dev/docker/blog/kkfileview-6.webp)

### 4.7 再增加一本图书 PDF

列表可以继续放业务文档和图书 PDF，方便对比预览效果。

![kkFileView 本地源列表显示怎样解题 PDF、金刚经 PDF 与 docx](https://img.xuanyuan.dev/docker/blog/kkfileview-7.webp)

### 4.8 图书封面预览

多页图书 PDF（如《怎样解题》）的封面和目录页可以在阅读器里翻阅。

![kkFileView 预览怎样解题数学思维新方法 PDF 封面](https://img.xuanyuan.dev/docker/blog/kkfileview-8.webp)

### 4.9 压缩包上架

上传 `.7z` 之后，压缩包和 PDF、docx 并列显示在本地源列表。

![kkFileView 文件列表增加泰山金刚经 7z 压缩包](https://img.xuanyuan.dev/docker/blog/kkfileview-9.webp)

### 4.10 压缩包内预览

进入压缩包目录后，可以直接点里面的 PDF 预览，不必先解压到本机。

![kkFileView 浏览 7z 压缩包目录并预览包内金刚经 PDF](https://img.xuanyuan.dev/docker/blog/kkfileview-10.webp)

---

## 五、接到业务系统

生产环境更常见的接法是：业务系统自己持有文件 URL，再调用预览接口，而不是长期打开演示首页的上传。

- 预览入口类似 `/onlinePreview?url=<Base64 编码后的文件 URL>`
- `trust.host` 写成业务域名或 IP。生产环境不要长期使用 `trust.host = *`
- 服务放在反向代理后面时，按 `application.properties` 里的注释设置 `base.url` 与 `context-path`
- 演示上传保持关闭：`file.upload.disable = true`

能力与配置说明见 [kkview.cn](https://kkview.cn)。

---

## 六、常见问题

**Q1：页面提示「文件上传功能已禁用」？**

首页不能上传。`wangbowen/kkfileview:5.1.0` 里 `file.upload.disable = true` 是字面量，没有 `${KK_FILE_UPLOAD_DISABLE:...}`。`-e KK_FILE_UPLOAD_DISABLE=false` 不会生效。按第三节改 `application.properties`，再挂进容器。

**Q2：提示「预览源文件来自不受信任的站点」？**

源文件 URL 的主机不在 `trust.host` 白名单里。先看配置里的 `trust.host` 和 `not.trust.host`。内网可以临时写成 `trust.host = *`，或写成具体 IP、域名。`not.trust.host` 如果拦了 `192.168.*`，内网地址也会被拒绝。

**Q3：预览报下载失败，且 URL 是本机局域网 IP？**

报错里带 `Connect timed out`，地址形如 `http://<宿主机局域网 IP>:8012/...`。容器在 bridge 网络里回连这个 IP 会超时。可以二选一：

1. 在 Compose 里加上 `extra_hosts: ["<该 IP>:host-gateway"]`。
2. 改用 `network_mode: host`，并执行 `ufw allow 8012/tcp`。

业务文件尽量放在容器能直接访问的对象存储或内网 HTTP 上，不要依赖容器去下载自己对外发布的地址。

**Q4：本机 curl 正常，别的电脑打不开？**

先确认是不是 `network_mode: host`。host 模式加上 UFW 处于开启时，需要 `ufw allow 8012/tcp`。bridge 配合 `ports` 时，Docker 通常会自己插入发布规则，表现不一样。

**Q5：LibreOffice 日志出现 exit code 81？**

启动阶段 Office 进程可能短暂退出再拉起。若随后出现 `Connected: 'socket,...port=2001'`，并且预览正常，可以忽略。若一直失败，再加大内存，或重新拉取镜像核对是否完整。

**Q6：生产环境要不要打开上传？**

不建议。演示上传历史上出过安全问题。生产用 URL 接入，保持 `file.upload.disable = true`，并收紧 `trust.host`。

**Q7：为什么不用 keking/kkfileview？**

[keking/kkfileview](https://xuanyuan.cloud/zh/r/keking/kkfileview) 是官方坐标，约两年未更新。本文使用 [wangbowen/kkfileview](https://xuanyuan.cloud/zh/r/wangbowen/kkfileview)。`5.1.0` 同步上游近期改动，镜像说明里写了缺陷修复和功能优化。

**Q8：镜像页示例写成了 iwangbowen/kkfileview？**

镜像页「基本使用」里的示例坐标是 `iwangbowen/kkfileview:latest`。拉取和 Compose 使用 `wangbowen/kkfileview:5.1.0`。不要把 `latest` 写进命令。

---

## 七、命令速查

```bash
docker pull docker.xuanyuan.run/wangbowen/kkfileview:5.1.0

cd /www/wwwroot/kkfileview
# macOS：cd ~/docker/kkfileview
docker compose up -d --force-recreate
docker compose ps
docker logs --tail 80 kkfileview

curl -sI http://127.0.0.1:8012/ | head -n 5

docker exec kkfileview grep -E '^(file.upload.disable|trust.host)' 
  /opt/kkFileView-5.0.0/config/application.properties

# host 网络且启用了 UFW 时
sudo ufw allow 8012/tcp comment 'kkfileview'
```

---

## 八、延伸阅读

| 资源 | 链接 |
|------|------|
| [wangbowen/kkfileview 镜像页](https://xuanyuan.cloud/zh/r/wangbowen/kkfileview) | [https://xuanyuan.cloud/zh/r/wangbowen/kkfileview](https://xuanyuan.cloud/zh/r/wangbowen/kkfileview) |
| [wangbowen/kkfileview 概览](https://xuanyuan.cloud/r/wangbowen/kkfileview) | [https://xuanyuan.cloud/r/wangbowen/kkfileview](https://xuanyuan.cloud/r/wangbowen/kkfileview) |
| [wangbowen/kkfileview 标签列表](https://xuanyuan.cloud/r/wangbowen/kkfileview/tags) | [https://xuanyuan.cloud/r/wangbowen/kkfileview/tags](https://xuanyuan.cloud/r/wangbowen/kkfileview/tags) |
| [Docker Hub · wangbowen/kkfileview](https://hub.docker.com/r/wangbowen/kkfileview) | [https://hub.docker.com/r/wangbowen/kkfileview](https://hub.docker.com/r/wangbowen/kkfileview) |
| [GitHub · iwangbowen/kkFileView](https://github.com/iwangbowen/kkFileView) | [https://github.com/iwangbowen/kkFileView](https://github.com/iwangbowen/kkFileView) |
| [Gitee · kekingcn/file-online-preview](https://gitee.com/kekingcn/file-online-preview) | [https://gitee.com/kekingcn/file-online-preview](https://gitee.com/kekingcn/file-online-preview) |
| [官网 kkview.cn](https://kkview.cn) | [https://kkview.cn](https://kkview.cn) |
| [keking/kkfileview 镜像页](https://xuanyuan.cloud/zh/r/keking/kkfileview) | [https://xuanyuan.cloud/zh/r/keking/kkfileview](https://xuanyuan.cloud/zh/r/keking/kkfileview) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

官方坐标 `keking/kkfileview` 约两年未更新，本文使用 `wangbowen/kkfileview:5.1.0`。

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/kkfileview-docker-deploy



# Docker 部署万能文件预览神器 kkFileView：浏览器即可在线预览 Office、PDF

![Docker 部署万能文件预览神器 kkFileView：浏览器即可在线预览 Office、PDF](https://assets.xuanyuan.me/docker/blog/kkfileview.webp)

*分类: Docker部署教程 | 标签: kkFileView,Docker,轩辕镜像,文件预览,Office,PDF,私有化部署,部署教程 | 发布时间: 2026-07-23 07:32:05*

> OA、网盘、教培、合同系统都要「点一下就能看 Word / Excel / PDF」，自建一套在线预览往往比接商业 SaaS 更省心。kkFileView 号称开源的万能文件预览系统：统一入口覆盖 Office / CAD / 图片 / 压缩包 / 音视频等 70+ 常见类型，提供 REST 接入，适合嵌进现有业务。

*本文基于 [wangbowen/kkfileview:5.1.0](https://xuanyuan.cloud/zh/r/wangbowen/kkfileview) 镜像（社区维护构建，同步上游 5.x），Ubuntu 24.04 服务器实测。不推荐继续使用已约两年未更新的官方 [keking/kkfileview](https://xuanyuan.cloud/zh/r/keking/kkfileview)。*

OA、网盘、教培、合同系统都要「点一下就能看 Word / Excel / PDF」，自建一套在线预览往往比接商业 SaaS 更省心。**kkFileView** 号称开源的**万能文件预览系统**：统一入口覆盖 Office / CAD / 图片 / 压缩包 / 音视频等 **70+** 常见类型，提供 REST 接入，适合嵌进现有业务。

官方 Docker 镜像 `keking/kkfileview` 已久未维护；本文改用持续更新的第三方镜像 **`wangbowen/kkfileview:5.1.0`**，用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取，Compose 单容器拉起，浏览器打开即可试预览，全程零基础可跟做。

上游项目见 [Gitee kekingcn/file-online-preview](https://gitee.com/kekingcn/file-online-preview)、[官网 kkview.cn](https://kkview.cn)；本镜像维护仓库见 [iwangbowen/kkFileView](https://github.com/iwangbowen/kkFileView)。镜像页：[wangbowen/kkfileview](https://xuanyuan.cloud/zh/r/wangbowen/kkfileview)，标签列表：[tags](https://xuanyuan.cloud/r/wangbowen/kkfileview/tags)。

---

## 一、kkFileView 是什么？

**kkFileView** 是基于 Spring Boot 的 **文件文档在线预览** 开源方案：独立部署后通过 HTTP / REST 接入，不必和业务系统强耦合。首页自称「开源的万能文件预览系统」，能力覆盖如下几大类：

| 类别 | 说明 | 常见格式 |
|------|------|----------|
| Office 办公文档 | 日常业务流里最常见的 Office、WPS、LibreOffice | doc/docx、xls/xlsx、ppt/pptx、csv/tsv、wps/dps/et、odt/ods/odp… |
| CAD 与 3D | 设计、制造、工程协同图纸与模型 | dwg/dxf/dwf、obj/3ds/stl/gltf/glb/fbx、ifc/step/iges… |
| 图片与图像 | 位图、多页图、矢量、较新移动端格式 | jpg/png/gif/webp/heic、tif/tga/svg；支持翻转、缩放、镜像 |
| 压缩与文本 | 压缩包目录浏览、纯文本与源码高亮 | zip/rar/7z/tar、txt/md/xml/java/js/py… |
| 音视频与邮件等 | 媒体、邮件归档与其它业务格式 | mp3/wav/mp4、eml/msg、epub/ofd/xmind/bpmn/drawio/dcm… |
| 接入能力 | 首页即可验证常用控制项 | AES、Basic Auth、FTP 参数、页码/高亮/水印、上传与目录浏览 |

典型场景：企业文档 / OA、在线教育课件、协同办公、CMS、对象存储旁路预览。

### 1.1 为什么不用官方 keking 镜像？

| 镜像 | 状态 | 本文 |
|------|------|------|
| [keking/kkfileview](https://xuanyuan.cloud/zh/r/keking/kkfileview) | 社区官方坐标，**约两年未更新** | **不推荐** |
| [wangbowen/kkfileview](https://xuanyuan.cloud/zh/r/wangbowen/kkfileview) | 社区构建，含 bug 修复与功能优化；`5.1.0` 同步上游近期改动 | **采用** |

> 容器内安装根目录仍为 `/opt/kkFileView-5.0.0`（与镜像标签 `5.1.0` 无关，以 Dockerfile 为准）。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux x86_64（本文 Ubuntu 24.04） |
| Docker | Docker Engine + Compose V2（`docker compose`） |
| 内存 | 建议 ≥ **2～4 GB** 可用（内置 LibreOffice，转换吃内存） |
| 磁盘 | ≥ 3 GB（镜像约 1.3 GB 级压缩体积 + 预览缓存） |
| 端口 | **8012** |
| 工作目录 | `/data/kkfileview`（示例） |

```bash
docker --version
docker compose version
```

未装 Docker 可用轩辕一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```


备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```
更多说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、拉取镜像

```bash
docker pull docker.xuanyuan.run/wangbowen/kkfileview:5.1.0
```

实测输出（节选）：

```text
5.1.0: Pulling from wangbowen/kkfileview
9050f9ffcf48: Pull complete
…
Digest: sha256:3bda282b1e9542f173203d18c0772be7e634b7cf269f09aa06dd2646df31c021
Status: Downloaded newer image for docker.xuanyuan.run/wangbowen/kkfileview:5.1.0
docker.xuanyuan.run/wangbowen/kkfileview:5.1.0
```

| Docker Hub | 轩辕加速 |
|------------|----------|
| `wangbowen/kkfileview:5.1.0` | `docker.xuanyuan.run/wangbowen/kkfileview:5.1.0` |

> 镜像页个别示例曾误写成 `iwangbowen/...`，以 **`wangbowen/kkfileview`** 为准。

---

## 四、Compose 部署

本镜像默认 **关闭首页上传**（`file.upload.disable = true` 为字面量，环境变量盖不住），内网试玩还需配置 **信任主机**。建议：先起一次拷配置 → 改两项 → 用最终 Compose 挂载配置重启。

### 4.1 目录与临时启动

```bash
sudo mkdir -p /data/kkfileview/file /data/kkfileview/config
cd /data/kkfileview

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

成功时日志可见 Java 21 / Spring Boot 3.x、Tomcat 监听 **8012**，以及 LibreOffice 进程连接成功；`curl` 返回 `HTTP/1.1 200`。

拷出配置并修改（内网实测）：

```bash
docker cp kkfileview:/opt/kkFileView-5.0.0/config/application.properties ./config/application.properties

# 开启演示页上传（生产建议保持 true）
sed -i 's/^file\.upload\.disable.*/file.upload.disable = false/' ./config/application.properties

# 信任预览源主机：实验室可用 *；生产请改为业务域名/IP 白名单
sed -i 's/^trust\.host.*/trust.host = */' ./config/application.properties
sed -i 's/^not\.trust\.host.*/not.trust.host = default/' ./config/application.properties

grep -E '^(file\.upload\.disable|trust\.host|not\.trust\.host)' ./config/application.properties
```

### 4.2 最终 Compose（bridge + 配置挂载 + hairpin）

演示页生成的文件 URL 常带 **宿主机局域网 IP**（如 `http://192.168.1.10:8012/demo/...`）。容器在 bridge 网络里回连该 IP 可能 **Connect timed out**。用 `extra_hosts` 把该 IP 指到宿主机网关即可；把下面的 IP 换成你的实际地址。

```bash
cd /data/kkfileview

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

docker exec kkfileview grep -E '^(file\.upload\.disable|trust\.host)' \
  /opt/kkFileView-5.0.0/config/application.properties
```

参数说明：

| 配置 | 说明 |
|------|------|
| `8012:8012` | Web 端口 |
| `./file` → `/opt/kkFileView-5.0.0/file` | 预览缓存 / 演示上传目录 |
| 配置只读挂载 | 持久化上传开关与 trust.host |
| `extra_hosts` | 修复容器下载「本机 IP」演示文件超时 |
| `mem_limit: 2g` | 限制内存，可按机器调大 |

浏览器访问：`http://<服务器IP>:8012/`。

### 4.3 备选：host 网络

若改用 `network_mode: host`，**不要写** `ports:`。host 模式下 Docker 不会自动替你开防火墙，启用了 UFW 时需手动放行：

```bash
sudo ufw allow 8012/tcp comment 'kkfileview'
```

实测中：本机 `curl 127.0.0.1:8012` 正常、Windows 超时，正是因为 UFW 默认 deny、规则里没有 8012。

---

## 五、浏览器体验（10 张实测截图）

### 5.1 首页：万能预览能力地图

打开首页即可看到「开源的万能文件预览系统」与六大能力块（Office / CAD·3D / 图片 / 压缩·文本 / 音视频·邮件 / 接入能力），以及「文件链接预览」「上传文件预览」两个试玩区。

![kkFileView 首页展示开源万能文件预览系统与格式能力地图](https://assets.xuanyuan.me/docker/blog/kkfileview-1.webp)

### 5.2 上传前的安全提示

选择本地文件上传时，页面会弹出提示：勿上传机密/个人敏感文件，或用完即删。内网演示请自行评估风险。

![kkFileView 上传文件时弹出勿上传机密文档的安全提示对话框](https://assets.xuanyuan.me/docker/blog/kkfileview-2.webp)

### 5.3 上传成功：列表出现 docx

开启 `file.upload.disable = false` 后，可上传例如「开户确认书.docx」，列表出现「预览 / 删除」。

![kkFileView 本地源列表显示已上传的开户确认书 docx](https://assets.xuanyuan.me/docker/blog/kkfileview-3.webp)

### 5.4 Office 预览：docx → PDF 阅读器

点击「预览」，LibreOffice 转换后进入 PDF.js 风格阅读器（侧栏缩略图、缩放、页码等）。

![kkFileView 在线预览开户确认书 docx 成功显示文档内容](https://assets.xuanyuan.me/docker/blog/kkfileview-4.webp)

### 5.5 多文件列表：docx + 大体积 PDF

可继续上传扫描件 PDF 等，列表同时管理多种格式。

![kkFileView 文件列表同时包含金刚经 PDF 与开户确认书 docx](https://assets.xuanyuan.me/docker/blog/kkfileview-5.webp)

### 5.6 大图 PDF：高清缩放

百页级扫描 PDF（如摩崖石刻图录）可侧栏翻页、放大查看细节。

![kkFileView PDF 阅读器高清预览金刚经摩崖石刻扫描件](https://assets.xuanyuan.me/docker/blog/kkfileview-6.webp)

### 5.7 再增一本图书 PDF

列表可继续堆积业务文档与图书 PDF，方便对比预览效果。

![kkFileView 本地源列表显示怎样解题 PDF、金刚经 PDF 与 docx](https://assets.xuanyuan.me/docker/blog/kkfileview-7.webp)

### 5.8 图书封面预览

多页图书 PDF（如《怎样解题》）封面与目录页可在阅读器中正常翻阅。

![kkFileView 预览怎样解题数学思维新方法 PDF 封面](https://assets.xuanyuan.me/docker/blog/kkfileview-8.webp)

### 5.9 压缩包上架

上传 `.7z` 等压缩包后，与 PDF、docx 并列显示在本地源列表。

![kkFileView 文件列表增加泰山金刚经 7z 压缩包](https://assets.xuanyuan.me/docker/blog/kkfileview-9.webp)

### 5.10 压缩包内预览

进入压缩包目录，可直接点内部 PDF 预览，无需先解压到本机——这是「万能预览」里很实用的能力。

![kkFileView 浏览 7z 压缩包目录并预览包内金刚经 PDF](https://assets.xuanyuan.me/docker/blog/kkfileview-10.webp)

---

## 六、业务接入提示（简述）

生产环境更常见的是：**业务系统持有文件 URL**，调用预览接口，而不是长期开放演示首页上传。

- 预览入口形态类似：`/onlinePreview?url=<Base64 编码后的文件 URL>`
- 务必配置合理的 `trust.host`（白名单），生产勿长期 `trust.host = *`
- 反向代理时配置 `base.url` / `context-path`（见官方文档与 `application.properties` 注释）
- 建议关闭演示上传：`file.upload.disable = true`

官方能力与配置说明见 [kkview.cn](https://kkview.cn)。

---

## 七、常见问题 FAQ

### 7.1 提示「文件上传功能已禁用」？

`wangbowen/kkfileview:5.1.0` 配置里是字面量 `file.upload.disable = true`，**没有** `${KK_FILE_UPLOAD_DISABLE:...}`，因此 `-e KK_FILE_UPLOAD_DISABLE=false` **无效**。必须改 `application.properties` 并挂载进容器（见第四节）。

### 7.2 「预览源文件来自不受信任的站点」？

源文件 URL 的主机不在 `trust.host` 白名单。内网实测可临时 `trust.host = *`，或写成具体 IP/域名；同时检查 `not.trust.host` 是否误伤 `192.168.*`。

### 7.3 「下载失败… Connect timed out」且 URL 是本机 IP？

容器在 bridge 下访问 `http://<宿主机局域网IP>:8012/...` 失败（hairpin）。处理：

1. Compose 加 `extra_hosts: ["<该IP>:host-gateway"]`；或  
2. `network_mode: host`（并放行 UFW 8012）。

业务文件应尽量放在容器**能直接访问**的对象存储 / 内网 HTTP，而不是依赖「容器下载自己」。

### 7.4 本机 curl 通、其它电脑打不开？

`network_mode: host` + UFW active 时，需 `ufw allow 8012/tcp`。bridge + `ports` 时 Docker 通常会插入发布规则，表现不同。

### 7.5 LibreOffice 日志出现 exit code 81？

启动阶段可能短暂重启 Office 进程；若随后出现 `Connected: 'socket,...port=2001'` 且预览正常，可忽略。长期失败再加大内存或检查镜像完整性。

### 7.6 生产要不要开上传？

**不建议**。演示上传历史上出过安全问题；生产用 URL/API 接入，保持 `file.upload.disable = true`，收紧 `trust.host`。

---

## 八、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/wangbowen/kkfileview:5.1.0

# 启动 / 重建
cd /data/kkfileview && docker compose up -d --force-recreate

# 状态与日志
docker compose ps
docker logs --tail 80 kkfileview

# 探测
curl -sI http://127.0.0.1:8012/ | head -n 5

# 核对接配置
docker exec kkfileview grep -E '^(file\.upload\.disable|trust\.host)' \
  /opt/kkFileView-5.0.0/config/application.properties

# host 网络时放行防火墙
sudo ufw allow 8012/tcp comment 'kkfileview'
```

---

## 九、延伸阅读

- 轩辕镜像页：[wangbowen/kkfileview](https://xuanyuan.cloud/zh/r/wangbowen/kkfileview)（本文采用）
- 官方旧镜像页（不推荐）：[keking/kkfileview](https://xuanyuan.cloud/zh/r/keking/kkfileview)
- 标签列表：https://xuanyuan.cloud/r/wangbowen/kkfileview/tags
- 上游 Gitee：https://gitee.com/kekingcn/file-online-preview
- 镜像维护仓库：https://github.com/iwangbowen/kkFileView
- 官网：https://kkview.cn
- 轩辕使用手册：https://xuanyuan.cloud/usage



# 10 分钟上手 Stirling PDF：Docker 一键部署，浏览器里合并压缩加水印

![10 分钟上手 Stirling PDF：Docker 一键部署，浏览器里合并压缩加水印](https://img.xuanyuan.dev/docker/blog/stirling-pdf.png)

*分类: Stirling PDF,Docker,轩辕镜像,PDF工具,ultra-lite,部署教程 | 标签: Stirling PDF,Docker,轩辕镜像,PDF工具,ultra-lite,部署教程 | 发布时间: 2026-06-24 14:55:12*

> 想在浏览器里合并 PDF、加水印、改文字，又不想装 Adobe 或一堆桌面软件？**Stirling PDF** 是一款开源、可本地托管的 Web PDF 工具箱，提供合并、拆分、压缩、水印、文本编辑等 60+ 工具，文件在服务器内存中临时处理，任务完成后自动清理，适合个人与小团队私有化部署。

*本文基于 [stirlingtools/stirling-pdf:2.13.1-ultra-lite](https://xuanyuan.cloud/zh/r/stirlingtools/stirling-pdf) 镜像，Ubuntu 24.04 服务器实测*

想在浏览器里合并 PDF、加水印、改文字，又不想装 Adobe 或一堆桌面软件？**Stirling PDF** 是一款开源、可本地托管的 Web PDF 工具箱，提供合并、拆分、压缩、水印、文本编辑等 60+ 工具，文件在服务器内存中临时处理，任务完成后自动清理，适合个人与小团队私有化部署。

本文带你完成一次 **10 分钟级 Stirling PDF Docker 部署**：从 Docker 环境准备、轩辕镜像加速拉取，到一条 `docker run` 启动容器、读懂启动日志，再到浏览器里上传 PDF、编辑文字、添加水印并下载——全程零基础可跟做。下文基于 Ubuntu 24.04、约 4GB 内存环境实测，命令可直接复制执行。

国内用户从 Docker Hub 拉取 `stirlingtools/stirling-pdf` 可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速域 `docker.xuanyuan.run`。官方文档见 [Stirling PDF Docs](https://docs.stirlingpdf.com/)，源码仓库 [Stirling-Tools/Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF)。

---

## 一、环境要求

| 项目 | ultra-lite 建议 |
|------|-----------------|
| 操作系统 | Linux（本文 Ubuntu 24.04） |
| 内存 | ≥ 2 GB（实测检测到 3845 MB，JVM 自动分配约 15%～70%） |
| CPU | 双核即可 |
| 磁盘 | ≥ 5 GB 可用（镜像 + `configs` 数据） |
| 端口 | **8080**（容器内固定监听 8080，可映射到其他宿主机端口） |

> **踩坑提示**：本文使用 **ultra-lite** 精简镜像，**不含 LibreOffice**（无法 Word/Excel 转 PDF）且 **OCR 能力受限**。若侧栏出现灰色不可用工具，属预期行为，可换 `latest` 或 `fat` 镜像。首次启动约 **30 秒～2 分钟**，期间请**不要**用 `Ctrl+C` 打断 `docker logs -f`。

**镜像版本对照**（按需选择标签）：

| 标签 | 适用场景 |
|------|----------|
| `2.13.1-ultra-lite` | 低配 VPS、只要基础 PDF 操作（本文主镜像） |
| `2.13.1` / `latest` | 需要 OCR + Office 文档转换 |
| `2.13.1-fat` | 多语言字体、高质量转换 |

---

## 二、安装 Docker

若尚未安装 Docker，可使用轩辕镜像一键脚本（适用于 Linux 及国内云服务器）：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

验证：

```bash
docker --version
docker compose version
```

更多安装说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、拉取 Stirling PDF 镜像

使用轩辕镜像加速域拉取 **2.13.1-ultra-lite** 标签：

```bash
docker pull docker.xuanyuan.run/stirlingtools/stirling-pdf:2.13.1-ultra-lite
```

成功时终端显示：

```
Status: Downloaded newer image for docker.xuanyuan.run/stirlingtools/stirling-pdf:2.13.1-ultra-lite
```

| 官方镜像 | 轩辕镜像加速拉取 | 镜像说明 |
|----------|------------------|----------|
| `stirlingtools/stirling-pdf:2.13.1-ultra-lite` | `docker pull docker.xuanyuan.run/stirlingtools/stirling-pdf:2.13.1-ultra-lite` | [stirlingtools/stirling-pdf](https://xuanyuan.cloud/zh/r/stirlingtools/stirling-pdf) |

---

## 四、创建目录并一键启动容器

### 4.1 准备数据目录

持久化配置与数据库写在挂载的 `configs` 目录，重建容器后不会丢失：

```bash
mkdir -p /www/wwwroot/docker_xuanyuan_cloud/stirling-data/configs
```

若提示权限不足，可在路径前加 `sudo`，或改为 `$HOME/stirling-data/configs`，下文路径同步替换。

### 4.2 启动容器（实测命令）

```bash
docker run -d \
  --name stirling-pdf \
  --restart=unless-stopped \
  -p 8080:8080 \
  -v /www/wwwroot/docker_xuanyuan_cloud/stirling-data/configs:/configs \
  docker.xuanyuan.run/stirlingtools/stirling-pdf:2.13.1-ultra-lite
```

各参数说明：

| 参数 | 说明 |
|------|------|
| `--name stirling-pdf` | 容器名称，便于 `docker logs` / `docker stop` |
| `--restart=unless-stopped` | 服务器重启后容器自动恢复 |
| `-p 8080:8080` | 宿主机 8080 → 容器 8080；若 8080 被占用可改为 `-p 8090:8080` |
| `-v .../configs:/configs` | 设置、数据库、生成密钥持久化到宿主机 |
| 镜像标签 | `2.13.1-ultra-lite` 精简版，体积小、启动快 |

成功时终端返回容器 ID，例如：

```
462552d6e739492d5d5b3cc948f807dd37163c53c7edac9543d7aed6233970e0
```

### 4.3 查看启动日志

```bash
docker logs -f stirling-pdf
```

看到 Spring Boot 启动 banner 且无持续报错后，即可尝试浏览器访问。首次启动会生成 `settings.yml`，约 30 秒～2 分钟。

---

## 五、读懂启动日志（判断是否部署成功）

对照实测日志中的关键行，快速判断是否正常：

| 日志 | 含义 |
|------|------|
| `Detected container memory: 3845MB` | 容器可见内存，JVM 据此自动调参 |
| `Without additional features in jar` | ultra-lite 精简版，**无登录/安全扩展模块** |
| `Xvfb not installed; skipping virtual display setup` | 无虚拟显示，正常 |
| `unoserver/unoconvert not installed; skipping UNO setup` | **无 LibreOffice**，Office 转 PDF 不可用 |
| `Created settings file from template` | 首次运行，已在 `/configs` 生成配置 |
| `Starting SPDFApplication v2.13.1` | 应用版本 **2.13.1** |
| `Powered by Spring Boot 4.0.6` | 后端框架就绪中 |
| `Using default multipart file upload limit: 2000MB` | 单文件上传上限约 2 GB |

**命令行健康检查**：

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080
```

期望返回 **200** 或 **302**。同时确认容器在运行：

```bash
docker ps | grep stirling-pdf
```

---

## 六、验证部署：浏览器首次访问

在浏览器中打开（将 `YOUR_SERVER_IP` 换成服务器局域网或公网 IP）：

```
http://YOUR_SERVER_IP:8080
```

若本机在服务器上操作，也可用 `http://127.0.0.1:8080`。云服务器需确保安全组 / 防火墙已放行 **8080** 端口。

首次进入会出现 **Stirling V2** 欢迎引导，介绍新布局、管理工具与 PDF 文本编辑等功能：

![Stirling PDF V2 欢迎页：欢迎使用 Stirling V2 引导弹窗](https://img.xuanyuan.dev/docker/blog/stirling-pdf-1.png)

*图 1：部署成功后首次访问的 V2 欢迎页，点击「下一步」完成引导*

左侧可点击 **「从电脑打开」** 上传本地 PDF；右侧为工具分类（合并、压缩、水印、签署等）。

---

## 七、功能实测（跟做验证部署成功）

以下步骤用于确认服务不仅「能打开」，还能完成常见 PDF 操作。

### 7.1 打开 PDF 文件

1. 点击左侧 **「从电脑打开」**，选择任意 PDF（本文示例为打印机说明书）
2. 文件出现在左侧 **「文件」** 列表后，中间区域进入 **查看器**，可翻页、缩放

![打开 PDF 后的 Stirling PDF 主界面：查看器与右侧工具栏](https://img.xuanyuan.dev/docker/blog/stirling-pdf-2.png)

*图 2：PDF 已加载，中间为预览区，右侧为推荐工具与文档安全类工具*

### 7.2 PDF 文本编辑器（V2 新功能）

在右侧 **「推荐」** 中选择 **「PDF 文本编辑器」**（ALPHA）。首次使用会弹出说明：适合简单版式文档，复杂表格、多栏排版可能效果有限。

![PDF 文本编辑器欢迎说明：抢先体验与适用场景](https://img.xuanyuan.dev/docker/blog/stirling-pdf-3.png)

*图 3：文本编辑器说明弹窗，建议先阅读适用场景与限制*

点击 **「知道了」** 进入编辑模式，可直接选中页面文字并修改：

![PDF 文本编辑器修改文字：在页面上直接编辑正文](https://img.xuanyuan.dev/docker/blog/stirling-pdf-4.png)

*图 4：在 PDF 页面上直接修改文字，右侧可调整字体与分组模式，点击「应用更改」保存*

### 7.3 添加水印（日常高频场景）

在右侧工具栏选择 **「添加水印」**（或在「文档安全」分类中找到）：

1. **文件**：确认当前 PDF 已选中
2. **水印类型** / **措辞**：在文字框填入水印内容（示例为 `https://xuanyuan.cloud/`）
3. 按需展开 **样式**、**格式** 调整透明度、角度等
4. 点击 **「添加水印」** 生成预览

![添加水印配置界面：措辞填入 URL 或文字](https://img.xuanyuan.dev/docker/blog/stirling-pdf-5.png)

*图 5：水印配置步骤，措辞中可填文字或链接*

预览满意后，在 **「审核」** 步骤点击 **「下载」**，保存带水印的 PDF：

![水印效果预览与下载：页面铺满水印并可下载](https://img.xuanyuan.dev/docker/blog/stirling-pdf-6.png)

*图 6：水印已应用到全文预览，点击「下载」保存文件*

至此，**拉镜像 → 启容器 → 上传 PDF → 编辑文字 → 加水印下载** 全流程验证完成。

---

## 八、可选进阶配置

### 8.1 中文界面

若界面为英文，重建容器时增加环境变量：

```bash
docker stop stirling-pdf && docker rm stirling-pdf

docker run -d \
  --name stirling-pdf \
  --restart=unless-stopped \
  -p 8080:8080 \
  -v /www/wwwroot/docker_xuanyuan_cloud/stirling-data/configs:/configs \
  -e LANGS=zh_CN \
  -e SYSTEM_DEFAULTLOCALE=zh-CN \
  docker.xuanyuan.run/stirlingtools/stirling-pdf:2.13.1-ultra-lite
```

### 8.2 完整数据卷挂载

便于备份、日志排查与自动化流水线，可一次性创建子目录并挂载：

```bash
mkdir -p /www/wwwroot/docker_xuanyuan_cloud/stirling-data/{configs,logs,pipeline,customFiles,tessdata}
```

对应 `docker run` 增加卷：

```bash
-v /www/wwwroot/docker_xuanyuan_cloud/stirling-data/tessdata:/usr/share/tessdata \
-v /www/wwwroot/docker_xuanyuan_cloud/stirling-data/configs:/configs \
-v /www/wwwroot/docker_xuanyuan_cloud/stirling-data/customFiles:/customFiles \
-v /www/wwwroot/docker_xuanyuan_cloud/stirling-data/logs:/logs \
-v /www/wwwroot/docker_xuanyuan_cloud/stirling-data/pipeline:/pipeline \
```

| 挂载路径 | 作用 |
|----------|------|
| `/configs` | 设置、数据库、密钥（**务必备份**） |
| `/logs` | 应用日志 |
| `/pipeline` | 自动化流水线配置 |
| `/customFiles` | 自定义静态资源 |
| `/usr/share/tessdata` | OCR 语言包（ultra-lite 上 OCR 仍受限） |

**docker-compose.yml** 示例（与上述等价，便于长期维护）：

```yaml
services:
  stirling-pdf:
    image: docker.xuanyuan.run/stirlingtools/stirling-pdf:2.13.1-ultra-lite
    container_name: stirling-pdf
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - ./stirling-data/tessdata:/usr/share/tessdata
      - ./stirling-data/configs:/configs
      - ./stirling-data/customFiles:/customFiles
      - ./stirling-data/logs:/logs
      - ./stirling-data/pipeline:/pipeline
    environment:
      LANGS: zh_CN
      SYSTEM_DEFAULTLOCALE: zh-CN
```

```bash
cd /www/wwwroot/docker_xuanyuan_cloud
docker compose up -d
docker compose logs -f
```

### 8.3 开启登录（可选，需换镜像）

实测日志 `Without additional features in jar` 表明：**ultra-lite 不包含登录模块**。默认部署**无登录墙**，若将 8080 暴露到公网，存在被滥用的风险。

需要用户认证时，建议：

1. 换用标准镜像：`docker.xuanyuan.run/stirlingtools/stirling-pdf:2.13.1`（或 `latest`）
2. 同时设置（缺一不可）：
   - `DOCKER_ENABLE_SECURITY=true`
   - `SECURITY_ENABLELOGIN=true`
   - `SECURITY_INITIALLOGIN_USERNAME` / `SECURITY_INITIALLOGIN_PASSWORD`（首次管理员账号）
3. 保留原有 `/configs` 卷挂载

示例：

```bash
docker run -d \
  --name stirling-pdf \
  --restart=unless-stopped \
  -p 8080:8080 \
  -v /www/wwwroot/docker_xuanyuan_cloud/stirling-data/configs:/configs \
  -e DOCKER_ENABLE_SECURITY=true \
  -e SECURITY_ENABLELOGIN=true \
  -e SECURITY_INITIALLOGIN_USERNAME=admin \
  -e SECURITY_INITIALLOGIN_PASSWORD='请改为强密码' \
  docker.xuanyuan.run/stirlingtools/stirling-pdf:2.13.1
```

---

## 九、升级镜像

配置与数据在 `configs` 卷中，升级时保留挂载即可：

```bash
docker pull docker.xuanyuan.run/stirlingtools/stirling-pdf:2.13.1-ultra-lite
docker stop stirling-pdf && docker rm stirling-pdf
# 再执行第四节 docker run 或 docker compose up -d
```

---

## 十、常见问题 FAQ

**Q1：8080 打不开或浏览器超时？**

依次检查：`docker ps` 容器是否为 Up；`docker logs stirling-pdf` 是否启动完成；本机 `curl http://127.0.0.1:8080` 是否返回 200/302；云安全组与 `ufw` 是否放行 8080。

**Q2：部分工具灰色、无法点击？**

ultra-lite 预期行为。需要 Office 转换或完整 OCR 时，换 `2.13.1` / `latest` 或 `2.13.1-fat` 镜像。

**Q3：Word / Excel 转 PDF 失败？**

日志 `unoserver/unoconvert not installed` 表示无 LibreOffice，请换标准版或 fat 镜像。

**Q4：OCR 不可用或没有语言选项？**

ultra-lite 不含完整 Tesseract 栈；换 `latest` 并挂载 `tessdata` 卷后可按需下载语言包。

**Q5：上传大 PDF 失败？**

默认上传上限约 2000MB；若仍失败，检查网络稳定性与浏览器限制。

**Q6：重建容器后设置丢失？**

确认 `-v .../configs:/configs` 已挂载；数据在宿主机 `stirling-data/configs` 目录。

**Q7：如何改用其他端口？**

将 `-p 8080:8080` 改为 `-p 8090:8080`，浏览器访问 `http://YOUR_SERVER_IP:8090`。

**Q8：需要合并多个 PDF 怎么做？**

在右侧 **「推荐」** 中选择 **「合并」**，按界面提示添加多个文件并执行即可（ultra-lite 支持）。

---

## 总结

本文完成了 Stirling PDF 从 Docker 环境到浏览器功能验证的完整流程：

- 使用轩辕镜像加速拉取 `stirlingtools/stirling-pdf:2.13.1-ultra-lite`
- 一条 `docker run` 映射 8080 并持久化 `configs`
- 读懂启动日志，确认 ultra-lite 的能力边界
- 浏览器访问 V2 界面，实测 PDF 文本编辑与添加水印下载

**延伸阅读：**

- [Stirling PDF 官方文档](https://docs.stirlingpdf.com/)
- [Docker 安装指南](https://docs.stirlingpdf.com/Installation/Docker%20Install/)
- [Stirling-Tools/Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF)
- [stirlingtools/stirling-pdf 镜像页](https://xuanyuan.cloud/zh/r/stirlingtools/stirling-pdf)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

如果你在拉取 Docker 镜像时遇到速度慢、超时等问题，可以试试 [轩辕镜像](https://xuanyuan.cloud) 的加速服务；镜像页支持一键复制拉取命令。欢迎收藏 [stirlingtools/stirling-pdf](https://xuanyuan.cloud/zh/r/stirlingtools/stirling-pdf) 镜像页，获取最新标签与更新说明。



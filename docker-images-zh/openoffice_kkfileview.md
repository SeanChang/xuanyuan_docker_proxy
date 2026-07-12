---
image: openoffice/kkfileview
description: "kkFileView是一款文件文档在线预览解决方案，支持多种格式文件预览，提供一键部署、RESTful接口，兼容新版Office及国产WPS文档，适用于微服务场景快速接入。"
source: https://xuanyuan.cloud/zh/r/openoffice/kkfileview
canonical: https://xuanyuan.cloud/zh/r/openoffice/kkfileview
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openoffice/kkfileview" title="openoffice/kkfileview Docker 镜像中文简介、标签列表与拉取命令">openoffice/kkfileview 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# kkFileView Docker镜像文档

## 镜像概述

kkFileView是一款文件文档在线预览解决方案，旨在为各类系统提供便捷的文件在线预览能力。该镜像基于kkFileView社区版构建，支持独立部署，提供RESTful接口，可快速集成到微服务架构中，满足多样化的文件预览需求。

## 核心功能和特性

- **一键部署，快速接入**：简化部署流程，通过Docker命令即可快速启动服务，降低接入门槛
- **广泛格式支持**：兼容常见办公文档、国产WPS文档、图像、音视频、3D模型、CAD文件等多种格式
- **灵活预览模式**：支持多种预览模式切换，满足不同场景下的预览需求
- **微服务友好**：独立部署架构，提供标准化RESTful接口，易于集成到微服务系统中

## 快速启动

通过以下Docker命令快速启动kkFileView服务：

```bash
docker run -itd \
  --name=kkFileView \
  -p 8012:8012 \
  -e KK_TRUST_HOST=your_ip_or_domain \
  --restart=always \
docker.xuanyuan.run/openoffice/kkfileview:latest
```

**参数说明**：
- `-p 8012:8012`：端口映射，将容器内8012端口映射到主机8012端口
- `-e KK_TRUST_HOST=your_ip_or_domain`：设置信任的主机或域名，用于跨域访问控制
- `--restart=always`：设置容器开机自启

## 支持的文件类型

kkFileView支持以下各类文件格式的预览：

### 办公文档
- Office文档：doc, docx, xls, xlsx, xlsm, ppt, pptx, csv, tsv, dotm, xlt, xltm, dot, dotx, xlam, xla, pages等
- 国产WPS文档：wps, dps, et, ett, wpt等
- OpenOffice/LibreOffice文档：odt, ods, ots, odp, otp, six, ott, fodt, fods等

### 图形与设计文件
- Visio流程图：vsd, vsdx等
- Windows图像文件：wmf, emf等
- Photoshop文件：psd, eps等
- 图片文件：jpg, jpeg, png, gif, bmp, ico, jfif, webp（支持翻转、缩放、镜像）
- 其他图像格式：tif, tiff, tga, svg等

### 专业文档与模型
- 文档类：pdf, ofd, rtf, xmind, bpmn, eml, epub, drawio等
- 3D模型：obj, 3ds, stl, ply, gltf, glb, off, 3dm, fbx, dae, wrl, 3mf, ifc, brep, step, iges, fcstd, bim等
- CAD模型：dwg, dxf, dwf, iges, igs, dwt, dng, ifc, dwfx, stl, cf2, plt等
- 医疗影像：dcm等

### 其他格式
- 纯文本：txt, xml(渲染), md(渲染), java, php, py, js, css等
- 压缩包：zip, rar, jar, tar, gzip, 7z等
- 音视频：mp3, wav, mp4, flv, avi, mov, rm, webm, ts, mkv, mpeg, ogg, mpg, rmvb, wmv, 3gp, swf等（部分格式支持转码预览）

## 接入说明

以下为前端项目接入kkFileView的详细说明，假设kkFileView服务地址为：`http://127.0.0.1:8012`。

### 1. HTTP/HTTPS资源文件预览
适用于直接通过URL访问的文件，通过以下代码实现预览：

```javascript
var url = 'http://127.0.0.1:8080/file/test.txt'; // 要预览文件的访问地址
window.open('http://127.0.0.1:8012/onlinePreview?url=' + encodeURIComponent(base64Encode(url)));
```

### 2. HTTP/HTTPS流资源文件预览
适用于通过接口（如带fileId参数）返回文件流的场景，需指定文件名：

```javascript
var originUrl = 'http://127.0.0.1:8080/filedownload?fileId=1'; // 要预览文件的访问地址
var previewUrl = originUrl + '&fullfilename=test.txt'; // 添加文件名参数
window.open('http://127.0.0.1:8012/onlinePreview?url=' + encodeURIComponent(Base64.encode(previewUrl)));
```

### 3. FTP资源文件预览（匿名访问）
适用于可匿名访问的FTP文件：

```javascript
var url = 'ftp://127.0.0.1/file/test.txt'; // 要预览文件的访问地址
window.open('http://127.0.0.1:8012/onlinePreview?url=' + encodeURIComponent(Base64.encode(url)));
```

### 4. FTP加密资源文件预览（需认证）
适用于需要用户名密码认证的FTP文件，通过URL参数传递认证信息：

```javascript
var originUrl = 'ftp://127.0.0.1/file/test.txt'; // 要预览文件的访问地址
var previewUrl = originUrl + '?ftp.username=xx&ftp.password=xx&ftp.control.encoding=xx'; // 添加认证参数
window.open('http://127.0.0.1:8012/onlinePreview?url=' + encodeURIComponent(Base64.encode(previewUrl)));
```

**注**：上述代码中的`base64Encode`/`Base64.encode`为Base64编码函数，需确保前端实现该功能。

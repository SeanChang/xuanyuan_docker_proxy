---
image: kasmweb/edge
description: "适用于Kasm Workspaces的Microsoft Edge Insider Preview浏览器镜像，支持通过浏览器访问，集成KasmVNC实现高性能Web原生渲染，可用于桌面、应用及Web服务的流式访问。"
source: https://xuanyuan.cloud/zh/r/kasmweb/edge
canonical: https://xuanyuan.cloud/zh/r/kasmweb/edge
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/edge" title="kasmweb/edge Docker 镜像中文简介、标签列表与拉取命令">kasmweb/edge 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm Workspaces Edge镜像

## 实时演示

[在新浏览器窗口启动实时演示](https://app.kasmweb.com/#/cast/2153006857)。

> **注意**：演示限制3分钟，出于安全考虑，上传/下载功能受限。

## 快速开始

试用免费社区版：[下载][download]。

Kasm Workspaces团队开源了镜像库（[信息][image_info] & [源代码][workspaces_images]）。

Web原生渲染由开源项目[KasmVNC][kasmvnc]提供支持。

## 关于本镜像

本镜像包含可通过浏览器访问的[Microsoft Edge Insider Preview](https://www.microsoftedgeinsider.com/en-us/download?platform=linux-deb)版本。

![截图][Image_Screenshot]

[Image_Screenshot]: https://f.hubspotusercontent30.net/hubfs/5856039/dockerhub/image-screenshots/edge.png "Image Screenshot"

## 环境变量

* `LAUNCH_URL` - 浏览器启动时默认访问的URL。
* `APP_ARGS` - 启动浏览器时传递的额外参数。
* `KASM_RESTRICTED_FILE_CHOOSER` - 将“文件上传”和“文件保存”对话框限制在~/Desktop目录，默认启用。

## 独立部署

本镜像设计用于在Kasm Workspaces中运行，但也可独立部署并通过浏览器访问。

```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/edge:1.18.0
```

容器现在可通过浏览器访问：https://服务器IP:6901

* 用户：kasm_user
* 密码：password

**请注意，部分功能（如音频、上传、下载和麦克风直通）仅在使用Kasm Workspaces进行编排时可用。**

## 标签

* 1.18.0
  - 镜像根据Kasm Workspaces版本构建并标记。

* 1.18.0-rolling
  - 滚动标签镜像每晚更新构建，确保运行最新版本。

* develop
  - develop标签用于测试，不保证兼容性。

## 其他信息

### 源代码
* [KasmVNC GitHub][kasmvnc]：开源VNC服务器，支持Web原生、安全、高性能。
* [镜像GitHub][workspaces_images]：Workspaces Docker镜像库。
* [核心镜像GitHub][core_images]：用于自定义镜像的核心OS基线库。

### Workspaces文档
* [开发者API][developer_api]：与应用和工作流集成。
* [Workspaces][installation]：安装和配置Kasm Workspaces的说明。
* [自定义镜像][custom_images]：配置自定义镜像和安装软件的信息。

### 问题报告
* [GitHub问题跟踪][github_support]：社区问题报告。


[workspaces_images]: https://github.com/kasmtech/workspaces-images "Workspaces Images"
[kasmvnc]: https://github.com/kasmtech/KasmVNC "KasmVNC"
[image_info]: https://www.kasmweb.com/docs/latest/guide/custom_images.html "Image Info"
[download]: https://kasmweb.com/downloads "Download"
[core_images]: https://github.com/kasmtech/workspaces-core-images "Core Images"
[developer_api]: https://www.kasmweb.com/docs/latest/developers/developer_api.html "Developer API"
[installation]: https://www.kasmweb.com/docs/latest/install.html "Installation"
[custom_images]: https://www.kasmweb.com/docs/latest/how_to/building_images.html "Custom Images"
[github_support]: https://github.com/kasmtech/workspaces-issues/issues "GitHub Support"

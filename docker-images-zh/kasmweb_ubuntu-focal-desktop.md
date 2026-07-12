---
image: kasmweb/ubuntu-focal-desktop
description: "适用于Kasm Workspaces的Ubuntu Focal桌面镜像，包含生产力和开发应用，支持浏览器访问，也可独立部署。"
source: https://xuanyuan.cloud/zh/r/kasmweb/ubuntu-focal-desktop
canonical: https://xuanyuan.cloud/zh/r/kasmweb/ubuntu-focal-desktop
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/ubuntu-focal-desktop" title="kasmweb/ubuntu-focal-desktop Docker 镜像中文简介、标签列表与拉取命令">kasmweb/ubuntu-focal-desktop 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

**Kasm Workspaces是一个Docker容器流平台，用于通过浏览器提供对桌面、应用程序和Web服务的访问。**

# 在线演示

<a href="https://app.kasmweb.com/#/cast/5124887069" target="_blank"><img src="https://info.kasmweb.com/hubfs/dockerhub/GIFs/ubuntu-focal-desktop.gif" width="640" height="360"></a>

**在新浏览器窗口中启动实时演示：** <a href="https://app.kasmweb.com/#/cast/5124887069" target="_blank">在线演示</a>。

<a href="https://app.kasmweb.com/#/cast/5124887069" target="_blank"><img src="https://5856039.fs1.hubspotusercontent-na1.net/hub/5856039/hubfs/dockerhub/casting-buttons/UbuntuFocalDesktop.png" width="300" height="104"></a>

&lowast;*注意：演示时长限制为3分钟，出于安全考虑，上传/下载功能已受限。*


# 快速开始

试用免费的社区版：[下载][download]。

Kasm Workspaces团队已开源我们的镜像库（[信息][image_info] 和 [源代码][workspaces_images]）。

基于Web的渲染由我们的开源项目提供支持：[KasmVNC][kasmvnc]。

# 关于此镜像

此镜像包含可通过浏览器访问的Ubuntu Focal桌面，已安装各种生产力和开发应用。

![截图][Image_Screenshot]

[Image_Screenshot]: https://f.hubspotusercontent30.net/hubfs/5856039/dockerhub/image-screenshots/ubuntu-focal-desktop.png "Image Screenshot"

# 独立部署

此镜像设计用于在Kasm Workspaces中原生运行，但也可独立部署并通过Web浏览器访问。

```
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/ubuntu-focal-desktop:1.16.0
```

容器现在可通过浏览器访问：https://服务器IP:6901

* 用户：kasm_user
* 密码：password

**请注意，某些功能（如音频、上传、下载和麦克风直通）仅在使用Kasm Workspaces进行编排时可用。**

# 标签

* 1.16.0
  - 镜像按Kasm Workspaces版本号构建和标记。

* 1.16.0-rolling
  - 滚动标签（rolling tags）是每晚更新和构建的镜像，确保您的镜像运行最新版本。

* develop
  - develop标签用于测试，不保证兼容性。

# 其他信息

* 源代码
  - [KasmVNC GitHub][kasmvnc]：开源VNC服务器，支持Web原生、安全、高性能。
  - [镜像GitHub][workspaces_images]：Workspaces Docker镜像库。
  - [核心镜像GitHub][core_images]：用于自定义镜像的核心OS基线库。

* Workspaces文档
  - [开发者API][developer_api]：与您的应用程序和工作流集成。
  - [Workspaces][installation]：安装和配置Kasm Workspaces的说明。
  - [自定义镜像][custom_images]：配置自定义镜像和安装软件的信息。

* 问题报告
  - [GitHub问题跟踪器][github_support]：社区问题报告。


[workspaces_images]: https://github.com/kasmtech/workspaces-images "Workspaces Images"
[kasmvnc]: https://github.com/kasmtech/KasmVNC "KasmVNC"
[image_info]: https://www.kasmweb.com/docs/latest/guide/custom_images.html "Image Info"
[download]: https://kasmweb.com/downloads "Download"
[core_images]: https://github.com/kasmtech/workspaces-core-images "Core Images"
[developer_api]: https://www.kasmweb.com/docs/latest/developers/developer_api.html "Developer API"
[installation]: https://www.kasmweb.com/docs/latest/install.html "Installation"
[custom_images]: https://www.kasmweb.com/docs/latest/how_to/building_images.html "Custom Images"
[github_support]: https://github.com/kasmtech/workspaces-issues/issues "GitHub Support"

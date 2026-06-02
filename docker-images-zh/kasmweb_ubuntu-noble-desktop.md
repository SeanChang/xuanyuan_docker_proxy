---
image: kasmweb/ubuntu-noble-desktop
description: "适用于Kasm Workspaces的Ubuntu生产力桌面"
source: https://xuanyuan.cloud/zh/r/kasmweb/ubuntu-noble-desktop
canonical: https://xuanyuan.cloud/zh/r/kasmweb/ubuntu-noble-desktop
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [kasmweb/ubuntu-noble-desktop — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/kasmweb/ubuntu-noble-desktop)

含镜像标签、拉取命令、部署文档与相关推荐。

[kasmweb/ubuntu-noble-desktop Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/kasmweb/ubuntu-noble-desktop)

**Kasm Workspaces 是一个Docker容器流平台，用于提供基于浏览器的桌面、应用程序和Web服务访问。**

# 实时演示

<a href="https://app.kasmweb.com/#/cast/6708319219" target="_blank"><img src="https://info.kasmweb.com/hubfs/dockerhub/GIFs/ubuntu-jammy-desktop.gif" width="640" height="360"></a>

**在新浏览器窗口中启动实时演示：** <a href="https://app.kasmweb.com/#/cast/6708319219" target="_blank">实时演示</a>。

<a href="https://app.kasmweb.com/#/cast/6708319219" target="_blank"><img src="https://5856039.fs1.hubspotusercontent-na1.net/hubfs/dockerhub/casting-buttons/UbuntuJammyDesktop.png" width="300" height="104"></a>

*注：演示时长限制为3分钟，出于安全考虑，上传/下载功能受限。*


# 开始使用

试用我们的免费社区版：[下载][download]。

我们的Kasm Workspaces团队开源了我们的镜像库（[信息][image_info] 和 [源代码][workspaces_images]）。

基于Web的渲染由我们的开源项目提供支持：[KasmVNC][kasmvnc]。

# 关于此镜像

此镜像包含可通过浏览器访问的Ubuntu Noble桌面，预装了各种生产力和开发应用。

![截图][Image_Screenshot]

[Image_Screenshot]: https://5856039.fs1.hubspotusercontent-na1.net/hubfs/5856039/dockerhub/image-screenshots/ubuntu_jammy_desktop.png "Image Screenshot"

此镜像预装了Signal应用。Signal实施严格的安全规则，若检测到SSL检测（中间人攻击），会阻止网络访问。当**WebFilter**启用时，为确保Signal正常运行，必须在**WebFilter配置**的**SSL绕过域名**列表中添加以下域名（注意前面的点(.)确保所有子域名也被绕过）：
```
.signal.org
.signal.art
.signal.tube
.signal.group
.signal.link
.signal.me
```


# 独立部署

此镜像设计用于在Kasm Workspaces中原生运行，但也可独立部署并通过浏览器访问。

```
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/ubuntu-noble-desktop:1.17.0
```

容器现在可通过浏览器访问：https://服务器IP:6901

* 用户：kasm_user
* 密码：password

**请注意，部分功能（如音频、上传、下载和麦克风直通）仅在使用Kasm Workspaces进行编排时可用。**

# 标签

* 1.17.0
  - 镜像按Kasm Workspaces版本号构建和标记。

* 1.17.0-rolling
  - 滚动标签镜像每晚更新构建，确保运行最新版本。

* develop
  - develop标签用于测试，不保证兼容性。

# 其他信息

* 源代码
  - [KasmVNC GitHub][kasmvnc]：开源VNC服务器，支持Web原生、安全、高性能。
  - [Images GitHub][workspaces_images]：Workspaces Docker镜像库。
  - [Core Images GitHub][core_images]：用于自定义镜像的核心OS基线库。

* Workspaces文档
  - [开发者API][developer_api]：与您的应用程序和工作流集成。
  - [Workspaces][installation]：Kasm Workspaces安装和配置说明。
  - [自定义镜像][custom_images]：配置自定义镜像和安装软件的信息。

* 问题报告
  - [GitHub Issue Tracker][github_support]：社区问题报告。


[workspaces_images]: https://github.com/kasmtech/workspaces-images "Workspaces Images"
[kasmvnc]: https://github.com/kasmtech/KasmVNC "KasmVNC"
[image_info]: https://www.kasmweb.com/docs/latest/guide/custom_images.html "Image Info"
[download]: https://kasmweb.com/downloads "Download"
[core_images]: https://github.com/kasmtech/workspaces-core-images "Core Images"
[developer_api]: https://www.kasmweb.com/docs/latest/developers/developer_api.html "Developer API"
[installation]: https://www.kasmweb.com/docs/latest/install.html "Installation"
[custom_images]: https://www.kasmweb.com/docs/latest/how_to/building_images.html "Custom Images"
[github_support]: https://github.com/kasmtech/workspaces-issues/issues "GitHub Support"

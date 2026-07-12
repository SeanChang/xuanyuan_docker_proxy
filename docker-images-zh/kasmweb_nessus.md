---
image: kasmweb/nessus
description: "适用于Kasm Workspaces的Nessus漏洞扫描器"
source: https://xuanyuan.cloud/zh/r/kasmweb/nessus
canonical: https://xuanyuan.cloud/zh/r/kasmweb/nessus
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/nessus" title="kasmweb/nessus Docker 镜像中文简介、标签列表与拉取命令">kasmweb/nessus 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

**Kasm Workspaces是一个Docker容器流平台，用于提供基于浏览器的桌面、应用程序和Web服务访问。**

# 实时演示

<a href="https://app.kasmweb.com/#/cast/42823419034" target="_blank"><img src="https://info.kasmweb.com/hubfs/dockerhub/GIFs/nessus.gif" width="640" height="360"></a>

**在新浏览器窗口中启动实时演示：** <a href="https://app.kasmweb.com/#/cast/42823419034" target="_blank">实时演示</a>。

<a href="https://app.kasmweb.com/#/cast/42823419034" target="_blank"><img src="https://5856039.fs1.hubspotusercontent-na1.net/hub/5856039/hubfs/dockerhub/casting-buttons/nessus.png" width="300" height="104"></a>

&lowast;*注意：演示限制为3分钟，出于安全考虑，上传/下载功能受到限制。*


# 开始使用

试用我们的免费社区版：[下载][download]。

Kasm Workspaces团队已开源我们的镜像库（[信息][image_info] 和 [源代码][workspaces_images]）。

基于Web的渲染由我们的开源项目提供支持：[KasmVNC][kasmvnc]。

# 关于此镜像

此镜像包含可通过浏览器访问的[Tennable Nessus](https://www.tenable.com/products/nessus)版本。

![截图][Image_Screenshot]

[Image_Screenshot]: https://5856039.fs1.hubspotusercontent-na1.net/hubfs/5856039/dockerhub/image-screenshots/nessus.png "Image Screenshot"

# 环境变量

* `APP_ARGS` - 启动应用程序时传递的附加参数。


# 独立部署

此镜像设计用于在Kasm Workspaces中原生运行，但也可独立部署并通过Web浏览器访问。

```
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/nessus:1.17.0
```

容器现在可通过浏览器访问：https://服务器IP:6901

* 用户：kasm_user
* 密码：password

**请注意，部分功能（如音频、上传、下载和麦克风直通）仅在使用Kasm Workspaces进行编排时可用。**

# 标签

* 1.17.0
  - 镜像根据Kasm Workspaces版本进行构建和标记。

* 1.17.0-rolling
  - Rolling标签的镜像每晚更新和构建，确保运行最新版本。

* develop
  - develop标签用于测试，不保证兼容性。

# 其他信息

* 源代码
  - [KasmVNC GitHub][kasmvnc]：开源VNC服务器，支持Web原生、安全、高性能。
  - [镜像GitHub][workspaces_images]：Workspaces Docker镜像库。
  - [核心镜像GitHub][core_images]：用于自定义镜像的核心OS基线库。

* Workspaces文档
  - [开发者API][developer_api]：与您的应用程序和工作流集成。
  - [Workspaces][installation]：Kasm Workspaces安装和配置说明。
  - [自定义镜像][custom_images]：自定义镜像配置和软件安装信息。

* 问题反馈
  - [GitHub问题跟踪器][github_support]：社区问题反馈。


[workspaces_images]: https://github.com/kasmtech/workspaces-images "Workspaces Images"
[kasmvnc]: https://github.com/kasmtech/KasmVNC "KasmVNC"
[image_info]: https://www.kasmweb.com/docs/latest/guide/custom_images.html "Image Info"
[download]: https://kasmweb.com/downloads "Download"
[core_images]: https://github.com/kasmtech/workspaces-core-images "Core Images"
[developer_api]: https://www.kasmweb.com/docs/latest/developers/developer_api.html "Developer API"
[installation]: https://www.kasmweb.com/docs/latest/install.html "Installation"
[custom_images]: https://www.kasmweb.com/docs/latest/how_to/building_images.html "Custom Images"
[github_support]: https://github.com/kasmtech/workspaces-issues/issues "GitHub Support"

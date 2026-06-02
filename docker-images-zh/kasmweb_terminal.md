---
image: kasmweb/terminal
description: "Kasm Workspaces的浏览器可访问版xfce4-terminal，用于在Docker容器流平台中提供基于浏览器的终端访问，支持通过Web界面使用xfce4-terminal终端应用。"
source: https://xuanyuan.cloud/zh/r/kasmweb/terminal
canonical: https://xuanyuan.cloud/zh/r/kasmweb/terminal
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/terminal" title="kasmweb/terminal Docker 镜像中文简介、标签列表与拉取命令">kasmweb/terminal — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/kasmweb/terminal" title="kasmweb/terminal Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/kasmweb/terminal</a>

# Kasm Workspaces 终端镜像

**Kasm Workspaces是一个Docker容器流平台，用于提供基于浏览器的桌面、应用程序和Web服务访问。**

## 在线演示

<a href="https://app.kasmweb.com/#/cast/8660593092" target="_blank"><img src="https://info.kasmweb.com/hubfs/dockerhub/GIFs/terminal.gif" width="640" height="360"></a>

**在新浏览器窗口中启动实时演示：** <a href="https://app.kasmweb.com/#/cast/8660593092" target="_blank">在线演示</a>。

<a href="https://app.kasmweb.com/#/cast/8660593092" target="_blank"><img src="https://5856039.fs1.hubspotusercontent-na1.net/hub/5856039/hubfs/dockerhub/casting-buttons/Terminal.png" width="300" height="104"></a>

*注意：演示限制3分钟，出于安全考虑，上传/下载功能受限。*


## 快速开始

试用我们的免费社区版：[下载][download]。

Kasm Workspaces团队已开源我们的镜像库（[信息][image_info] 和 [源代码][workspaces_images]）。

Web原生渲染由我们的开源项目提供支持：[KasmVNC][kasmvnc]。


## 关于此镜像

此镜像包含[xfce4-terminal](https://docs.xfce.org/apps/terminal/start)的浏览器可访问版本。

![截图][Image_Screenshot]

[Image_Screenshot]: https://f.hubspotusercontent30.net/hubfs/5856039/dockerhub/image-screenshots/terminal.png "镜像截图"


## 环境变量

* `TERMINAL_ARGS` - 启动应用程序时传递的额外参数。
* `SHELL_EXEC` - 终端启动时运行的命令。


## 独立部署

此镜像设计用于在Kasm Workspaces中原生运行，但也可独立部署并通过浏览器访问。

```
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/terminal:1.17.0
```

容器现在可通过浏览器访问：https://服务器IP:6901

* 用户：kasm_user
* 密码：password

**请注意，某些功能（如音频、上传、下载和麦克风直通）仅在使用Kasm Workspaces进行编排时可用。**


## 标签

* 1.17.0
  - 镜像根据Kasm Workspaces发布版本构建和标记。

* 1.17.0-rolling
  - 滚动标签镜像每晚更新构建，确保镜像运行最新版本。

* develop
  - develop标签用于测试，不保证兼容性。


## 其他信息

### 源代码
* [KasmVNC GitHub][kasmvnc]：开源VNC服务器，支持Web原生、安全、高性能。
* [镜像GitHub][workspaces_images]：Workspaces Docker镜像库。
* [核心镜像GitHub][core_images]：用于自定义镜像的核心OS基线库。

### Workspaces文档
* [开发者API][developer_api]：与您的应用程序和工作流集成。
* [Workspaces][installation]：Kasm Workspaces安装和配置说明。
* [自定义镜像][custom_images]：配置自定义镜像和安装软件的信息。

### 问题报告
* [GitHub问题跟踪器][github_support]：社区问题报告。


[workspaces_images]: https://github.com/kasmtech/workspaces-images "工作区镜像"
[kasmvnc]: https://github.com/kasmtech/KasmVNC "KasmVNC"
[image_info]: https://www.kasmweb.com/docs/latest/guide/custom_images.html "镜像信息"
[download]: https://kasmweb.com/downloads "下载"
[core_images]: https://github.com/kasmtech/workspaces-core-images "核心镜像"
[developer_api]: https://www.kasmweb.com/docs/latest/developers/developer_api.html "开发者API"
[installation]: https://www.kasmweb.com/docs/latest/install.html "安装"
[custom_images]: https://www.kasmweb.com/docs/latest/how_to/building_images.html "自定义镜像"
[github_support]: https://github.com/kasmtech/workspaces-issues/issues "GitHub支持"

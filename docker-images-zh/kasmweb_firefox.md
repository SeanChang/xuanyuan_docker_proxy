---
image: kasmweb/firefox
description: "适用于Kasm Workspaces的浏览器可访问版本的Mozilla Firefox，支持通过Web界面访问Firefox浏览器，可集成于Kasm Workspaces平台或独立部署。"
source: https://xuanyuan.cloud/zh/r/kasmweb/firefox
canonical: https://xuanyuan.cloud/zh/r/kasmweb/firefox
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/firefox" title="kasmweb/firefox Docker 镜像中文简介、标签列表与拉取命令">kasmweb/firefox — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/kasmweb/firefox" title="kasmweb/firefox Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/kasmweb/firefox</a>

# Kasm Workspaces Firefox镜像

Kasm Workspaces是一个Docker容器流式传输平台，用于提供基于浏览器的桌面、应用程序和Web服务访问。

## 在线演示

<a href="https://app.kasmweb.com/#/cast/9504951512" target="_blank"><img src="https://info.kasmweb.com/hubfs/dockerhub/GIFs/firefox.gif" width="640" height="360"></a>

**在新浏览器窗口中启动实时演示：** <a href="https://app.kasmweb.com/#/cast/9504951512" target="_blank">在线演示</a>。

<a href="https://app.kasmweb.com/#/cast/9504951512" target="_blank"><img src="https://5856039.fs1.hubspotusercontent-na1.net/hub/5856039/hubfs/dockerhub/casting-buttons/Firefox.png" width="300" height="104"></a>

*注：演示时长限制为3分钟，出于安全考虑，上传/下载功能受限。*


## 快速开始

试用免费的社区版：[下载][download]。

Kasm Workspaces团队已开源我们的镜像库（[信息][image_info] & [源代码][workspaces_images]）。

基于Web的渲染由我们的开源项目提供支持：[KasmVNC][kasmvnc]。


## 关于本镜像

本镜像包含可通过浏览器访问的[Mozilla Firefox](https://www.mozilla.org/)版本。

![截图][Image_Screenshot]

[Image_Screenshot]: https://f.hubspotusercontent30.net/hubfs/5856039/dockerhub/image-screenshots/firefox.png "镜像截图"


## 环境变量

* `LAUNCH_URL` - 浏览器创建时默认启动的URL。
* `APP_ARGS` - 启动浏览器时传递的额外参数。
* `KASM_RESTRICTED_FILE_CHOOSER` - 将“文件上传”和“文件保存”对话框限制在~/Desktop目录。默认启用。


## 独立部署

本镜像设计用于在Kasm Workspaces中原生运行，但也可独立部署并通过浏览器访问。

```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/firefox:1.18.0
```

容器现在可通过浏览器访问：https://服务器IP:6901

* 用户：kasm_user
* 密码：password

**请注意，部分功能（如音频、上传、下载和麦克风直通）仅在使用Kasm Workspaces进行编排时可用。**


## 标签

* 1.18.0
  - 镜像使用Kasm Workspaces发布版本号进行构建和标记。

* 1.18.0-rolling
  - Rolling标签的镜像每晚更新构建，确保运行最新版本。

* develop
  - develop标签用于测试，不保证兼容性。


## 其他信息

### 源代码
  - [KasmVNC GitHub][kasmvnc]：开源VNC服务器，支持Web原生、安全、高性能。
  - [镜像GitHub][workspaces_images]：Workspaces Docker镜像库。
  - [核心镜像GitHub][core_images]：用于自定义镜像的核心OS基线库。

### Workspaces文档
  - [开发者API][developer_api]：与您的应用程序和工作流集成。
  - [Workspaces][installation]：Kasm Workspaces安装和配置说明。
  - [自定义镜像][custom_images]：配置自定义镜像和安装软件的信息。

### 问题报告
  - [GitHub问题跟踪][github_support]：社区问题反馈。


[workspaces_images]: https://github.com/kasmtech/workspaces-images "Workspaces镜像"
[kasmvnc]: https://github.com/kasmtech/KasmVNC "KasmVNC"
[image_info]: https://www.kasmweb.com/docs/latest/guide/custom_images.html "镜像信息"
[download]: https://kasmweb.com/downloads "下载"
[core_images]: https://github.com/kasmtech/workspaces-core-images "核心镜像"
[developer_api]: https://www.kasmweb.com/docs/latest/developers/developer_api.html "开发者API"
[installation]: https://www.kasmweb.com/docs/latest/install.html "安装"
[custom_images]: https://www.kasmweb.com/docs/latest/how_to/building_images.html "自定义镜像"
[github_support]: https://github.com/kasmtech/workspaces-issues/issues "GitHub支持"

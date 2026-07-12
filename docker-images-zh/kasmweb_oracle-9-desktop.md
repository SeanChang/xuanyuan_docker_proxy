---
image: kasmweb/oracle-9-desktop
description: "Kasm Workspaces的Oracle 9桌面镜像，提供浏览器可访问的桌面环境，预装多种生产力和开发应用，支持独立部署或集成到Kasm Workspaces平台，通过Web浏览器即可访问。"
source: https://xuanyuan.cloud/zh/r/kasmweb/oracle-9-desktop
canonical: https://xuanyuan.cloud/zh/r/kasmweb/oracle-9-desktop
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/oracle-9-desktop" title="kasmweb/oracle-9-desktop Docker 镜像中文简介、标签列表与拉取命令">kasmweb/oracle-9-desktop 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm Workspaces Oracle 9桌面镜像

## 实时演示

<a href="https://app.kasmweb.com/#/cast/6708319219" target="_blank"><img src="https://info.kasmweb.com/hubfs/dockerhub/GIFs/ubuntu-jammy-desktop.gif" width="640" height="360"></a>

**在新浏览器窗口中启动实时演示：** <a href="https://app.kasmweb.com/#/cast/6708319219" target="_blank">实时演示</a>

<a href="https://app.kasmweb.com/#/cast/6708319219" target="_blank"><img src="https://5856039.fs1.hubspotusercontent-na1.net/hub/5856039/hubfs/dockerhub/casting-buttons/UbuntuJammyDesktop.png" width="300" height="104"></a>

*注意：演示时长限制为3分钟，出于安全考虑，上传/下载功能已受限。*


## 快速开始

试用免费社区版：[下载][download]

Kasm Workspaces团队已开源镜像库（[详情][image_info] 和 [源代码][workspaces_images]）。

Web原生渲染功能由开源项目 [KasmVNC][kasmvnc] 提供支持。


## 关于此镜像

本镜像包含浏览器可访问的Oracle 9桌面环境，预装多种生产力和开发应用。

![截图][Image_Screenshot]

[Image_Screenshot]: https://info.kasmweb.com/hubfs/dockerhub/image-screenshots/oracle-9-desktop.png "镜像截图"


## 独立部署

此镜像设计用于在Kasm Workspaces中原生运行，也可独立部署并通过Web浏览器访问。

```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/oracle-9-desktop:1.17.0
```

容器现在可通过浏览器访问：https://服务器IP:6901

* 用户：kasm_user
* 密码：password

**注意：部分功能（如音频、上传、下载和麦克风直通）仅在使用Kasm Workspaces编排时可用。**


## 标签

* 1.17.0
  - 镜像根据Kasm Workspaces版本号构建和标记。

* 1.17.0-rolling
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

### 问题反馈
* [GitHub Issue Tracker][github_support]：社区问题反馈。


[workspaces_images]: https://github.com/kasmtech/workspaces-images "Workspaces镜像"
[kasmvnc]: https://github.com/kasmtech/KasmVNC "KasmVNC"
[image_info]: https://www.kasmweb.com/docs/latest/guide/custom_images.html "镜像信息"
[download]: https://kasmweb.com/downloads "下载"
[core_images]: https://github.com/kasmtech/workspaces-core-images "核心镜像"
[developer_api]: https://www.kasmweb.com/docs/latest/developers/developer_api.html "开发者API"
[installation]: https://www.kasmweb.com/docs/latest/install.html "安装指南"
[custom_images]: https://www.kasmweb.com/docs/latest/how_to/building_images.html "自定义镜像"
[github_support]: https://github.com/kasmtech/workspaces-issues/issues "GitHub支持"

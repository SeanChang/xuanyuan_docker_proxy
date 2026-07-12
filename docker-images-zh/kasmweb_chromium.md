---
image: kasmweb/chromium
description: "Kasm Workspaces的浏览器可访问版Chromium镜像，提供基于浏览器的桌面、应用和Web服务访问，通过开源KasmVNC实现Web原生渲染，支持独立部署和环境变量配置。"
source: https://xuanyuan.cloud/zh/r/kasmweb/chromium
canonical: https://xuanyuan.cloud/zh/r/kasmweb/chromium
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/chromium" title="kasmweb/chromium Docker 镜像中文简介、标签列表与拉取命令">kasmweb/chromium 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm Workspaces Chromium镜像

## 镜像概述和主要用途
Kasm Workspaces是一个Docker容器流平台，用于提供基于浏览器的桌面、应用和Web服务访问。本镜像包含可通过浏览器访问的[Chromium](https://www.chromium.org/Home)版本，支持通过KasmVNC实现Web原生渲染，可集成到Kasm Workspaces或独立部署。

## 实时演示

[在新浏览器窗口启动实时演示](https://app.kasmweb.com/#/cast/9365782355)。

![Chromium演示](https://info.kasmweb.com/hubfs/dockerhub/GIFs/chromium.gif "Chromium演示")

![Chromium访问按钮](https://5856039.fs1.hubspotusercontent-na1.net/hub/5856039/hubfs/dockerhub/casting-buttons/Chromium.png "Chromium访问按钮")

*注：演示时长限制为3分钟，出于安全考虑，上传/下载功能受限。*

## 快速开始

尝试免费社区版：[下载][download]。

Kasm Workspaces团队开源了镜像库（[信息][image_info] & [源代码][workspaces_images]）。

Web原生渲染由开源项目[KasmVNC][kasmvnc]提供支持。

## 关于本镜像

本镜像包含可通过浏览器访问的Chromium版本。

![镜像截图][Image_Screenshot]

[Image_Screenshot]: https://f.hubspotusercontent30.net/hubfs/5856039/dockerhub/image-screenshots/chromium.png "Chromium镜像截图"

## 环境变量

- `LAUNCH_URL` - 浏览器启动时默认访问的URL。
- `APP_ARGS` - 启动浏览器时传递的额外参数。
- `KASM_RESTRICTED_FILE_CHOOSER` - 将"文件上传"和"文件保存"对话框限制在~/Desktop目录，默认启用。

## 独立部署

本镜像设计用于在Kasm Workspaces中运行，也可独立部署并通过浏览器访问：

```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/chromium:1.18.0
```

容器可通过浏览器访问：https://服务器IP:6901

- 用户：kasm_user
- 密码：password

> 注意：部分功能（如音频、上传、下载和麦克风直通）仅在使用Kasm Workspaces编排时可用。

## 标签说明

- `1.18.0` - 按Kasm Workspaces发布版本构建和标记的镜像。
- `1.18.0-rolling` - 滚动标签镜像，每日更新构建，确保运行最新版本。
- `develop` - 测试用标签，不保证兼容性。

## 其他信息

### 源代码
- [KasmVNC GitHub][kasmvnc]：开源VNC服务器，支持Web原生、安全、高性能渲染。
- [镜像库GitHub][workspaces_images]：Workspaces Docker镜像库。
- [核心镜像GitHub][core_images]：用于自定义镜像的核心OS基线库。

### Workspaces文档
- [开发者API][developer_api]：与应用和工作流集成。
- [Workspaces安装][installation]：Kasm Workspaces安装和配置指南。
- [自定义镜像][custom_images]：自定义镜像配置和软件安装说明。

### 问题反馈
- [GitHub Issue Tracker][github_support]：社区问题反馈渠道。


[workspaces_images]: https://github.com/kasmtech/workspaces-images "Workspaces Images"
[kasmvnc]: https://github.com/kasmtech/KasmVNC "KasmVNC"
[image_info]: https://www.kasmweb.com/docs/latest/guide/custom_images.html "镜像信息"
[download]: https://kasmweb.com/downloads "下载"
[core_images]: https://github.com/kasmtech/workspaces-core-images "核心镜像"
[developer_api]: https://www.kasmweb.com/docs/latest/developers/developer_api.html "开发者API"
[installation]: https://www.kasmweb.com/docs/latest/install.html "安装指南"
[custom_images]: https://www.kasmweb.com/docs/latest/how_to/building_images.html "自定义镜像"
[github_support]: https://github.com/kasmtech/workspaces-issues/issues "GitHub支持"

---
image: kasmweb/core-cuda-focal
description: "Kasm Workspaces的CUDA工具包基础镜像，提供GPU加速支持，适用于构建和运行依赖CUDA的应用环境。"
source: https://xuanyuan.cloud/zh/r/kasmweb/core-cuda-focal
canonical: https://xuanyuan.cloud/zh/r/kasmweb/core-cuda-focal
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [kasmweb/core-cuda-focal — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/kasmweb/core-cuda-focal)

含镜像标签、拉取命令、部署文档与相关推荐。

[kasmweb/core-cuda-focal Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/kasmweb/core-cuda-focal)

# kasmweb/core-cuda-focal 镜像技术文档


## 实时演示

**在新浏览器窗口启动实时演示**：<a href="https://app.kasmweb.com/#/cast/4398794189" target="_blank">实时演示</a>

<a href="https://app.kasmweb.com/#/cast/4398794189" target="_blank"><img src="https://5856039.fs1.hubspotusercontent-na1.net/hub/5856039/hubfs/dockerhub/casting-buttons/CoreCUDAFocal.png" width="300" height="104"></a>

*此演示链接到Jammy桌面镜像，用于展示Kasm Workspaces的基本功能。*  
*注意：演示限时3分钟，出于安全考虑限制上传/下载功能。*


## 快速开始

试用免费社区版：[下载][download]  

Kasm Workspaces团队开源了镜像库（[镜像信息][image_info] & [源代码][workspaces_images]）。  

其Web原生渲染能力由开源项目[KasmVNC][kasmvnc]提供支持。


## 镜像概述和主要用途

该镜像包含浏览器可访问的Ubuntu Focal系统及CUDA工具包。  

主要用于开源容器化[机器学习桌面](https://github.com/kasmtech/workspaces-machine-learning)和[数据科学桌面](https://github.com/kasmtech/workspaces-data-science)。可作为基础镜像构建自定义衍生镜像，或修改现有机器学习/数据科学镜像以满足需求。所有镜像需配合NVIDIA容器工具包使用，以将GPU能力传递到容器化桌面环境，该环境预装常用开发和数据科学工具及库。

![镜像截图][Image_Screenshot]

[Image_Screenshot]: https://f.hubspotusercontent30.net/hubfs/5856039/dockerhub/image-screenshots/core-cuda-focal.png "镜像截图"


## 核心功能和特性

- **系统基础**：基于Ubuntu Focal操作系统  
- **CUDA集成**：内置CUDA工具包，支持GPU加速计算  
- **浏览器访问**：通过Web浏览器直接访问容器化桌面  
- **GPU支持**：需配合NVIDIA容器工具包，实现GPU能力透传  
- **预装工具**：集成常用开发及数据科学工具和库  
- **可定制性**：支持作为基础镜像构建自定义环境  


## 使用场景和适用范围

- 构建机器学习、数据科学等GPU加速开发环境  
- 作为基础镜像定制行业专用容器化桌面（如科研、AI开发）  
- 独立部署轻量级GPU开发环境，通过浏览器远程访问  
- 与Kasm Workspaces配合，实现企业级容器化桌面编排和管理  


## 使用方法和配置说明

### 独立部署

该镜像设计用于Kasm Workspaces环境，但也可独立部署并通过浏览器访问。

#### 部署命令
```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/core-cuda-focal:1.16.0
```

#### 参数说明
- `--shm-size=512m`：设置共享内存大小，优化桌面性能  
- `-p 6901:6901`：映射容器6901端口到主机，用于Web访问  
- `-e VNC_PW=password`：设置VNC访问密码（替换`password`为自定义密码）  
- `--rm`：容器退出后自动删除  
- `-it`：交互式终端模式  

#### 访问方式
容器启动后，通过浏览器访问：`https://服务器IP:6901`  
- 用户名：`kasm_user`  
- 密码：启动命令中设置的`VNC_PW`值（如示例中的`password`）  

#### 注意事项
- 部分功能（音频、文件上传/下载、麦克风透传）仅在Kasm Workspaces编排环境中可用  
- 独立部署时需手动配置GPU设备映射（如使用`--gpus all`参数）以启用CUDA加速  


## 标签说明

| 标签名           | 说明                                                                 |
|------------------|----------------------------------------------------------------------|
| `1.16.0`         | 基于Kasm Workspaces发布版本构建的稳定镜像，版本号对应发布版本         |
| `1.16.0-rolling` | 滚动更新标签，每日夜间构建，包含最新安全补丁和功能更新               |
| `develop`        | 开发测试标签，包含未稳定功能，不保证兼容性，仅用于测试环境           |


## 补充信息

### 源代码
- **KasmVNC**：开源VNC服务器，提供Web原生、安全、高性能的远程显示能力  
  [GitHub仓库][kasmvnc]  
- **工作区镜像库**：Kasm Workspaces Docker镜像集合  
  [GitHub仓库][workspaces_images]  
- **核心镜像库**：用于构建自定义镜像的基础操作系统镜像库  
  [GitHub仓库][core_images]  

### 官方文档
- **开发者API**：与应用和工作流集成的接口文档  
  [文档链接][developer_api]  
- **Kasm Workspaces安装**：Kasm Workspaces平台的安装和配置指南  
  [文档链接][installation]  
- **自定义镜像**：配置自定义镜像及软件安装的详细说明  
  [文档链接][custom_images]  

### 问题反馈
- 社区issue跟踪：[GitHub Issue Tracker][github_support]  


[workspaces_images]: https://github.com/kasmtech/workspaces-images "工作区镜像库"
[kasmvnc]: https://github.com/kasmtech/KasmVNC "KasmVNC"
[image_info]: https://www.kasmweb.com/docs/latest/guide/custom_images.html "镜像信息"
[download]: https://kasmweb.com/downloads "下载"
[core_images]: https://github.com/kasmtech/workspaces-core-images "核心镜像库"
[developer_api]: https://www.kasmweb.com/docs/latest/developers/developer_api.html "开发者API"
[installation]: https://www.kasmweb.com/docs/latest/install.html "安装指南"
[custom_images]: https://www.kasmweb.com/docs/latest/how_to/building_images.html "自定义镜像"
[github_support]: https://github.com/kasmtech/workspaces-issues/issues "GitHub支持"

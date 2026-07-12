---
image: kalilinux/kali-rolling
description: "官方卡利Linux Docker镜像，即kali-rolling滚动更新版本的每周快照，为用户提供便捷、轻量级的安全测试与渗透工具环境，可通过Docker快速部署使用，集成了Kali Linux的核心工具与最新更新，适合安全研究人员、渗透测试工程师等专业人士在容器化环境中高效开展相关工作。"
source: https://xuanyuan.cloud/zh/r/kalilinux/kali-rolling
canonical: https://xuanyuan.cloud/zh/r/kalilinux/kali-rolling
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kalilinux/kali-rolling" title="kalilinux/kali-rolling Docker 镜像中文简介、标签列表与拉取命令">kalilinux/kali-rolling 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Kali Linux Docker 镜像（Rolling 版）

如果您不确定该选择哪个 Docker 镜像，这个就是您应该使用的版本。  

该镜像每周更新，基于所有 Kali 用户默认使用的 kali-rolling 软件仓库。  


### 工具安装说明  
注意：默认情况下不含任何工具。您可以通过以下方式安装所需工具：  

- `apt update && apt -y install <package>`（安装特定工具包，将 `<package>` 替换为具体工具名称）  
- `apt update && apt -y install kali-linux-headless`（安装无界面工具集）  
- `apt update && apt -y install kali-linux-large`（安装大型工具集，包含更多工具）  


### 更多信息  
- [Kali 所有 Docker 镜像详解]   
- [Kali Docker 镜像使用指南]   
- [Kali 分支说明]   
- [Kali 元数据包详解]   
- [生成 Kali Docker 镜像的构建脚本]

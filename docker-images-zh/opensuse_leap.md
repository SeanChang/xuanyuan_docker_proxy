---
image: opensuse/leap
description: "官方openSUSE Leap镜像"
source: https://xuanyuan.cloud/zh/r/opensuse/leap
canonical: https://xuanyuan.cloud/zh/r/opensuse/leap
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/opensuse/leap" title="opensuse/leap Docker 镜像中文简介、标签列表与拉取命令">opensuse/leap — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/opensuse/leap" title="opensuse/leap Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/opensuse/leap</a>

# openSUSE Leap

[openSUSE Leap](https://en.opensuse.org/Portal:Leap) 是一款稳定、易用且完整的多用途发行版。它面向在桌面或服务器环境工作的用户和开发者，适合初学者、有经验的用户以及资深极客等各类人群，简而言之，它适合所有人！最新版本 openSUSE Leap 15.4 包含所有实用服务器和桌面应用程序的全新且大幅改进的版本，附带超过 1000 个开源应用。

主页：[https://www.opensuse.org](https://www.opensuse.org)

# openSUSE 项目

[openSUSE 项目](https://en.opensuse.org/Main_Page) 是一项全球协作的努力，旨在推动 Linux 在各个领域的使用。openSUSE 不仅创建世界一流的 Linux 发行版，还开发多种工具，如 [OBS、OpenQA、Kiwi、YaST、OSEM](https://en.opensuse.org/Main_Page)，这些工具在开放、透明且友好的氛围中协作，是全球 [自由及开源软件](https://en.opensuse.org/Free_and_Open_Source_Software) 社区的一部分。该项目由社区主导，依赖于个人贡献者的参与，包括测试人员、文档撰写者、翻译者、可用性专家、艺术家、大使及开发者。项目拥抱多样化的技术，欢迎不同专业水平、使用不同语言、拥有不同文化背景的人群参与。

# 源代码来源

完整的发行版源代码可在 https://build.opensuse.org（openSUSE:Leap:X.Y 项目）上找到。

镜像通过 OBS 构建：
- openSUSE Leap 15.5: [https://build.opensuse.org/package/show/openSUSE:Leap:15.5:Images/opensuse-leap-image](https://build.opensuse.org/package/show/openSUSE:Leap:15.5:Images/opensuse-leap-image)
- openSUSE Leap 15.4: [https://build.opensuse.org/package/show/openSUSE:Leap:15.4:Images/opensuse-leap-image](https://build.opensuse.org/package/show/openSUSE:Leap:15.4:Images/opensuse-leap-image)
- openSUSE Leap 15.3: [https://build.opensuse.org/package/show/openSUSE:Leap:15.3:Images/opensuse-leap-image](https://build.opensuse.org/package/show/openSUSE:Leap:15.3:Images/opensuse-leap-image)
- openSUSE Leap 15.2: [https://build.opensuse.org/package/show/openSUSE:Leap:15.2:Images/opensuse-leap-image](https://build.opensuse.org/package/show/openSUSE:Leap:15.2:Images/opensuse-leap-image)
- openSUSE Leap 15.1: [https://build.opensuse.org/package/show/openSUSE:Leap:15.1:Images/opensuse-leap-image](https://build.opensuse.org/package/show/openSUSE:Leap:15.1:Images/opensuse-leap-image)
- openSUSE Leap 15.0: [https://build.opensuse.org/package/show/openSUSE:Leap:15.0:Images/opensuse-leap-image](https://build.opensuse.org/package/show/openSUSE:Leap:15.0:Images/opensuse-leap-image)
- openSUSE Leap 42.3: [https://build.opensuse.org/package/show/Virtualization:containers:images:openSUSE-Leap-42.3/openSUSE-Leap-42.3-container-image](https://build.opensuse.org/package/show/Virtualization:containers:images:openSUSE-Leap-42.3/openSUSE-Leap-42.3-container-image)

# Docker 部署示例

## 基本运行容器
运行一个临时的 openSUSE Leap 容器：
```bash
docker run -it --rm opensuse/leap:15.5
```

## 交互式 Shell
启动一个带有交互式 bash shell 的容器：
```bash
docker run -it opensuse/leap:15.5 /bin/bash
```

## 作为基础镜像构建自定义镜像
创建 Dockerfile 以 openSUSE Leap 为基础镜像：
```dockerfile
FROM opensuse/leap:15.5
RUN zypper refresh && zypper install -y nginx
CMD ["nginx", "-g", "daemon off;"]
```
构建并运行自定义镜像：
```bash
docker build -t my-leap-nginx .
docker run -d -p 80:80 my-leap-nginx
```

# 贡献方式

更多贡献信息请访问：[https://contribute.opensuse.org/](https://contribute.opensuse.org/)

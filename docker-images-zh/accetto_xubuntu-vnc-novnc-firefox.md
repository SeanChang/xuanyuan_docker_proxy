---
image: accetto/xubuntu-vnc-novnc-firefox
description: "带有VNC/noVNC和Firefox的无头Ubuntu/Xfce容器（第二代）。"
source: https://xuanyuan.cloud/zh/r/accetto/xubuntu-vnc-novnc-firefox
canonical: https://xuanyuan.cloud/zh/r/accetto/xubuntu-vnc-novnc-firefox
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/accetto/xubuntu-vnc-novnc-firefox" title="accetto/xubuntu-vnc-novnc-firefox Docker 镜像中文简介、标签列表与拉取命令">accetto/xubuntu-vnc-novnc-firefox 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 带有VNC/noVNC和Firefox的无头Ubuntu/Xfce容器

## accetto/xubuntu-vnc-novnc-firefox

[Docker Hub][this-docker] - [GitHub][this-github] - [更新日志][this-changelog] - [Wiki][this-wiki] - [镜像层级][this-wiki-image-hierarchy]

## 概述

本仓库包含基于[Ubuntu 18.04 LTS][docker-ubuntu]的Docker镜像构建资源，该镜像配备[Xfce][xfce]桌面环境和[VNC][tigervnc]/[noVNC][novnc]服务器，适用于无头使用场景。

这是我的无头镜像的**第二代**（G2），于2022年3月停止维护，但因仍有拉取需求，于2022年11月重启项目。当前**第二版**（G2v2）主要在构建流程和支持脚本方面进行了改进。

如需基于[Ubuntu 20.04 LTS][docker-ubuntu]并包含最新[TigerVNC][tigervnc-releases]/[noVNC][novnc-releases]版本的**更新镜像**，请查看第三代（G3）镜像：[accetto/ubuntu-vnc-xfce-g3][accetto-docker-ubuntu-vnc-xfce-g3]、[accetto/ubuntu-vnc-xfce-chromium-g3][accetto-docker-ubuntu-vnc-xfce-chromium-g3]或[accetto/ubuntu-vnc-xfce-firefox-g3][accetto-docker-ubuntu-vnc-xfce-firefox-g3]。

## 镜像描述

主镜像为[accetto/ubuntu-vnc-xfce-firefox-plus][accetto-docker-ubuntu-vnc-xfce-firefox-plus]的精简版本。由于**Firefox v67**对用户配置文件的处理方式不同，已重新实现了适用的**plus**功能。

该镜像属于[镜像层级][this-wiki-image-hierarchy]的一部分，基于[accetto/xubuntu-vnc-novnc][accetto-docker-xubuntu-vnc-novnc]构建，继承其所有功能，因此此处不再重复完整描述。

`latest`镜像继承的内容包括：
- 工具：**ping**、**wget**、**zip**、**unzip**、**sudo**、[curl][curl]、[git][git]（Ubuntu发行版）
- 工具**gdebi**：用于安装本地`.deb`包并解析依赖（Ubuntu发行版）
- JSON处理器[jq][jq]的当前版本
- 文本编辑器[vim][vim]和[nano][nano]（Ubuntu发行版）
- 轻量级图形编辑器[mousepad][mousepad]（Ubuntu发行版）
- [xfce4-screenshooter][screenshooter]和图像查看器[ristretto][ristretto]（Ubuntu发行版）
- [tini][tini]的当前版本作为入口点初始进程（PID 1）

并额外添加：
- [Firefox Quantum][firefox]网页浏览器的当前版本及下文描述的**plus**功能

重要变更历史记录在[更新日志][this-changelog]中。

## 镜像标签

以下镜像标签会定期维护和重建：
- `latest`：基于`accetto/xubuntu-vnc-novnc:latest`，包含**plus**功能

## Dockerfiles

[GitHub][this-github-xubuntu-vnc-novnc-firefox]仓库包含多个可用于构建镜像的Dockerfile：
- `Dockerfile.firefox`：构建`latest`标签的主Dockerfile，默认基于`accetto/xubuntu-vnc-novnc:latest`。通过`BASETAG`构建参数可基于其他基础标签（如`accetto/xubuntu-vnc-novnc:lab`）构建，包含**plus**功能。
- `Dockerfile.firefox.default`：构建`default`标签，基于`accetto/xubuntu-vnc-novnc:latest`，不含**plus**功能。
- `Dockerfile.firefox.myown`：用于构建内置自定义Firefox偏好设置的镜像。

## 端口

暴露以下**TCP**端口：
- **5901**：用于**VNC**访问
- **6901**：用于[noVNC][novnc]访问

## 卷

容器默认不创建或使用外部卷，但以下文件夹适合作为挂载点：`/home/headless/Documents/`、`/home/headless/Downloads/`、`/home/headless/Pictures/`、`/home/headless/Public/`

支持**命名卷**和**绑定挂载**。有关卷的更多信息，请参见[Docker文档][docker-doc]（如[管理Docker中的数据][docker-doc-managing-data]）。

## 容器用户账户

基于这些镜像创建的容器以非root**默认应用用户**（headless，1001:0）运行，但**sudo**命令允许用户提权。详细描述请查看基础镜像[accetto/xubuntu-vnc-novnc][accetto-docker-xubuntu-vnc-novnc]或[Wiki][this-wiki]。

## 版本标签

版本标签的用途在[Wiki][this-wiki]中有详细说明。**版本标签值**标识Docker镜像版本，在构建时持久化到镜像中，并在README中以徽章形式显示。

脚本`version_sticker.sh`可随时用于便捷检查已安装应用的当前版本，部署在由环境变量`STARTUPDIR`（默认值`/dockerstartup`）定义的启动文件夹中。

在容器内执行不带参数的脚本时，返回容器的**当前版本标签值**（基于容器中必要应用的当前版本计算）。若任何包含的应用更新到其他版本，**当前**版本标签值将与**持久化**值不同。

使用参数`-v`（小写）时，输出**版本标签值**中包含的必要应用的详细版本；使用`-V`（大写）时，输出更多应用的详细版本。示例见[Wiki][this-wiki]。

## 使用无头容器

有两种使用创建的无头容器的方式，请参考基础镜像[accetto/xubuntu-vnc-novnc][accetto-docker-xubuntu-vnc-novnc]了解详情。

默认**VNC用户**密码为**headless**。

## Firefox多进程

Firefox多进程（也称为**Electrolysis**或**E10S**）在Docker容器中若共享内存不足可能导致严重崩溃（“Gah. Your tab just crashed.”）。

在Firefox**76.0.1**及之前版本，可通过设置环境变量**MOZ_FORCE_DISABLE_E10S**禁用多进程。但在Firefox**77.0.1**中，该设置导致几乎所有网页因未解压而显示错乱。

Mozilla在后续版本修复了此问题，但警告未来可能不支持该开关。因此，标记为`latest`的主流镜像默认启用多进程，尽管需要更大共享内存，但性能更高且网页浏览更安全。

曾维护`singleprocess`镜像用于无法或不愿增加共享内存的场景，但Firefox**81.0**起，环境变量**MOZ_FORCE_DISABLE_E10S**不再生效，所有镜像均以多进程模式运行Firefox。

更多信息及不同场景下设置共享内存大小的说明，请查看Wiki页面[Firefox多进程][that-wiki-firefox-multiprocess]。

### 设置共享内存大小

多进程Firefox的不稳定性由共享内存大小过低导致，Docker默认仅分配**64MB**。测试表明，至少使用**256MB**可完全消除问题（具体可能因系统而异）。

[Firefox多进程][that-wiki-firefox-multiprocess] Wiki页面描述了多种增加共享内存大小的方法。若需为命令行启动的单个容器设置，操作简单，例如：

```bash
docker run -d -P --shm-size=256m docker.xuanyuan.run/accetto/xubuntu-vnc-novnc-firefox
```

在容器内执行以下命令可检查当前共享内存大小：

```bash
df -h /dev/shm
```

## Firefox偏好设置和plus功能

Firefox浏览器支持用户偏好的预配置。

用户可将个人浏览器偏好放入`user.js`文件并复制到Firefox配置文件文件夹，**plus**功能使此过程更简单。

`/home/headless/firefox.plus`文件夹包含`user.js`文件和辅助工具`copy_firefox_user_preferences.sh`，可将`user.js`复制到一个或多个现有Firefox配置文件。该工具为交互式，使用`-h`或`--help`参数可显示帮助。

为方便使用，还提供了工具和**Firefox配置文件管理器**的桌面启动器。

利用**plus**功能的推荐步骤：
1. 使用桌面启动器**FF Profile Manager**启动**Firefox配置文件管理器**。若尚无配置文件或需添加新配置文件，创建后启动Firefox（启动Firefox是创建实际配置文件内容的必要步骤）。  
   **提示**：创建配置文件前可勾选“离线工作”。  
   Firefox配置文件默认创建在`/home/headless/.mozilla/firefox`文件夹（`.mozilla`为隐藏文件夹）。点击“退出”按钮关闭配置文件管理器。

2. 将个人Firefox偏好放入`/home/headless/firefox.plus`文件夹中的`user.js`文件。有关语法，可查看Firefox文档（如[Firefox偏好设置][firefox-doc-preferences]）。  
   **提示**：另一种方法是先启动Firefox进行配置，然后将Firefox配置文件文件夹中的`prefs.js`内容复制到`user.js`，检查并保留需强制生效的偏好设置（仅需执行一次或更新时执行）。

3. 使用桌面启动器**Copy FF Preferences**启动辅助工具，可将`user.js`文件复制到任何现有Firefox配置文件。  
   **提示**：删除Firefox配置文件文件夹中的`user.js`文件前，偏好设置将一直生效。

通过`Dockerfile.firefox.myown`可轻松构建包含预填充`user.js`文件的自定义镜像，构建过程仅需数秒。

## 问题

若发现问题或有疑问，请先查看[Issues][this-issues]和[Wiki][this-wiki]（包括已关闭的问题）。如未找到解决方案，可提交新issue，问题描述越详细，解决可能性越高。

## 致谢

感谢所有为开源社区做出贡献的无数个人和公司，是他们让许多梦想成为现实。

[this-docker]: https://hub.docker.com/r/accetto/xubuntu-vnc-novnc-firefox/
[this-github]: https://github.com/accetto/xubuntu-vnc-novnc/
[this-changelog]: https://github.com/accetto/xubuntu-vnc-novnc/blob/master/CHANGELOG.md
[this-wiki]: https://github.com/accetto/xubuntu-vnc-novnc/wiki
[this-wiki-image-hierarchy]: https://github.com/accetto/xubuntu-vnc-novnc/wiki/Image-hierarchy
[that-wiki-firefox-multiprocess]: https://github.com/accetto/xubuntu-vnc/wiki/Firefox-multiprocess
[this-issues]: https://github.com/accetto/xubuntu-vnc-novnc/issues
[this-github-xubuntu-vnc-novnc-firefox]: https://github.com/accetto/xubuntu-vnc-novnc/tree/master/docker/xubuntu-vnc-novnc-firefox
[accetto-docker-xubuntu-vnc-novnc]: https://hub.docker.com/r/accetto/xubuntu-vnc-novnc/
[accetto-docker-ubuntu-vnc-xfce-firefox-plus]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-firefox-plus/
[docker-ubuntu]: https://hub.docker.com/_/ubuntu/
[docker-doc]: https://docs.docker.com/
[docker-doc-managing-data]: https://docs.docker.com/storage/
[firefox-doc-preferences]: https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/A_brief_guide_to_Mozilla_preferences
[curl]: http://manpages.ubuntu.com/manpages/bionic/man1/curl.1.html
[firefox]: https://www.mozilla.org
[git]: https://git-scm.com/
[jq]: https://stedolan.github.io/jq/
[mousepad]: https://github.com/codebrainz/mousepad
[nano]: https://www.nano-editor.org/
[novnc]: https://github.com/kanaka/noVNC
[novnc-releases]: https://github.com/novnc/noVNC/releases
[ristretto]: https://docs.xfce.org/apps/ristretto/start
[screenshooter]: https://docs.xfce.org/apps/screenshooter/start
[tigervnc]: http://tigervnc.org
[tigervnc-releases]: https://github.com/TigerVNC/tigervnc/releases
[tini]: https://github.com/krallin/tini
[vim]: https://www.vim.org/
[xfce]: http://www.xfce.org
[accetto-docker-ubuntu-vnc-xfce-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-g3
[accetto-docker-ubuntu-vnc-xfce-chromium-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-chromium-g3
[accetto-docker-ubuntu-vnc-xfce-firefox-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-firefox-g3

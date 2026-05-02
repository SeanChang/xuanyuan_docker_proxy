# Obsidian Docker 部署｜Windows+Linux 通用，新手也能10分钟上手

![Obsidian Docker 部署｜Windows+Linux 通用，新手也能10分钟上手](https://img.xuanyuan.dev/docker/blog/docker-obsidian-2.png)

*分类: Obsidian,部署教程,笔记软件 | 标签: Obsidian,部署教程,笔记软件 | 发布时间: 2026-04-21 07:33:20*

> Obsidian 作为一款备受欢迎的本地知识管理工具，凭借其灵活的笔记链接、本地存储优势，成为很多开发者、知识管理者的首选。而通过 Docker 部署 Obsidian，不仅能实现跨环境快速部署，还能轻松实现数据持久化，适配 NAS、服务器、个人电脑等多种场景。本文将详细介绍 Windows 和 Linux 两大系统下，通过 Docker 部署 Obsidian 的完整流程，同时提供 Docker 一键安装命令，降低部署门槛。

Obsidian 作为一款备受欢迎的本地知识管理工具，凭借其灵活的笔记链接、本地存储优势，成为很多开发者、知识管理者的首选。而通过 Docker 部署 Obsidian，不仅能实现跨环境快速部署，还能轻松实现数据持久化，适配 NAS、服务器、个人电脑等多种场景。本文将详细介绍 Windows 和 Linux 两大系统下，通过 Docker 部署 Obsidian 的完整流程，同时提供 Docker 一键安装命令，降低部署门槛。

![Obsidian Web](https://img.xuanyuan.dev/docker/blog/docker-obsidian.png)

本文使用的 Obsidian 容器镜像来自 [LinuxServer\.io 官方发布版本](https://xuanyuan.cloud/zh/r/linuxserver/obsidian)，镜像地址适配轩辕镜像加速，拉取速度更稳定，中文相关说明可参考官方中文链接：[https://xuanyuan\.cloud/zh/r/linuxserver/obsidian](https://xuanyuan.cloud/zh/r/linuxserver/obsidian)。

# 一、Docker 一键安装与镜像加速（推荐方案）

部署 Obsidian 前，需先安装 Docker 环境。以下提供的 Linux Docker \&amp; Docker Compose 一键安装配置脚本，可适配 13 种主流 Linux 发行版（含国产系统如银河麒麟、欧拉），能一键完成 Docker、Docker Compose 的安装，以及轩辕镜像加速配置，全程无需手动操作，极大提升部署效率；Windows/Mac 系统则需手动安装 Docker Desktop，下文将单独说明。

## 1\. Linux 系统 Docker 一键安装

本方案支持测试环境和生产环境（生产环境需提前审计脚本），根据自身场景选择对应命令执行即可。

### 🧪 测试环境（快速体验，仅限非生产场景）

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

### 🏭 生产环境（推荐，安全优先）

```bash
# 1. 下载脚本到本地
wget https://xuanyuan.cloud/docker.sh -O docker-install.sh

# 2. （可选）审计脚本源码（建议企业环境必做）
less docker-install.sh  # 或使用vim、cat查看脚本内容

# 3. 执行脚本
bash docker-install.sh
```

### ⚠️ 安全强制提示

- curl \| bash / wget \| bash 这种直接执行远程脚本的方式，仅建议用于测试、个人学习或非核心环境，生产环境严禁直接使用；

- 金融、政务、内网等敏感环境，必须先将脚本下载到本地，进行全面的安全审计，确认无恶意代码后，再执行安装操作。

## 2\. Windows/Mac 系统 Docker 安装

Windows 和 Mac 系统需安装 Docker Desktop，具体步骤如下：

- 访问 Docker 官方下载页：[https://www\.docker\.com/products/docker\-desktop](https://www.docker.com/products/docker-desktop)

- 根据自身系统（Windows/Mac）下载对应安装包，双击安装，全程默认下一步即可；

- 安装完成后，启动 Docker Desktop，等待后台服务启动成功（右下角图标显示“Running”）。

## 3\. 验证 Docker 环境

无论哪种系统，安装完成后，执行以下命令验证 Docker 是否正常运行：

```bash
docker version
```

若能正常显示 Docker 客户端和服务端版本信息，说明环境准备就绪，可以开始部署 Obsidian。

# 二、Obsidian Docker 部署（Windows 系统）

Windows 系统部署 Obsidian，需使用 PowerShell 执行命令，全程操作简单，分为拉取镜像、启动容器、访问界面三步。

## 1\. 拉取 Obsidian 镜像

打开 Windows PowerShell，执行以下命令，从轩辕镜像仓库拉取 Obsidian 最新镜像（拉取速度更快，稳定性更高）：

```bash
docker pull docker.xuanyuan.run/linuxserver/obsidian:latest
```

拉取成功后，会显示类似以下输出，说明镜像拉取完成：

```text
Status: Downloaded newer image for docker.xuanyuan.run/linuxserver/obsidian:latest
```

## 2\. 启动 Obsidian 容器

执行以下命令启动容器，同时配置数据持久化、端口映射和时区，确保容器稳定运行：

```bash
docker run -d --name obsidian -p 3005:3000 -v C:\docker\obsidian:/config -e TZ=Asia/Shanghai --restart unless-stopped docker.xuanyuan.run/linuxserver/obsidian:latest
```

### 参数详细说明

|参数|说明|
|---|---|
|\-d|后台运行容器，不占用当前终端|
|\-\-name obsidian|指定容器名称为 obsidian，方便后续管理|
|\-p 3005:3000|端口映射：将宿主机 3005 端口映射到容器 3000 端口（可根据需求修改宿主机端口）|
|\-v C:\\docker\\obsidian:/config|数据持久化：将容器内的配置和笔记数据，挂载到宿主机 C:\\docker\\obsidian 目录，删除容器不丢失数据|
|\-e TZ=Asia/Shanghai|设置容器时区为上海时区，避免时间显示异常|
|\-\-restart unless\-stopped|容器自动重启：除非手动停止，否则宿主机重启、容器异常退出后都会自动重启|

## 3\. 访问 Obsidian 界面

容器启动成功后，打开浏览器，输入以下地址即可访问 Obsidian Web 界面：

```text
http://localhost:3005
```
![Obsidian Web 界面](https://img.xuanyuan.dev/docker/blog/docker-ob.png)

注意：所有笔记数据都会保存在宿主机 `C:\\docker\\obsidian` 目录下，即使删除容器，数据也不会丢失，后续重新启动容器即可恢复。

# 三、Obsidian Docker 部署（Linux 系统）

Linux 系统部署流程与 Windows 类似，区别在于数据挂载目录的路径（Linux 路径格式与 Windows 不同），以下是完整步骤，适用于所有主流 Linux 发行版（Ubuntu、CentOS、欧拉、银河麒麟等）。

## 1\. 拉取 Obsidian 镜像

打开 Linux 终端，执行以下命令拉取镜像（与 Windows 命令一致，适配轩辕镜像加速）：

```bash
docker pull docker.xuanyuan.run/linuxserver/obsidian:latest
```

拉取成功后，同样会显示镜像下载完成的提示。

## 2\. 准备数据挂载目录

Linux 系统建议将数据挂载到 `/opt/docker/obsidian` 目录（可自定义路径），执行以下命令创建目录并设置权限（避免权限不足导致容器启动失败）：

```bash
# 创建目录
mkdir -p /opt/docker/obsidian

# 设置权限（赋予最大权限，避免挂载失败，生产环境可根据需求调整）
chmod -R 777 /opt/docker/obsidian
```

## 3\. 启动 Obsidian 容器

执行以下命令启动容器，参数与 Windows 基本一致，仅修改数据挂载路径：

```bash
docker run -d --name obsidian -p 3005:3000 -v /opt/docker/obsidian:/config -e TZ=Asia/Shanghai --restart unless-stopped docker.xuanyuan.run/linuxserver/obsidian:latest
```

### Linux 专属参数说明

\-v /opt/docker/obsidian:/config：Linux 系统的数据挂载路径，笔记和配置会保存在 `/opt/docker/obsidian` 目录，删除容器后数据依然保留。

## 4\. 访问 Obsidian 界面

容器启动成功后，有两种访问方式：

- 本地访问（Linux 本机）：打开浏览器，输入 `http://localhost:3005`；

- 远程访问（其他设备）：输入 `http://Linux服务器IP:3005`（需确保 Linux 服务器开放 3005 端口，防火墙放行该端口）。

例如：服务器 IP 为 192\.168\.1\.100，访问地址即为 `http://192\.168\.1\.100:3005`。

# 四、常用 Docker 管理命令（Windows\+Linux 通用）

部署完成后，可通过以下命令管理 Obsidian 容器，适用于 Windows PowerShell 和 Linux 终端。

```bash
# 查看运行中的容器（确认 Obsidian 容器是否正常运行）
docker ps

# 查看所有容器（包括已停止的容器）
docker ps -a

# 停止 Obsidian 容器
docker stop obsidian

# 启动 Obsidian 容器（停止后重新启动）
docker start obsidian

# 删除 Obsidian 容器（删除前需先停止容器，数据不会丢失）
docker rm obsidian

# 查看容器日志（容器启动失败时，可通过日志排查问题）
docker logs obsidian
```

# 五、常见问题与解决方案

部署过程中可能会遇到端口占用、容器名称冲突等问题，以下是常见问题及详细解决方案，覆盖 Windows 和 Linux 系统。

## 1\. 端口被占用

启动容器时出现以下错误，说明宿主机指定的端口（如 3005）已被其他程序占用：

```text
ports are not available
bind: Only one usage of each socket address
```

解决方案：更换宿主机端口，例如将 3005 改为 3006，修改启动命令中的端口映射参数即可：

```bash
# Windows/Linux 通用，将 3006 改为其他未被占用的端口也可
-p 3006:3000
```

修改后，访问地址也需对应修改，例如 `http://localhost:3006`。

## 2\. 容器名称冲突

启动容器时出现以下错误，说明系统中已存在名为“obsidian”的容器：

```text
Conflict. The container name "/obsidian" is already in use
```

解决方案：删除旧的同名容器，再重新启动新容器：

```bash
# 先停止旧容器（若容器正在运行）
docker stop obsidian

# 删除旧容器
docker rm obsidian

# 重新启动新容器（执行之前的启动命令即可）
```

## 3\. Windows PowerShell 换行符错误

在 Windows PowerShell 中，若将启动命令换行编写，使用 `^`作为换行符，会出现以下错误：

```text
-p : 无法识别
-v : 无法识别
```

原因：`^` 是 CMD 命令的换行符，PowerShell 不支持该换行符。

解决方案（二选一）：

### 方法一（推荐）：将命令写成一行

直接执行完整的一行启动命令，避免换行，示例：

```bash
docker run -d --name obsidian -p 3005:3000 -v C:\docker\obsidian:/config -e TZ=Asia/Shanghai --restart unless-stopped docker.xuanyuan.run/linuxserver/obsidian:latest
```

### 方法二：使用 PowerShell 专用换行符

PowerShell 的换行符为 `\``（反引号，位于键盘左上角，与 \~ 同键），换行编写命令如下：

```bash
docker run -d `
--name obsidian `
-p 3005:3000 `
-v C:\docker\obsidian:/config `
-e TZ=Asia/Shanghai `
--restart unless-stopped `
docker.xuanyuan.run/linuxserver/obsidian:latest
```

## 4\. Linux 容器启动失败（权限不足）

Linux 系统中，若未设置数据挂载目录权限，可能会出现容器启动失败，日志显示“权限不足”。

解决方案：重新设置挂载目录权限，执行以下命令：

```bash
chmod -R 777 /opt/docker/obsidian
```

设置完成后，重新启动容器即可。

# 六、镜像说明与适用场景

## 1\. 镜像说明

本文使用的 `docker\.xuanyuan\.run/linuxserver/obsidian` 镜像，并非传统的 Web 版 Obsidian，而是通过容器运行完整的桌面版 Obsidian，并提供浏览器远程访问功能。因此，首次访问时可能会看到类似“远程桌面”的界面，这是正常现象，进入界面后即可正常使用 Obsidian 的所有功能。

关于该镜像的更多详细说明，可参考官方中文链接：[https://xuanyuan\.cloud/zh/r/linuxserver/obsidian](https://xuanyuan.cloud/zh/r/linuxserver/obsidian)。

## 2\. 适用场景

Docker 版 Obsidian 适合以下场景，尤其适合服务器和 NAS 环境：

- NAS 部署：将 Obsidian 部署在 NAS 上，实现笔记的集中存储和多设备访问；

- 服务器远程访问：部署在云服务器或本地服务器，通过浏览器随时随地访问笔记；

- 多设备同步：多台设备通过浏览器访问同一容器，实现笔记实时同步（无需额外配置同步工具）；

- 私有知识库部署：搭建个人或团队私有知识库，数据本地存储，更安全可控。

提示：如果只是个人电脑单独使用，直接安装 Obsidian 官方客户端（[https://obsidian\.md/](https://obsidian.md/)），体验会更流畅。

# 七、总结

通过 Docker 部署 Obsidian，无论 Windows 还是 Linux 系统，都只需三个核心步骤：拉取镜像 → 启动容器 → 浏览器访问，全程操作简单，无需复杂配置。结合 Docker 的数据卷挂载功能，可实现笔记数据的持久化存储，即使删除容器，数据也不会丢失。

对于 Linux 用户，推荐使用本文提供的 Docker 一键安装脚本，快速完成环境搭建；对于 Windows 用户，安装 Docker Desktop 后，即可轻松部署。Docker 版 Obsidian 完美解决了跨环境、多设备访问的需求，是搭建个人私有知识库的理想方案。

> 告别繁琐安装！Obsidian 容器化部署，跨设备访问笔记自由



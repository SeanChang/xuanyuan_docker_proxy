# 轻量AI接口网关一键部署｜calciumion/new-api Windows/Linux Docker 部署全教程

![轻量AI接口网关一键部署｜calciumion/new-api Windows/Linux Docker 部署全教程](https://img.xuanyuan.dev/docker/blog/docker-newapi.png)

*分类: new-api,AI,部署教程,one-api | 标签: new-api,AI,部署教程,one-api | 发布时间: 2026-05-11 07:22:59*

> 推荐一款轻量高效的AI统一API服务镜像——calciumion/new-api，无需复杂配置，依托Docker即可一键极速部署。本文完整讲解Windows、Linux全环境部署流程，全程复制命令就能操作，纯新手也能快速落地，看完直接上手私有AI接口网关搭建。

## 一、认识 calciumion/new-api 项目
calciumion/new-api 是一款**基于One API二次开发的轻量AI大模型统一网关接口服务镜像**，主打**零复杂配置、跨平台兼容、极速部署**。

无需手动搭建运行环境、安装依赖、调试繁杂配置，仅靠Docker一行命令，几分钟即可完成服务搭建。它核心作用是**整合市面上所有主流AI大模型接口**，将各类模型统一转为标准OpenAI接口格式，支持密钥集中管理、接口负载均衡、故障自动切换、调用统计权限管控等能力。

非常适合**开发者接口调试、个人私有AI网关搭建、团队多模型统一管理、小型AI服务分发**等场景。

中文镜像地址：https://xuanyuan.cloud/zh/r/calciumion/new-api

## 二、前置准备：Docker环境一键搞定
部署 calciumion/new-api 最优方式就是Docker容器化部署，隔离环境、无需操心依赖冲突，一条命令直接运行。先完成Docker环境安装，不同系统对应专属操作，新手照抄即可。

### Linux系统（含国产系统）一键安装
Ubuntu、CentOS、Debian，以及**银河麒麟、统信UOS、欧拉**等国产Linux系统通用，无需手动换源、装依赖，复制以下一键脚本到终端执行，自动安装Docker、Docker Compose，同时配置国内镜像加速，从根源解决镜像下载慢问题：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```
执行后等待几分钟，全程自动安装配置，无需任何手动干预。

### Windows/Mac用户
Windows和Mac用户不用输复杂命令，直接下载Docker Desktop即可，图形化界面操作简单，小白也能轻松搞定：
👉 [Docker Desktop官方下载](https://www.docker.com/get-started/)

安装完成后启动软件，桌面状态栏出现小鲸鱼图标即代表Docker正常运行；**Windows用户务必等待2~3分钟**，确保后台Docker服务完全初始化完毕，再进行后续部署。

### 验证Docker安装
环境安装完成后，打开Linux终端 / Windows PowerShell，输入验证命令：
```bash
docker version
```
能正常显示Client客户端、Server服务端版本信息，就说明Docker环境就绪，可以开始部署镜像。

## 三、实操部署：calciumion/new-api 一键运行
Docker环境就绪后，部署仅分**拉取镜像 + 运行容器**两步，全程复制粘贴命令即可，不同系统仅目录路径有区别，按需操作。

### 第一步：拉取国内稳定版镜像
打开终端或PowerShell，拉取实测**稳定可用版本 v1.0.0-rc.4** 国内镜像：
```bash
docker pull docker.xuanyuan.run/calciumion/new-api:v1.0.0-rc.4
```
拉取成功后终端会输出分层拉取完成、Digest校验信息，代表镜像已缓存到本地。

### 第二步：运行容器（分系统操作）
镜像下载完成后，执行对应系统运行命令，自动配置**开机自启、端口映射、时区校准、数据持久化挂载**，保障服务长期稳定运行。

#### 1. Windows系统（PowerShell执行）
自动创建D盘数据目录，启动容器：
```powershell
mkdir D:\new-api -Force; docker run -d --name new-api --restart always -p 3000:3000 -e TZ=Asia/Shanghai -v D:\new-api:/data docker.xuanyuan.run/calciumion/new-api:v1.0.0-rc.4
```
**命令简易说明**
- 自动创建本地数据目录，挂载到容器实现数据持久化，删除容器也不会丢失配置数据；
- --restart always 配置容器开机自启，系统重启服务自动恢复；
- -p 3000:3000 端口映射，本地3000端口访问服务；
- 校准上海时区，避免后台时间、日志时间错乱。

#### 2. Linux系统
终端执行以下命令，适配Linux标准目录规范：
```bash
mkdir -p /data/new-api; docker run -d --name new-api --restart always -p 3000:3000 -e TZ=Asia/Shanghai -v /data/new-api:/data docker.xuanyuan.run/calciumion/new-api:v1.0.0-rc.4
```
命令逻辑和Windows完全一致，仅本地数据存放路径不同。

## 四、高频避坑：3000端口冲突
很多小伙伴启动容器时，会遇到经典端口占用报错：
> docker: Error response from daemon: ports are not available: exposing port TCP 0.0.0.0:3000 -> 127.0.0.1:0: listen tcp 0.0.0.0:3000: bind: Only one usage of each socket address

**报错原因**：本地3000端口已被其他软件、后台服务、站点程序占用，Docker无法绑定端口。

### 两种解决方法（推荐方法一，零改动最省事）
#### 方法1：修改本地映射端口（首选）
不用关闭任何已有程序，只改端口映射格式：**本地闲置端口:容器3000**，示例改用3001端口：

Windows修改后命令：
```powershell
mkdir D:\new-api -Force; docker run -d --name new-api --restart always -p 3001:3000 -e TZ=Asia/Shanghai -v D:\new-api:/data docker.xuanyuan.run/calciumion/new-api:v1.0.0-rc.4
```

Linux修改后命令：
```bash
mkdir -p /data/new-api; docker run -d --name new-api --restart always -p 3001:3000 -e TZ=Asia/Shanghai -v /data/new-api:/data docker.xuanyuan.run/calciumion/new-api:v1.0.0-rc.4
```
修改完成后，访问地址改为：`http://127.0.0.1:3001` 即可。

#### 方法2：关闭占用3000端口程序
若必须使用3000端口，先结束占用进程：
- Windows：PowerShell执行 `netstat -ano | findstr :3000` 查出进程PID，任务管理器结束对应进程；
- Linux：终端执行 `lsof -i:3000` 查看占用进程，执行 `kill -9 进程ID` 关闭后重新启动容器。

## 五、部署验证 + 后台登录 + 容器常用管理
### 1. 部署成功验证
容器启动后，浏览器访问：
默认端口：`http://127.0.0.1:3000`
改端口后：`http://127.0.0.1:自定义端口`

![new-api 设置](https://img.xuanyuan.dev/docker/blog/docker-newapi-1.png)

能正常打开项目首页，即代表部署完成。

### 2. 后台初始登录账号密码
首次进入管理后台设置账号密码：

![new-api 设置密码](https://img.xuanyuan.dev/docker/blog/docker-newapi-2.png)

建议第一时间修改密码，提升服务安全性。

![new-api 选择模式](https://img.xuanyuan.dev/docker/blog/docker-newapi-3.png)

![new-api 完成设置](https://img.xuanyuan.dev/docker/blog/docker-newapi-4.png)

![new-api 首页](https://img.xuanyuan.dev/docker/blog/docker-newapi-5.png)

部署后，其他更多内容建议参考 new-api 官方文档进行配置 https://docs.newapi.pro/zh ，本文不做过多介绍。

### 3. 新手必备容器管理命令
日常启停、排查日志直接复制使用：
- 查看容器运行状态：`docker ps | grep new-api`
- 停止服务容器：`docker stop new-api`
- 重启服务容器：`docker restart new-api`
- 删除旧容器（需先停止）：`docker rm new-api`
- 查看运行日志（排查报错）：`docker logs new-api`

## 六、总结
calciumion/new-api 作为轻量AI统一接口网关，最大优势就是**开箱即用、跨平台兼容、部署零难度**。不管是Windows电脑、普通Linux服务器，还是银河麒麟、统信UOS等国产系统，只要装好Docker，复制本文命令就能一键部署。

本文针对性解决了新手最头疼的**3000端口冲突**问题，同时配备国内高速镜像，彻底解决拉取慢、超时问题。部署后可实现多AI模型统一管理、接口中转、密钥分发，个人自用、团队办公都非常合适。

部署遇到疑难问题，可前往官方中文镜像地址查阅文档：https://xuanyuan.cloud/zh/r/calciumion/new-api，也欢迎评论区留言交流。

觉得教程实用，欢迎收藏转发，分享给身边需要搭建AI接口服务的朋友！


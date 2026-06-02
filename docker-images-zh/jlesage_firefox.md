<!-- xuanyuan-docker-images-zh
image: jlesage/firefox
source: https://xuanyuan.cloud/zh/r/jlesage/firefox
canonical: https://xuanyuan.cloud/zh/r/jlesage/firefox
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [jlesage/firefox — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/jlesage/firefox "jlesage/firefox Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/jlesage/firefox

# Firefox Docker容器

[![Release]([])]([])
[![Docker Image Size]([])]([])
[![Docker Pulls]([])]([])
[![Docker Stars]([])]([])
[![Build Status]([])]([])
[![Source]([])]([])
[![Donate]([])]([])


这是一个Firefox的Docker容器。应用程序的图形用户界面（GUI）可通过现代Web浏览器直接访问，无需在客户端安装或配置任何软件。


[![Firefox logo]([])]([])[![Firefox]([],0,0,0.0)&textColor=rgba(121,121,121,1))]([])

Mozilla Firefox是一款免费开源的网页浏览器，由Mozilla基金会及其子公司Mozilla公司开发。


## 快速启动

**注意**：  
以下提供的Docker命令为示例，具体参数需根据实际需求调整。


启动Firefox容器的命令如下：
```shell
docker run -d \
    --name=firefox \
    -p 5800:5800 \
    -v /docker/appdata/firefox:/config:rw \
    jlesage/firefox
```

参数说明：  
- `/docker/appdata/firefox`：用于存储应用的配置、状态、日志及其他需要持久化的文件。


通过浏览器访问Firefox界面：`[] 文档

完整文档可访问：[] 支持与联系

如使用容器时遇到问题或有疑问，请[创建新issue]([])。  

其他Docker化应用可访问：[]

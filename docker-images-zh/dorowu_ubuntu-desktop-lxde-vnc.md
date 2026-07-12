---
image: dorowu/ubuntu-desktop-lxde-vnc
description: "提供HTML5 VNC界面以访问Ubuntu LXDE和LXQt桌面环境的Docker镜像"
source: https://xuanyuan.cloud/zh/r/dorowu/ubuntu-desktop-lxde-vnc
canonical: https://xuanyuan.cloud/zh/r/dorowu/ubuntu-desktop-lxde-vnc
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dorowu/ubuntu-desktop-lxde-vnc" title="dorowu/ubuntu-desktop-lxde-vnc Docker 镜像中文简介、标签列表与拉取命令">dorowu/ubuntu-desktop-lxde-vnc 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-ubuntu-vnc-desktop

[![Docker Pulls](https://img.shields.io/docker/pulls/dorowu/ubuntu-desktop-lxde-vnc.svg)](https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/)
[![Docker Stars](https://img.shields.io/docker/stars/dorowu/ubuntu-desktop-lxde-vnc.svg)](https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/)

docker-ubuntu-vnc-desktop是一个提供Web VNC界面以访问Ubuntu LXDE/LxQT桌面环境的Docker镜像。

## 目录

- [快速启动](#快速启动)
- [VNC查看器](#vnc查看器)
- [HTTP基础认证](#http基础认证)
- [SSL](#ssl)
- [屏幕分辨率](#屏幕分辨率)
- [默认桌面用户](#默认桌面用户)
- [部署到子目录（相对URL根路径）](#部署到子目录相对url根路径)
- [声音（预览版且仅支持Linux）](#声音预览版且仅支持linux)
- [从jinja模板生成Dockerfile](#从jinja模板生成dockerfile)
- [故障排除与常见问题](#故障排除与常见问题)
- [许可证](#许可证)

## 快速启动

运行Docker容器并通过端口`6080`访问

```shell
docker run -p 6080:80 -v /dev/shm:/dev/shm docker.xuanyuan.run/dorowu/ubuntu-desktop-lxde-vnc
```

在浏览器中访问 http://127.0.0.1:6080/

<img src="https://raw.github.com/fcwu/docker-ubuntu-vnc-desktop/master/screenshots/lxde.png?v1" width=700/>

### Ubuntu版本选择

通过[标签](https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/tags/)选择您喜欢的Ubuntu版本

- focal: Ubuntu 20.04（最新版）
- focal-lxqt: Ubuntu 20.04 LXQt
- bionic: Ubuntu 18.04
- bionic-lxqt: Ubuntu 18.04 LXQt
- xenial: Ubuntu 16.04（已弃用）
- trusty: Ubuntu 14.04（已弃用）

## VNC查看器

通过以下命令将VNC服务端口5900转发到主机

```shell
docker run -p 6080:80 -p 5900:5900 -v /dev/shm:/dev/shm docker.xuanyuan.run/dorowu/ubuntu-desktop-lxde-vnc
```

现在，打开VNC查看器并连接到端口5900。如果您想通过密码保护VNC服务，请设置环境变量`VNC_PASSWORD`，例如

```shell
docker run -p 6080:80 -p 5900:5900 -e VNC_PASSWORD=mypassword -v /dev/shm:/dev/shm docker.xuanyuan.run/dorowu/ubuntu-desktop-lxde-vnc
```

浏览器或VNC查看器会提示输入密码。

## HTTP基础认证

此镜像通过`HTTP_PASSWORD`提供HTTP基础访问认证

```shell
docker run -p 6080:80 -e HTTP_PASSWORD=mypassword -v /dev/shm:/dev/shm docker.xuanyuan.run/dorowu/ubuntu-desktop-lxde-vnc
```

## SSL

要通过SSL连接，如果没有SSL证书，请先生成自签名SSL证书

```shell
mkdir -p ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl/nginx.key -out ssl/nginx.crt
```

通过`SSL_PORT`指定SSL端口，将证书路径设置为`/etc/nginx/ssl`，并将其转发到6081

```shell
docker run -p 6081:443 -e SSL_PORT=443 -v ${PWD}/ssl:/etc/nginx/ssl -v /dev/shm:/dev/shm docker.xuanyuan.run/dorowu/ubuntu-desktop-lxde-vnc
```

## 屏幕分辨率

首次连接服务器时，虚拟桌面的分辨率会适应浏览器窗口大小。您可以通过传递`RESOLUTION`环境变量选择固定分辨率，例如

```shell
docker run -p 6080:80 -e RESOLUTION=1920x1080 -v /dev/shm:/dev/shm docker.xuanyuan.run/dorowu/ubuntu-desktop-lxde-vnc
```

## 默认桌面用户

默认用户是`root`。您可以分别通过`USER`和`PASSWORD`环境变量更改用户和密码，例如

```shell
docker run -p 6080:80 -e USER=doro -e PASSWORD=password -v /dev/shm:/dev/shm docker.xuanyuan.run/dorowu/ubuntu-desktop-lxde-vnc
```

## 部署到子目录（相对URL根路径）

您可以将此应用部署到子目录，例如`/some-prefix/`。然后您可以通过`http://127.0.0.1:6080/some-prefix/`访问应用。这可以通过`RELATIVE_URL_ROOT`配置选项指定，如下所示

```shell
docker run -p 6080:80 -e RELATIVE_URL_ROOT=some-prefix docker.xuanyuan.run/dorowu/ubuntu-desktop-lxde-vnc
```

注意：此变量不应有前导和尾随斜杠（/）

## 声音（预览版且仅支持Linux）

仅在Linux上工作。

首先，插入内核模块`snd-aloop`并将`2`指定为声音循环设备的索引

```shell
sudo modprobe snd-aloop index=2
```

启动容器

```shell
docker run -it --rm -p 6080:80 --device /dev/snd -e ALSADEV=hw:2,0 docker.xuanyuan.run/dorowu/ubuntu-desktop-lxde-vnc
```

其中`--device /dev/snd -e ALSADEV=hw:2,0`表示授予容器声音设备访问权限，并设置基本ALSA配置以使用声卡2。

在浏览器中打开URL http://127.0.0.1:6080/#/?video，其中`video`表示以视频模式启动。现在您可以从开始菜单启动Chromium（互联网 -> Chromium Web Browser Sound）并尝试播放一些视频。

以下是这些操作的屏幕录制。在视频结尾打开声音！

[![演示视频](http://img.youtube.com/vi/Kv9FGClP1-k/0.jpg)](http://www.youtube.com/watch?v=Kv9FGClP1-k)

## 从jinja模板生成Dockerfile

警告：已弃用

Dockerfile和配置可以通过模板生成。

- arch: `amd64`或`armhf`之一
- flavor: 参考flavor/`flavor`.yml文件
- image: 基础镜像
- desktop: 在flavor中设置的桌面环境
- addon_package: 在flavor中设置的要安装的Debian软件包

如果Dockerfile和配置不存在，将重新生成。或者您可以通过`make clean`命令删除它们以强制重新生成。

## 故障排除与常见问题

1. boot2docker连接问题，https://github.com/fcwu/docker-ubuntu-vnc-desktop/issues/2
2. 多语言支持，https://github.com/fcwu/docker-ubuntu-vnc-desktop/issues/80
3. 自动启动，https://github.com/fcwu/docker-ubuntu-vnc-desktop/issues/85#issuecomment-466778407
4. x11vnc参数（multiptr），https://github.com/fcwu/docker-ubuntu-vnc-desktop/issues/101
5. firefox/chrome崩溃（/dev/shm），https://github.com/fcwu/docker-ubuntu-vnc-desktop/issues/112
6. 不销毁容器调整显示大小，https://github.com/fcwu/docker-ubuntu-vnc-desktop/issues/115#issuecomment-522426037

## 许可证

详情参见LICENSE文件。

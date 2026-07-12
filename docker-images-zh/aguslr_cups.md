---
image: aguslr/cups
description: "设置CUPS以通过网络共享USB打印机"
source: https://xuanyuan.cloud/zh/r/aguslr/cups
canonical: https://xuanyuan.cloud/zh/r/aguslr/cups
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/aguslr/cups" title="aguslr/cups Docker 镜像中文简介、标签列表与拉取命令">aguslr/cups 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# aguslr/docker-cups

[![docker-pulls](https://img.shields.io/docker/pulls/aguslr/cups)](https://hub.docker.com/r/aguslr/cups) [![image-size](https://img.shields.io/docker/image-size/aguslr/cups/latest)](https://hub.docker.com/r/aguslr/cups)


此Docker镜像在容器内设置CUPS，CUPS是类Unix系统的模块化打印系统，可让计算机充当打印服务器。


## 安装

要使用docker-cups，请按照以下步骤操作：

### 步骤

1. 将DEB格式的打印机驱动下载到名为`./drivers`的目录中。

2. 启动容器：

   ```bash
   docker run --privileged -p 631:631 \
     -e CUPS_USER=admin \
     -e CUPS_PASS=admin \
     -v /dev/bus/usb:/dev/bus/usb \
     -v /run/dbus:/run/dbus \
     -v "${PWD}"/drivers:/opt/drivers \
     docker.io/aguslr/cups:latest
   ```

3. 在Web浏览器中打开<http://127.0.0.1:631>以访问CUPS管理界面。


### 环境变量

镜像通过运行时传递的环境变量进行配置，所有变量均以`CUPS_`为前缀。

| 变量   | 功能               | 默认值   | 是否必填 |
| :----- | :----------------- | :------- | :------- |
| `USER` | CUPS用户的用户名   | `admin`  | 否       |
| `PASS` | CUPS用户的密码     | 自动生成 | 否       |

要查看默认的自动生成密码，请检查容器日志：

```bash
docker logs <container_name> | grep '^Password'
```


## 本地构建

如需本地构建而非拉取远程镜像：

1. 克隆仓库：

   ```bash
   git clone https://github.com/aguslr/docker-cups.git
   ```

2. 进入目录并使用`docker-compose`构建启动：

   ```bash
   cd docker-cups && docker-compose up --build -d
   ```


[1]: https://github.com/aguslr/docker-cups
[2]: https://www.cups.org/

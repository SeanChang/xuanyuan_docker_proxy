---
image: szabis/iventoy
description: "iVentoy 是一个完整的 PXE 引导服务器，包含支持电脑通过网络启动所需的服务。"
source: https://xuanyuan.cloud/zh/r/szabis/iventoy
canonical: https://xuanyuan.cloud/zh/r/szabis/iventoy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/szabis/iventoy" title="szabis/iventoy Docker 镜像中文简介、标签列表与拉取命令">szabis/iventoy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# iVentoy

运行[iVentoy](https://www.iventoy.com)的Docker镜像。

iVentoy是一个完整的PXE引导服务器，包含支持计算机通过网络启动所需的必要服务。

如果您不了解PXE、DHCP或TFTP，请不要尝试使用！

建议与第三方DHCP服务器配合使用
[iVentoy与第三方DHCP服务器](https://www.iventoy.com/en/doc_ext_dhcp.html)

| 目录   | 挂载点                  | 说明                                   |
|--------|-------------------------|----------------------------------------|
| `data` | /opt/iventoy/data       | 用于许可证文件、配置文件。             |
| `iso`  | /opt/iventoy/iso        | 用于ISO文件。                          |
| `log`  | /opt/iventoy/log        | 用于日志文件。                         |
| `user` | /opt/iventoy/user       | 用于用户文件、第三方软件、自动安装脚本等。 |

## 更新内容
iVentoy已更新至1.0.21版本。

## 命令行启动

此容器必须以root用户运行。

```bash
docker run -d --name iventoy \
  --network host \
  --privileged \
  -v /path/to/data:/opt/iventoy/data \
  -v /path/to/iso:/opt/iventoy/iso \
  -v /path/to/log:/opt/iventoy/log \
  -v /path/to/user:/opt/iventoy/user \
  -p 67:67/udp \
  -p 69:69/udp \
  -p 10809:10809/tcp \
  -p 16000:16000/tcp \
  -p 26000:26000/tcp \
  docker.xuanyuan.run/szabis/iventoy:latest
```

## Docker Compose

此容器必须以root用户运行。

```yaml
---
version: '3.9'
services:
  iventoy:
    image: szabis/iventoy:latest
    network_mode: "host"
    container_name: iventoy
    restart: always
    privileged: true #必须设置为true
    environment:
      - AUTO_START_PXE=true
    ports:
      - "67:67/udp" # DHCP服务器
      - "69:69/udp" # TFTP服务器
      - "10809:10809" # NBD服务器 (NBD)
      - "16000:16000" # PXE服务HTTP服务器 (iVentoy PXE服务)
      - "26000:26000" # PXE GUI HTTP服务器 (iVentoy图形界面)
    volumes:
      - /path/to/data:/opt/iventoy/data
      - /path/to/iso:/opt/iventoy/iso
      - /path/to/log:/opt/iventoy/log
      - /path/to/user:/opt/iventoy/user

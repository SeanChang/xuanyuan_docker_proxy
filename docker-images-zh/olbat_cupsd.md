<!-- xuanyuan-docker-images-zh
image: olbat/cupsd
source: https://xuanyuan.cloud/zh/r/olbat/cupsd
canonical: https://xuanyuan.cloud/zh/r/olbat/cupsd
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/olbat/cupsd" title="olbat/cupsd Docker 镜像中文简介、标签列表与拉取命令">olbat/cupsd — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/olbat/cupsd" title="olbat/cupsd Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/olbat/cupsd</a></p>

### 说明  
本镜像基于 [[]]([]) 构建。


## 概述  
该Docker镜像包含CUPS打印服务器及 Debian 官方打包的打印驱动，可用于搭建远程打印服务。


## 运行CUPS服务器  

### 使用默认配置  
直接运行容器，使用镜像自带的 `cupsd.conf` 配置文件：  
```bash
docker run -d -p 631:631 -v /var/run/dbus:/var/run/dbus --name cupsd olbat/cupsd
```

### 使用自定义配置  
如需自定义配置，将本地 `cupsd.conf` 文件挂载到容器内：  
```bash
docker run -d -p 631:631 -v /var/run/dbus:/var/run/dbus -v $PWD/cupsd.conf:/etc/cups/cupsd.conf --name cupsd olbat/cupsd
```

**注意**：若需连接USB打印机，可添加挂载 `-v /dev/bus/usb:/dev/bus/usb`（参考 [issue#103]([])）。  

**补充说明**：若启动时出现 `cupsdDoSelect() failed` 错误，可通过调整容器 `ulimit` 配置解决（参考 [issue#111]([])）。


## 向CUPS服务器添加打印机  

1. 访问CUPS服务器管理页面：[[]]([])  
2. 添加打印机：依次点击 **Administration > Printers > Add Printer**  

**注意**：CUPS服务器管理员账号密码为 `print`/`print`。


## 配置本地CUPS客户端  

1. 安装 `cups-client` 包  
2. 编辑 `/etc/cups/client.conf`，设置 `ServerName` 为 `127.0.0.1:631`  
3. 测试服务器连接：`lpstat -r`  
4. 检查打印机是否被识别：`lpstat -v`  
5. 完成后，本地应用程序即可检测到打印机。


### 包含的软件包  
- cups、cups-client、cups-filters  
- foomatic-db  
- printer-driver-all、printer-driver-cups-pdf  
- openprinting-ppds  
- hpijs-ppds、hp-ppd  
- sudo、whois  
- smbclient  


## 故障排除  

本镜像集成了 Debian 官方打包的大部分打印驱动，可用于搭建远程CUPS打印服务器。  

### 注意事项  
- 镜像的GitHub仓库不负责维护或调试 Debian 打包的打印机驱动及CUPS服务本身。  
- 若需驱动或CUPS服务支持，建议联系相关渠道：  
  - [Debian 论坛]([])  
  - [Debian 打印团队]([])  
  - [CUPS 邮件列表]([])  
  - 或通过搜索引擎查找其他支持资源。  

- 关于容器启动、本地网络访问、NAS部署等问题，也请联系对应支持渠道。若涉及Docker网络配置，建议先阅读 [Docker 网络文档]([]) 了解基础概念。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/olbat/cupsd" title="olbat/cupsd Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/olbat/cupsd</a></p>

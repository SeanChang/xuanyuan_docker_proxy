---
image: chuckcharlie/cups-avahi-airprint
description: "基于Alpine的AirPrint中继，为iOS设备提供打印支持，适用于网络中不支持AirPrint的打印机，支持ARM64和AMD64架构。"
source: https://xuanyuan.cloud/zh/r/chuckcharlie/cups-avahi-airprint
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[chuckcharlie/cups-avahi-airprint](https://xuanyuan.cloud/zh/r/chuckcharlie/cups-avahi-airprint)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# chuckcharlie/cups-avahi-airprint

从[quadportnick/docker-cups-airprint](https://github.com/quadportnick/docker-cups-airprint)分叉而来

### 现已支持ARM64和AMD64架构！
使用`latest`或`version#`标签可自动选择匹配的架构。

本镜像基于Alpine系统，运行CUPS实例作为AirPrint中继，专为网络中不支持AirPrint的打印机设计。相比其他同类镜像，本镜像采用Alpine替代Ubuntu，可在更多主机操作系统上运行。

## 核心功能与特性
- 轻量级Alpine系统基础，资源占用低
- 支持ARM64和AMD64双架构，自动适配
- 持久化存储打印机配置，确保重启后配置不丢失
- 自动生成Avahi服务文件，实现打印机网络发现
- 通过环境变量灵活配置管理员账户

## 使用场景
适用于家庭或小型办公环境，当网络中存在不支持AirPrint的传统打印机，需要让iOS设备（iPhone、iPad等）实现无线打印时使用。

## 配置说明

### 卷（Volumes）
* `/config`：存储持久化的打印机配置文件
* `/services`：生成Avahi服务文件的目录

### 环境变量（Variables）
* `CUPSADMIN`：CUPS管理员用户名，未指定时默认值为`CUPSADMIN`
* `CUPSPASSWORD`：管理员用户密码，未指定时默认与`CUPSADMIN`值相同

### 网络要求
* 必须使用host网络模式运行，以支持AirPrint所需的多播功能

## 使用方法

### 示例运行命令
```bash
docker run --name cups --restart unless-stopped --net host \
  -v <你的服务目录>:/services \
  -v <你的配置目录>:/config \
  -e CUPSADMIN="<用户名>" \
  -e CUPSPASSWORD="<密码>" \
  chuckcharlie/cups-avahi-airprint:latest
```

### 示例docker-compose配置
```yaml
version: '3.5'
services:
  cups:
    image: chuckcharlie/cups-avahi-airprint:latest
    container_name: cups
    network_mode: host
    volumes:
      - </你的服务目录>:/services
      - </你的配置目录>:/config
    environment:
      CUPSADMIN: "<你的管理员用户名>"
      CUPSPASSWORD: "<你的密码>"
    restart: unless-stopped
```

### 网络配置
* **必须使用host网络模式**，这是支持多播（AirPrint功能必需）的必要条件

## 打印机添加与设置
1. 通过 `http://[主机IP]:631` 访问CUPS管理界面，使用`CUPSADMIN`和`CUPSPASSWORD`登录
2. 配置打印机时，确保勾选 **"共享此打印机（Share This Printer）"** 选项
3. 配置完成后，需关闭Web浏览器至少60秒。CUPS仅在检测到连接关闭达一分钟左右时，才会写入配置文件。

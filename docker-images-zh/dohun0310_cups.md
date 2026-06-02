---
image: dohun0310/cups
description: "支持CUPS和AirPrint，并集成systemd，用于网络打印机管理的Docker镜像。"
source: https://xuanyuan.cloud/zh/r/dohun0310/cups
canonical: https://xuanyuan.cloud/zh/r/dohun0310/cups
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dohun0310/cups" title="dohun0310/cups Docker 镜像中文简介、标签列表与拉取命令">dohun0310/cups — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/dohun0310/cups" title="dohun0310/cups Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/dohun0310/cups</a>

# CUPS 打印服务器 Docker 镜像

## 镜像概述和主要用途
本镜像提供基于Docker的CUPS（通用UNIX打印系统）打印服务器，集成AirPrint和systemd，支持网络打印机的集中管理与共享。适用于家庭或小型办公环境，可实现跨平台（Windows、macOS、Linux、iOS）打印服务的快速部署与维护。

## 核心功能和特性
- 完整支持CUPS核心功能，提供标准网络打印服务
- 兼容AirPrint协议，支持iOS和macOS设备无线打印
- 集成systemd，确保服务稳定运行与进程管理
- 内置丰富打印驱动和工具包，支持多种打印机型号
- 支持自定义管理员账户及配置持久化存储

## 使用场景和适用范围
- 家庭网络中共享单个或多个物理打印机
- 小型办公室网络打印机集中管理与访问控制
- 需要跨设备、跨平台打印支持的环境
- 希望通过容器化方式简化打印服务部署与维护的场景

## 使用方法和配置说明

### 默认部署
通过以下命令快速启动默认配置的CUPS服务器：
```bash
docker run -d -p 631:631 -p 5353:5353 --name cups dohun0310/cups
```
默认管理员账户信息：用户名`print`，密码`print`。

### 自定义部署
如需自定义配置，可使用以下命令：
```bash
docker run -d -p 631:631 -p 5353:5353 -v $(pwd):/etc/cups -e TZ=Asia/Seoul -e USERNAME=user -e PASSWORD=password --name cups dohun0310/cups
```
**参数说明**：
- `-v $(pwd):/etc/cups`：将当前目录挂载到容器内`/etc/cups`，实现配置持久化
- `-e TZ=Asia/Seoul`：设置时区（示例为亚洲/首尔，可替换为其他时区如`Asia/Shanghai`）
- `-e USERNAME=user`：自定义管理员用户名
- `-e PASSWORD=password`：自定义管理员密码

## 如何向CUPS服务器添加打印机

### 连接CUPS服务器
打开浏览器，访问CUPS Web管理界面：`http://127.0.0.1:631`（若服务器部署在远程，替换`127.0.0.1`为服务器IP）。

### 添加打印机
1. 在CUPS Web界面顶部导航栏点击**Administration**（管理）选项卡
2. 在**Printers**（打印机）分类下，点击**Add Printer**（添加打印机）按钮

### 完成打印机设置向导
1. 若提示身份验证，输入CUPS管理员用户名和密码（默认`print`/`print`或自定义账户）
2. 在可用打印机列表中选择需添加的打印机（确保打印机已连接并开机）
3. 按提示配置打印机名称、描述及位置信息
4. 选择匹配的打印机驱动（镜像已包含多种驱动，通常可自动识别）
5. 确认配置并点击**Add Printer**（添加打印机）或**Finish**（完成）

### 测试打印机
1. 在打印机配置页面中找到**Print Test Page**（打印测试页）选项
2. 点击测试打印，检查打印机是否成功输出测试页
3. 若打印失败，检查驱动配置或打印机连接状态

## 包含的软件包
- 系统工具：sudo、curl、wget
- CUPS组件：cups、cups-client、cups-filters、cups-bsd、foomatic-db
- 打印驱动：printer-driver-all、printer-driver-cups-pdf、openprinting-ppds、hpijs-ppds、hp-ppd
- 辅助工具：cups-filters、openprinting-ppds

# 10 分钟用 Docker 跑起 Odoo！中小企业免费 ERP 部署实战

![10 分钟用 Docker 跑起 Odoo！中小企业免费 ERP 部署实战](https://img.xuanyuan.dev/docker/blog/docker-odoo.png)

*分类: Docker部署教程 | 标签: Docker,Odoo,ERP,PostgreSQL | 发布时间: 2026-06-08 03:47:21*

> 不少中小企业都有这样的困扰：销售靠Excel记账、库存人工盘点、财务对账耗时费力、客户信息零散混乱，多个办公系统切换使用，数据不通、效率低下。今天给大家分享一套零成本、一体化的解决方案——Odoo开源ERP系统。全程采用Docker部署，无需复杂环境配置，10分钟即可搭建完成，适配国内服务器，稳定高速、无冗余操作。

不少中小企业都有这样的困扰：销售靠Excel记账、库存人工盘点、财务对账耗时费力、客户信息零散混乱，多个办公系统切换使用，数据不通、效率低下。今天给大家分享一套零成本、一体化的解决方案——Odoo开源ERP系统。全程采用Docker部署，无需复杂环境配置，10分钟即可搭建完成，适配国内服务器，稳定高速、无冗余操作。

## 一、为什么选Odoo？中小企业专属数字化工具

Odoo是全球主流的开源企业管理系统，前身是OpenERP，基于Python开发，支持免费商用。最大的优势是**模块化、全集成、无版权费用**，完美适配中小微企业日常经营需求，彻底告别多系统杂乱办公的问题。

核心常用功能全覆盖：

- **销售管理**：一键生成报价单、销售订单，全程跟进发货、回款流程

- **客户管理(CRM)**：统一归档客户信息、跟进商机线索，避免客户流失

- **库存仓储**：实时同步库存数据，支持多仓库管理、出入库记录溯源

- **财务会计**：自动对账、开票管理、流水记录，简化财务核算工作

- **人事行政**：员工档案、考勤请假、招聘流程一体化管理

- **电商建站**：快速搭建企业官网、线上店铺，订单自动同步后台

相较于付费ERP系统，Odoo基础功能永久免费、不限用户数，小到初创团队、大到中小型工厂都能直接使用。国内可通过轩辕镜像快速拉取Odoo镜像，速度远超官方源，配套中文文档，部署更省心：[Odoo ERP 镜像下载](https://xuanyuan.cloud/zh/r/library/odoo)

## 二、前置准备：Docker环境一键搞定
本次采用 Docker 容器化方式部署 Odoo，隔离环境、部署简单、迁移方便，下面分系统完成 Docker 安装配置。

### Linux系统（含国产系统）一键安装
Ubuntu、CentOS、欧拉、银河麒麟、统信UOS 等主流 Linux 及国产操作系统，可直接执行一键脚本，自动安装 Docker、Docker Compose，并配置国内镜像加速，彻底解决拉取镜像慢的问题。
打开终端，执行以下命令：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

### Windows / Mac 用户
Windows 和 Mac 桌面系统，直接使用官方 Docker Desktop 即可，图形化操作简单易上手。
👉 [Docker Desktop官方下载](https://www.docker.com/get-started/)
安装完成后启动软件，桌面状态栏出现鲸鱼图标，代表 Docker 正常运行。

### 验证安装
打开终端（Linux）或 PowerShell（Windows），执行命令检查 Docker 状态：
```bash
docker version
```
输出 Client、Server 版本信息，即代表环境准备完成。

## 三、Docker 部署 Odoo 19 及权限问题排错

### 1. 创建本地挂载目录并授权
我们将宿主机 `/data/odoo` 目录挂载到容器内 `/var/lib/odoo`，首先手动创建目录，并开放读写权限，解决权限拒绝问题：
```bash
# 递归创建目录
mkdir -p /data/odoo

# 赋予目录完整读写权限
chmod -R 777 /data/odoo
```

### 2. 启动Odoo 19容器
执行 `docker run` 命令拉取轩辕镜像并启动容器，命令中配置了网络、端口、数据库连接、自启动等参数，直接复制运行即可：
```bash
docker run -d \
  --name odoo19 \
  --network odoo-net \
  -p 8069:8069 \
  -e HOST=odoo-db \
  -e USER=odoo \
  -e PASSWORD=odoo123 \
  -v /data/odoo:/var/lib/odoo \
  --restart unless-stopped \
  docker.xuanyuan.run/library/odoo:19.0-20260528
```

### 3. 查看运行日志，验证是否正常启动
通过日志排查运行状态，不再出现权限报错即为正常：
```bash
docker logs -f odoo19
```
**正常日志特征**：
出现 `HTTP service (werkzeug) running on`、`database: odoo@odoo-db:5432` 相关内容。
**异常判断**：
如果日志中包含 `PermissionError: [Errno 13]`，说明目录权限依旧异常，重新执行第一步授权命令即可。

很多朋友在挂载本地目录运行 Odoo 容器后，会遇到 **500 服务错误**，根源并非 Odoo 程序本身，而是**宿主机挂载目录权限不足**，容器内 Odoo 进程无法创建 `sessions` 会话目录，进而触发权限报错。

下面一步步完整部署并修复问题。

### 停止并清理旧容器
如果之前已经启动过异常容器，先停止并删除，避免冲突：
```bash
# 停止Odoo容器
docker stop odoo19

# 删除旧容器
docker rm odoo19
```

## 四、Odoo数据库初始化配置
容器启动成功后，打开浏览器访问地址：`http://服务器IP:8069`，进入 Odoo 数据库初始化页面。

### 1. 页面参数说明与填写
页面会自动生成**数据库管理主密码（Master Password）**，该密码用于后续数据库创建、备份、删除、恢复，请务必妥善保存。
本次示例生成密码：`hs49-y5aj-qr7t`（你本地会随机生成，以页面显示为准）。

![odoo登录页](https://img.xuanyuan.dev/docker/blog/docker-odoo-1.png)

各参数填写参考：
1. **Master Password**：使用页面自动生成的密码（后期可修改）
2. **Database Name**：自定义数据库名，例如 `odoo19`
3. **Email**：管理员登录账号（如 `admin@example.com`）
4. **Password**：设置后台管理员登录密码
5. **Phone Number**：选填，可留空
6. **Language**：选择 `Chinese, Simplified / 简体中文`
7. **Country**：选择 `China`
8. **Demo Data**：测试体验可勾选，正式生产环境建议取消勾选

填写完成后点击 **Create database**，首次初始化耗时 1~5 分钟，耐心等待即可。
![odoo提示](https://img.xuanyuan.dev/docker/blog/docker-odoo-2.png)
> 小提示：重复点击创建按钮会提示数据库已存在，属于正常现象，点击蓝色 odoo19 继续进入页面即可。

### 2. 登录后台
数据库创建完成后，直接点击页面上的数据库名称，或访问后台地址：
```
http://服务器IP:8069/web
```

![odoo登录](https://img.xuanyuan.dev/docker/blog/docker-odoo-3.png)
登录注意区分两个密码：
- **管理员登录**：使用刚才设置的 `Email + 自定义密码`
- **数据库管理**（建库/删库/备份）：使用页面生成的 `Master Password`

### 3. 数据库状态核查（可选）
如需确认数据库是否正常创建，可执行以下命令进入数据库查看：
```bash
docker exec -it odoo-db psql -U odoo -l
```
列表中能看到你创建的数据库名（如 `odoo19`），代表整个部署流程全部完成。

![odoo应用列表](https://img.xuanyuan.dev/docker/blog/docker-odoo-4.png)

此时，Odoo 就正常运行进入了，你可以根据需要添加相关系统模块。

![odoo反馈](https://img.xuanyuan.dev/docker/blog/docker-odoo-5.png)

## 五、总结
1. Odoo 采用 Docker 容器部署是最高效的方式，依托轩辕镜像可快速拉取、稳定运行；
2. 部署 Odoo 最常见的 500 报错，90% 都是**本地挂载目录权限不足**导致，给目录开放读写权限即可彻底解决；
3. 部署完成后分清「管理员登录密码」和「数据库主密码」，避免后续操作混淆；
4. 正式上线前建议关闭演示数据，保证系统纯净，满足企业正式使用需求。

按照本文步骤操作，即可在 Linux、国产服务器上快速搭建一套可用的 Odoo 19 企业ERP系统。

参考文档：[Odoo ERP 中文简介及镜像下载](https://xuanyuan.cloud/zh/r/library/odoo)

附件：

```bash
version: "3.8"

services:
  db:
    image: docker.xuanyuan.run/postgres:17
    container_name: odoo-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: odoo
      POSTGRES_PASSWORD: odoo123
      POSTGRES_DB: postgres
    volumes:
      - /data/postgres:/var/lib/postgresql/data
    networks:
      - odoo-net

  odoo:
    image: docker.xuanyuan.run/library/odoo:19.0-20260528
    container_name: odoo19
    restart: unless-stopped
    depends_on:
      - db
    ports:
      - "8069:8069"
    environment:
      HOST: db
      USER: odoo
      PASSWORD: odoo123
    volumes:
      - /data/odoo:/var/lib/odoo
    networks:
      - odoo-net

networks:
  odoo-net:
    driver: bridge
```


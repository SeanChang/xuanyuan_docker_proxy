---
image: dingdangdog/cashbook
description: "Cashbook是一款简单易用、自主可控的记账本Docker镜像，支持数据本地存储与清晰美观的统计分析，追求数据记录简单易用、统计分析直观有效，适合个人和家庭财务记录管理。"
source: https://xuanyuan.cloud/zh/r/dingdangdog/cashbook
canonical: https://xuanyuan.cloud/zh/r/dingdangdog/cashbook
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dingdangdog/cashbook" title="dingdangdog/cashbook Docker 镜像中文简介、标签列表与拉取命令">dingdangdog/cashbook — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/dingdangdog/cashbook" title="dingdangdog/cashbook Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/dingdangdog/cashbook</a>

# Cashbook 4.0+

- Github：[https://github.com/dingdangdog/cashbook](https://github.com/dingdangdog/cashbook)
- 在线体验：[cashbook.oldmoon.top](https://cashbook.oldmoon.top/) (体验账号: `cashbook`/`cashbook`)
- 在线体验后台：[cashbook.oldmoon.top/admin](https://cashbook.oldmoon.top/admin) (体验账号: `admin`/`admin123456`)
- QQ交流群：`564081656`

## 镜像概述和主要用途

Cashbook记账本Docker镜像，旨在提供简单易用、自主可控的数据记录与清晰美观的统计分析功能。在数据记录上追求简单、易用、自主可控，确保用户对财务数据拥有完全控制权；在统计分析上力求清晰、美观、简洁有效，帮助用户直观掌握财务状况。

**重要提示：如果使用 `docker-compose` 部署到公网，请自行修改各类环境变量（如：后台账号密码、数据库密码、服务地址等）！！！**

## 核心功能和特性

- 前后台分离设计，独立后台便于系统管理
- 支持Docker容器化部署，简化安装流程
- 数据本地存储，支持挂载卷持久化（小票图片等）
- 多平台账单导入：支付宝CSV、微信CSV、京东金融CSV
- 消费类型自动映射转换，支持自定义配置
- 直观的消费日历看板与多维度统计图表：
  - 支出类型统计饼图
  - 支付方式统计饼图
  - 每日流水统计曲线图
  - 每月流水统计柱状图
- 多用户模式支持，数据隔离
- 单用户多账本功能，账本间数据独立
- 基于PostgreSQL数据库，稳定可靠
- 小票图片上传与数据快速迁移（导入/导出）
- 待实现功能：主题系统等

## 使用场景和适用范围

适用于个人、家庭或小型团队的财务记录管理，尤其适合注重数据隐私与自主可控的用户。可部署在本地服务器、私有云或个人NAS上，满足日常记账、消费分析、账单导入等需求，帮助用户清晰掌握收支情况。

## 详细使用方法和配置说明

### Docker部署

推荐使用`docker-compose`部署，以下提供两种部署方案。

#### 方案一：Cashbook与数据库一起部署

```yaml
services:
  main:
    container_name: cashbook4
    depends_on: 
      - "db"
    image: dingdangdog/cashbook:4.0.1
    restart: always
    volumes:
      - ./data:/app/data # 数据挂载到本地，不建议修改
    environment:
      DATABASE_URL: "postgresql://postgres:postgres@cashbook_db:5432/cashbook?schema=public" # 数据库链接，【请自行修改！与你的数据库一致】
      NUXT_DATA_PATH: "/app/data" # 数据存储路径，仅含小票图片，不建议修改
      NUXT_APP_URL: "https://cashbook.oldmoon.top" # 服务根路径，含端口需添加端口号
      NUXT_AUTH_ORIGIN: "https://cashbook.oldmoon.top/api/auth" # 登录授权接口地址 【请自行修改域名/IP！需以 /api/auth 结尾】
      NUXT_AUTH_SECRET: "auth_secret" # 前台登录加密密钥 【自行修改！】
      NUXT_ADMIN_USERNAME: "admin" # 后台登录用户名
      # 后台登录密码（加密后），生成密码可访问 https://cashbook.oldmoon.top/admin/GetPassword 或部署后访问 `你的url/admin/GetPassword` 【自行修改！】
      NUXT_ADMIN_PASSWORD: "fb35e9343a1c095ce1c1d1eb6973dc570953159441c3ee315ecfefb6ed05f4cc"
    ports:
      - 9090:9090 # 账本开放端口 【自行修改！】
  db:
    container_name: cashbook_db
    image: postgres
    restart: always
    shm_size: 128mb
    volumes:
      - ./db:/var/lib/postgresql/data # 数据库数据挂载到本地，不建议修改
    environment:
      POSTGRES_PASSWORD: postgres # 数据库密码 【自行修改！】
```

#### 方案二：仅部署Cashbook（使用已有PostgreSQL数据库）

需自行配置数据库连接，建议了解Docker网络知识。

```yaml
services:
  main:
    container_name: cashbook4
    image: dingdangdog/cashbook:4.0.1
    restart: always
    network_mode: "host" # 如需连接宿主机数据库，可启用host网络
    volumes:
      - ./data:/app/data # 数据挂载到本地，不建议修改
    environment:
      DATABASE_URL: "postgresql://postgres:postgres@localhost:5432/cashbook?schema=public" # 数据库链接，【请修改账号密码及地址！】
      NUXT_DATA_PATH: "/app/data" # 数据存储路径，不建议修改
      NUXT_APP_URL: "https://cashbook.oldmoon.top" # 服务根路径，含端口需添加端口号
      NUXT_AUTH_ORIGIN: "https://cashbook.oldmoon.top/api/auth" # 登录授权接口地址 【请自行修改域名/IP！需以 /api/auth 结尾】
      NUXT_AUTH_SECRET: "auth_secret" # 前台登录加密密钥 【自行修改！】
      NUXT_ADMIN_USERNAME: "admin" # 后台登录用户名
      # 后台登录密码（加密后），生成密码可访问 https://cashbook.oldmoon.top/admin/GetPassword 或部署后访问 `你的url/admin/GetPassword` 【自行修改！】
      NUXT_ADMIN_PASSWORD: "fb35e9343a1c095ce1c1d1eb6973dc570953159441c3ee315ecfefb6ed05f4cc"
```

### 环境变量说明

| 环境变量名               | 说明                                                                 | 是否建议修改       |
|--------------------------|----------------------------------------------------------------------|--------------------|
| DATABASE_URL             | PostgreSQL数据库连接地址，格式：postgresql://用户名:密码@地址:端口/数据库名?schema=public | 是（必须与数据库配置一致） |
| NUXT_DATA_PATH           | 数据存储路径，仅存储小票图片                                         | 否                 |
| NUXT_APP_URL             | 服务根URL，如部署在公网需填写实际访问地址（含端口）                   | 是（需修改为实际地址） |
| NUXT_AUTH_ORIGIN         | 登录授权接口地址，需以 `/api/auth` 结尾                               | 是（需修改为实际地址） |
| NUXT_AUTH_SECRET         | 前台用户登录加密密钥                                                 | 是（提高安全性）   |
| NUXT_ADMIN_USERNAME      | 后台管理账号用户名                                                   | 是（默认admin不安全） |
| NUXT_ADMIN_PASSWORD      | 后台管理账号加密密码，需通过指定页面生成                             | 是（默认密码需修改） |

### 类型映射配置

系统支持账单导入时的消费类型自动映射，默认映射关系如下（可在系统中修改）：

```json
{
  "食品酒饮": "餐饮美食",
  "餐饮美食": "餐饮美食",
  "家居家装": "日用百货",
  "日用百货": "日用百货",
  "鞋服箱包": "日用百货",
  "清洁纸品": "日用百货",
  "医疗保健": "医疗健康",
  "医疗健康": "医疗健康",
  "充值缴费": "充值缴费",
  "教育培训": "教育培训",
  "图书文娱": "文化休闲",
  "运动户外": "文化休闲",
  "文体玩具": "文化休闲",
  "文化休闲": "文化休闲",
  "微信红包": "转账红包",
  "微信红包（单发）": "转账红包",
  "微信红包（群红包）": "转账红包",
  "转账红包": "转账红包",
  "转账": "转账红包",
  "二维码收款": "微信交易",
  "微信交易": "微信交易",
  "商户消费": "微信交易",
  "扫二维码付款": "微信交易",
  "小金库": "投资理财",
  "投资理财": "投资理财",
  "收入": "投资理财",
  "转入零钱通-来自零钱": "投资理财",
  "手机通讯": "数码电器",
  "数码电器": "数码电器",
  "电脑办公": "数码电器",
  "服饰内衣": "服饰装扮",
  "服饰装扮": "服饰装扮",
  "钟表眼镜": "服饰装扮",
  "美妆个护": "美容美发",
  "美容美发": "美容美发",
  "汽车用品": "爱车养车",
  "爱车养车": "爱车养车",
  "亲友代付": "亲友代付",
  "亲属卡交易": "亲友代付",
  "亲属卡交易-退款": "退款",
  "美团平台商户-退款": "退款",
  "退款": "退款"
}
```

#### 修改方法：

1. **后台全局修改**：  
   登录后台（`你的url/admin`）→ 进入“类型数据”菜单 → 修改默认映射关系（账本Id和用户Id为0的记录）并保存。默认映射关系会在创建新账本时自动应用。

2. **前台账本配置**：  
   登录前台 → 进入“系统管理 → CSV导入映射配置”或“类型管理 → CSV导入映射配置” → 编辑当前账本的映射关系，仅对当前账本生效。

> 注意：创建账本后，账本映射关系与默认映射关系相互独立，需分别修改。<|FCResponseEnd|>===SHORT_DESC===
Cashbook是一款简单易用、自主可控的记账本Docker镜像，支持本地数据存储与清晰美观的统计分析，适合个人和家庭财务记录管理，兼顾数据隐私与使用便捷性。
===FULL_DESC===# Cashbook 4.0+

- Github：[https://github.com/dingdangdog/cashbook](https://github.com/dingdangdog/cashbook)
- 在线体验：[cashbook.oldmoon.top](https://cashbook.oldmoon.top/) (体验账号: `cashbook`/`cashbook`)
- 在线体验后台：[cashbook.oldmoon.top/admin](https://cashbook.oldmoon.top/admin) (体验账号: `admin`/`admin123456`)
- QQ交流群：`564081656`

## 镜像概述和主要用途

Cashbook是一款专注于个人财务记录的Docker镜像，核心特点为：在数据记录上追求简单、易用、自主可控；在统计分析上力求清晰、美观、简洁有效。支持本地数据持久化存储，可部署在个人服务器或私有环境中，满足用户对财务数据隐私与自主管理的需求。

**重要提示：如使用 `docker-compose` 部署到公网，务必修改各类环境变量（包括但不限于后台账号密码、数据库密码、服务地址等），确保部署安全！**

## 核心功能和特性

- 前后台分离架构，独立后台便于系统管理
- Docker容器化部署，支持`docker-compose`快速搭建
- 多平台账单导入：支付宝CSV、微信CSV、京东金融CSV
- 消费类型自动映射转换，支持自定义配置
- 直观数据可视化：消费日历看板、支出类型饼图、支付方式饼图、每日流水曲线图、每月流水柱状图
- 多用户支持，数据相互隔离
- 单用户多账本功能，账本间数据独立
- PostgreSQL数据库支持，数据可靠存储
- 小票图片上传与数据迁移（导入/导出）
- 本地数据挂载，确保数据自主可控

## 使用场景和适用范围

适用于个人、家庭或小型团队的日常财务记录与管理，尤其适合注重数据隐私、需要自主掌控财务数据的用户。可部署在本地服务器、NAS或私有云环境，满足日常记账、消费分析、账单导入整理等需求，帮助用户清晰掌握收支状况。

## 详细使用方法和配置说明

### Docker部署

推荐使用`docker-compose`部署，提供以下两种部署方案。

#### 方案一：Cashbook与数据库协同部署

```yaml
services:
  main:
    container_name: cashbook4
    depends_on: 
      - "db"
    image: dingdangdog/cashbook:4.0.1
    restart: always
    volumes:
      - ./data:/app/data # 数据挂载到本地，不建议修改
    environment:
      DATABASE_URL: "postgresql://postgres:postgres@cashbook_db:5432/cashbook?schema=public" # 数据库链接，【请自行修改！与数据库配置一致】
      NUXT_DATA_PATH: "/app/data" # 数据存储路径（仅含小票图片），不建议修改
      NUXT_APP_URL: "https://cashbook.oldmoon.top" # 服务根路径，含端口需添加端口号
      NUXT_AUTH_ORIGIN: "https://cashbook.oldmoon.top/api/auth" # 登录授权接口地址 【请自行修改域名/IP！需以 /api/auth 结尾】
      NUXT_AUTH_SECRET: "auth_secret" # 前台登录加密密钥 【请自行修改！】
      NUXT_ADMIN_USERNAME: "admin" # 后台登录用户名
      # 后台登录密码（加密后），生成密码可访问 https://cashbook.oldmoon.top/admin/GetPassword 或部署后访问 `你的url/admin/GetPassword` 【请自行修改！】
      NUXT_ADMIN_PASSWORD: "fb35e9343a1c095ce1c1d1eb6973dc570953159441c3ee315ecfefb6ed05f4cc"
    ports:
      - 9090:9090 # 服务开放端口 【请自行修改！】
  db:
    container_name: cashbook_db
    image: postgres
    restart: always
    shm_size: 128mb
    volumes:
      - ./db:/var/lib/postgresql/data # 数据库数据挂载到本地，不建议修改
    environment:
      POSTGRES_PASSWORD: postgres # 数据库密码 【请自行修改！】
```

#### 方案二：仅部署Cashbook（使用现有PostgreSQL数据库）

适用于已存在PostgreSQL数据库的环境，需正确配置数据库连接信息。

```yaml
services:
  main:
    container_name: cashbook4
    image: dingdangdog/cashbook:4.0.1
    restart: always
    network_mode: "host" # 如需连接宿主机数据库，建议启用host网络
    volumes:
      - ./data:/app/data # 数据挂载到本地，不建议修改
    environment:
      DATABASE_URL: "postgresql://postgres:postgres@localhost:5432/cashbook?schema=public" # 数据库链接，【请修改用户名、密码、地址及端口！】
      NUXT_DATA_PATH: "/app/data" # 数据存储路径，不建议修改
      NUXT_APP_URL: "https://cashbook.oldmoon.top" # 服务根路径，含端口需添加端口号
      NUXT_AUTH_ORIGIN: "https://cashbook.oldmoon.top/api/auth" # 登录授权接口地址 【请自行修改域名/IP！需以 /api/auth 结尾】
      NUXT_AUTH_SECRET: "auth_secret" # 前台登录加密密钥 【请自行修改！】
      NUXT_ADMIN_USERNAME: "admin" # 后台登录用户名
      # 后台登录密码（加密后），生成密码可访问 https://cashbook.oldmoon.top/admin/GetPassword 或部署后访问 `你的url/admin/GetPassword` 【请自行修改！】
      NUXT_ADMIN_PASSWORD: "fb35e9343a1c095ce1c1d1eb6973dc570953159441c3ee315ecfefb6ed05f4cc"
```

### 核心环境变量配置说明

| 环境变量名               | 说明                                                                 | 配置建议                                   |
|--------------------------|----------------------------------------------------------------------|--------------------------------------------|
| DATABASE_URL             | PostgreSQL数据库连接串，格式：`postgresql://用户名:密码@地址:端口/数据库名?schema=public` | 必须修改，需与实际数据库配置匹配           |
| NUXT_DATA_PATH           | 应用数据存储路径，仅存储小票图片                                     | 建议保持默认，避免数据丢失                 |
| NUXT_APP_URL             | 服务访问根URL，公网部署需填写实际域名或IP（含端口）                   | 必须修改为实际访问地址                     |
| NUXT_AUTH_ORIGIN         | 登录授权接口基础地址，必须以 `/api/auth` 结尾                         | 必须修改为与NUXT_APP_URL匹配的地址         |
| NUXT_AUTH_SECRET         | 前台用户登录会话加密密钥                                             | 强烈建议修改，使用随机字符串提高安全性     |
| NUXT_ADMIN_USERNAME      | 后台管理账号用户名                                                   | 建议修改默认admin，使用自定义用户名        |
| NUXT_ADMIN_PASSWORD      | 后台管理账号加密密码，需通过 `你的url/admin/GetPassword

---
image: nocodb/nocodb
description: "NocoDB是开源的Airtable替代品，提供快速在线构建数据库的解决方案，具备丰富的电子表格界面、多视图类型、工作流自动化及编程访问能力，支持多种数据库后端和部署方式。"
source: https://xuanyuan.cloud/zh/r/nocodb/nocodb
canonical: https://xuanyuan.cloud/zh/r/nocodb/nocodb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nocodb/nocodb" title="nocodb/nocodb Docker 镜像中文简介、标签列表与拉取命令">nocodb/nocodb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# NocoDB - 开源的Airtable替代方案

![NocoDB](https://github.com/user-attachments/assets/555ac729-4822-4efd-b0e6-a9b865ef1850)

## 镜像概述和主要用途

NocoDB是一款开源的在线数据库构建工具，被称为"最快最简单的在线数据库构建方式"，同时也是Airtable的开源替代方案。它允许用户无需编写代码即可创建功能丰富的数据库应用，提供类电子表格的直观界面，支持多种数据视图和工作流自动化，适用于个人、团队及企业级数据管理需求。

**官方资源**  
- [官网](http://www.nocodb.com) • [Discord社区](https://discord.gg/5RgZmkW) • [文档](https://docs.nocodb.com/)

## 核心功能和特性

### 丰富的电子表格界面
- ⚡ 基础操作：创建、读取、更新和删除表格、列和行
- ⚡ 字段操作：排序、筛选、分组、隐藏/显示列
- ⚡ 多视图类型：默认网格视图、画廊视图、表单视图、看板视图和日历视图
- ⚡ 视图权限类型：协作视图和锁定视图
- ⚡ 共享功能：公共或私有（带密码保护）的数据库/视图分享
- ⚡ 多样单元格类型：ID、链接、查找、汇总、单行文本、附件、货币、公式、用户等
- ⚡ 细粒度访问控制：不同级别的角色权限管理

### 工作流自动化应用商店
提供三大类集成能力，详情见[应用商店文档](https://docs.nocodb.com/account-settings/oss-specific-details/#app-store)：
- ⚡ 聊天工具：Slack、Discord、Mattermost等
- ⚡ 邮件服务：AWS SES、SMTP、MailerSend等
- ⚡ 存储服务：AWS S3、Google Cloud Storage、Minio等

### 编程访问能力
支持通过以下方式进行程序化操作，可使用JWT或社交认证令牌授权请求：
- ⚡ REST API接口
- ⚡ NocoDB SDK

## 使用场景和适用范围

- **替代商业电子表格工具**：作为Airtable的开源替代方案，降低企业软件成本
- **快速数据库开发**：无需编写代码，通过可视化界面快速构建数据库应用
- **团队协作数据管理**：支持多用户协作，适用于项目管理、内容规划、库存跟踪等场景
- **开源解决方案需求**：适合对数据隐私和自定义部署有严格要求的组织
- **中小企业数据系统**：轻量级部署，支持多种数据库后端，满足灵活扩展需求

## 详细的使用方法和配置说明

### Docker部署方式

#### Docker + SQLite（默认配置）
适合快速测试和单机部署，数据存储在本地文件：

```bash
docker run -d \
  --name noco \
  -v "$(pwd)"/nocodb:/usr/app/data/ \  # 挂载本地目录存储数据
  -p 8080:8080 \                        # 映射端口到主机8080
  nocodb/nocodb:latest
```

#### Docker + PostgreSQL（生产环境推荐）
使用外部PostgreSQL数据库，提高数据可靠性：

```bash
docker run -d \
  --name noco \
  -v "$(pwd)"/nocodb:/usr/app/data/ \  # 持久化存储配置数据
  -p 8080:8080 \                        # 服务端口映射
  -e NC_DB="pg://host.docker.internal:5432?u=root&p=password&d=d1" \  # PostgreSQL连接字符串
  -e NC_AUTH_JWT_SECRET="569a1821-0a93-45e8-87ab-eb857f20a010" \  # JWT密钥，建议自定义
  nocodb/nocodb:latest
```

**环境变量说明**：
- `NC_DB`：指定后端数据库连接字符串，支持PostgreSQL、MySQL、SQL Server等
- `NC_AUTH_JWT_SECRET`：用于JWT认证的密钥，生产环境必须自定义并保密

### Nix部署

#### 快速运行
```bash
nix run github:nocodb/nocodb
```

#### NixOS模块配置
在flake.nix中集成NocoDB模块：

```nix
{
  description = "NixOS配置示例";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nocodb.url = "github:nocodb/nocodb";
  };

  outputs = inputs@{ nixpkgs, nocodb, ... }: {
    nixosConfigurations = {
      hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          nocodb.nixosModules.nocodb

          {
            services.nocodb.enable = true;  # 启用NocoDB服务
          }
        ];
      };
    };
  };
}
```

### 自动部署脚本（生产环境推荐）
Auto-upstall是单命令生产环境部署工具，自动生成docker-compose配置：

```bash
bash <(curl -sSL http://install.nocodb.com/noco.sh) <(mktemp)
```

**脚本功能**：
- 自动安装依赖（Docker、Docker Compose）
- 部署NocoDB及配套服务（PostgreSQL、Redis、Minio、Traefik网关）
- 支持版本自动更新
- 自动配置SSL证书并续期（需提供域名）

### 其他安装方式（本地测试用）

| 安装方式                | 命令                                                                 |
|-------------------------|----------------------------------------------------------------------|
| 🍏 MacOS arm64（二进制） | `curl http://get.nocodb.com/macos-arm64 -o nocodb -L && chmod +x nocodb && ./nocodb` |
| 🍏 MacOS x64（二进制）   | `curl http://get.nocodb.com/macos-x64 -o nocodb -L && chmod +x nocodb && ./nocodb` |
| 🐧 Linux arm64（二进制） | `curl http://get.nocodb.com/linux-arm64 -o nocodb -L && chmod +x nocodb && ./nocodb` |
| 🐧 Linux x64（二进制）   | `curl http://get.nocodb.com/linux-x64 -o nocodb -L && chmod +x nocodb && ./nocodb` |
| 🪟 Windows arm64（二进制）| `iwr http://get.nocodb.com/win-arm64.exe -OutFile Noco-win-arm64.exe && .\Noco-win-arm64.exe` |
| 🪟 Windows x64（二进制）  | `iwr http://get.nocodb.com/win-x64.exe -OutFile Noco-win-x64.exe && .\Noco-win-x64.exe` |

> 本地访问地址：[http://localhost:8080/dashboard](http://localhost:8080/dashboard)

## 界面截图

![界面截图1](https://github.com/nocodb/nocodb/assets/86527202/a127c05e-2121-4af2-a342-128e0e2d0291)
![界面截图2](https://github.com/nocodb/nocodb/assets/86527202/674da952-8a06-4848-a0e8-a7b02d5f5c88)
![界面截图3](https://github.com/nocodb/nocodb/assets/86527202/cbc5152a-9caf-4f77-a8f7-92a9d06d025b)
（更多截图请参见官方仓库）

## 贡献和社区

欢迎通过[贡献指南](https://github.com/nocodb/nocodb/blob/master/.github/CONTRIBUTING.md)参与开发。社区贡献者名单：

<a href="https://github.com/nocodb/nocodb/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=nocodb/nocodb" />
</a>

## 许可证

本项目采用[AGPLv3许可证](https://github.com/nocodb/nocodb/blob/master/LICENSE)。

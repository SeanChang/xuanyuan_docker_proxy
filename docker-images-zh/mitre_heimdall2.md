---
image: mitre/heimdall2
description: "Heimdall用于查看、存储和比较各类自动化安全控制扫描结果。"
source: https://xuanyuan.cloud/zh/r/mitre/heimdall2
canonical: https://xuanyuan.cloud/zh/r/mitre/heimdall2
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mitre/heimdall2" title="mitre/heimdall2 Docker 镜像中文简介、标签列表与拉取命令">mitre/heimdall2 — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mitre/heimdall2" title="mitre/heimdall2 Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mitre/heimdall2</a>

# Heimdall Enterprise Server 2.0

![Run E2E Backend + Frontend Tests](https://github.com/mitre/heimdall2/workflows/Run%20E2E%20Backend%20+%20Frontend%20Tests/badge.svg) ![Run Frontend Tests](https://github.com/mitre/heimdall2/workflows/Run%20Frontend%20Tests/badge.svg) ![Run Backend Tests](https://github.com/mitre/heimdall2/workflows/Run%20Backend%20Tests/badge.svg)

## 镜像概述和主要用途

Heimdall是MITRE开发的安全控制扫描结果查看器，允许用户查看、存储和比较各种自动化安全控制扫描结果。本仓库包含Heimdall 2后端和前端(Heimdall-Lite)的源代码。

Heimdall提供两种版本：完整版Heimdall Enterprise Server和轻量级Heimdall-Lite版本。两者共享相同的前端界面，但针对不同的需求和使用场景设计。

## 核心功能和特性

### Heimdall与Heimdall-Lite对比

| 功能 | [Heimdall-Lite](https://github.com/mitre/heimdall-lite/) | [Heimdall](https://github.com/mitre/heimdall/) |
| :----------------------------------------------------------- | :------------------------------------------------------: | :----------------------------------------------------------: |
| 安装要求 | 任何Web服务器 | PostgreSQL服务器 |
| 概览仪表板和计数 | ✓ | ✓ |
| 800-53分区和TreeMap视图 | ✓ | ✓ |
| 数据表格/控制摘要 | ✓ | ✓ |
| InSpec代码/控制查看器 | ✓ | ✓ |
| SSP内容生成器 | | ✓ |
| 用户和角色及多团队支持 | | ✓ |
| 认证和授权 | 托管Web服务器 | 托管Web服务器<br>LDAP<br>OAuth支持:<br>GitHub, GitLab, Google和Okta |
| 高级数据/过滤器报告和查看 | | ✓ |
| 多种报告输出<br/>(DISA检查表XML, CAT, XCCDF-Results等) | | ✓ |
| 认证REST API | | ✓ |
| InSpec运行"Delta"视图 | | ✓ |
| 多报告标记、过滤和Delta视图 | | ✓ |

## 使用场景和适用范围

### Heimdall-Lite适用场景

- 通过简单电子邮件发送应用程序和数据
- 最小的资源占用和部署时间
- 本地或离线使用
- 一次性快速审查
- 分散式部署
- 最小化的授权时间

### Heimdall Server适用场景

- 多团队支持
- 时间线和报告历史
- 集中式部署模型
- 需要查看一个或多个运行之间的差异
- 需要查看800-53控制对齐的子集
- 需要生成多种格式的复杂报告

## 详细的使用方法和配置说明

### 演示版本

#### 视频演示

![](https://github.com/mitre/docs-mitre-inspec/raw/master/images/Heimdall_demo.gif)

#### 托管演示

> **注意：这些演示仅用于展示Heimdall的功能，请不要上传任何敏感数据。**

##### 已发布预览版

[Heimdall Lite](https://heimdall-lite.mitre.org) | [Heimdall Server](https://heimdall-demo.mitre.org/)

##### 当前"开发主分支"预览版

[Heimdall Lite](https://heimdall-lite.netlify.com/) | [Heimdall Server](https://mitre-heimdall-staging.herokuapp.com/)

### Heimdall Lite安装

Heimdall Lite发布在npmjs.org上，可通过以下方式获取和运行：

#### 通过npm运行

要在本地运行Heimdall Lite，只需使用`npm`内置工具`npx`：

```bash
npx @mitre/heimdall-lite
```

如果经常使用此工具并希望本地安装，请使用以下命令：

```bash
npm install -g @mitre/heimdall-lite
```

之后，任何后续的`npx @mitre/heimdall-lite`命令都将使用本地版本并更快加载。

#### 通过Docker运行

也可以使用Docker运行heimdall-lite：

```bash
docker run -d -p 8080:80 mitre/heimdall-lite:release-latest
```

然后可以通过[http://localhost:8080](http://localhost:8080)访问heimdall-lite。

如果希望运行最新开发版本的heimdall-lite，请将`mitre/heimdall-lite:release-latest`替换为`mitre/heimdall-lite:latest`。

### Heimdall Server - Docker部署

由于Heimdall至少需要数据库服务，我们使用Docker和Docker Compose提供简单的部署体验。

#### 设置Docker容器(全新安装)

1. 安装Docker

2. 从[发布页面](https://github.com/mitre/heimdall2/releases)下载并提取最新的Heimdall发布版。

3. 导航到`docker-compose.yml`所在的基本文件夹

4. 默认情况下，Heimdall将生成有效期为7天的自签名证书。将证书文件放在`./nginx/certs/`中，名称分别为`ssl_certificate.crt`和`ssl_certificate_key.key`。

5. 在Heimdall源目录的终端窗口中运行以下命令：

   ```bash
   ./setup-docker-secrets.sh
   # 如果想进一步配置Heimdall实例，请编辑运行上一行后生成的.env文件
   docker-compose up -d
   ```

6. 导航到[http://127.0.0.1:3000](http://127.0.0.1:3000)。

#### 运行Docker容器

确保已至少运行过一次设置步骤！

1. 在终端窗口中运行以下命令：
   ```bash
   docker-compose up -d
   ```

2. 在Web浏览器中访问[http://127.0.0.1:3000](http://127.0.0.1:3000)。

#### 更新Docker容器

> **从2.5.0版本开始，Docker上的Heimdall默认使用SSL。将证书文件放在`./nginx/certs/`中，名称分别为`ssl_certificate.crt`和`ssl_certificate_key.key`。**

可以通过运行以下命令获取新版本的docker容器：

```bash
docker-compose pull
docker-compose up -d
```

这将获取最新版本的容器，如果有新版本则重新部署，然后应用任何数据库迁移(如适用)。此操作不应丢失任何数据。

#### 停止容器

从启动时的源目录运行：

```bash
docker-compose down
```

### 在Cloud.gov上运行

Cloud.gov是一个[FEDRAMP中等平台即服务(PaaS)](https://marketplace.fedramp.gov/#!/product/18f-cloudgov?sort=productName)。此仓库包含一个示例[manifest.yml.example](manifest.yml.example)文件，可直接推送并运行最新版本的Heimdall2容器。复制示例文件并适当更新键值：

```bash
cp manifest.yml.example manifest.yml
```

1. 设置cloud.gov账户 - https://cloud.gov/docs/getting-started/accounts/

2. 安装cf-cli - https://cloud.gov/docs/getting-started/setup/

3. 在Heimdall源目录的终端窗口中运行以下命令：
   ```bash
   cd ~/Documents/Github/Heimdall2
   cf login -a api.fr.cloud.gov --sso
   # 出现提示时，按照链接复制临时认证码
   ```

4. 设置演示应用空间
   ```bash
   cf target -o sandbox-rename create-space heimdall2-rename
   ```

5. 创建postgresql数据库
   ```bash
   # 更新manifest.yml文件以重命名应用程序和数据库键名
   cf marketplace
   cf create-service aws-rds medium-psql heimdall2-rename
   cf create-service-key heimdall2-db-rename heimdall2-db-test-key
   cf push
   ```

**将返回新测试实例的URL，可通过该URL访问。**

> 注意：这仅用于演示目的，要运行生产级别的联邦/FISMA系统，您需要联系[cloud.gov程序](https://cloud.gov)并咨询组织的安全团队(进行风险评估和授权操作)。

## API使用

API使用仅在使用Heimdall Enterprise Server(又名"服务器模式")时有效。

目前尚无完善的API文档。同时，以下是向Heimdall Server上传评估的快速说明：

```bash
# 创建用户(只需执行一次)
curl -X POST -H "Content-Type: application/json" -d '{"email": "user@example.com", "password": "password", "passwordConfirmation": "password", "role": "user", "creationMethod": "local" }' http://localhost:3000/users

# 登录
curl -X POST -H "Content-Type: application/json" -d '{"email": "user@example.com", "password": "password" }' http://localhost:3000/authn/login

# 上一个命令返回需要放在以下命令中的Bearer Token
# 上传评估
curl -F "data=@Evaluation.json" -F "filename=Your Filename" -F "public=true/false" -H "Authorization: Bearer bearertokengoeshere" "http://localhost:3000/evaluations"
```

## 环境变量配置

Heimdall使用.env文件进行环境变量配置。有关.env文件的更多信息，请访问[环境变量配置](https://github.com/mitre/heimdall2/wiki/Environment-Variables-Configuration)。

## 开发者指南

### 安装方法

如果您想根据需要修改Heimdall，Heimdall有"开发模式"，如果您对代码进行更改，应用程序将自动重建并使用这些更改。请注意，在部署Heimdall供一般使用时，不应运行开发模式。要在基于Debian的发行版上开始，请按照以下步骤操作：

1. 安装系统依赖：

   ```bash
   sudo apt install postgresql nodejs nano git
   sudo npm install -g yarn
   ```

2. 克隆此仓库：

   ```bash
   git clone https://github.com/mitre/heimdall2
   ```

3. 创建Postgres角色：

   ```sql
   # 启动Postgres终端
   psql postgres

   # 创建用户
   CREATE USER <username> with encrypted password '<password>';
   ALTER USER <username> CREATEDB;
   \q
   ```

4. 安装项目依赖：

   ```bash
   cd heimdall2
   yarn install
   ```

5. 编辑.env文件并创建数据库：

   ```bash
   nano apps/backend/.env-example
   # 用您的值替换注释，如果需要默认值，可以删除该行。
   mv apps/backend/.env-example apps/backend/.env
   yarn backend sequelize-cli db:create
   yarn backend sequelize-cli db:migrate
   yarn backend sequelize-cli db:seed:all
   ```

6. 启动Heimdall：

   ```bash
   yarn start:dev
   ```

这将以开发模式启动前端和后端，意味着对源代码的任何更改都将立即生效。请注意，我们已经提供了Visual Studio Code工作区文件，您可以使用它来组织您的工作区。

### 调试Heimdall Server

如果使用Visual Studio Code，可以非常简单地在本地调试此应用程序。首先打开Visual Studio Code工作区，并确保启用了Visual Studio Code中的[Node调试器自动附加](https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_auto-attach)功能。接下来，打开集成的Visual Studio Code终端并运行：

```bash
yarn backend start:debug
```

Visual Studio Code将自动附加调试器，并在您在应用程序中放置的任何断点处停止。

### 独立开发Heimdall Lite

如果只想对前端(heimdall-lite)进行更改，请使用以下命令：

```bash
yarn frontend start:dev
```

### 代码检查和修复

要验证和检查代码，请运行：

```bash
yarn run lint
```

### 编译和压缩生产环境的前端和后端

```bash
yarn build
```

### 运行测试

测试代码以确保一切正常：

```bash
# 运行前端Vue测试
yarn frontend test
# 运行后端Nest测试
yarn backend test:ci-cov
```

#### 运行Cypress端到端测试

应用程序包含端到端前端+后端测试(使用[cypress.io](https://www.cypress.io/)框架构建)。这些测试自动检查Heimdall Server是否按预期运行。要运行这些测试，需要运行应用程序实例。

```bash
CYPRESS_TESTING=true yarn start:dev
CYPRESS_BASE_URL=http://localhost:8080 yarn test:ui:open
```

第一个命令将启动Heimdall Server实例，并公开允许测试运行所需的其他路由。第二个命令将打开Cypress UI，每当代码更改时将运行测试。

### 创建发布版本

**注意：此操作需要对仓库具有适当的权限才能执行。**

1. 确保已将最新代码复制到本地计算机上。
2. 使用`lerna version`，运行`lerna version <显式版本>`，或者使用适当的lerna关键字之一：`'major', 'minor', 'patch', 'premajor', 'preminor', 'prepatch', 或 'prerelease'`来更新版本。这将向Github推送新标签。
3. 导航到Github上的"Releases"，编辑"Release Drafter"为您创建的发布说明，并将它们分配给您刚刚推送的标签。

## 版本控制和开发状态

本项目使用[语义化版本控制策略](https://semver.org/)

## 贡献、问题和支持

### 贡献

欢迎查看我们的问题，创建分支并提交PR和改进。我们很乐意听取最终用户和社区的意见，并很高兴就建议、更新、修复或新功能与您交流。

### 问题和支持

如有任何建议、问题或问题，请随时通过在问题板上**打开一个issue**或发送电子邮件至[inspec@mitre.org](mailto:inspec@mitre.org)与我们联系。如果您对我们软件的使用有更多一般性问题或其他疑虑，请通过[opensource@mitre.org](mailto:opensource@mitre.org)与我们联系。

## NOTICE

© 2019-2021 The MITRE Corporation.

批准公开发布；分发不受限制。案例编号18-3678。

MITRE特此授予根据本项目包含的LICENSE.md文件中提供的许可条款使用、复制、分发、修改和以其他方式利用本软件的明确书面许可。

本软件是为美国政府根据合同编号HHSM-500-2012-00008I生产的，受联邦采购条例第52.227-14条"数据通用权利"的约束。

除授予美国政府的权利外，或根据该条款代表美国政府行事的人员，未经The MITRE Corporation的明确书面许可，不得进行其他使用。

如需更多信息，请联系The MITRE Corporation，合同管理办公室，7515 Colshire Drive, McLean, VA 22102-7539，(703) 983-6000。

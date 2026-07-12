---
image: radarbase/management-portal
description: "RADAR平台的管理门户应用"
source: https://xuanyuan.cloud/zh/r/radarbase/management-portal
canonical: https://xuanyuan.cloud/zh/r/radarbase/management-portal
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/radarbase/management-portal" title="radarbase/management-portal Docker 镜像中文简介、标签列表与拉取命令">radarbase/management-portal 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ManagementPortal 镜像文档

## 镜像概述和主要用途

ManagementPortal 是一个用于管理 [RADAR-base](http://www.radar-base.org/) 试点研究的应用程序。它提供了一个集中式平台，用于管理研究项目、参与者、数据收集和相关配置，是RADAR-base生态系统的重要组成部分。

## 核心功能和特性

- 试点研究全生命周期管理
- 用户和角色权限控制
- OAuth2认证与授权集成
- 研究参与者管理
- 数据收集配置
- 多环境支持（开发、生产）
- 可定制的用户界面
- 与RADAR-base生态系统其他组件无缝集成

## 使用场景和适用范围

ManagementPortal 主要适用于以下场景：
- 学术研究机构管理其RADAR-base试点项目
- 医疗健康领域的远程患者监测研究
- 需要集中管理多源数据收集的研究项目
- 希望标准化研究流程和数据管理的团队

## 详细使用方法和配置说明

### 快速入门

#### 使用Docker-Compose

使用Docker-Compose是在生产模式下快速启动ManagementPortal的推荐方式：

1. 确保系统已安装[Docker][]和[Docker-Compose][]
2. 生成用于签名JWT令牌的密钥对：
   ```shell
   keytool -genkeypair -alias radarbase-managementportal-ec -keyalg EC -validity 3650 -keysize 256 -sigalg SHA256withECDSA -storetype PKCS12 -keystore src/main/docker/etc/config/keystore.p12 -storepass radarbase -keypass radarbase
   ```
3. 使用以下命令启动服务栈：
   ```shell
   docker-compose -f src/main/docker/management-portal.yml up -d
   ```

这将启动Postgres数据库和ManagementPortal应用。默认管理员账户`admin`的密码为`admin`。

#### 从源码构建

要从源码构建，需在机器上安装并配置以下依赖：

1. [Node.js][]：用于运行开发Web服务器和构建项目
2. [Yarn][]：用于管理Node依赖

构建步骤：

1. 生成JWT签名密钥对：
   ```shell
   keytool -genkeypair -alias radarbase-managementportal-ec -keyalg EC -validity 3650 -keysize 256 -sigalg SHA256withECDSA -storetype PKCS12 -keystore src/main/resources/config/keystore.p12 -storepass radarbase -keypass radarbase
   ```
   
   > **注意：** 确保密钥密码和存储密码相同！这是Spring Security的要求。

2. 使用以下命令运行ManagementPortal：
   ```shell
   # 生产模式
   ./gradlew bootRun -Pprod
   
   # 开发模式
   ./gradlew bootRun -Pdev
   ```

3. 使用`admin:admin`登录应用。生产环境中请务必更改管理员密码。

开发和生产环境差异：

| 特性 | 开发环境 | 生产环境 |
|------|----------|----------|
| 数据库类型 | 内存数据库 | Postgres |
| 加载演示数据 | 是 | 否 |
| 应用上下文路径 | `/` | `/managementportal` |

可以通过以下命令拉取Docker镜像：
```shell
docker pull docker.xuanyuan.run/radarbase/management-portal
```

### 配置

ManagementPortal提供了一组默认配置值。您可以在构建应用前修改`application.yml`和`application-prod.yml`（或开发环境的`application-dev.yml`），或使用环境变量覆盖默认值。

#### 环境变量

以下是部署时最可能需要修改的环境变量列表。完整配置可在[application.yml](src/main/resources/config/application.yml)和[application-prod.yml](src/main/resources/config/application-prod.yml)文件中找到。

| 变量 | 默认值 | 描述 |
|------|--------|------|
| `SPRING_DATASOURCE_URL` | `jdbc:postgresql://localhost:5432/managementportal` | 数据库连接URL |
| `SPRING_DATASOURCE_USERNAME` | `<username>` | 数据库访问用户名 |
| `SPRING_DATASOURCE_PASSWORD` | `<password>` | 数据库访问密码 |
| `SPRING_APPLICATION_JSON` | None | 用于覆盖所有类型应用设置的通用环境变量 |
| `MANAGEMENTPORTAL_MAIL_FROM` | None（必须覆盖） | 电子邮件发件人地址 |
| `MANAGEMENTPORTAL_FRONTEND_CLIENT_SECRET` | None（必须覆盖） | 前端OAuth客户端密钥 |
| `MANAGEMENTPORTAL_FRONTEND_ACCESS_TOKEN_VALIDITY_SECONDS` | `14400` | 前端访问令牌有效期（秒） |
| `MANAGEMENTPORTAL_FRONTEND_REFRESH_TOKEN_VALIDITY_SECONDS` | `259200` | 前端刷新令牌有效期（秒） |
| `MANAGEMENTPORTAL_OAUTH_CLIENTS_FILE` | `/mp-includes/config/oauth_client_details.csv` | OAuth客户端文件位置 |
| `MANAGEMENTPORTAL_OAUTH_KEY_STORE_PASSWORD` | `radarbase` | JWT密钥库密码 |
| `MANAGEMENTPORTAL_OAUTH_SIGNING_KEY_ALIAS` | `radarbase-managementportal-ec` | 用于签名的密钥对别名 |
| `MANAGEMENTPORTAL_OAUTH_ENABLE_PUBLIC_KEY_VERIFIERS` | `false` | 是否使用公钥验证器 |
| `MANAGEMENTPORTAL_CATALOGUE_SERVER_ENABLE_AUTO_IMPORT` | `false` | 是否启用从目录服务器自动导入源 |
| `MANAGEMENTPORTAL_CATALOGUE_SERVER_SERVER_URL` | None | 目录服务器URL |
| `MANAGEMENTPORTAL_COMMON_BASE_URL` | None | 托管平台的可解析基础URL |
| `MANAGEMENTPORTAL_COMMON_MANAGEMENT_PORTAL_BASE_URL` | None | 本ManagementPortal实例的可解析基础URL |
| `MANAGEMENTPORTAL_COMMON_PRIVACY_POLICY_URL` | None | 通用隐私政策URL |
| `MANAGEMENTPORTAL_COMMON_ADMIN_PASSWORD` | None | 管理员密码 |
| `MANAGEMENTPORTAL_COMMON_ACTIVATION_KEY_TIMEOUT_IN_SECONDS` | 86400 | 账户激活/重置超时（秒） |
| `RADAR_IS_CONFIG_LOCATION` | 类路径中的`radar-is.yml` | 其他公钥配置文件位置 |
| `JHIPSTER_SLEEP` | `10` | 应用启动等待时间（秒），用于等待数据库就绪 |
| `JAVA_OPTS` | `-Xmx512m` | JVM参数 |

在此Spring版本中，环境变量不能直接编码列表。例如，OAuth检查密钥别名需要使用`SPRING_APPLICATION_JSON`变量进行编码：
```json
{"managementportal":{"oauth":{"checkingKeyAliases":["one","two"]}}}
```
如果未设置此列表，签名密钥也将用作检查密钥。

#### OAuth客户端

ManagementPortal使用OAuth2工作流提供认证和授权。您可以通过UI在运行时添加新的OAuth客户端，或添加到由`MANAGEMENTPORTAL_OAUTH_CLIENTS_FILE`配置选项引用的OAuth客户端文件中。

- 如果客户端需要与"Pair app"功能配合使用，需要在其`additional_information`映射中设置`{"dynamic_registration": true}`。
- 如果客户端启用了`dynamic_registration`，"Pair app"功能生成的QR码将包含一个短期URL。通过对该URL执行GET请求，可以获取`refresh-token`和相关元数据。
- 如果要防止OAuth客户端通过UI被修改，可以在`additional_information`映射中添加`{"protected": true}`。

当通过Pair App对话框配对应用时，扫描的QR码包含一个短期URL，例如：`https://radar-base-url.org/api/meta-token/bMUkowOmTOci`

应用应访问此URL，将收到OAuth2刷新令牌以及平台的基础URL和隐私政策URL。访问此URL不需要授权。**重要提示：** 出于安全原因，此URL中的信息只能访问一次。

应用可以使用以下HTTP请求使用该刷新令牌获取新的访问令牌和刷新令牌，使用OAuth客户端ID作为用户名，空密码进行HTTP基本认证：
```
POST /oauth/token
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token&refresh_token=<refresh_token>
```

响应将至少包含访问令牌和刷新令牌：
```json
{
   "access_token": "...",
   "refresh_token": "...",
   "expires_in": 14400
}
```

两个令牌都仅在有限时间内有效。当访问令牌过期时，需要执行上述类似请求，但必须使用新的`refresh_token`，因为刷新令牌仅一次有效。

#### 授权码流程

OAuth2客户端的授权码流程如下：

1. 注册一个授权类型为`authorization_code`的oauth-client，并为该客户端添加有效的`redirect_uri`（例如`https://my.example.com/oauth_redirect`）
2. 请求用户授权您的应用：
   ```
   GET /oauth/authorize?client_id=MyId&response_type=code&redirect_uri=https://my.example.com/oauth_redirect
   ```
   将`MyId`替换为您的OAuth客户端ID。这需要从交互式Web视图（浏览器或Web窗口）中完成。如果用户批准，将重定向到`https://my.example.com/oauth_redirect?code=abcdef`。在Android中使用[AppAuth库](https://appauth.io)，URL可以是`com.example.my://oauth_redirect`。
   您可以添加可选的`state`参数，它将与`code`一起返回。

3. 通过POST请求获取应用令牌，再次使用OAuth客户端ID作为用户名，空密码进行HTTP基本认证：
   ```
   POST /oauth/token
   Content-Type: application/x-www-form-urlencoded

   grant_type=authorization_code&code=abcdef&redirect_uri=https://my.example.com/oauth_redirect
   ```
   
   响应将包含访问令牌和刷新令牌：
   ```json
   {
      "access_token": "...",
      "refresh_token": "..."
   }
   ```
   
   现在应用可以使用上述刷新令牌流程。

#### UI自定义

您可以通过替换`src/main/webapp/content/images`中的图像来自定义ManagementPortal Web应用：
- `navbar-logo.png`：70x45像素（宽x高）的图像，显示在每个页面的顶部
- `home-page-logo.png`：仅显示在主页上，建议使用350x350像素的图像

构建项目后，您将在`build/www/assets/images`中找到这些图像。

### 生产环境部署

#### 构建生产版本

要优化ManagementPortal应用以用于生产环境，请运行：
```shell
./gradlew -Pprod clean bootWar
```

#### 生产环境托管

最新的Meta-QR码实现要求`api/meta-token/*`上的REST资源必须由上游服务器进行速率限制。

构建完成后，通过以下命令启动应用：
```shell
java -jar build/libs/*.war
```

然后在浏览器中导航至[http://localhost:8080](http://localhost:8080)。

### Docker Compose部署示例

以下是一个完整的Docker Compose配置示例，用于部署ManagementPortal：

```yaml
version: '3.8'

services:
  managementportal:
    image: docker.xuanyuan.run/radarbase/management-portal
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - SPRING_DATASOURCE_URL=jdbc:postgresql://postgresql:5432/managementportal
      - SPRING_DATASOURCE_USERNAME=mpuser
      - SPRING_DATASOURCE_PASSWORD=mppassword
      - MANAGEMENTPORTAL_MAIL_FROM=management@example.com
      - MANAGEMENTPORTAL_FRONTEND_CLIENT_SECRET=your-secret-key-here
      - MANAGEMENTPORTAL_OAUTH_KEY_STORE_PASSWORD=radarbase
      - JHIPSTER_SLEEP=10
      - JAVA_OPTS=-Xmx1024m
    depends_on:
      - postgresql
    restart: unless-stopped

  postgresql:
    image: docker.xuanyuan.run/postgres:13
    environment:
      - POSTGRES_USER=mpuser
      - POSTGRES_PASSWORD=mppassword
      - POSTGRES_DB=managementportal
    volumes:
      - postgres_data:/var/lib/postgresql/data/
    restart: unless-stopped

volumes:
  postgres_data:
```

使用以下命令启动服务：
```shell
docker-compose up -d
```

## 开发指南

### 开发环境设置

在构建项目之前，必须在机器上安装和配置以下依赖项：

1. [Node.js][]：用于运行开发Web服务器和构建项目
2. [Yarn][]：用于管理Node依赖
3. 本地SMTP服务器：提供了一个简单的docker-compose配置用于本地SMTP服务器。从`smtp.env.template`创建`smtp.env`并相应修改`application.yml`。

安装Node后，运行以下命令安装开发工具：
```shell
yarn install
```

我们使用yarn脚本和Webpack作为构建系统。

在两个单独的终端中运行以下命令，以创建愉快的开发体验，当硬盘上的文件更改时，浏览器会自动刷新：
```shell
./gradlew
yarn start
```

然后打开<http://localhost:8080/>启动界面并使用admin/admin登录。

### 依赖管理

例如，要将[Leaflet][]库添加为应用的运行时依赖，运行以下命令：
```shell
yarn add --exact leaflet
```

要在开发中受益于[DefinitelyTyped][]仓库的TypeScript类型定义，运行以下命令：
```shell
yarn add --dev --exact @types/leaflet
```

然后导入库安装说明中指定的JS和CSS文件，以便Webpack知道它们：

编辑[src/main/webapp/app/vendor.ts](src/main/webapp/app/vendor.ts)文件：
```typescript
import 'leaflet/dist/leaflet.js';
```

编辑[src/main/webapp/content/css/vendor.css](src/main/webapp/content/css/vendor.css)文件：
```css
@import '~leaflet/dist/leaflet.css';
```

### 使用angular-cli

您还可以使用[Angular CLI][]生成一些自定义客户端代码。

例如，以下命令：
```shell
ng generate component my-component
```

将生成几个文件：
```
create src/main/webapp/app/my-component/my-component.component.html
create src/main/webapp/app/my-component/my-component.component.ts
update src/main/webapp/app/app.module.ts
```

## 测试

要启动应用程序的测试，请运行：
```shell
./gradlew test
```

### 客户端测试

单元测试由Karma运行，并使用Jasmine编写。它们位于[src/test/javascript/]中，可以通过以下命令运行：
```shell
yarn test
```

UI端到端测试由Protractor提供支持，它构建在WebDriverJS之上。它们位于[src/test/javascript/e2e]中，可以通过在一个终端中启动Spring Boot（`./gradlew bootRun`）并在第二个终端中运行测试（`yarn run e2e`）来执行。

### 其他测试

性能测试由Gatling运行并使用Scala编写。它们位于[src/test/gatling]中，可以通过以下命令运行：
```shell
./gradlew gatlingRunAll
```
或
```shell
./gradlew gatlingRun<SIMULATION_CLASS_NAME>  # 例如 gatlingRunProjectGatlingTest
```

## 使用Docker简化开发（可选）

您可以使用Docker改善JHipster开发体验。[src/main/docker](src/main/docker)文件夹中提供了许多docker-compose配置，用于启动所需的第三方服务。

例如，要在docker容器中启动PostgreSQL数据库，运行：
```shell
docker-compose -f src/main/docker/postgresql.yml up -d
```

要停止并删除容器，运行：
```shell
docker-compose -f src/main/docker/postgresql.yml down
```

您也可以将应用程序及其所有依赖的服务完全docker化。为此，首先通过运行以下命令构建应用程序的docker镜像：
```shell
./gradlew bootWar -Pprod buildDocker
```

然后运行：
```shell
docker-compose -f src/main/docker/app.yml up -d
```

## 文档

访问我们的[Github pages](https://radar-base.github.io/ManagementPortal)网站，找到Javadoc和API文档的链接：
* [management-portal-javadoc](https://radar-base.github.io/ManagementPortal/management-portal-javadoc/)
* [oauth-client-util-javadoc](https://radar-base.github.io/ManagementPortal/oauth-client-util-javadoc/)
* [radar-auth-javadoc](https://radar-base.github.io/ManagementPortal/radar-auth-javadoc/)
* [managementportal-client-javadoc](https://radar-base.github.io/ManagementPortal/managementportal-client-javadoc/)
* [apidoc](https://radar-base.github.io/ManagementPortal/apidoc/swagger.json)

## 客户端库

该项目提供了一个Gradle任务，用于从OpenAPI规范生成客户端库：
```bash
./gradlew generateOpenApiSpec
```

运行此任务时，ManagementPortal需要运行并可通过`http://localhost:8080`访问。

生成的文件可以导入到[Swagger editor]中，或与[Swagger codegen]一起使用以生成客户端库。

[Docker]: https://docs.docker.com/
[Docker-Compose]: https://docs.docker.com/compose/
[Node.js]: https://nodejs.org/
[Yarn]: https://yarnpkg.org/
[Webpack]: https://webpack.github.io/
[Angular CLI]: https://cli.angular.io/
[Karma]: http://karma-runner.github.io/
[

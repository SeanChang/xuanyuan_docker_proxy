---
image: bitnami/node
description: "Bitnami 提供的 Node.js 安全镜像，基于 Photon Linux 构建，具有强化安全特性、最小漏洞、合规支持和供应链安全保障，适用于快速部署安全可靠的 Node.js 应用。"
source: https://xuanyuan.cloud/zh/r/bitnami/node
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[bitnami/node](https://xuanyuan.cloud/zh/r/bitnami/node)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Node.js 镜像

## 什么是 Node.js？

> Node.js 是一个基于 V8 JavaScript 引擎构建的运行时环境。其事件驱动、非阻塞 I/O 模型支持开发快速、可扩展且数据密集型的服务器应用程序。

[Node.js 概述](https://nodejs.org/)
商标声明：本软件列表由 Bitnami 打包。产品中提及的各个商标分别归各自公司所有，使用这些商标并不意味着任何关联或认可。

## 快速使用 (TL;DR)

```console
docker run -it --name node bitnami/node:latest
```

这是由 Bitnami 构建和维护的经过强化的最小 CVE 镜像。Bitnami 安全镜像基于云优化、安全强化的企业级 [Photon Linux 操作系统](https://vmware.github.io/photon/)。选择 BSI 镜像的理由：
- 流行开源软件的强化安全镜像，几乎零漏洞
- 漏洞分类和优先级排序，包含 VEX 声明、KEV 和 EPSS 评分
- 专注合规性，支持 FIPS、STIG 和离线选项，包括安全物料清单 (SBOM)
- 通过 in-toto 实现软件供应链来源证明
- 对互联网上最受欢迎的 Helm 图表提供一流支持

每个镜像都附带有价值的安全元数据。您可以在 [我们的公共目录](https://app-catalog.vmware.com/bitnami/apps) 中查看元数据。注意：某些数据仅对 [BSI 商业订阅](https://bitnami.com/) 用户可用。

如果您正在寻找我们基于 Debian Linux 的上一代镜像，请参阅 Bitnami Legacy 注册表。

## 支持的标签及对应的 `Dockerfile` 链接

了解更多关于 Bitnami 标签政策以及滚动标签和不可变标签之间的区别，请参阅 [我们的文档页面](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

您可以通过查看分支文件夹中的 `tags-info.yaml` 文件（即 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）来了解不同标签之间的对应关系。

通过关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers) 订阅项目更新。

## 获取此镜像

获取 Bitnami Node.js Docker 镜像的推荐方式是从 [Docker Hub 注册表](https://hub.docker.com/r/bitnami/node) 拉取预构建镜像。

```console
docker pull bitnami/node:latest
```

要使用特定版本，您可以拉取带版本的标签。您可以在 Docker Hub 注册表中查看 [可用版本列表](https://hub.docker.com/r/bitnami/node/tags/)。

```console
docker pull bitnami/node:[TAG]
```

如果需要，您也可以通过克隆仓库、切换到包含 Dockerfile 的目录并执行 `docker build` 命令来自行构建镜像。请记住将下面示例命令中的 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 路径占位符替换为正确的值。

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## 进入 REPL

默认情况下，运行此镜像会将您带入 Node.js REPL，您可以在其中交互式地测试和尝试 Node.js 功能。

```console
docker run -it --name node bitnami/node
```

**延伸阅读：**

- [nodejs.org/api/repl.html](https://nodejs.org/api/repl.html)

## 配置

### 运行 Node.js 脚本

Node.js 镜像的默认工作目录是 `/app`。您可以将主机上包含 Node.js 脚本的文件夹挂载到此目录，并使用 `node` 命令正常运行它。

```console
docker run -it --name node -v /path/to/app:/app bitnami/node \
  node script.js
```

### 使用 npm 依赖运行 Node.js 应用

如果您的 Node.js 应用有定义应用依赖和启动脚本的 `package.json`，您可以在运行应用之前安装依赖。

```console
docker run --rm -v /path/to/app:/app bitnami/node npm install
docker run -it --name node  -v /path/to/app:/app bitnami/node npm start
```

或者通过修改此仓库中提供的 [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/node/docker-compose.yml) 文件：

```yaml
node:
  ...
  command: "sh -c 'npm install && npm start'"
  volumes:
    - .:/app
  ...
```

**延伸阅读：**

- [package.json 文档](https://docs.npmjs.com/files/package.json)
- [npm start 脚本](https://docs.npmjs.com/misc/scripts#default-values)

### Bitnami 安全镜像中的 FIPS 配置

[Bitnami 安全镜像](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) 目录中的 Bitnami Node.js Docker 镜像包含额外功能和设置，可配置容器的 FIPS 功能。您可以配置以下环境变量：

- `OPENSSL_FIPS`：OpenSSL 是否以 FIPS 模式运行。`yes`（默认）、`no`。

## 使用私有 npm 模块

要使用 npm 私有模块，必须登录 npm。npm CLI 使用 *auth tokens* 进行身份验证。有关如何获取令牌的更多信息，请查看官方 [npm 文档](https://www.npmjs.com/package/get-npm-token)。

如果您在 Docker 环境中工作，可以通过以下方式在构建时将令牌注入 Dockerfile 中：

- 在项目中创建一个 `npmrc` 文件。它包含 `npm` 命令对 npmjs.org 注册表进行身份验证的指令。`NPM_TOKEN` 将在构建时获取。文件内容应如下所示：

```console
//registry.npmjs.org/:_authToken=${NPM_TOKEN}
```

- 在 Dockerfile 中添加一些新行，以复制 `npmrc` 文件，使用 ARG 参数添加预期的 `NPM_TOKEN`，并在 npm install 完成后删除 `npmrc` 文件。

以下是 Dockerfile 示例：

```dockerfile
FROM bitnami/node

ARG NPM_TOKEN
COPY npmrc /root/.npmrc

COPY . /app

WORKDIR /app
RUN npm install

CMD node app.js
```

- 现在您可以使用上述 Dockerfile 和令牌构建镜像。运行 `docker build` 命令如下：

```console
docker build --build-arg NPM_TOKEN=${NPM_TOKEN} .
```

**注意：** 末尾的 "." 表示 `docker build` 使用当前目录作为参数。

恭喜！您现在已登录到 npm 仓库。

### 延伸阅读

- [npm 官方文档](https://docs.npmjs.com/private-modules/docker-and-private-modules)。

## 访问运行 Web 服务器的 Node.js 应用

默认情况下，镜像暴露容器的 `3000` 端口。您可以将此端口用于 Node.js 应用服务器。

以下是 [express.js](http://expressjs.com/) 应用的示例，它在 `3000` 端口上监听远程连接：

```javascript
var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Hello World!');
});

var server = app.listen(3000, '0.0.0.0', function () {

  var host = server.address().address;
  var port = server.address().port;

  console.log('Example app listening at http://%s:%s', host, port);
});
```

要从主机访问 Web 服务器，您可以让 Docker 将主机上的随机端口映射到容器内的 `3000` 端口。

```console
docker run -it --name node -v /path/to/app:/app -P bitnami/node node index.js
```

运行 `docker port` 以确定 Docker 分配的随机端口。

```console
$ docker port node
3000/tcp -> 0.0.0.0:32769
```

您也可以指定要从主机转发到容器的端口。

```console
docker run -it --name node -p 8080:3000 -v /path/to/app:/app bitnami/node node index.js
```

通过在浏览器中导航到 `http://localhost:8080` 访问 Web 服务器。

## 连接到其他容器

如果要在另一个容器内连接到 Node.js Web 服务器，可以使用 Docker 网络创建网络并将所有容器附加到该网络。

### 通过 nginx 前端提供 Node.js 应用服务

我们可能希望仅通过 nginx Web 服务器访问 Node.js Web 服务器。这样做可以设置更复杂的配置，使用 nginx 提供静态资源，负载均衡到不同的 Node.js 实例等。

#### 步骤 1：创建网络

```console
docker network create app-tier --driver bridge
```

#### 步骤 2：创建虚拟主机

让我们创建一个 nginx 虚拟主机来反向代理到 Node.js 容器。

```nginx
server {
    listen 0.0.0.0:80;
    server_name yourapp.com;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header HOST $http_host;
        proxy_set_header X-NginX-Proxy true;

        # proxy_pass http://[your_node_container_link_alias]:3000;
        proxy_pass http://myapp:3000;
        proxy_redirect off;
    }
}
```

注意我们已替换为链接别名 `myapp`，我们将在创建容器时使用相同的名称。

复制上面的虚拟主机配置，将文件保存在主机上的某个位置。我们将把它作为卷挂载到 nginx 容器中。

#### 步骤 3：使用特定名称运行 Node.js 镜像

```console
docker run -it --name myapp --network app-tier \
  -v /path/to/app:/app \
  bitnami/node node index.js
```

#### 步骤 4：运行 nginx 镜像

```console
docker run -it \
  -v /path/to/vhost.conf:/bitnami/nginx/conf/vhosts/yourapp.conf:ro \
  --network app-tier \
  bitnami/nginx
```

## 维护

### 升级此镜像

Bitnami 会在 Node.js 上游版本发布后尽快提供更新版本，包括安全补丁。我们建议您按照以下步骤升级容器。

#### 步骤 1：获取更新的镜像

```console
docker pull bitnami/node:latest
```

#### 步骤 2：删除当前运行的容器

```console
docker rm -v node
```

#### 步骤 3：运行新镜像

从新镜像重新创建容器。

```console
docker run --name node bitnami/node:latest
```

## 重要变更

### 自 2024 年 1 月 16 日起

- `docker-compose.yaml` 文件已被移除，因为它仅用于内部测试目的。

### 6.2.0-r0 (2016-05-11)

- 命令现在以 `root` 用户执行。使用 `--user` 参数切换到其他用户，或使用 `sudo` 更改为所需用户以启动应用程序。此外，从 Docker 1.10 开始，docker 守护进程支持用户命名空间。有关更多详细信息，请参阅 [守护进程用户命名空间选项](https://docs.docker.com/engine/security/userns-remap/)。

### 4.1.2-0 (2015-10-12)

- 修复了权限问题，使 `bitnami` 用户可以安装全局 npm 模块而无需 `sudo`。

### 4.1.1-0-r01 (2015-10-07)

- `/app` 目录不再作为卷导出。这在基于镜像构建时会导致问题，因为卷中的更改不会在 Dockerfile `RUN` 指令之间保留。要保持以前的行为（以便您可以在另一个容器中挂载卷），请使用 `-v /app` 选项创建容器。

## 贡献

我们欢迎您为此 Docker 镜像做出贡献。您可以通过创建 [issue](https://github.com/bitnami/containers/issues) 请求新功能，或提交 [pull request](https://github.com/bitnami/containers/pulls) 贡献代码。

## 问题反馈

如果您在运行此容器时遇到问题，可以提交 [issue](https://github.com/bitnami/containers/issues/new/choose)。为了让我们提供更好的支持，请务必填写 issue 模板。

## 许可证

版权所有 &copy; 2025 Broadcom。术语“Broadcom”指 Broadcom Inc. 和/或其子公司。

根据 Apache 许可证 2.0 版（“许可证”）授权；除非遵守许可证，否则您不得使用此文件。您可以在以下位置获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则根据许可证分发的软件按“原样”分发，不附带任何明示或暗示的担保或条件。有关许可证下权限和限制的具体语言，请参阅许可证。

---
image: datadog/synthetics-private-location-worker
description: "用于合成监控私有位置工作器的Docker容器"
source: https://xuanyuan.cloud/zh/r/datadog/synthetics-private-location-worker
canonical: https://xuanyuan.cloud/zh/r/datadog/synthetics-private-location-worker
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/datadog/synthetics-private-location-worker" title="datadog/synthetics-private-location-worker Docker 镜像中文简介、标签列表与拉取命令">datadog/synthetics-private-location-worker 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Synthetics Private Location Worker Docker镜像

## 镜像概述和主要用途

Synthetics Private Location Worker Docker镜像是用于部署Datadog Synthetics私有位置工作器的容器化解决方案。该镜像允许用户在自己的网络环境中运行Datadog Synthetics监控检查，实现对内部资源和私有服务的监控能力。

## 支持的架构

- `amd64`

## 核心功能和特性

- 在私有网络环境中执行Datadog Synthetics监控检查
- 支持多种监控类型，包括API测试、浏览器测试和合成监控
- 与Datadog平台无缝集成，提供统一的监控体验
- 简化私有位置的部署和管理流程
- 内置多种云服务和第三方工具集成能力

## 使用场景和适用范围

- 监控无法从公共互联网访问的内部应用和服务
- 满足严格的网络安全和数据隐私要求
- 在隔离环境中执行合成监控检查
- 实现对私有云资源和本地数据中心的监控
- 需要模拟用户地理位置进行性能测试的场景

## 使用方法和配置说明

### 前提条件

- Docker引擎已安装并运行
- 有效的Datadog账户和访问凭证
- 已在Datadog控制台中创建私有位置

### 基本使用方法

#### Docker Run 命令

```bash
docker run -d \
  --name datadog-synthetics-worker \
  -e DD_API_KEY=<YOUR_DATADOG_API_KEY> \
  -e DD_SITE=<YOUR_DATADOG_SITE> \
  -e DD_PRIVATE_LOCATION_KEY=<YOUR_PRIVATE_LOCATION_KEY> \
  docker.xuanyuan.run/datadog/synthetics-private-location-worker
```

#### Docker Compose 配置

```yaml
version: '3'
services:
  synthetics-worker:
    image: docker.xuanyuan.run/datadog/synthetics-private-location-worker
    container_name: datadog-synthetics-worker
    environment:
      - DD_API_KEY=<YOUR_DATADOG_API_KEY>
      - DD_SITE=<YOUR_DATADOG_SITE>
      - DD_PRIVATE_LOCATION_KEY=<YOUR_PRIVATE_LOCATION_KEY>
      - DD_REGION=<YOUR_REGION>
    restart: always
    network_mode: bridge
```

### 环境变量配置

| 环境变量 | 描述 | 必需 |
|---------|------|------|
| `DD_API_KEY` | 您的Datadog API密钥 | 是 |
| `DD_SITE` | Datadog站点（例如：`datadoghq.com`、`datadoghq.eu`） | 是 |
| `DD_PRIVATE_LOCATION_KEY` | 私有位置的唯一标识符 | 是 |
| `DD_REGION` | 工作器运行的区域 | 否 |
| `DD_PROXY_HTTP` | HTTP代理服务器地址 | 否 |
| `DD_PROXY_HTTPS` | HTTPS代理服务器地址 | 否 |
| `DD_LOG_LEVEL` | 日志级别（DEBUG, INFO, WARN, ERROR） | 否 |
| `DD_WORKER_TAGS` | 工作器标签，用于分类和过滤 | 否 |

## 支持和文档

### 官方文档

有关设置私有位置的详细说明，请参阅[Datadog官方文档](https://docs.datadoghq.com/synthetics/private_locations)。

### 获取支持

如遇问题或需要故障排除帮助，请[联系Datadog支持团队](https://www.datadoghq.com/support/)。

## 许可证

本软件的使用和操作受[最终用户许可协议](https://www.datadoghq.com/legal/eula/)约束。

与所有Docker镜像一样，此镜像可能还包含其他软件，这些软件可能受其他许可证约束（例如基础发行版中的Bash等，以及包含的主要软件的任何直接或间接依赖项）。

对于任何预构建镜像的使用，镜像用户有责任确保对本镜像的任何使用符合其中包含的所有软件的相关许可证。

本代码包含第三方分发的软件。这些库及其许可证列表如下：

| 组件 | 来源 | 许可证 | 代码库 |
|:----------|:-------|:--------|:-----|
|@aws-sdk/client-device-farm|import|Apache-2.0|github.com/aws/aws-sdk-js-v3|
|@aws-sdk/client-s3|import|Apache-2.0|github.com/aws/aws-sdk-js-v3|
|@aws-sdk/client-sqs|import|Apache-2.0|github.com/aws/aws-sdk-js-v3|
|@aws-sdk/client-ssm|dev|Apache-2.0|github.com/aws/aws-sdk-js-v3|
|@aws-sdk/credential-provider-imds|dev|Apache-2.0|github.com/aws/aws-sdk-js-v3|
|@aws-sdk/credential-providers|import|Apache-2.0|github.com/aws/aws-sdk-js-v3|
|@aws-sdk/node-http-handler|import|Apache-2.0|github.com/aws/aws-sdk-js-v3|
|@aws-sdk/middleware-retry|import|Apache-2.0|github.com/aws/aws-sdk-js-v3|
|@aws-sdk/s3-request-presigner|import|Apache-2.0|github.com/aws/aws-sdk-js-v3|
|@aws-sdk/types|dev|Apache-2.0|github.com/aws/aws-sdk-js-v3|
|@aws-sdk/util-arn-parser|import|Apache-2.0|github.com/aws/aws-sdk-js-v3|
|@axe-core/puppeteer|import|MPL-2.0|github.com/dequelabs/axe-core-npm|
|@azure/identity|import|MIT|github.com/Azure/azure-sdk-for-js|
|@azure/storage-blob|import|MIT|github.com/Azure/azure-sdk-for-js|
|@babel/core|dev|MIT|github.com/babel/babel|
|@babel/plugin-transform-modules-commonjs|dev|MIT|github.com/babel/babel|
|@babel/preset-env|dev|MIT|github.com/babel/babel|
|@datadog/browser-rum|import|Apache-2.0|github.com/DataDog/browser-sdk|
|@datadog/datadog-api-client|import|Apache-2.0|github.com/DataDog/datadog-api-client-typescript|
|@datadog/datadog-ci|dev|Apache-2.0|github.com/DataDog/datadog-ci|
|@electron/remote|dev|MIT|github.com/electron/remote|
|@google-cloud/pubsub|import|Apache-2.0|github.com/googleapis/nodejs-pubsub|
|@google-cloud/storage|import|MIT|github.com/googleapis/nodejs-storage|
|@grpc/grpc-js|import|Apache-2.0|github.com/grpc/grpc-node/tree/master/packages/grpc-js|
|@grpc/proto-loader|dev|Apache-2.0|github.com/grpc/grpc-node/tree/master/packages/proto-loader|
|@heroku/socksv5|import|MIT|github.com/heroku/socksv5|
|@kayahr/jest-electron-runner|dev|MIT|github.com/kayahr/jest-electron-runner|
|@octokit/rest|import|MIT|github.com/octokit/octokit.js|
|@octokit/request-error|import|MIT|github.com/octokit/octokit.js|
|@openpgp/web-stream-tools|dev|MIT|github.com/openpgpjs/web-stream-tools|
|@slack/web-api|dev|MIT|github.com/slackapi/node-slack-sdk|
|@stylistic/eslint-plugin|dev|MIT|github.com/eslint-stylistic/eslint-stylistic|
|@types/adm-zip|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/async|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/bindings|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/consul|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/cookie|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/debug|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/follow-redirects|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/google-protobuf|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/http-auth|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/http-proxy|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/jest|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/jsonpath|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/js-yaml|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/kerberos|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/lodash|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/luxon|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/minimist|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/msgpack-lite|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/node|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/node-forge|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/ping|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/pug|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/selenium-webdriver|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/semver|dev|ISC|github.com/npm/node-semver|
|@types/ssh2|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/stream-json|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/tmp|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/triple-beam|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/tough-cookie|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/whatwg-mimetype|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/ws|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@types/yargs|dev|MIT|github.com/DefinitelyTyped/DefinitelyTyped|
|@wdio/types|dev|MIT|github.com/webdriverio/webdriverio|
|@xmldom/xmldom|import|MIT|github.com/xmldom/xmldom|
|adm-zip|import|MIT|github.com/cthackers/adm-zip|
|agent-base|import|MIT|github.com/TooTallNate/node-agent-base|
|ajv|import|MIT|github.com/ajv-validator/ajv|
|asn1.js|import|MIT|github.com/indutny/asn1.js|
|asn1.js-rfc2560|import|MIT|github.com/indutny/asn1.js|
|async|import|MIT|github.com/caolan/async|
|aws-sdk|import|Apache-2.0|github.com/aws/aws-sdk-js|
|aws-sdk-client-mock|dev|MIT|github.com/m-radzikowski/aws-sdk-client-mock|
|aws-sdk-client-mock-jest|dev|MIT|github.com/m-radzikowski/aws-sdk-client-mock-jest|
|babel-loader|dev|MIT|github.com/babel/babel-loader|
|concurrently|dev|MIT|github.com/kimmobrunfeldt/concurrently|
|consul|import|MIT|github.com/silas/node-consul|
|cookie|import|MIT|github.com/jshttp/cookie|
|copyfiles|dev|MIT|github.com/calvinmetcalf/copyfiles|
|core-js|import|MIT|github.com/zloirock/core-js|
|cross-env|dev|MIT|github.com/kentcdodds/cross-env|
|css.escape|import|MIT|github.com/mathiasbynens/CSS.escape|
|csv-parse|dev|MIT|github.com/adaltas/node-csv-parse|
|date-fns|import|MIT|github.com/date-fns/date-fns|
|dd-trace|import|BSD-3-Clause|github.com/DataDog/dd-trace-js|
|debug|dev|MIT|github.com/debug-js/debug|
|devtools-protocol|import|The Chromium Authors (i.e. BSD-3)|github.com/ChromeDevTools/devtools-protocol|
|dns2|dev|MIT|github.com/song940/node-dns|
|electron|dev|MIT|github.com/electron/electron|
|es-check|dev|MIT|github.com/yowainwright/es-check|
|eslint|dev|MIT|github.com/eslint/eslint|
|eslint-config-prettier|dev|MIT|github.com/prettier/eslint-config-prettier|
|eslint-import-resolver-typescript|dev|ISC|github.com/alexgorbatchev/eslint-import-resolver-typescript|
|eslint-plugin-import|dev|MIT|github.com/benmosher/eslint-plugin-import|
|eslint-plugin-jest|dev|MIT|github.com/jest-community/eslint-plugin-jest|
|eslint-plugin-n|dev|MIT|github.com/eslint-community/eslint-plugin-n|
|eslint-plugin-prefer-arrow|dev|MIT|github.com/TristonJ/eslint-plugin-prefer-arrow|
|eslint-plugin-sort-keys-fix|dev|MIT|github.com/leo-buneev/eslint-plugin-sort-keys-fix|
|eslint-plugin-unicorn|dev|MIT|github.com/sindresorhus/eslint-plugin-unicorn|
|follow-redirects|import|MIT|github.com/follow-redirects/follow-redirects|
|form-data|import|MIT|github.com/form-data/form-data|
|get-port|import|MIT|github.com/sindresorhus/get-port|
|got|import|MIT|github.com/sindresorhus/got|
|hot-shots|import|MIT|github.com/brightcove/hot-shots|
|http-auth|dev|MIT|github.com/http-auth/http-auth|
|http-auth-utils|import|MIT|github.com/nfroidure/http-auth-utils|
|http-proxy|import|MIT|github.com/http-party/node-http-proxy|
|http-proxy-agent|dev|MIT|github.com/TooTallNate/proxy-agents|
|http2-wrapper|import|MIT|github.com/szmarczak/http2-wrapper|
|iconv-lite|import|MIT|github.com/ashtuchkin/iconv-lite|
|imports-loader|dev|MIT|github.com/webpack-contrib/imports-loader|
|int64-buffer|import|MIT|github.com/kawanet/int64-buffer|
|ipaddr.js|import|MIT|github.com/whitequark/ipaddr.js|
|is-in-subnet|import|MIT|github.com/natesilva/is-in-subnet|
|jest|dev|MIT|github.com/facebook/jest|
|jest-date-mock|dev|MIT|github.com/hustcc/jest-date-mock|
|js-levenshtein|import|MIT|github.com/gustf/js-levenshtein|
|json-diff|dev|MIT|github.com/andreyvit/json-diff|
|jsonpath|import|MIT|github.com/dchester/jsonpath|
|js-md5|import|MIT|github.com/emn178/js-md5|
|js-yaml|dev|MIT|github.com/nodeca/js-yaml|
|kerberos|import|Apache-2.0|github.com/mongodb-js/kerberos|
|letterparser|import|BSD-3-Clause|github.com/mat-sz|
|lodash|import|MIT|github.com/lodash/lodash|
|luxon|import|MIT|github.com/moment/luxon|
|minimist|dev|MIT|github.com/substack/minimist|
|moment-timezone|import|MIT|github.com/moment/moment-timezone|
|msgpack-lite|import|MIT|github.com/kawanet/msgpack-lite|
|nock|dev|MIT|github.com/nock/nock|
|node-forge|import|(BSD-3-Clause OR GPL-2.0)|github.com/digitalbazaar/forge|
|node-gyp|dev|MIT|github.com/nodejs/node-gyp|
|node-html-parser|import|MIT|github.com/taoqf/node-html-parser|
|null-loader|dev|MIT|github.com/webpack-contrib/null-loader|
|octokit|dev|MIT|github.com/octokit/octokit.js/|
|openpgp|dev|LGPL-3.0+|https://github.com/openpgpjs/openpgpjs|
|otplib|import|MIT|github.com/yeojz/otplib|
|pac-resolver|import|MIT|github.com/TooTallNate/proxy-agents|
|parse-domain|import|Unlicense|github.com/peerigon/parse-domain|
|ping|import|MIT|github.com/danielzzz/node-ping|
|prettier|dev|MIT|github.com/prettier/prettier|
|prettier-plugin-sh|dev|MIT

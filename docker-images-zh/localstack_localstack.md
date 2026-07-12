---
image: localstack/localstack
description: "LocalStack是一款可在单个容器中运行的云服务模拟器，支持在本地离线运行AWS应用程序或Lambda函数，无需连接远程云提供商，加速云应用的测试与开发工作流程。"
source: https://xuanyuan.cloud/zh/r/localstack/localstack
canonical: https://xuanyuan.cloud/zh/r/localstack/localstack
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/localstack/localstack" title="localstack/localstack Docker 镜像中文简介、标签列表与拉取命令">localstack/localstack 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LocalStack 镜像文档

## 概述
LocalStack 是一款云服务模拟器，可在您的笔记本电脑或CI环境中的单个容器内运行。借助 LocalStack，您可以在本地计算机上完全运行AWS应用程序或Lambda函数，而无需连接到远程云提供商！无论您是测试复杂的CDK应用程序、Terraform配置，还是刚开始学习AWS服务，LocalStack都能帮助加速和简化您的测试与开发工作流程。

LocalStack支持日益增多的AWS服务，如AWS Lambda、S3、DynamoDB、Kinesis、SQS、SNS等。您可以在[☑️ 功能覆盖](https://docs.localstack.cloud/user-guide/aws/feature-coverage/)页面查看支持的API完整列表。此外，LocalStack还提供了额外功能，为云开发人员提供更多便利，详情请参阅[用户指南](https://docs.localstack.cloud/user-guide/)。

## 使用方法
在开始前，请确保您的机器上已配置好[Docker环境](https://docs.docker.com/get-docker/)。可通过在终端执行`docker info`命令检查Docker是否正常配置，若未报错且显示Docker系统信息，则说明配置正确。

### Docker CLI
您可以直接使用Docker CLI启动LocalStack容器。此方法需要更多手动步骤和配置，但能让您更好地控制容器设置。

执行以下命令启动Docker容器：
```console
$ docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack
```

使用LocalStack的[`awslocal`](https://docs.localstack.cloud/user-guide/integrations/aws-cli/#localstack-aws-cli-awslocal) CLI创建S3存储桶：
```
$ awslocal s3api create-bucket --bucket sample-bucket
$ awslocal s3api list-buckets
```

**注意**
- 若本地已存在镜像，此命令将重用该镜像，不会自动从Docker Hub拉取最新镜像。
- 此命令未绑定LocalStack可能使用的所有端口，也未挂载任何卷。通过Docker手动启动LocalStack时，您需要自行配置容器（详见[`docker-compose.yml`](https://github.com/localstack/localstack/blob/main/docker-compose.yml)和[配置](https://docs.localstack.cloud/references/configuration/)）。这可视为启动LocalStack的“专家模式”。若您需要更简单的启动方式，请使用[LocalStack CLI](https://docs.localstack.cloud/getting-started/installation/#localstack-cli)。

### Docker Compose
您可以通过配置`docker-compose.yml`文件，使用[Docker Compose](https://docs.docker.com/compose/)启动LocalStack。目前支持docker-compose 1.9.0+版本。

```yaml
version: "3.8"

services:
  localstack:
    container_name: "${LOCALSTACK_DOCKER_NAME:-localstack-main}"
    image: docker.xuanyuan.run/localstack/localstack
    ports:
      - "127.0.0.1:4566:4566"            # LocalStack网关
      - "127.0.0.1:4510-4559:4510-4559"  # 外部服务端口范围
    environment:
      # LocalStack配置：https://docs.localstack.cloud/references/configuration/
      - DEBUG=${DEBUG:-0}
    volumes:
      - "${LOCALSTACK_VOLUME_DIR:-./volume}:/var/lib/localstack"
      - "/var/run/docker.sock:/var/run/docker.sock"
```

执行以下命令启动容器：
```console
$ docker-compose up
```

使用LocalStack的[`awslocal`](https://docs.localstack.cloud/user-guide/integrations/aws-cli/#localstack-aws-cli-awslocal) CLI创建SQS队列：
```
$ awslocal sqs create-queue --queue-name test-queue
$ awslocal sqs list-queues
```

**注意**
- 若本地无镜像，此命令将拉取`main`分支的当前夜间构建版本，而非最新支持版本。如需使用特定版本，请在`docker-compose.yml`文件的`services.localstack.image`处设置相应的LocalStack镜像标签（例如`localstack/localstack:<version>`）。
- 若本地已存在镜像，此命令将重用该镜像，不会自动从Docker Hub拉取最新镜像。
- 将Docker套接字`/var/run/docker.sock`挂载为卷是Lambda服务的要求，更多信息请参阅[Lambda提供程序](https://docs.localstack.cloud/user-guide/aws/lambda/)文档。

请注意，通过docker-compose手动配置堆栈时可能存在一些陷阱（如必需的容器名称、Docker网络、卷挂载和环境变量）。建议使用LocalStack CLI验证配置，它会在检测到潜在配置问题时打印警告消息：
```console
$ localstack config validate
```

## 基础镜像标签
LocalStack Docker镜像提供多种标签，您可根据需求选择：

- `latest`（默认）
  - 这是默认标签，指向经过全面集成测试套件测试的最新提交。
  - 包含主要版本更新，可能存在破坏性变更。
  - 适用于希望保持最新变更的场景。

- `stable`
  - 指向最新的标记版本，会随LocalStack的每次发布更新。
  - 包含主要版本更新，可能存在破坏性变更。
  - 适用于希望跟进版本发布，但不一定需要立即获取最新变更的场景。

- `<major>`（如`3`）
  - 指向特定主要版本的最新发布，会随该主要版本内的每次次要和补丁版本更新。
  - 适用于希望避免潜在破坏性变更的场景。

- `<major>.<minor>`（如`3.0`）
  - 指向特定次要版本的最新发布，会随该次要版本内的每次补丁版本更新。
  - 适用于希望避免新功能等较大变更，但仍需更新至最新 bugfix 版本的场景。

- `<major>.<minor>.<patch>`（如`3.0.2`）
  - 指向特定版本，不会更新。
  - 适用于希望完全避免镜像变更（包括最小的 bugfixes）的场景。

## 获取帮助
您可以通过以下渠道联系LocalStack团队：报告🐞[问题](https://github.com/localstack/localstack/issues/new/choose)、为👍[功能请求](https://github.com/localstack/localstack/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc)投票、🙋🏽提出[支持问题](https://docs.localstack.cloud/getting-started/help-and-support/)或🗣️讨论本地云开发：
- [LocalStack Slack社区](https://localstack.cloud/contact/)
- [LocalStack GitHub Issue跟踪器](https://github.com/localstack/localstack/issues)
- [入门指南 - FAQ](https://docs.localstack.cloud/getting-started/faq/)

## 许可证
版权所有 (c) 2017-2024 LocalStack维护者及贡献者。

版权所有 (c) 2016 Atlassian及其他方。

本版本的LocalStack采用Apache License 2.0许可协议（详见[LICENSE](https://github.com/localstack/localstack/blob/main/LICENSE.txt)）。下载和使用本软件即表示您同意[最终用户许可协议(EULA)](https://github.com/localstack/localstack/blob/main/doc/end_user_license_agreement)。

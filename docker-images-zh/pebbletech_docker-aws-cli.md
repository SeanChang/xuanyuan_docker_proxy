---
image: pebbletech/docker-aws-cli
description: "这是一个封装AWS CLI工具的Docker镜像，允许用户通过容器便捷执行AWS服务命令，无需本地安装AWS CLI，支持挂载本地凭证文件实现身份验证。"
source: https://xuanyuan.cloud/zh/r/pebbletech/docker-aws-cli
canonical: https://xuanyuan.cloud/zh/r/pebbletech/docker-aws-cli
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/pebbletech/docker-aws-cli" title="pebbletech/docker-aws-cli Docker 镜像中文简介、标签列表与拉取命令">pebbletech/docker-aws-cli 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-aws-cli
该镜像提供了AWS CLI的容器化运行环境，帮助用户在无需本地安装AWS CLI的情况下，便捷执行各类AWS服务操作。

## 核心功能
- 支持所有AWS CLI命令的执行
- 通过挂载本地AWS凭证文件实现身份验证
- 保持与官方AWS CLI一致的功能和版本

## 使用场景
- 临时需要执行AWS命令但不想本地安装依赖的环境
- 多环境下统一AWS CLI版本，避免版本不一致问题
- CI/CD流程中集成AWS服务操作（如S3上传、EC2管理等）

## 配置说明
需将本地`~/.aws/credentials`文件挂载到容器内的`/root/.aws/credentials`路径，以提供AWS身份验证信息。

## 部署示例
### 拉取镜像
```bash
docker pull docker.xuanyuan.run/pebbletech/docker-aws-cli
```

### 执行AWS命令（以S3列出对象为例）
```bash
docker run -v ${HOME}/.aws/credentials:/root/.aws/credentials docker.xuanyuan.run/pebbletech/docker-aws-cli aws s3api list-objects --bucket bucket-name --prefix folder/ --output json
```

### 简化命令使用
可将容器命令封装为别名，替代本地AWS CLI：
```bash
alias aws='docker run -v ${HOME}/.aws/credentials:/root/.aws/credentials pebbletech/docker-aws-cli aws'
```
之后直接使用`aws`命令即可通过容器执行操作。

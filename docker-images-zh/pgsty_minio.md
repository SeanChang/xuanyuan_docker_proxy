---
image: pgsty/minio
description: "社区维护的minio/minio分支，提供S3兼容的高性能对象存储解决方案，适用于AI/ML、数据分析等数据密集型工作负载，恢复了嵌入式管理控制台GUI版本引用并更新了文档链接。"
source: https://xuanyuan.cloud/zh/r/pgsty/minio
canonical: https://xuanyuan.cloud/zh/r/pgsty/minio
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/pgsty/minio" title="pgsty/minio Docker 镜像中文简介、标签列表与拉取命令">pgsty/minio 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 重要声明

这是由[Pigsty](https://pigsty.io)维护的[minio/minio](https://github.com/minio/minio)社区分支。本项目与MinIO, Inc.无关联、未获其认可或赞助。"MinIO"是MinIO, Inc.的商标，此处仅用于标识上游项目。

本分支仅提供缺失的RPM/DEB/Docker镜像，修改极小：恢复了嵌入式ADMIN控制台GUI版本引用，并更新了文档链接和Go模块路径以指向本仓库。

# MinIO快速入门指南

[![网站: minio.pigsty.io](https://img.shields.io/badge/website-minio.pigsty.io-slategray?style=flat&logo=cilium&logoColor=white)](https://pigsty.io) [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io) [![许可证](https://img.shields.io/badge/license-AGPL%20V3-blue)](https://github.com/pgsty/minio/blob/master/LICENSE)

MinIO是一款高性能、兼容S3的对象存储解决方案，基于GNU AGPL v3.0许可证发布。其设计注重速度和可扩展性，为AI/ML、分析和数据密集型工作负载提供行业领先的性能。

- S3 API兼容——与现有S3工具无缝集成
- 专为AI和分析构建——针对大规模数据管道优化
- 高性能——适用于高要求的存储工作负载

本文档提供从源码构建MinIO并部署到裸机硬件的说明。使用[MinIO文档](https://github.com/minio/docs)项目可构建和托管本地文档副本。

## 从源码安装

使用以下命令从源码编译并运行独立的MinIO服务器。若没有可用的Golang环境，请遵循[如何安装Golang](https://golang.org/doc/install)。最低要求版本为[go1.24](https://golang.org/dl/#stable)

```sh
go install github.com/pgsty/minio@latest
```

也可运行`go build`并使用`GOOS`和`GOARCH`环境变量控制目标操作系统和架构。例如：

```sh
env GOOS=linux GOARCH=arm64 go build
```

通过运行`minio server PATH`启动MinIO，其中`PATH`是本地文件系统上的任意空文件夹。

MinIO部署使用默认根凭据`minioadmin:minioadmin`启动。可使用MinIO Console（MinIO Server内置的基于Web的对象浏览器）测试部署。在主机上打开Web浏览器，访问<http://127.0.0.1:9000>，使用根凭据登录。可通过浏览器创建桶、上传对象和浏览MinIO服务器内容。

也可使用任何S3兼容工具连接，如MinIO Client `mc`命令行工具：

```sh
mc alias set local http://localhost:9000 minioadmin minioadmin
mc admin info local
```

有关使用`mc`命令行工具的更多信息，请参见[使用MinIO Client `mc`测试](#使用-minio-client-mc-测试)。对于应用开发者，请访问<https://min.io/docs/minio/linux/developers/minio-drivers.html>查看支持语言的MinIO SDK。

## 构建Docker镜像

可使用`docker build .`命令在本地主机构建Docker镜像。必须先[构建MinIO](#从源码安装)并确保`minio`二进制文件存在于项目根目录。

以下命令使用项目根目录中的默认`Dockerfile`构建Docker镜像，仓库和镜像标签为`myminio:minio`

```sh
docker build -t myminio:minio .
```

使用`docker image ls`确认镜像存在于本地仓库。可使用标准Docker命令运行服务器：

```sh
docker run -p 9000:9000 -p 9001:9001 myminio:minio server /tmp/minio --console-address :9001
```

有关构建Docker容器、管理自定义镜像或将镜像加载到编排平台的完整文档超出本文档范围。可根据具体镜像需求修改`Dockerfile`和`dockerscripts/docker-entrypoint.sh`。

## 使用Helm Charts安装

有两种方式在Kubernetes基础设施上安装MinIO：

- 使用[MinIO Operator](https://github.com/minio/operator)
- 使用社区维护的[Helm charts](https://github.com/pgsty/minio/tree/master/helm/minio)

社区Helm chart的说明位于文件夹级别的README中。

## 测试MinIO连接性

### 使用MinIO Console测试

MinIO Server附带内置的基于Web的对象浏览器。将Web浏览器指向<http://127.0.0.1:9000>以确认服务器已成功启动。

> [!NOTE]
> MinIO默认在随机端口运行控制台，若需指定端口，使用`--console-address`选择特定接口和端口。

### 使用MinIO Client `mc`测试

`mc`提供了现代替代方案，替代ls、cat、cp、mirror、diff等UNIX命令。它支持文件系统和Amazon S3兼容的云存储服务。

以下命令设置本地别名、验证服务器信息、创建桶、将数据复制到该桶并列出桶内容。

```sh
mc alias set local http://localhost:9000 minioadmin minioadmin
mc admin info
mc mb data
mc cp ~/Downloads/mydata data/
mc ls data/
```

有关更多说明，请遵循MinIO Client [快速入门指南](https://min.io/docs/minio/linux/reference/minio-mc.html#quickstart)。

## 进一步探索

- [MinIO纠删码概述](https://min.io/docs/minio/linux/operations/concepts/erasure-coding.html)
- [将`mc`与MinIO Server一起使用](https://min.io/docs/minio/linux/reference/minio-mc.html)
- [将`minio-go` SDK与MinIO Server一起使用](https://min.io/docs/minio/linux/developers/go/minio-go.html)
- [MinIO V3指标参考](docs/metrics/v3.md)

## 贡献

请遵循MinIO [贡献者指南](https://github.com/minio/minio/blob/master/CONTRIBUTING.md)了解向仓库提交新贡献的指导。

## 许可证

- MinIO源码基于[GNU AGPLv3](LICENSE)许可。
- MinIO [文档](docs/)基于[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)许可。
- [许可证合规性](COMPLIANCE.md)

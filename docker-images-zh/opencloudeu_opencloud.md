<!-- xuanyuan-docker-images-zh
image: opencloudeu/opencloud
source: https://xuanyuan.cloud/zh/r/opencloudeu/opencloud
canonical: https://xuanyuan.cloud/zh/r/opencloudeu/opencloud
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [opencloudeu/opencloud — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/opencloudeu/opencloud "opencloudeu/opencloud Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/opencloudeu/opencloud

# OpenCloud服务器后端Docker镜像

## 概述
本镜像为OpenCloud服务器的主要Docker镜像，包含后端服务的Golang代码库，用于部署OpenCloud后端服务。该项目遵循Apache 2.0开源许可证，欢迎社区贡献。

## 核心功能与特性

### 认证机制
- 支持通过[OpenID Connect](https://openid.net/connect/)进行用户认证
- 兼容外部身份提供商（如Keycloak）
- 内置嵌入式身份提供商[LibreGraph Connect](https://github.com/libregraph/lico)

### 数据存储
- 无数据库依赖，所有数据存储于文件系统
- 默认数据根目录：`$HOME/.opencloud/`（容器内默认路径为`/root/.opencloud/`）

### 开源特性
- 基于Apache 2.0许可证发布
- 支持代码贡献、问题反馈等社区参与形式

## 使用场景
适用于需要自托管后端服务的环境，尤其适合以下场景：
- 需轻量级数据存储方案（文件系统替代数据库）
- 需灵活身份认证配置（支持多种IdP）
- 开源技术栈部署需求

## 使用方法

### 基本部署流程
1. 初始化配置（生成默认配置文件）
2. 启动服务器服务

### Docker运行示例

#### 1. 初始化配置
```bash
docker run -v $HOME/.opencloud:/root/.opencloud opencloudeu/opencloud init
```
- `-v $HOME/.opencloud:/root/.opencloud`：挂载本地目录至容器内，持久化配置数据
- 配置文件将生成在本地`$HOME/.opencloud`目录

#### 2. 启动服务器
```bash
docker run -d -p 8080:8080 -v $HOME/.opencloud:/root/.opencloud opencloudeu/opencloud server
```
- `-d`：后台运行容器
- `-p 8080:8080`：映射容器8080端口至主机（默认服务端口，可根据配置调整）
- 持久化目录需与初始化步骤保持一致

## 技术详情

### 构建信息（开发者参考）
如需从源码构建镜像，需先生成资产并编译二进制：
```bash
# 生成Web UI及身份提供商所需资产
make generate
# 编译opencloud二进制
make -C opencloud build
```
编译产物为`opencloud/bin/opencloud`，可直接作为本地测试实例运行。

## 安全信息
如发现安全相关问题，请立即联系：[security@opencloud.eu](mailto:security@opencloud.eu)

## 参与贡献
项目欢迎社区贡献，贡献指南详见：[Contribution Guidelines](https://github.com/opencloud-eu/opencloud/blob/main/CONTRIBUTING.md)

## 参考链接
- [OpenCloud GitHub主页](https://github.com/opencloud-eu/)
- [OpenCloud官方网站](https://opencloud.eu)
- [开发文档](https://docs.opencloud.eu/)

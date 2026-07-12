---
image: openeuler/dotnet-runtime
description: "适用于.NET应用的openEuler运行时镜像。"
source: https://xuanyuan.cloud/zh/r/openeuler/dotnet-runtime
canonical: https://xuanyuan.cloud/zh/r/openeuler/dotnet-runtime
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/dotnet-runtime" title="openeuler/dotnet-runtime Docker 镜像中文简介、标签列表与拉取命令">openeuler/dotnet-runtime 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Dotnet Runtime (.NET Runtime) | openEuler

## 镜像概述和主要用途
官方Dotnet Runtime (.NET Runtime) Docker镜像，基于openEuler构建，免费使用且无用户速率限制。.NET是一个免费、跨平台、开源的开发者平台，用于构建多种应用程序，支持多种编程语言（以C#最流行），依赖高性能运行时，被许多大规模应用在生产环境中使用。

## 核心功能和特性
- 跨平台支持：可在amd64和arm64架构上运行
- 基于openEuler：使用稳定可靠的openEuler基础镜像
- 多版本组合：提供不同.NET Runtime版本与openEuler版本的组合
- 无速率限制：免费使用，不受用户速率限制

## 支持的标签及对应Dockerfile链接
每个`dotnet-runtime` Docker镜像的标签由`dotnet-runtime`版本和基础镜像版本组成，详情如下：

| 标签 | 当前版本 | 架构 |
|------|----------|------|
|[10.0.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dotnet-runtime/10.0.0/24.03-lts-sp2/Dockerfile) | openEuler 24.03-LTS-SP2上的dotnet 10.0.0 | amd64, arm64 |
|[8.0.3-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dotnet-runtime/8.0.3/22.03-lts-sp3/Dockerfile)| openEuler 22.03-LTS-SP3上的Dotnet-runtime 8.0.3 | amd64, arm64 |
|[8.0.7-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dotnet-runtime/8.0.7/22.03-lts-sp3/Dockerfile)| openEuler 22.03-LTS-SP3上的Dotnet-runtime 8.0.7 | amd64, arm64 |
|[8.0.8-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dotnet-runtime/8.0.8/22.03-lts-sp3/Dockerfile)| openEuler 22.03-LTS-SP3上的Dotnet-runtime 8.0.8 | amd64, arm64 |
|[8.0.10-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dotnet-runtime/8.0.10/20.03-lts-sp4/Dockerfile)| openEuler 20.03-LTS-SP4上的Dotnet-runtime 8.0.10 | amd64, arm64 |
|[8.0.10-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dotnet-runtime/8.0.10/22.03-lts-sp1/Dockerfile)| openEuler 22.03-LTS-SP1上的Dotnet-runtime 8.0.10 | amd64, arm64 |
|[8.0.10-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dotnet-runtime/8.0.10/22.03-lts-sp3/Dockerfile)| openEuler 22.03-LTS-SP3上的Dotnet-runtime 8.0.10 | amd64, arm64 |
|[8.0.10-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dotnet-runtime/8.0.10/22.03-lts-sp4/Dockerfile)| openEuler 22.03-LTS-SP4上的Dotnet-runtime 8.0.10 | amd64, arm64 |
|[8.0.10-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dotnet-runtime/8.0.10/24.03-lts/Dockerfile)| openEuler 24.03-LTS上的Dotnet-runtime 8.0.10 | amd64, arm64 |

## 使用方法和配置说明

在使用时，用户可根据需求选择相应的`{Tag}`。

### 拉取镜像
从Docker拉取`openeuler/dotnet-runtime`镜像：

```bash
docker pull docker.xuanyuan.run/openeuler/dotnet-runtime:{Tag}
```

### 启动dotnet-runtime实例
```bash
docker run -d --name my-dotnet-runtime docker.xuanyuan.run/openeuler/dotnet-runtime:{Tag}
```

### HelloWorld应用示例
1. 创建HelloWorld.csproj文件，内容如下：

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>
</Project>
```

2. 创建Program.cs文件，代码如下：

```csharp
Console.WriteLine("Hello, World!");
```

3. 发布.NET应用（需要"dotnet8"包）：

```bash
dotnet publish -c Release -o app
```

4. 使用"openeuler/dotnet-runtime:8.0.3-oe2203sp3"运行应用：

```bash
docker run --rm -v $PWD/app:/app docker.xuanyuan.run/openeuler/dotnet-runtime:8.0.3-oe2203sp3 /app/HelloWorld.dll
Hello, World!
```

### 查看容器运行日志
```bash
docker logs -f my-dotnet-runtime
```

### 获取交互式shell
```bash
docker run -it --entrypoint /bin/bash --name my-dotnet-runtime docker.xuanyuan.run/openeuler/dotnet-runtime:{Tag}
```

## 快速参考
- 官方Dotnet Runtime (.NET Runtime) Docker镜像。
- 维护者：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)。
- 获取帮助：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)，[openEuler](https://gitee.com/openeuler/community)。

## 问答
如有任何问题或需要使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)上提交issue或pull request。

<!-- xuanyuan-docker-images-zh
image: bellsoft/liberica-openjdk-alpine
source: https://xuanyuan.cloud/zh/r/bellsoft/liberica-openjdk-alpine
canonical: https://xuanyuan.cloud/zh/r/bellsoft/liberica-openjdk-alpine
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [bellsoft/liberica-openjdk-alpine — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/bellsoft/liberica-openjdk-alpine "bellsoft/liberica-openjdk-alpine Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/bellsoft/liberica-openjdk-alpine

# bellsoft/liberica-openjdk-alpine 镜像文档


## 镜像概述和主要用途

`bellsoft/liberica-openjdk-alpine` 是基于 Alpine Linux 构建的 Liberica JDK Docker 镜像，采用 glibc 库而非 Alpine 默认的 musl。Liberica JDK 是由 BellSoft 开发的免费开源 Java 运行时，100% 兼容 Java SE 规范，通过 TCK 验证，适用于桌面、服务器、云环境及嵌入式场景。

本镜像结合了 Alpine Linux 的轻量级特性（基础镜像约 5MB）与 Liberica JDK 的兼容性，旨在提供最小化、高性能的 Java 容器环境，特别适合微服务部署和云原生应用。


## 核心功能和特性

### Liberica JDK 核心优势
- **灵活性**：支持多架构（x86_64、aarch64、armhf）和多操作系统，统一各类部署场景的 Java 运行时。
- **成本与效率优化**：基于 Alpine Linux 和 Liberica Lite 构建的容器体积比传统 CentOS/Debian 镜像小 5-7 倍，降低云资源消耗并加速部署。
- **安全性**：通过 Java SE TCK 验证，严格测试漏洞，遵循 CPU（关键补丁更新）周期及时提供安全补丁和 bug 修复。

### 镜像特性
- **轻量级**：最小容器体积仅 42.72 MB，为业界同类产品中最小。
- **多架构支持**：覆盖 x86_64（amd64）、aarch64（ARM64）及 armhf（如 Raspberry Pi 2/3）。
- **CDS 支持**：含 `-cds` 标签的镜像预构建类数据共享（Class Data Sharing）归档，加速 JVM 启动。
- **版本变体**：提供基础版（base）、精简版（lite）、标准版（standard）等多种 JDK 变体，可按需选择 VM（server/client/minimal）。


## 支持的架构
- **x86_64（amd64）**：主流 64 位 x86 架构
- **aarch64（ARM64）**：64 位 ARM 架构（如 AWS Graviton、树莓派 4）
- **armhf**：32 位 ARM 架构（如树莓派 2/3）


## 标签说明

### 标签结构
- **基础格式**：`X-Y` 或 `X-cds-Y`，其中 `X` 为 Java 版本，`Y` 为架构类型（如 `aarch64`）。若未指定架构，默认支持 amd64 和 ARM64。
- **特殊标签**：`latest` 指向最新版本；含 `-cds` 标签的镜像包含 CDS 归档。

### 可用标签列表
按 Java 版本分组：

#### Java 25
- `latest-cds`, `latest`, `25-cds`, `25`

#### Java 24
- `24-cds`, `24`

#### Java 23
- `23-cds`, `23`

#### Java 22
- `22`, `22-cds`

#### Java 21
- `21.0.8-cds`, `21.0.8`, `21.0.7-cds`, `21.0.7`, `21.0.6-cds`, `21.0.6`, `21.0.5-cds`, `21.0.5`, `21.0.4-cds`, `21.0.4`, `21.0.3-cds`, `21.0.3`, `21`, `21-cds`

#### Java 20
- `20`

#### Java 19
- `19`

#### Java 18
- `18`

#### Java 17
- `17.0.16-cds`, `17.0.16`, `17.0.15-cds`, `17.0.15`, `17.0.14-cds`, `17.0.14`, `17.0.13-cds`, `17.0.13`, `17.0.12`, `17.0.12-cds`, `17.0.11`, `17.0.11-cds`, `17`, `17-cds`

#### Java 16-13
- `16`, `15`, `14`, `13`

#### Java 12
- `12`

#### Java 11
- `11.0.28-cds`, `11.0.28`, `11.0.27-cds`, `11.0.27`, `11.0.26-cds`, `11.0.26`, `11.0.25-cds`, `11.0.25`, `11.0.24`, `11.0.24-cds`, `11.0.23`, `11.0.23-cds`, `11`, `11-cds`

#### Java 10
- `10.0.2`, `10.0.1`, `10`（仅 armhf 架构）

#### Java 9
- `9.0.4`, `9.0.1`（仅 armhf 架构）

#### Java 8
- `8u462`, `8u462-cds`, `8u432`, `8u432-cds`, `8u422`, `8u422-cds`, `8u412`, `8u412-cds`, `8u392`, `8u392-cds`, `8u`, `8u-cds`, `8`, `8-cds`（仅 amd64 和 aarch64 架构）


## 使用场景和适用范围
- **Java 微服务**：轻量级镜像加速部署并降低资源占用。
- **云原生应用**：适合 Kubernetes、Docker Swarm 等容器编排平台。
- **嵌入式设备**：支持 armhf 架构，适用于树莓派等边缘设备。
- **CI/CD 流水线**：快速启动的容器环境用于自动化测试和构建。
- **桌面/服务器应用**：需跨平台兼容的 Java 应用部署。


## 构建参数说明

Dockerfile 支持以下构建参数，用于自定义镜像内容：

### 通用参数
| 参数名       | 说明                                                                 | 默认值              |
|--------------|----------------------------------------------------------------------|---------------------|
| `LANG`       | 指定镜像的 locale（语言环境），取值参考 [Locale 名称](https://www.gnu.org/software/gettext/manual/html_node/Locale-Names.html) | `en_US.UTF-8`       |
| `OPT_PKGS`   | 需安装的可选 Alpine 包，空格分隔（如 `curl ttf-dejavu`）             | 空（不安装额外包）  |

### 版本特定参数
#### JDK 8u* 版本
| 参数名             | 说明                                                                 | 默认值  |
|--------------------|----------------------------------------------------------------------|---------|
| `LIBERICA_USE_LITE`| 是否构建 Lite 版本（移除演示、示例和源码）：`0`（保留完整 JDK），`1`（Lite 版本） | `1`     |

#### JDK 11* 和 17* 版本
| 参数名                  | 说明                                                                 | 默认值   |
|-------------------------|----------------------------------------------------------------------|----------|
| `LIBERICA_IMAGE_VARIANT`| 镜像变体：`base`（仅含 `java.base` 模块的 server VM）、`base-minimal`（`java.base` 模块的 minimal VM）、`lite`（精简 JDK）、`standard`（标准 JDK） | `lite`   |
| `LIBERICA_VM`           | 包含的 VM 类型（仅对 `lite` 和 `standard` 变体生效）：`server`、`client`、`minimal`、`all`（所有 VM） | `server` |


## 使用方法

### 基础使用
运行容器并验证 Java 版本：
```bash
docker run -it --rm bellsoft/liberica-openjdk-alpine:latest java -version
```

### 运行 Java 应用
#### 方法 1：挂载本地应用目录
```bash
docker run -it --rm -v /path/to/your/app:/app bellsoft/liberica-openjdk-alpine:21 java -jar /app/MyApp.jar
```

#### 方法 2：基于镜像构建应用镜像
创建 `Dockerfile`：
```dockerfile
FROM bellsoft/liberica-openjdk-alpine:21
WORKDIR /app
COPY target/MyApp.jar /app/
CMD ["java", "-jar", "MyApp.jar"]
```
构建并运行：
```bash
docker build -t my-java-app .
docker run -it --rm my-java-app
```

### Docker Compose 示例
创建 `docker-compose.yml`：
```yaml
version: '3.8'
services:
  app:
    image: bellsoft/liberica-openjdk-alpine:21
    volumes:
      - ./target/MyApp.jar:/app/MyApp.jar
    command: java -jar /app/MyApp.jar
    ports:
      - "8080:8080"
```
启动服务：
```bash
docker-compose up
```


## 离屏渲染支持

容器化部署中，若需进行离屏渲染（如生成文档、图片），JDK 需依赖系统字体和 `fontconfig` 库。缺少这些组件会导致类似以下异常：
```
Exception in thread "main" java.lang.InternalError: java.lang.reflect.InvocationTargetException
...
Caused by: java.lang.NullPointerException
	at java.desktop/sun.awt.FontConfiguration.getVersion(FontConfiguration.java:1262)
```

### 解决方案
安装 `fontconfig` 和字体包（如 `ttf-dejavu`）：

#### 运行时安装（临时）
```bash
docker run -it --rm bellsoft/liberica-openjdk-alpine:latest sh -c "apk add fontconfig ttf-dejavu && java -jar /app/MyApp.jar"
```

#### 构建时集成（推荐）
通过 `OPT_PKGS` 参数在构建镜像时预装依赖：
```bash
docker build -t my-app-with-fonts \
  --build-arg OPT_PKGS="fontconfig ttf-dejavu" \
  --build-arg LIBERICA_VERSION=21.0.8 \
  .
```


## 替代方案：Alpaquita Linux 容器

[Alpaquita Linux](https://bell-sw.com/alpaquita-linux/) 是 BellSoft 推出的轻量级 Linux 发行版，作为 Alpine 的增强替代方案，提供：
- 同时支持 glibc 和优化版 musl 库
- 内核硬化、Secure Boot 等安全增强特性
- 性能优化（如内存分配、文件系统改进）
- BellSoft 官方支持及长期维护（LTS）

Alpaquita 与 Liberica JDK 的容器化方案可在 [bellsoft/liberica-runtime-container](https://hub.docker.com/r/bellsoft/liberica-runtime-container) 获取。

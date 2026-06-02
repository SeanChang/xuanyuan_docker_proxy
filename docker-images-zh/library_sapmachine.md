---
image: library/sapmachine
description: "library/sapmachine 是 SAP 官方提供的 OpenJDK 二进制分发版 Docker 镜像，基于 SapMachine 构建——这是 SAP 开发、质量测试并长期支持的 OpenJDK 衍生版本，兼容 Java SE 标准。该镜像支持 Java 11、17、21（长期支持 LTS 版本）及 25（最新版本），适配 Ubuntu（Noble/Jammy）、Alpine（3.21/3.22）等基础镜像，提供 JDK、JRE、无头（Headless）等多种变体，满足企业级 Java 应用（如 Spring Boot 微服务、SAP 自研系统）在容器化环境中的部署需求，同时覆盖 amd64、arm64v8、ppc64le 多架构场景。"
source: https://xuanyuan.cloud/zh/r/library/sapmachine
canonical: https://xuanyuan.cloud/zh/r/library/sapmachine
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/sapmachine" title="library/sapmachine Docker 镜像中文简介、标签列表与拉取命令">library/sapmachine 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# SapMachine Docker 镜像使用指南

## 快速参考

### 维护方
由 The SapMachine Team（SAP 官方团队）维护。

### 帮助渠道
可通过邮件 sapmachine@sap.com 获取官方支持。

### 支持的标签及对应 Dockerfile 链接

标签命名规则：Java版本-组件类型-基础镜像-基础镜像版本，核心分类如下（简化高频标签，完整列表见 Docker Hub）：

#### Ubuntu 24.04（Noble）基础镜像

**Java 11（LTS）标签：**
- JDK: 11-jdk-ubuntu-noble、11.0.28-jdk-ubuntu-noble
- JRE: 11-jre-ubuntu-noble、11.0.28-jre-ubuntu-noble
- JDK-headless: 11-jdk-headless-ubuntu-noble
- JRE-headless: 11-jre-headless-ubuntu-noble

**Java 17（LTS）标签：**
- JDK: 17-jdk-ubuntu-noble、17.0.16-jdk-ubuntu-noble
- JRE: 17-jre-ubuntu-noble、17.0.16-jre-ubuntu-noble
- JDK-headless: 17-jdk-headless-ubuntu-noble
- JRE-headless: 17-jre-headless-ubuntu-noble

**Java 21（LTS）标签：**
- JDK: 21-jdk-ubuntu-noble、21.0.8-jdk-ubuntu-noble
- JRE: 21-jre-ubuntu-noble、21.0.8-jre-ubuntu-noble
- JDK-headless: 21-jdk-headless-ubuntu-noble
- JRE-headless: 21-jre-headless-ubuntu-noble

**Java 25 标签：**
- JDK: 25-jdk-ubuntu-noble
- JRE: 25-jre-ubuntu-noble
- JDK-headless: 25-jdk-headless-ubuntu-noble
- JRE-headless: 25-jre-headless-ubuntu-noble

#### Ubuntu 22.04（Jammy）基础镜像

- Java 11: 11-jdk-ubuntu-jammy、11.0.28-jdk-ubuntu-jammy
- Java 17: 17-jdk-ubuntu-jammy、17.0.16-jdk-ubuntu-jammy
- Java 21: 21-jdk-ubuntu-jammy、21.0.8-jdk-ubuntu-jammy
- Java 25: 25-jdk-ubuntu-jammy

#### Alpine 3.22 基础镜像

- Java 11: 11-jdk-alpine-3.22、11.0.28-jdk-alpine-3.22、11-jre-alpine-3.22
- Java 17: 17-jdk-alpine-3.22、17.0.16-jdk-alpine-3.22、17-jre-alpine-3.22
- Java 21: 21-jdk-alpine-3.22、21.0.8-jdk-alpine-3.22、21-jre-alpine-3.22
- Java 25: 25-jdk-alpine-3.22、25-jre-alpine-3.22

#### 简化标签

- Java 11: 11（默认 JDK+Ubuntu Noble）、11-lts
- Java 17: 17、17-lts
- Java 21: 21、21-lts
- Java 25: 25
- latest（对应最新 LTS 版本，如 21）

### 问题反馈地址
SapMachine GitHub 仓库：https://github.com/SAP/SapMachine（可参考 SapMachine Wiki 获取更多信息）

### 支持的架构
amd64（x86-64）、arm64v8（ARM 64 位）、ppc64le（PowerPC 64 位小端序）

### 镜像详情
包含元数据、传输大小等信息，可查看 repo-info 仓库的 repos/sapmachine/ 目录（历史记录）。

### 镜像更新
- 跟踪更新：official-images 仓库的 library/sapmachine 标签
- 更新记录：official-images 仓库的 library/sapmachine 文件（历史记录）

### 本文档来源
docs 仓库的 sapmachine/ 目录（历史记录）


## 什么是 SapMachine

SapMachine 是 SAP 推出的 OpenJDK 官方兼容分发版，核心特性如下：

1. **企业级保障**：经过 SAP 严格的质量测试（包括功能、性能、稳定性验证），提供长期支持（LTS 版本支持周期与 OpenJDK 一致，如 Java 11 支持至 2026 年，Java 17 支持至 2031 年）
2. **生态适配**：是 SAP 业务技术平台（SAP Business Technology Platform, BTP）的默认 Java 运行时，同时支持 Cloud Foundry 云平台的 Java Build Pack，可无缝运行 SAP 自研应用（如 S/4HANA 云版）及第三方 Java 应用
3. **标准兼容**：完全遵循 Java SE 规范，通过 Oracle 的 Java Compatibility Kit（JCK）认证，确保与现有 Java 代码的兼容性，无需修改即可迁移
4. **多平台支持**：覆盖 Windows、Linux、macOS 操作系统，容器化版本则适配 Ubuntu、Alpine 等主流基础镜像，满足多样化部署场景


## 如何使用本镜像

### 场景 1：快速验证 Java 版本

直接拉取镜像并运行 java -version 验证环境：

```bash
# 拉取最新 LTS 版本（如 Java 21）
docker pull library/sapmachine:latest

# 运行容器并查看 Java 版本
docker run -it --rm library/sapmachine:latest java -version
# 输出示例：openjdk version "21.0.8" 2024-07-16 LTS
#           SapMachine Runtime Environment (build 21.0.8+9-LTS)
#           OpenJDK 64-Bit Server VM (build 21.0.8+9-LTS, mixed mode)
```

### 场景 2：作为基础镜像运行 Java 应用（Ubuntu 基础）

创建 Dockerfile，基于 SapMachine 部署预编译的 JAR 包（如 myapp.jar）：

```dockerfile
# 选择 Java 17 LTS 的 JDK 镜像（Ubuntu Jammy 基础，兼容性更广）
FROM library/sapmachine:17-jdk-ubuntu-jammy

# 创建应用目录（避免权限问题，使用非 root 用户）
RUN mkdir -p /opt/myapp && chown -R sapmachine:sapmachine /opt/myapp
USER sapmachine

# 复制 JAR 包到容器
COPY --chown=sapmachine:sapmachine myapp.jar /opt/myapp/

# 启动命令（运行 JAR 包）
CMD ["java", "-jar", "/opt/myapp/myapp.jar"]
```

构建并运行镜像：

```bash
# 构建镜像（标签为 my-java-app）
docker build -t my-java-app .

# 后台运行容器（映射端口 8080）
docker run -d -p 8080:8080 --name my-app-container my-java-app
```

### 场景 3：使用轻量 Alpine 镜像（适合资源受限环境）

Alpine 基础镜像体积仅约 5MB，适合追求镜像轻量化的场景（注意：Alpine 使用 musl libc，部分依赖 glibc 的 Java 库需适配）：

```dockerfile
# 选择 Java 21 LTS 的 JRE-headless 镜像（无 GUI，更轻量）
FROM library/sapmachine:21-jre-headless-alpine-3.22

# 复制 JAR 包（Alpine 镜像默认使用 root 用户，可按需调整）
COPY myapp.jar /opt/

# 启动命令（限制 JVM 内存，适配容器环境）
CMD ["java", "-Xmx512m", "-jar", "/opt/myapp.jar"]
```

构建运行：

```bash
docker build -t my-lightweight-app .
docker run -it --rm -p 8080:8080 my-lightweight-app
```


## 镜像变体说明

SapMachine 镜像提供多种变体，需根据场景选择：

**JDK**
- 特点：包含编译器（javac）、调试工具及完整类库
- 适用场景：Java 应用开发、编译构建、需要调试的场景

**JRE**
- 特点：仅包含运行时环境（无编译器）
- 适用场景：仅运行已编译 JAR 包的生产环境

**JDK-headless**
- 特点：JDK 基础上去除 GUI 相关库（如 AWT/Swing）
- 适用场景：服务器端开发（无图形界面需求）

**JRE-headless**
- 特点：JRE 基础上去除 GUI 相关库
- 适用场景：纯服务器端运行环境（如微服务、API 服务）

**Ubuntu 基础**
- 特点：使用 glibc 库，兼容性强
- 适用场景：依赖 glibc 的 Java 应用、需要安装 apt 包的场景

**Alpine 基础**
- 特点：使用 musl 库，体积轻量（约为 Ubuntu 镜像的 1/3）
- 适用场景：资源受限环境（如边缘计算、轻量容器）


## 配置说明

### 核心环境变量

- **JAVA_HOME**: /opt/sapmachine/jdk（Java 安装根目录，镜像内已预配置，可直接引用）
- **PATH**: ${JAVA_HOME}/bin:${PATH}（包含 Java 二进制目录，可直接执行 java/javac）

### 常用 JVM 参数（容器环境优化）

- 限制堆内存：-Xmx512m（避免容器内存溢出）
- 启用容器内存感知：-XX:+UseContainerSupport（JDK 11+ 默认启用，自动适配容器内存限制）
- 无头模式强制：-Djava.awt.headless=true（在 headless 变体中已默认配置，避免 GUI 相关异常）


## 注意事项

### 版本选择建议
- 生产环境优先使用 LTS 版本（Java 11、17、21），避免非 LTS 版本（如 Java 25）的短期支持风险
- 避免依赖 latest 标签，建议指定具体版本（如 21.0.8-jre-ubuntu-jammy），确保环境一致性

### 基础镜像适配
- 若 Java 应用依赖 libfontconfig、libfreetype 等系统库（如生成 PDF/图片），优先选择 Ubuntu 镜像（可通过 apt install 安装依赖）
- Alpine 镜像需注意 musl libc 兼容性：若应用报错 NoClassDefFoundError 或 UnsatisfiedLinkError，可尝试添加 libc6-compat 包（apk add libc6-compat）模拟 glibc

### 权限管理
- Ubuntu 基础镜像默认创建 sapmachine 用户（UID 1000），建议使用该用户运行应用（避免 root 权限风险）
- Alpine 镜像默认使用 root 用户，可通过 RUN adduser -D myuser && su myuser 切换非 root 用户

### 安全更新
- 定期拉取最新标签镜像，SAP 会同步 OpenJDK 的安全补丁（如 Log4j、Deserialization 等漏洞修复）
- 生产环境建议使用镜像扫描工具（如 Trivy、Clair）检查潜在安全风险


## 许可信息

- **Dockerfile 及关联脚本**：遵循 Apache License 2.0 许可协议
- **SapMachine 核心组件**：遵循 GNU General Public License（GPL）Version 2，附带 CLASSPATH Exception——允许基于 SapMachine 构建商业应用，无需开源应用代码
- **基础镜像软件**：Ubuntu/Alpine 镜像中包含的系统组件（如 Bash、musl）遵循各自开源许可（如 MIT、Apache）

使用前请确保遵守所有包含软件的许可条款，商业场景需确认 GPLv2 Classpath Exception 的适用范围（详见 SapMachine 许可页面 https://sap.github.io/SapMachine/license.html）。

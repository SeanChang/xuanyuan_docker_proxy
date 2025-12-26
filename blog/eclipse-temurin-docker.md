---
id: 69
title: Eclipse Temurin OpenJDK Docker 容器化部署指南
slug: eclipse-temurin-docker
summary: Eclipse Temurin是由Eclipse Adoptium项目维护的开源Java开发工具包（JDK），提供经过Java SE TCK（Technology Compatibility Kit）认证的OpenJDK二进制分发版本。其设计目标是提供高性能、企业级、跨平台且符合开源许可的Java运行环境，广泛应用于企业级应用开发、服务端部署及嵌入式系统等场景。
category: Docker,OpenJDK,Eclipse Temurin
tags: openjdk,eclipse-temurin,nginx,docker,部署教程
image_name: library/eclipse-temurin
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-openjdk.png"
status: published
created_at: "2025-11-26 05:32:17"
updated_at: "2025-11-27 02:12:44"
---

# Eclipse Temurin OpenJDK Docker 容器化部署指南

> Eclipse Temurin是由Eclipse Adoptium项目维护的开源Java开发工具包（JDK），提供经过Java SE TCK（Technology Compatibility Kit）认证的OpenJDK二进制分发版本。其设计目标是提供高性能、企业级、跨平台且符合开源许可的Java运行环境，广泛应用于企业级应用开发、服务端部署及嵌入式系统等场景。

## 概述

Eclipse Temurin是由Eclipse Adoptium项目维护的开源Java开发工具包（JDK），提供经过Java SE TCK（Technology Compatibility Kit）认证的OpenJDK二进制分发版本。其设计目标是提供高性能、企业级、跨平台且符合开源许可的Java运行环境，广泛应用于企业级应用开发、服务端部署及嵌入式系统等场景。

通过Docker容器化部署Eclipse Temurin，可实现环境一致性、快速部署与扩展、资源隔离等优势，特别适合微服务架构及云原生应用场景。本文将详细介绍Eclipse Temurin Docker镜像的获取、部署、测试及生产环境优化方案，帮助用户快速实现容器化Java应用部署。


## 环境准备

### Docker环境安装

部署Eclipse Temurin容器前需确保服务器已安装Docker环境。推荐使用轩辕云提供的一键安装脚本，自动完成Docker引擎、Docker Compose及相关依赖的配置：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本执行完成后，可通过以下命令验证安装结果：

```bash
docker --version  # 验证Docker引擎版本
docker compose version  # 验证Docker Compose版本
```

如需验证加速配置是否生效，可查看Docker配置文件：

```bash
cat /etc/docker/daemon.json
```

正常情况下将包含`"registry-mirrors": ["https://xxx.xuanyuan.run"]`字段。


## 镜像准备

### 镜像拉取命令

```bash
docker pull xxx.xuanyuan.run/library/eclipse-temurin:{TAG}
```

其中`{TAG}`为镜像版本标签，推荐使用官方维护的稳定版本。本文以推荐标签`latest`为例，执行以下命令拉取最新版镜像：

```bash
docker pull xxx.xuanyuan.run/library/eclipse-temurin:latest
```

### 标签选择说明

Eclipse Temurin镜像提供多种标签，用于区分Java版本、操作系统基础镜像及功能特性，常见标签格式包括：
- **版本号标签**：如`21`（Java 21）、`17.0.10_7`（Java 17.0.10修订版7），指定具体Java版本。
- **操作系统变体**：如`21-jammy`（基于Ubuntu Jammy）、`21-alpine`（基于Alpine Linux，体积更小）。
- **JDK/JRE标识**：部分标签包含`-jdk`（完整JDK）或`-jre`（仅JRE运行时），如`21-jre-alpine`。

可通过[轩辕镜像标签列表](https://xuanyuan.cloud/r/library/eclipse-temurin/tags)查看所有可用标签，选择时需考虑：
- 生产环境建议使用具体版本标签（如`21.0.2_13-jdk`）而非`latest`，避免自动更新导致兼容性问题。
- 追求最小镜像体积可选择Alpine变体，但需注意Alpine使用musl libc，部分依赖glibc的应用可能需要适配。


## 容器部署

### 基础部署流程

#### 1. 验证镜像完整性

拉取完成后，通过`docker images`命令确认镜像存在：

```bash
docker images | grep eclipse-temurin
```

预期输出类似：
```
xxx.xuanyuan.run/library/eclipse-temurin   latest    abc12345   2 weeks ago   475MB
```

#### 2. 基本运行命令

以交互式方式运行容器，验证Java环境：

```bash
docker run -it --rm xxx.xuanyuan.run/library/eclipse-temurin:latest java -version
```

参数说明：
- `-it`：交互式终端，支持命令输入。
- `--rm`：容器退出后自动删除，避免残留临时容器。
- `java -version`：执行Java版本检查命令。

成功运行将输出Java版本信息，例如：
```
openjdk version "21.0.2" 2024-01-16 LTS
OpenJDK Runtime Environment Temurin-21.0.2+13 (build 21.0.2+13-LTS)
OpenJDK 64-Bit Server VM Temurin-21.0.2+13 (build 21.0.2+13-LTS, mixed mode, sharing)
```

### 典型应用场景部署

#### 场景1：运行本地JAR文件

将主机上的Java应用JAR文件挂载到容器中运行：

1. **准备测试JAR**（若无可跳过此步，使用容器内临时文件）：
   ```bash
   # 创建测试目录
   mkdir -p /opt/java-app && cd /opt/java-app
   # 生成简单Java应用（打印Hello World）
   cat > HelloWorld.java << 'EOF'
   public class HelloWorld {
       public static void main(String[] args) {
           System.out.println("Hello, Eclipse Temurin!");
           System.out.println("Java Version: " + System.getProperty("java.version"));
       }
   }
   EOF
   # 编译为JAR（需本地安装JDK或使用容器编译）
   docker run -v $(pwd):/app --rm xxx.xuanyuan.run/library/eclipse-temurin:latest javac /app/HelloWorld.java
   # 打包为JAR（简化示例，实际需MANIFEST.MF，此处直接运行class文件）
   ```

2. **运行JAR文件**：
   ```bash
   docker run -it --rm -v /opt/java-app:/opt/app xxx.xuanyuan.run/library/eclipse-temurin:latest \
     java -cp /opt/app HelloWorld
   ```

   参数说明：
   - `-v /opt/java-app:/opt/app`：将主机`/opt/java-app`目录挂载到容器`/opt/app`。
   - `-cp /opt/app`：指定Java类路径为挂载目录。
   - `HelloWorld`：执行编译后的HelloWorld类。

   预期输出：
   ```
   Hello, Eclipse Temurin!
   Java Version: 21.0.2
   ```

#### 场景2：作为基础镜像构建应用镜像

通过Dockerfile将Java应用与Eclipse Temurin基础镜像打包为独立镜像：

1. **创建Dockerfile**：
   ```dockerfile
   # 基础镜像使用Eclipse Temurin JDK
   FROM xxx.xuanyuan.run/library/eclipse-temurin:21-jdk-jammy
   
   # 设置工作目录
   WORKDIR /app
   
   # 复制应用JAR文件到容器（假设当前目录有app.jar）
   COPY app.jar /app/
   
   # 暴露应用端口（根据实际应用修改，如Spring Boot默认8080）
   EXPOSE 8080
   
   # 启动命令
   CMD ["java", "-jar", "app.jar"]
   ```

2. **构建并运行应用镜像**：
   ```bash
   # 构建镜像（当前目录包含Dockerfile和app.jar）
   docker build -t my-java-app:1.0 .
   
   # 运行应用容器，映射端口8080
   docker run -d -p 8080:8080 --name my-app my-java-app:1.0
   ```

### 高级部署配置

#### 1. 自定义JVM参数

通过环境变量`JAVA_TOOL_OPTIONS`或命令行参数调整JVM性能，例如设置堆内存大小：

```bash
docker run -d -p 8080:8080 \
  -e JAVA_TOOL_OPTIONS="-Xms512m -Xmx1024m -XX:+UseG1GC" \
  --name my-app my-java-app:1.0
```

#### 2. 添加自定义CA证书

如需信任内部CA证书，可通过挂载证书目录并设置`USE_SYSTEM_CA_CERTS`环境变量实现（非Windows镜像适用）：

```bash
# 主机准备证书目录，存放PEM格式.crt证书
mkdir -p /opt/certs && cp internal-ca.crt /opt/certs/

# 运行容器时挂载证书并启用处理
docker run -it --rm \
  -v /opt/certs:/certificates \
  -e USE_SYSTEM_CA_CERTS=1 \
  xxx.xuanyuan.run/library/eclipse-temurin:latest \
  keytool -list -keystore $JRE_CACERTS_PATH  # 验证证书已添加
```

#### 3. 非Root用户运行

为增强安全性，配置容器以非Root用户运行（需基础镜像支持，如Ubuntu变体）：

```dockerfile
FROM xxx.xuanyuan.run/library/eclipse-temurin:21-jdk-jammy

# 创建应用用户
RUN groupadd -r appuser && useradd -r -g appuser appuser

# 设置工作目录权限
WORKDIR /app
RUN chown -R appuser:appuser /app

# 切换到非Root用户
USER appuser

COPY app.jar /app/
CMD ["java", "-jar", "app.jar"]
```


## 功能测试

### 基础功能验证

1. **Java版本与环境检查**：
   ```bash
   docker run --rm xxx.xuanyuan.run/library/eclipse-temurin:latest \
     sh -c "java -version && javac -version && echo 'Java Home: $JAVA_HOME'"
   ```

   预期输出包含Java版本、javac编译器版本及`JAVA_HOME`路径（通常为`/opt/java/openjdk`）。

2. **JRE/JDK功能验证**：
   - 若使用JRE镜像，验证`javac`是否不可用（符合预期）：
     ```bash
     docker run --rm xxx.xuanyuan.run/library/eclipse-temurin:21-jre \
       sh -c "javac -version || echo 'JRE: javac not available'"
     ```
   - 若使用JDK镜像，验证编译器正常工作：
     ```bash
     docker run --rm -v $(pwd):/app xxx.xuanyuan.run/library/eclipse-temurin:21-jdk \
       javac /app/HelloWorld.java && echo "Compilation success"
     ```

### 应用兼容性测试

以Spring Boot应用为例，验证Eclipse Temurin运行环境兼容性：

1. **创建简单Spring Boot应用**（通过Spring Initializr生成，包含Web依赖）。
2. **打包为JAR**并构建Docker镜像（参考部署章节的Dockerfile）。
3. **运行并测试接口**：
   ```bash
   # 启动应用容器
   docker run -d -p 8080:8080 --name spring-app my-spring-app:1.0
   
   # 测试健康检查接口
   curl http://localhost:8080/actuator/health
   ```

   预期返回`{"status":"UP"}`，表明应用在Eclipse Temurin环境下正常运行。

### 特殊功能测试

1. **CA证书信任测试**：
   ```bash
   # 运行容器并添加自定义CA，测试HTTPS请求内部服务
   docker run --rm \
     -v /opt/certs:/certificates \
     -e USE_SYSTEM_CA_CERTS=1 \
     xxx.xuanyuan.run/library/eclipse-temurin:latest \
     curl -v https://internal-service.example.com  # 应成功建立TLS连接
   ```

2. **JLink自定义运行时测试**：
   ```bash
   # 使用JLink生成最小化JRE（多阶段构建示例）
   docker run --rm xxx.xuanyuan.run/library/eclipse-temurin:21-jdk \
     jlink --add-modules java.base,java.net.http --output /tmp/jre
   
   # 验证自定义JRE大小（通常小于完整JRE）
   du -sh /tmp/jre
   ```


## 生产环境建议

### 镜像选择与版本管理

1. **优先使用具体版本标签**：避免`latest`标签，明确指定Java版本和基础镜像，如`21.0.2_13-jdk-jammy`，确保部署一致性。
2. **选择稳定基础镜像**：生产环境推荐使用Ubuntu LTS变体（如`jammy`、`noble`），而非Alpine，以减少musl libc兼容性问题。
3. **定期更新镜像**：关注[轩辕镜像文档](https://xuanyuan.cloud/r/library/eclipse-temurin)获取安全更新，及时升级以修复漏洞。

### 资源限制与性能优化

1. **配置资源限制**：通过`--memory`、`--cpus`限制容器资源，避免资源争抢：
   ```bash
   docker run -d --name prod-app \
     --memory=2g --memory-swap=2g \  # 限制内存2GB
     --cpus=1.5 \                   # 限制CPU核心1.5个
     --restart=always \             # 自动重启策略
     my-java-app:1.0
   ```

2. **JVM参数优化**：根据应用特性调整JVM参数，例如：
   - 设置堆内存：`-Xms1g -Xmx1.5g`（初始1GB，最大1.5GB，避免频繁GC）。
   - 使用G1GC垃圾收集器：`-XX:+UseG1GC -XX:MaxGCPauseMillis=200`。
   - 启用JVM统计：`-XX:+PrintGCApplicationStoppedTime`（调试时使用）。

### 安全性增强

1. **非Root用户运行**：如部署章节示例，通过`USER`指令切换到非特权用户，限制容器权限。
2. **只读文件系统**：除必要目录外，以只读模式挂载文件系统，防止恶意写入：
   ```bash
   docker run -d --name secure-app \
     --read-only \
     -v /tmp:/tmp \  # 临时目录可写（JVM可能需要）
     -v /app/logs:/app/logs \  # 日志目录可写
     my-java-app:1.0
   ```

3. **禁用不必要功能**：通过`--cap-drop=ALL`移除Linux capabilities，仅保留必要权限：
   ```bash
   docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE  # 仅允许绑定端口
   ```

### 持久化与日志管理

1. **数据持久化**：关键数据（如配置文件、日志）通过Docker Volume或绑定挂载持久化到主机：
   ```bash
   docker volume create app-config  # 创建命名卷
   docker run -v app-config:/app/config my-java-app:1.0  # 挂载配置卷
   ```

2. **日志收集**：配置Docker日志驱动，将日志发送至集中化日志系统（如ELK、Promtail）：
   ```bash
   docker run -d --log-driver=json-file --log-opt max-size=10m --log-opt max-file=3 my-java-app:1.0
   ```

### 监控与健康检查

1. **健康检查配置**：通过`--health-cmd`定期检查应用状态，Docker自动重启异常容器：
   ```bash
   docker run -d --name monitored-app \
     --health-cmd "curl -f http://localhost:8080/actuator/health || exit 1" \
     --health-interval=30s \
     --health-timeout=10s \
     --health-retries=3 \
     my-java-app:1.0
   ```

2. **JVM监控集成**：暴露JMX端口或使用Prometheus+Micrometer监控JVM指标：
   ```bash
   docker run -d -p 9090:9090 \
     -e JAVA_TOOL_OPTIONS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9090 -Dcom.sun.management.jmxremote.rmi.port=9090 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=localhost" \
     my-java-app:1.0
   ```


## 故障排查

### 容器启动失败

1. **查看启动日志**：
   ```bash
   docker logs {容器ID/名称}  # 直接查看日志
   docker logs --tail=100 {容器ID/名称}  # 查看最后100行
   ```

2. **常见原因及解决**：
   - **JAR文件不存在**：检查Dockerfile中`COPY`指令路径是否正确，或挂载目录是否包含JAR。
   - **端口占用**：使用`docker ps`查看端口映射，确保主机端口未被占用，或通过`-p {主机端口}:{容器端口}`修改映射。
   - **权限问题**：非Root用户运行时，检查挂载目录权限是否允许应用用户访问，可通过`chown -R appuser:appuser /path`调整。

### JVM内存溢出（OOM）

1. **症状**：容器意外退出，日志中包含`java.lang.OutOfMemoryError`。
2. **排查步骤**：
   - 检查JVM内存配置：是否`-Xmx`设置过小，或容器内存限制低于JVM最大堆内存。
   - 分析堆转储文件：启用堆转储`-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/dump.hprof`，挂载`/tmp`目录获取文件后使用MAT工具分析。
3. **解决措施**：调整JVM堆大小（如`-Xmx2g`），或优化应用内存使用（减少对象创建、使用缓存等）。

### CA证书信任问题

1. **症状**：应用访问HTTPS服务时提示证书不受信任（`sun.security.validator.ValidatorException`）。
2. **排查步骤**：
   - 确认`USE_SYSTEM_CA_CERTS=1`环境变量已设置，且证书文件挂载到`/certificates`目录。
   - 非Root用户运行时，检查`JRE_CACERTS_PATH`环境变量是否存在，JVM是否通过`JAVA_TOOL_OPTIONS`使用该信任库。
3. **解决措施**：确保证书为PEM格式且扩展名为`.crt`，非Root环境下避免依赖系统CA store，直接使用`JRE_CACERTS_PATH`。

### 性能问题

1. **症状**：应用响应缓慢，CPU或内存使用率异常。
2. **排查工具**：
   - 使用`docker stats {容器ID}`实时查看容器资源使用。
   - 进入容器执行`jstat -gc {PID} 1000`监控GC情况（需容器内安装`jstat`，JDK镜像默认包含）。
3. **优化方向**：
   - 调整JVM垃圾收集器（如G1GC适合大堆，ZGC适合低延迟）。
   - 增加容器CPU/内存资源，或优化应用代码（减少同步阻塞、优化算法等）。


## 参考资源

1. **轩辕镜像文档**：[Eclipse Temurin镜像详情](https://xuanyuan.cloud/r/library/eclipse-temurin)
2. **轩辕镜像标签**：[所有可用版本标签](https://xuanyuan.cloud/r/library/eclipse-temurin/tags)
3. **官方项目资源**：
   - Eclipse Adoptium GitHub：[Adoptium/containers](https://github.com/adoptium/containers)（镜像构建脚本）
   - Adoptium支持：[Adoptium Slack](https://adoptium.net/slack)、[Adoptium Support Issues](https://github.com/adoptium/adoptium-support/issues)
4. **Docker官方文档**：[Docker Run参考](https://docs.docker.com/engine/reference/commandline/run/)
5. **Java性能优化**：[Java Platform, Standard Edition Tools Reference](https://docs.oracle.com/en/java/javase/21/docs/specs/man/index.html)


## 总结

本文详细介绍了Eclipse Temurin Docker容器化部署方案，从环境准备、镜像拉取、容器部署到功能测试，覆盖了开发与生产环境的关键步骤。通过Docker化部署，可充分利用Eclipse Temurin的企业级Java运行环境，实现应用的快速交付与稳定运行。

### 关键要点

- **环境准备**：使用轩辕一键脚本快速安装Docker并配置镜像访问支持，提升部署效率。
- **镜像拉取**：多段镜像名`library/eclipse-temurin`采用`docker pull xxx.xuanyuan.run/library/eclipse-temurin:{TAG}`格式，推荐使用具体版本标签确保稳定性。
- **容器部署**：支持基础运行、应用打包、自定义CA证书等场景，非Root用户运行和资源限制增强生产环境安全性。
- **故障排查**：通过日志分析、资源监控和JVM参数调整，解决启动失败、内存溢出等常见问题。

### 后续建议

- **深入学习Java优化**：结合应用特性调整JVM参数（如GC策略、堆大小），参考官方文档进行性能调优。
- **构建自动化流程**：集成CI/CD工具（如Jenkins、GitHub Actions），实现镜像自动构建、测试与部署。
- **监控体系建设**：部署Prometheus+Grafana监控JVM指标，结合ELK栈实现日志集中分析，提升问题排查效率。
- **版本管理策略**：建立镜像版本控制机制，定期更新基础镜像以获取安全补丁，同时通过灰度发布降低升级风险。

通过合理配置与最佳实践，Eclipse Temurin Docker镜像可为企业Java应用提供高效、可靠的运行环境，助力云原生架构落地与业务持续交付。


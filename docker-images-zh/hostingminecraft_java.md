---
image: hostingminecraft/java
description: "为hosting-minecraft.pro设计的Java镜像，提供预配置的Minecraft服务器运行环境，基于OpenJDK构建，支持主流Java版本，优化性能且易于部署。"
source: https://xuanyuan.cloud/zh/r/hostingminecraft/java
canonical: https://xuanyuan.cloud/zh/r/hostingminecraft/java
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hostingminecraft/java" title="hostingminecraft/java Docker 镜像中文简介、标签列表与拉取命令">hostingminecraft/java 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# hosting-minecraft.pro Java镜像

## 概述
本镜像为hosting-minecraft.pro平台设计，提供专用于Minecraft服务器及相关应用的Java运行环境。基于稳定的OpenJDK版本构建，确保与Minecraft服务端的兼容性，简化部署流程并优化运行性能。

## 特性
- **预配置环境**：集成Minecraft服务器所需的Java运行时依赖，无需手动配置JDK/JRE。
- **版本兼容性**：支持主流Java版本（如8、11、17），适配不同Minecraft服务端版本需求。
- **性能优化**：默认JVM参数针对Minecraft服务器负载优化，减少内存占用并提升响应速度。
- **轻量级基础**：基于Alpine或Debian Slim镜像，减小镜像体积，加快拉取速度。
- **灵活部署**：支持Docker Compose、Kubernetes等编排工具，便于规模化管理。

## 使用方法
### 基本部署示例
通过以下命令快速启动一个Minecraft服务器容器：
```bash
docker run -d \
  --name minecraft-server \
  -p 25565:25565 \
  -v /path/to/local/data:/data \
  -e JAVA_OPTS="-Xmx2G -Xms1G" \
  hosting-minecraft.pro/java:latest
```

### 参数说明
- `-p 25565:25565`：映射Minecraft默认端口。
- `-v /path/to/local/data:/data`：挂载本地目录到容器内`/data`，持久化服务器数据。
- `-e JAVA_OPTS`：自定义JVM参数（如内存分配），根据服务器规模调整。

## 注意事项
1. **数据持久化**：务必挂载`/data`目录，避免容器重启导致数据丢失。
2. **版本选择**：根据Minecraft服务端版本选择对应Java镜像标签（如`java:17`对应Java 17）。
3. **安全更新**：定期拉取最新镜像以获取Java安全补丁及性能优化。

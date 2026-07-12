---
image: cleanstart/busybox
description: "安全加固的最小化基础操作系统，集成BusyBox的300+常用Linux命令，为企业容器化环境提供轻量级、高效的基础，适用于最小容器基础镜像、生产环境调试及资源受限场景的系统工具。"
source: https://xuanyuan.cloud/zh/r/cleanstart/busybox
canonical: https://xuanyuan.cloud/zh/r/cleanstart/busybox
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cleanstart/busybox" title="cleanstart/busybox Docker 镜像中文简介、标签列表与拉取命令">cleanstart/busybox 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CleanStart Busybox 容器镜像

**CleanStart Busybox容器**基于BusyBox构建，后者将众多常见UNIX工具整合为单个小型可执行文件，提供完整的环境支持，包含300多个常用Linux命令，被誉为“嵌入式Linux的瑞士军刀”，是容器化应用的最小化基础。

📌 **CleanStart基础**：安全加固的最小化基础操作系统，专为企业容器化环境设计。

## 核心功能

* 极小体积（不足2MB），包含完整的Unix工具集
* 单二进制文件实现常见Unix工具
* 支持300多个常用Linux命令
* 针对嵌入式和容器化环境优化

## 常见使用场景

* 最小化容器的基础镜像
* 生产环境中的调试与故障排查
* 资源受限环境中的系统工具
* 嵌入式系统的测试与开发

## 快速开始

### 拉取命令

从镜像仓库下载BusyBox容器镜像

```bash
docker pull docker.xuanyuan.run/cleanstart/busybox:latest
docker pull docker.xuanyuan.run/cleanstart/busybox:latest-dev
```

### 基础生产部署

采用推荐安全设置的标准生产部署

```bash
docker run -d --name busybox-test \
  --read-only \
  --security-opt=no-new-privileges \
  --user 1000:1000 \
  docker.xuanyuan.run/cleanstart/busybox:latest sleep infinity
```

### 开发/测试环境

具备调试能力的开发环境设置

```bash
docker run -it --privileged docker.xuanyuan.run/cleanstart/busybox:latest-dev /bin/sh
```

### Docker Compose配置

生产就绪的Docker Compose配置

```yaml
version: '3.8'
services:
  busybox:
    image: docker.xuanyuan.run/cleanstart/busybox:latest
    container_name: busybox
    restart: unless-stopped
    volumes:
      - /tmp:/tmp
    security_opt:
      - no-new-privileges:true
    read_only: true
    tmpfs:
      - /tmp
```

## 配置

### 环境变量

| 变量名 | 默认值 | 描述 |
|--------|--------|------|
| PATH | /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin | 系统PATH配置 |
| BUSYBOX_VERSION | 1.36.1 | BusyBox安装版本 |

## 安全与最佳实践

### 推荐安全上下文

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 1000
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  capabilities:
    drop: ['ALL']
```

### 最佳实践

* 生产环境使用特定镜像标签（避免使用latest）
* 配置资源限制：内存和CPU约束
* 尽可能启用只读根文件系统
* 使用非root用户运行容器（--user 1000:1000）
* 使用--security-opt=no-new-privileges标志
* 定期更新容器镜像以获取安全补丁
* 实施适当的网络分段
* 监控容器指标以检测异常

## 架构支持

### 多平台镜像

拉取特定架构的镜像

```bash
docker pull --platform linux/amd64 cleanstart/busybox:latest
docker pull --platform linux/arm64 cleanstart/busybox:latest
```

## 资源与文档

- **CleanStart社区镜像**：[https://hub.docker.com/u/cleanstart](https://hub.docker.com/u/cleanstart)  
- **CleanStart镜像运行指南及示例项目**：[https://github.com/cleanstart-dev/cleanstart-containers](https://github.com/cleanstart-dev/cleanstart-containers)  
- **CleanStart官网**：[https://www.cleanstart.com](https://www.cleanstart.com)  
- **BusyBox文档**：[https://busybox.net/downloads/BusyBox.html](https://busybox.net/downloads/BusyBox.html)  


## 漏洞免责声明

CleanStart提供的Docker镜像包含由独立贡献者维护的第三方开源库和软件包。尽管CleanStart维护这些镜像并应用行业标准安全实践，但无法保证其控制范围之外的上游组件的安全性或完整性。

用户确认并同意，开源软件可能包含未发现的漏洞，或通过更新引入新风险。对于源自第三方库的安全问题，包括但不限于零日漏洞、供应链攻击或贡献者引入的风险，CleanStart不承担责任。

安全是共同责任：CleanStart会在可能的情况下提供更新的镜像和指导，而用户负责评估部署并实施适当的控制措施。

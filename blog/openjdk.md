# 重要通知：官方 OpenJDK 镜像已正式弃用，建议立即迁移至轩辕镜像支持的替代方案

![重要通知：官方 OpenJDK 镜像已正式弃用，建议立即迁移至轩辕镜像支持的替代方案](https://img.xuanyuan.dev/docker/blog/docker-openjdk-2026.png)

*分类: OpenJDK,公告,Docker,jdk | 标签: OpenJDK,公告,Docker,,jdk | 发布时间: 2026-02-23 13:00:16*

> 为保障您的容器化 Java 应用安全与稳定性，特此提醒：Docker 官方库中的 OpenJDK 镜像（library/openjdk）已正式弃用，轩辕镜像平台同步更新了该镜像的状态标识，即日起请您尽快停止在生产环境中使用，并迁移至受支持的替代方案。

为保障您的容器化 Java 应用安全与稳定性，特此提醒：**Docker 官方库中的 OpenJDK 镜像（library/openjdk）已正式弃用**，轩辕镜像平台同步更新了该镜像的状态标识，即日起请您尽快停止在生产环境中使用，并迁移至受支持的替代方案。

## 弃用背景与核心时间线
此次弃用源于 2022 年 6 月 Red Hat 发布的官方公告：OpenJDK 项目将停止为 JDK 8u 与 JDK 11u 提供社区构建版本，2022 年 7 月的 CPU 更新（11.0.16 与 8u342）成为最后一批维护版本。

基于此，Docker 官方库于 2022 年 7 月完成弃用流程，目前该镜像仅保留**早期访问版（Early Access builds）** 标签的更新（源码来自 jdk.java.net）—— 因主流替代项目均不支持此类预览版本，这也是唯一仍在更新的部分。

对于生产环境依赖的 JDK 8、11 等长期支持版本，继续使用原 OpenJDK 镜像将导致**无法获取安全补丁、漏洞修复与兼容性更新**，存在严重的业务风险。

## 轩辕镜像支持的官方替代方案
为降低迁移成本，轩辕镜像已同步缓存并维护以下 Docker 官方推荐替代镜像（按字母顺序排列，无优先级暗示），覆盖全平台架构与企业级需求，您可直接通过轩辕镜像域名拉取，享受国内专属访问体验：

| 替代镜像名称 | 轩辕镜像拉取地址 | 核心优势 |
| :--- | :--- | :--- |
| Amazon Corretto | https://xuanyuan.cloud/r/library/amazoncorretto | AWS 官方维护，免费长期支持，适配云原生环境 |
| Eclipse Temurin | https://xuanyuan.cloud/r/library/eclipse-temurin | Eclipse Adoptium 项目出品，全平台兼容（含 arm64、riscv64），JCK 认证，企业级首选 |
| IBM Semeru Runtimes | https://xuanyuan.cloud/r/library/ibm-semeru-runtimes | IBM 维护，基于 OpenJ9 构建，轻量高性能、低内存占用 |
| IBM Java | https://xuanyuan.cloud/r/library/ibmjava | 经典 IBM JDK 发行版，适配传统企业应用，擅长高并发、低内存占用场景 |
| SAP Machine | https://xuanyuan.cloud/r/library/sapmachine | SAP 官方维护，针对企业级 Java 应用优化，适配 SAP 自研系统与微服务场景 |

### 快速迁移示例（以 Eclipse Temurin 为例）
原拉取命令（已弃用）：
```bash
docker pull openjdk:8-jdk
```
替换为 Eclipse Temurin 轩辕镜像标准拉取命令：
```bash
# 生产环境推荐：JDK 8
docker pull docker.xuanyuan.run/library/eclipse-temurin:8-jdk
# 生产环境推荐：JDK 11（LTS）
docker pull docker.xuanyuan.run/library/eclipse-temurin:11-jdk
# 最新稳定版：JDK 21（LTS）
docker pull docker.xuanyuan.run/library/eclipse-temurin:21-jdk
```
其他替代镜像可自行查看镜像详情页相关标签。

## 迁移建议与最佳实践
1. **优先选择 LTS 版本**：生产环境请使用 JDK 8、11、21 等长期支持版本，避免使用非 LTS 版本以获得更长的维护周期。
2. **优先推荐 Eclipse Temurin**：作为 Docker 官方库后续默认的 OpenJDK 替代方案，其跨平台兼容性最强，社区活跃度高，是绝大多数应用的最优选择。
3. **全面排查依赖**：请梳理 CI/CD 流水线、Dockerfile、Kubernetes 部署清单等所有引用 `openjdk` 镜像的位置，批量替换为选定的替代镜像。
4. **测试兼容性**：迁移前在测试环境完成功能测试与性能验证，确保应用与新镜像的依赖库、系统参数完全兼容。
5. **启用专属加速**：轩辕镜像为所有替代镜像提供国内专属访问优化，专业版用户可获得专属加速地址，显著提升镜像拉取速度，优化 CI/CD 流程整体效率。

**轩辕镜像团队**
2026 年 2 月 23 日


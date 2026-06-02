<!-- xuanyuan-docker-images-zh
image: ymlisoft/kkfileview
source: https://xuanyuan.cloud/zh/r/ymlisoft/kkfileview
canonical: https://xuanyuan.cloud/zh/r/ymlisoft/kkfileview
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/ymlisoft/kkfileview" title="ymlisoft/kkfileview Docker 镜像中文简介、标签列表与拉取命令">ymlisoft/kkfileview — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/ymlisoft/kkfileview" title="ymlisoft/kkfileview Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ymlisoft/kkfileview</a></p>

# 升级Docker镜像文档（基于4.4.0版本）

## 镜像概述和主要用途
本Docker镜像是基于4.4.0版本的升级版本，旨在通过核心组件升级、依赖管理优化和资源清理，提升应用的性能、安全性及可维护性。主要适用于原使用4.4.0版本镜像的场景，需增强JVM配置灵活性、修复安全漏洞或解决依赖冲突的用户。

## 核心功能和特性
- **JDK版本升级**：升级至JDK 21，新增支持通过百分比配置JVM参数（如堆内存占比），提升资源配置灵活性。
- **Spring Boot版本升级**：升级至3.4版本，有效消除高危安全漏洞，增强应用部署的安全性。
- **pom依赖优化**：升级可更新的pom依赖，解决原有依赖冲突问题，提升项目依赖管理的稳定性。
- **项目资源清理**：删除项目自用图片及个人信息，减少镜像体积，避免敏感信息泄露。

## 使用场景和适用范围
- **原4.4.0版本用户**：需提升JVM配置灵活性（如百分比配置JVM参数）的应用部署场景。
- **安全合规需求**：存在Spring Boot高危漏洞风险，需满足安全合规要求的生产环境部署。
- **依赖冲突解决**：项目中存在依赖冲突问题，需通过升级pom依赖解决的开发或生产环境。
- **资源清理需求**：需移除项目自用图片、个人信息等非必要资源，优化镜像内容的场景。

## 详细使用方法和配置说明

### 基本使用
本镜像基于4.4.0版本升级，使用方式与原版本基本一致，可直接替换镜像版本标签进行部署。

#### Docker Run部署示例
```bash
docker run -d --name [自定义容器名称] [镜像名称]:[升级版本标签]
```

#### Docker Compose部署示例
```yaml
version: '3'
services:
  app:
    image: [镜像名称]:[升级版本标签]
    container_name: [自定义容器名称]
    # 其他配置（如端口映射、环境变量等）与原4.4.0版本保持一致
```

### JVM配置优化（新增特性）
因升级至JDK 21，支持通过百分比配置JVM参数，可在启动命令中添加相关参数，示例如下：
```bash
# 将JVM最大堆内存和初始堆内存均设置为容器可用内存的50%
docker run -d --name [自定义容器名称] [镜像名称]:[升级版本标签] -Xmx50% -Xms50%
```

### 注意事项
- **资源依赖检查**：镜像已删除项目自用图片及个人信息，若原应用依赖相关资源，需确保外部资源已提前配置，避免运行异常。
- **兼容性测试**：Spring Boot升级至3.4可能存在少量API变更，建议部署前进行兼容性测试，确保应用与新版本框架兼容。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/ymlisoft/kkfileview" title="ymlisoft/kkfileview Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/ymlisoft/kkfileview</a></p>

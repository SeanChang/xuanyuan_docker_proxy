<!-- xuanyuan-docker-images-zh
image: cleanstart/jdk
source: https://xuanyuan.cloud/zh/r/cleanstart/jdk
canonical: https://xuanyuan.cloud/zh/r/cleanstart/jdk
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [cleanstart/jdk — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/cleanstart/jdk "cleanstart/jdk Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/cleanstart/jdk

# CleanStart JDK容器镜像

## 镜像概述和主要用途

企业级Java开发工具包(JDK)容器镜像，提供完整的Java应用开发和运行环境。基于OpenJDK构建，包含企业Java开发所需的 essential 开发工具、调试功能和安全特性。针对云原生应用优化，具有轻量级和增强的安全控制。

📌 **CleanStart基础**：为企业容器化环境设计的安全加固、轻量级基础操作系统。

## 核心功能和特性

* 完整的Java开发和运行环境
* 针对云原生应用优化
* 内置调试和分析工具
* 增强的安全特性，包含漏洞扫描

## 使用场景和适用范围

* 企业Java应用开发
* 微服务部署
* 云原生Java应用
* CI/CD流水线Java构建

## 详细使用方法和配置说明

### 快速开始

#### 拉取最新镜像

从镜像仓库下载容器镜像

```bash
docker pull cleanstart/jdk:latest
docker pull cleanstart/jdk:latest-dev
```

#### 基本运行

使用基本配置运行容器

```bash
docker run -it --name jdk-test cleanstart/jdk:latest-dev
```

#### 生产环境部署

使用生产环境安全设置部署

```bash
docker run -d --name jdk-prod \
  --read-only \
  --security-opt=no-new-privileges \
  --user 1000:1000 \
  cleanstart/jdk:latest
```

#### 用于卷挂载的小型项目示例

```bash
cat > jdk-test/HelloWorld.java << 'EOF'
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello from JDK Container!");
        System.out.println("Java version: " + System.getProperty("java.version"));
        System.out.println("Java vendor: " + System.getProperty("java.vendor"));
    }
}
EOF
```

#### 卷挂载

挂载本地目录以实现数据持久化

```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/jdk:latest $(which javac) jdk-test/HelloWorld.java
```

### 配置

#### 环境变量

| 变量名 | 默认值 | 描述 |
|----------|---------|-------------|
| PATH | /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin | 系统PATH配置 |
| JAVA_HOME | /usr/local/openjdk | Java安装目录 |
| JAVA_VERSION | 17 | Java版本号 |

### 安全与最佳实践

#### 推荐的安全上下文

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

#### 最佳实践

* 生产环境使用特定镜像标签（避免使用latest）
* 配置资源限制：内存和CPU约束
* 尽可能启用只读根文件系统
* 使用非root用户运行容器（--user 1000:1000）
* 使用--security-opt=no-new-privileges标志
* 定期更新容器镜像以获取安全补丁
* 实施适当的网络分段
* 监控容器指标以检测异常

### 架构支持

#### 多平台镜像

```bash
docker pull --platform linux/amd64 cleanstart/jdk:latest
docker pull --platform linux/arm64 cleanstart/jdk:latest
```

## 资源与文档

- **CleanStart官网**：[https://www.cleanstart.com](https://www.cleanstart.com)  
- **OpenJDK文档**：[https://openjdk.org/docs](https://openjdk.org/docs)  
- **CleanStart社区镜像**：[https://hub.docker.com/u/cleanstart](https://hub.docker.com/u/cleanstart)  
- **CleanStart企业镜像**：[https://images.cleanstart.com/](https://images.cleanstart.com/)
- **在CleanStart GitHub仓库获取更多CleanStart镜像信息** [https://github.com/clnstrt/cleanstart-containers/tree/main/containers](https://github.com/clnstrt/cleanstart-containers/tree/main/containers)，  
  * 如何使用Dockerfile运行示例项目  
  * 如何通过Kubernetes YAML部署  
  * 如何从公共镜像迁移到CleanStart镜像

---

## 漏洞免责声明

CleanStart提供的Docker镜像包含由独立贡献者维护的第三方开源库和包。尽管CleanStart维护这些镜像并应用行业标准的安全实践，但无法保证超出其控制范围的上游组件的安全性或完整性。

用户承认并同意，开源软件可能包含未发现的漏洞，或通过更新引入新的风险。对于源自第三方库的安全问题，包括但不限于零日漏洞、供应链攻击或贡献者引入的风险，CleanStart不承担责任。

安全是共同的责任：CleanStart在可能的情况下提供更新的镜像和指导，而用户负责评估部署并实施适当的控制措施。

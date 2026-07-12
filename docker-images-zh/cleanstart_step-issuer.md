---
image: cleanstart/step-issuer
description: "Step-issuer是使用step-ca证书颁发机构进行自动化证书颁发和管理的专用容器，提供X.509证书自动配置、续订和吊销功能，集成ACME协议，适用于企业PKI基础设施。"
source: https://xuanyuan.cloud/zh/r/cleanstart/step-issuer
canonical: https://xuanyuan.cloud/zh/r/cleanstart/step-issuer
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cleanstart/step-issuer" title="cleanstart/step-issuer Docker 镜像中文简介、标签列表与拉取命令">cleanstart/step-issuer 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Step-Issuer 容器文档

## 镜像概述和主要用途
Step-issuer是一款专用容器，用于通过step-ca证书颁发机构实现自动化证书颁发和管理。它为企业PKI基础设施提供X.509证书的自动配置、续订和吊销能力，集成主流证书颁发机构并支持ACME协议自动化操作。

📌 **基础镜像**：基于Cleanstart Registry提供的安全强化、最小化基础操作系统，专为企业容器化环境设计。

## 核心功能和特性
### 核心能力与优势
- 自动化X.509证书颁发与续订
- 支持ACME协议实现证书自动化
- 与step-ca证书颁发机构集成
- 企业PKI基础设施管理

## 使用场景和适用范围
### 典型应用场景
- Web服务的自动化证书管理
- PKI基础设施自动化
- TLS证书部署自动化
- 零信任安全实施

## 使用方法和配置说明

### 拉取最新镜像
从镜像仓库下载容器镜像：

```bash
docker pull docker.xuanyuan.run/cleanstart/step-issuer:latest
```

开发版本：
```bash
docker pull docker.xuanyuan.run/cleanstart/step-issuer:latest-dev
```

### 基本运行
使用基础配置运行容器入口点：

```bash
docker run -it --entrypoint /bin/bash --name step-issuerrrrr-testsss docker.xuanyuan.run/cleanstart/step-issuer:latest-dev
```

### 生产环境部署
使用生产安全设置部署：

```bash
docker run -d --name step-issuer-prod \
  --read-only \
  --security-opt=no-new-privileges \
  --user 1000:1000 \
  docker.xuanyuan.run/cleanstart/step-issuer:latest
```

### 环境变量
通过环境变量进行配置的选项：

| 变量名 | 默认值 | 描述 |
|----------|---------|-------------|
| STEP_CA_URL | https://ca.example.com | Step CA服务器URL |
| STEP_ROOT_FILE | /certs/root_ca.crt | 根CA证书路径 |
| STEP_PROVISIONER_NAME | acme | 证书颁发的配置器名称 |
| STEP_RENEWAL_INTERVAL | 24h | 证书续订间隔 |

### 安全最佳实践
推荐的安全配置和实践：
- 使用适当的文件权限保护私钥
- 为证书存储使用独立卷
- 实施适当的证书管理访问控制
- 定期轮换配置器凭据
- 监控证书过期和续订事件
- 使用安全通信通道进行CA交互
- 实施适当的证书备份程序
- 定期对证书使用情况进行安全审计

### Kubernetes安全上下文
Kubernetes部署的推荐安全上下文：

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 1000
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  capabilities:
    drop: ["ALL"]
```

### 多平台镜像

```bash
# AMD64架构
docker pull --platform linux/amd64 cleanstart/step-issuer:latest

# ARM64架构
docker pull --platform linux/arm64 cleanstart/step-issuer:latest
```

## 文档资源
重要链接和参考资源：
- **容器仓库**：https://cleanstart.com
- **官方文档**：https://smallstep.com/docs/certificate-manager/kubernetes-tls/kubernetes-step-issuer/
- **CleanStart社区镜像**：https://hub.docker.com/u/cleanstart
- **如何运行CleanStart镜像及示例项目**：https://github.com/cleanstart-dev/cleanstart-containers
  * 使用Dockerfile运行示例项目
  * 通过Kubernetes YAML部署
  * 从公共镜像迁移到CleanStart镜像

---

## 漏洞免责声明

CleanStart提供的Docker镜像包含由独立贡献者维护的第三方开源库和软件包。尽管CleanStart维护这些镜像并应用行业标准安全实践，但无法保证其控制范围之外的上游组件的安全性或完整性。

用户确认并同意，开源软件可能包含未发现的漏洞，或通过更新引入新风险。对于源自第三方库的安全问题，包括但不限于零日漏洞、供应链攻击或贡献者引入的风险，CleanStart不承担责任。

安全是共同责任：CleanStart在可能的情况下提供更新的镜像和指导，而用户负责评估部署并实施适当的控制措施。

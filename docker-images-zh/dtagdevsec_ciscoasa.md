<!-- xuanyuan-docker-images-zh
image: dtagdevsec/ciscoasa
source: https://xuanyuan.cloud/zh/r/dtagdevsec/ciscoasa
canonical: https://xuanyuan.cloud/zh/r/dtagdevsec/ciscoasa
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/dtagdevsec/ciscoasa" title="dtagdevsec/ciscoasa Docker 镜像中文简介、标签列表与拉取命令">dtagdevsec/ciscoasa — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/dtagdevsec/ciscoasa" title="dtagdevsec/ciscoasa Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/dtagdevsec/ciscoasa</a></p>

# T-Pot Cisco ASA Honeypot 镜像文档

## 镜像概述
该镜像为[T-Pot - 一体化多蜜罐平台](https://github.com/telekom-security/tpotce)的组件之一，专门模拟Cisco ASA防火墙服务。通过模仿真实Cisco ASA设备的网络行为（如开放服务端口、响应模式），吸引潜在攻击者并记录其攻击活动，为网络安全监控、威胁情报收集提供数据支持。

## 核心功能与特性
- **服务模拟**：精准复现Cisco ASA防火墙的典型服务，包括SSH管理接口、HTTP/HTTPS配置页面及相关网络协议响应
- **攻击捕获**：记录攻击者的IP地址、端口扫描行为、认证尝试（如用户名/密码暴力破解）及命令执行操作
- **日志集成**：与T-Pot平台的集中日志系统无缝对接，支持攻击数据的统一存储、检索与分析
- **轻量部署**：基于Docker容器化设计，资源占用低，可快速集成至现有T-Pot环境或独立部署

## 使用场景与适用范围
- **企业安全监控**：部署于网络边界或内部网段，检测针对网络设备的定向攻击
- **威胁情报研究**：收集针对Cisco设备的攻击样本、恶意 payload 及攻击手法，生成威胁情报
- **安全培训教育**：为网络安全人员提供模拟攻击环境，实践攻击检测与响应能力
- **攻防演练**：在红队/蓝队对抗中作为目标节点，验证防御体系对设备攻击的检测有效性

## 使用方法与配置说明

### 前提条件
- 已安装Docker Engine（20.10+）及Docker Compose
- 已部署T-Pot平台（推荐通过官方脚本安装，详情见T-Pot文档）

### 部署方式
#### 作为T-Pot平台组件部署
通过T-Pot官方安装流程自动集成，无需单独配置。具体步骤参考：
```bash
# T-Pot官方部署脚本（仅示例，以最新文档为准）
git clone https://github.com/telekom-security/tpotce.git
cd tpotce
sudo ./install.sh
```

#### 独立测试部署
如需单独验证功能，可通过以下Docker命令快速启动（仅用于测试，生产环境建议通过T-Pot平台部署）：
```bash
docker run -d \
  --name tpot-cisco-asa \
  -p 2222:22 \    # 映射SSH服务端口（宿主机:容器）
  -p 8080:80 \    # 映射HTTP配置页面端口
  -v /path/to/logs:/var/log/tpot \  # 挂载日志目录（持久化存储攻击记录）
  --restart unless-stopped \
  telekomsecurity/tpot-cisco-asa
```

### 关键配置参数
| 参数类型       | 说明                                                                 | 示例值                  |
|----------------|----------------------------------------------------------------------|-------------------------|
| 端口映射       | 需映射容器内模拟服务端口至宿主机，建议使用非标准端口避免冲突         | `-p 2222:22 -p 8443:443` |
| 日志挂载       | 指定宿主机目录用于持久化存储攻击日志，需确保目录权限（777或容器用户可写） | `-v /opt/tpot/logs:/var/log/tpot` |
| 环境变量       | 可通过`-e`调整运行参数，如日志级别、时区等（具体参考T-Pot配置文档） | `-e LOG_LEVEL=DEBUG -e TZ=Asia/Shanghai` |

## 注意事项
- **合规性**：部署前需确保符合当地法律法规，仅用于授权的安全测试与监控场景
- **资源规划**：根据预期攻击流量调整宿主机资源，建议最低配置：1 CPU核心、2GB内存、20GB存储空间
- **更新维护**：定期通过T-Pot平台更新机制升级镜像，以获取最新的服务模拟规则和安全修复
- **日志管理**：攻击日志需定期归档，避免存储空间耗尽，建议配置日志轮转策略（如logrotate）

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/dtagdevsec/ciscoasa" title="dtagdevsec/ciscoasa Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/dtagdevsec/ciscoasa</a></p>

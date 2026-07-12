---
image: istio/examples-bookinfo-mongodb
description: "此镜像用于Istio示例，支持Istio服务网格的示例部署与演示。"
source: https://xuanyuan.cloud/zh/r/istio/examples-bookinfo-mongodb
canonical: https://xuanyuan.cloud/zh/r/istio/examples-bookinfo-mongodb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/istio/examples-bookinfo-mongodb" title="istio/examples-bookinfo-mongodb Docker 镜像中文简介、标签列表与拉取命令">istio/examples-bookinfo-mongodb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Istio示例镜像

## 镜像概述
该Docker镜像专为Istio服务网格的示例部署和演示设计。Istio是一个开源服务网格平台，提供流量管理、安全通信、可观测性等核心功能。此镜像包含运行Istio官方示例所需的基础组件和配置，旨在简化Istio功能的学习、测试与演示过程。

## 核心功能与特性
- 提供Istio官方示例的运行环境支持
- 包含与Istio控制平面交互的示例应用配置
- 简化Istio核心特性（如流量路由、故障注入、服务间通信加密）的演示流程

## 使用场景与适用范围
- Istio初学者学习服务网格基本概念和功能
- 开发人员演示Istio的流量管理、服务发现、监控等特性
- 测试环境中快速部署Istio示例应用以验证配置正确性

## 使用方法与配置说明

### 前提条件
- 已安装Docker环境
- 已部署Istio控制平面（参考[Istio官方入门指南](https://istio.io/latest/docs/setup/getting-started/)）

### 获取镜像
通过Docker Hub或Istio官方镜像仓库拉取该镜像：
```bash
docker pull docker.xuanyuan.run/istio/samples  # 实际镜像名称可能因具体示例而异，建议参考官方文档确认
```

### 运行示例应用
1. **部署Istio控制平面**  
   按照官方指南完成Istio控制平面部署：
   ```bash
   istioctl install --set profile=demo -y
   ```

2. **部署示例应用**  
   使用该镜像部署Istio官方示例（以Bookinfo示例为例）：
   ```bash
   kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
   ```

3. **访问示例服务**  
   获取示例服务的访问地址并验证功能：
   ```bash
   export GATEWAY_URL=$(kubectl get svc istio-ingressgateway -n istio-system -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
   curl http://$GATEWAY_URL/productpage
   ```

### 注意事项
- 示例镜像的具体使用方法可能因Istio版本不同而有所差异，请务必参考对应版本的[Istio官方文档](https://istio.io/latest/docs/setup/getting-started/)
- 部分示例可能需要额外配置服务网格规则（如虚拟服务、目标规则），详情参见示例配套文档
- 生产环境中不建议直接使用示例镜像，需根据实际需求进行定制化配置

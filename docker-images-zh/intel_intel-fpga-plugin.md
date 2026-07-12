---
image: intel/intel-fpga-plugin
description: "适用于Kubernetes的Intel FPGA设备插件，用于在Kubernetes集群中管理和调度Intel FPGA设备资源，支持容器化应用访问FPGA硬件加速。"
source: https://xuanyuan.cloud/zh/r/intel/intel-fpga-plugin
canonical: https://xuanyuan.cloud/zh/r/intel/intel-fpga-plugin
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/intel/intel-fpga-plugin" title="intel/intel-fpga-plugin Docker 镜像中文简介、标签列表与拉取命令">intel/intel-fpga-plugin 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Intel FPGA设备插件（Kubernetes）

## 镜像概述

Intel FPGA设备插件是专为Kubernetes设计的组件，用于在Kubernetes集群中发现、管理和暴露Intel FPGA设备资源，使容器化应用能够便捷地访问和利用FPGA硬件加速能力。该插件遵循Kubernetes设备插件框架规范，实现FPGA设备与Kubernetes集群的无缝集成。

## 核心功能与特性

- **自动设备发现**：识别节点上的Intel FPGA设备及其属性信息（如设备ID、功能配置等）；
- **资源上报**：将FPGA设备资源以自定义资源类型（如`intel.com/fpga`）上报至Kubernetes API服务器；
- **调度与隔离**：支持Kubernetes调度器基于FPGA资源需求进行Pod调度，并通过设备插件机制实现设备级资源隔离；
- **API兼容性**：遵循Kubernetes设备插件v1beta1 API规范，兼容主流Kubernetes版本（通常需v1.18及以上）。

## 使用场景与适用范围

### 适用场景
- AI推理与深度学习加速
- 实时数据处理与信号分析
- 高性能计算（HPC）
- 网络功能虚拟化（NFV）

### 环境要求
- Kubernetes集群（v1.18+）
- 节点配备Intel FPGA设备（如Arria、Stratix系列）
- 节点已安装Intel FPGA驱动及工具链（如Intel FPGA Software Suite）
- 集群已启用DevicePlugins功能（默认启用）

## 使用方法与配置说明

### 部署方式

推荐通过DaemonSet部署，确保每个节点运行设备插件实例。详细部署配置可参考官方GitHub仓库：

[Intel Device Plugins for Kubernetes - FPGA插件](https://github.com/intel/intel-device-plugins-for-kubernetes/tree/main/fpga)

### 基本配置步骤

1. **克隆仓库**
   ```bash
   git clone https://github.com/intel/intel-device-plugins-for-kubernetes.git
   cd intel-device-plugins-for-kubernetes/fpga
   ```

2. **部署设备插件**
   根据FPGA设备类型（如PCIe或集成式）选择对应的部署文件，例如：
   ```bash
   kubectl apply -f deployments/fpga_plugin.yaml
   ```

3. **验证部署**
   检查DaemonSet状态：
   ```bash
   kubectl get daemonset intel-fpga-plugin -n kube-system
   ```

   查看节点资源上报情况：
   ```bash
   kubectl describe node <node-name> | grep "intel.com/fpga"
   ```

### 应用示例

创建使用FPGA资源的Pod，需在Pod规格中声明FPGA资源需求：
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: fpga-accelerated-app
spec:
  containers:
  - name: app
    image: docker.xuanyuan.run/your-fpga-app-image
    resources:
      limits:
        intel.com/fpga: 1  # 请求1个FPGA设备
```

### 获取更多信息

完整的配置选项、参数说明及故障排查指南，请参考官方文档：  
[Intel FPGA Device Plugin Documentation](https://github.com/intel/intel-device-plugins-for-kubernetes/blob/main/fpga/README.md)

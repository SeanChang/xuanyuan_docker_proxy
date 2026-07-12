---
image: dyrnq/nfs-subdir-external-provisioner
description: "k8s.gcr.io/sig-storage/nfs-subdir-external-provisioner是Kubernetes官方容器仓库中由存储特别兴趣小组（sig-storage）维护的NFS子目录外部供应器，它通过NFS网络文件系统的子目录机制，为Kubernetes集群动态创建和管理持久化存储卷（PVC），帮助用户灵活利用NFS存储资源，满足容器化应用对持久化存储的动态需求。"
source: https://xuanyuan.cloud/zh/r/dyrnq/nfs-subdir-external-provisioner
canonical: https://xuanyuan.cloud/zh/r/dyrnq/nfs-subdir-external-provisioner
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dyrnq/nfs-subdir-external-provisioner" title="dyrnq/nfs-subdir-external-provisioner Docker 镜像中文简介、标签列表与拉取命令">dyrnq/nfs-subdir-external-provisioner 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## NFS Subdir External Provisioner 镜像说明


### 组件功能  
NFS Subdir External Provisioner 是 Kubernetes SIG-Storage 维护的外部存储供应器，用于动态创建 NFS 服务器上的子目录作为 PersistentVolume (PV)，支持 PersistentVolumeClaim (PVC) 的动态申请。适用于需要通过 NFS 提供共享存储的 Kubernetes 集群，解决静态 PV 创建繁琐的问题。


### 镜像地址说明  
该组件提供两个官方镜像仓库地址，功能完全一致，仅仓库位置不同：  
1. **旧仓库地址**：`k8s.gcr.io/sig-storage/nfs-subdir-external-provisioner`  
   注意：k8s.gcr.io 仓库已逐步停止维护，可能存在访问限制（如国内网络）或镜像更新延迟。  
2. **新仓库地址**：`registry.k8s.io/sig-storage/nfs-subdir-external-provisioner`  
   推荐使用此地址，为 Kubernetes 官方当前主推仓库，访问稳定性和更新及时性更优。  


### 使用建议  
1. **优先选择新仓库**：部署时优先使用 `registry.k8s.io` 地址，避免因旧仓库问题导致部署失败或镜像拉取超时。  
2. **指定版本标签**：镜像需显式指定版本（如 `v4.0.2`），不建议使用 `latest`。版本信息可从 [官方 GitHub 仓库]  的 Release 页面获取。  
3. **部署配置示例**：在 Deployment 或 StatefulSet 配置中，按如下格式设置镜像字段：  
   ```yaml
   spec:
     containers:
     - name: nfs-subdir-external-provisioner
       image: ***-k8s.xuanyuan.run/sig-storage/nfs-subdir-external-provisioner:v4.0.2  # 替换为实际版本
   ```  
4. **前置检查**：确保集群节点可访问 `registry.k8s.io` 仓库（可通过 `docker pull` 或 `crictl pull` 测试），同时 NFS 服务器需提前配置共享目录及读写权限。

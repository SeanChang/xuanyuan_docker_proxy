---
image: flannel/flannel
description: "Flannel是一个专为Kubernetes设计的开源网络插件（CNI），旨在为集群中的Pod提供跨节点的网络连接，实现Pod间的高效通信；它通过为每个节点分配独立子网，确保Pod拥有唯一IP地址，并支持vxlan、host-gw等多种后端模式，简化网络配置，帮助用户轻松构建跨节点的Kubernetes网络环境，是轻量级且广泛应用的容器网络解决方案。"
source: https://xuanyuan.cloud/zh/r/flannel/flannel
canonical: https://xuanyuan.cloud/zh/r/flannel/flannel
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/flannel/flannel" title="flannel/flannel Docker 镜像中文简介、标签列表与拉取命令">flannel/flannel 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Flannel：Kubernetes 网络插件


## 简介  
Flannel 是一款轻量级的 Kubernetes CNI（容器网络接口）插件，主要目标是解决 Kubernetes 集群中跨节点 Pod 的网络通信问题。由 CoreOS（现 Kinvolk）开发维护，Flannel 设计理念简洁，部署和维护成本低，适合中小规模集群或对网络配置复杂度敏感的场景。


## 核心功能  
### 1. 覆盖网络（Overlay Network）构建  
Flannel 为集群中的 Pod 分配独立的私有 IP 段（默认 `10.244.0.0/16`），并通过覆盖网络（Overlay Network）技术，将不同节点上的 Pod 网络“打通”。跨节点的 Pod 可通过各自的 IP 直接通信，无需经过 NAT 转换。  

### 2. 多后端网络支持  
支持多种底层网络后端，可根据集群环境灵活选择：  
- **vxlan**：默认后端，通过封装 L2 帧到 UDP 包实现跨节点通信，支持跨子网部署（如跨机架、跨数据中心），兼容性好但性能略低；  
- **host-gw**：直接在节点路由表中添加 Pod 网段的网关（指向目标节点 IP），无封装开销，性能接近物理网络，但要求所有节点在同一子网；  
- **udp**：早期后端，性能较差，仅用于调试或不支持 vxlan 的老旧环境。  

### 3. 自动 IP 地址管理  
Flannel 与 Kubernetes 集成，通过 etcd（旧版本）或 Kubernetes API（新版本，推荐）动态管理 Pod IP 池。无需手动分配 IP，节点加入集群后自动从 IP 池中获取子网，避免 IP 冲突。  

### 4. 低资源占用  
组件轻量：每个节点仅运行 `flanneld` 守护进程（负责网络配置同步）和 CNI 二进制文件（`flannel`），内存占用通常低于 50MB，CPU 消耗可忽略，对节点资源影响小。  


## 适用场景  
- **新手入门**：配置极简，官方提供一键部署 YAML，适合刚接触 Kubernetes 网络的用户快速上手；  
- **中小规模集群**：节点数在 100 以内时，网络性能和稳定性满足大部分业务需求，维护成本远低于复杂插件（如 Calico）；  
- **开发/测试环境**：快速部署、即插即用，无需复杂网络策略配置，专注业务功能验证；  
- **对网络性能要求不极致的生产环境**：若业务以 HTTP 等上层协议为主，vxlan 后端的性能损耗可接受，优先保障稳定性。  


## 安装步骤  
### 1. 准备工作  
- 确保 Kubernetes 集群已初始化（`kubeadm init` 或其他工具部署），节点间网络互通（至少开放 8472/UDP 端口，vxlan 后端需要）；  
- 关闭节点防火墙或开放必要端口（如 `firewalld` 需放行 8472/UDP、6443/TCP 等）；  
- 集群中未部署其他 CNI 插件（同一集群仅能运行一个 CNI）。  


### 2. 部署 Flannel  
通过官方 YAML 一键部署（推荐使用最新版本，适配 Kubernetes 1.24+）：  
```bash
kubectl apply -f []  
> 注：旧版本 Kubernetes（如 1.16-1.23）可能需要调整 YAML 中的 `net-conf.json` 或镜像版本，具体参考 [Flannel 文档] 。  


### 3. 验证安装  
- **检查 Pod 状态**：Flannel 以 DaemonSet 形式运行，每个节点一个 Pod，需确保所有 Pod 状态为 `Running`：  
  ```bash
  kubectl get pods -n kube-flannel
  # 输出示例：
  # NAME                    READY   STATUS    RESTARTS   AGE
  # kube-flannel-ds-abc12   1/1     Running   0          5m
  # kube-flannel-ds-def34   1/1     Running   0          5m
  ```  

- **检查节点网络接口**：节点应新增 `flannel.1` 接口（vxlan 后端），用于跨节点通信：  
  ```bash
  ip link show flannel.1
  # 输出示例：
  # 4: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UNKNOWN mode DEFAULT group default
  ```  

- **测试跨节点 Pod 通信**：在不同节点创建 Pod，验证 IP 连通性。例如：  
  ```bash
  # 在 node-1 创建测试 Pod
  kubectl run test-node1 --image=busybox --rm -it -- sh
  # 在 Pod 内获取 IP（假设为 10.244.1.2）
  
  # 在 node-2 创建测试 Pod
  kubectl run test-node2 --image=busybox --rm -it -- sh
  # 在 Pod 内 ping node-1 的 Pod IP
  ping 10.244.1.2  # 应能通
  ```  


## 配置调整  
### 1. 修改网络后端  
默认使用 vxlan 后端，若节点在同一子网（如本地物理机集群），可切换为 host-gw 提升性能：  
1. 编辑 Flannel 的 ConfigMap：  
   ```bash
   kubectl edit configmap kube-flannel-cfg -n kube-flannel
   ```  
2. 修改 `net-conf.json` 中的 `Backend` 字段：  
   ```json
   {
     "Network": "10.244.0.0/16",
     "Backend": {
       "Type": "host-gw"  # 原为 "vxlan"
     }
   }
   ```  
3. 重启 Flannel DaemonSet，使配置生效：  
   ```bash
   kubectl rollout restart daemonset kube-flannel-ds -n kube-flannel
   ```  


### 2. 调整 MTU（避免网络碎片）  
网络路径 MTU 需一致，否则可能导致数据包丢失或延迟。vxlan 后端默认 MTU 为 1450（物理网络 MTU 1500 减去 50 字节封装开销），若底层网络 MTU 小于 1500（如部分云厂商默认 MTU 为 1460），需手动调整：  
1. 编辑 ConfigMap，在 `Backend` 中添加 `MTU` 字段：  
   ```json
   "Backend": {
     "Type": "vxlan",
     "MTU": 1420  # 例如底层 MTU 1460 时，1460 - 40（vxlan 封装）= 1420
   }
   ```  
2. 重启 Flannel DaemonSet。  


### 3. 自定义 Pod IP 池  
默认 IP 池为 `10.244.0.0/16`，若需修改（如避免与现有网络冲突）：  
1. 编辑部署 YAML（或直接修改 ConfigMap 的 `Network` 字段），将 `10.244.0.0/16` 替换为目标网段（如 `10.100.0.0/16`）；  
2. 确保与 `kubeadm init` 时 `--pod-network-cidr` 参数一致（若用 kubeadm 部署集群）。  


## 注意事项  
- **避免插件冲突**：若集群已安装其他 CNI（如 Calico、Weave），需先删除对应 DaemonSet 和 CNI 配置（`/etc/cni/net.d/` 目录下的文件），否则 Flannel 无法正常启动；  
- **节点 IP 变化处理**：`flanneld` 依赖节点 IP 通信，若节点 IP 动态变化（如云环境弹性节点），需在节点启动脚本中重新启动 `flanneld` 或配置固定 IP；  
- **日志排查**：网络不通时，优先查看 Flannel Pod 日志定位问题：  
  ```bash
  kubectl logs -n kube-flannel <flannel-pod-name> -c kube-flannel
  ```  
- **MTU 必调**：生产环境务必根据底层网络 MTU 调整 Flannel MTU，否则可能出现“能 ping 通但 HTTP 超时”等诡异问题（因大包被丢弃）。  


## 参考链接  
- 官方 GitHub：[[]]   
- 后端配置文档：[Flannel Backends]

---
image: nicolaka/netshoot
description: "这是一个Docker网络故障排查的“瑞士军刀”容器，集成了多种网络诊断工具，可高效支持Docker环境下网络连接、配置、性能及通信异常等问题的排查与分析，轻量便携且功能全面，为开发与运维人员快速定位和解决Docker网络故障提供一站式工具支持。"
source: https://xuanyuan.cloud/zh/r/nicolaka/netshoot
canonical: https://xuanyuan.cloud/zh/r/nicolaka/netshoot
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nicolaka/netshoot" title="nicolaka/netshoot Docker 镜像中文简介、标签列表与拉取命令">nicolaka/netshoot — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/nicolaka/netshoot" title="nicolaka/netshoot Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/nicolaka/netshoot</a>

# netshoot：Docker 与 Kubernetes 网络排障利器容器


## 简介  
Docker 和 Kubernetes 网络问题排查往往复杂，需要深入理解其网络原理并搭配合适工具。`netshoot` 容器集成了一系列强大的网络排障工具，可直接用于定位 Docker 和 Kubernetes 环境中的网络问题，无需在主机或业务容器中安装额外依赖。


## 核心概念：网络命名空间  
使用 `netshoot` 前需先理解 **网络命名空间（Network Namespaces）**：它是 Linux 提供的网络资源隔离机制，Docker 和 Kubernetes 均基于此实现网络隔离。  

- **Docker**：每个容器拥有独立网络命名空间，包含独立的网卡、路由和 IP。  
- **Kubernetes**：每个 Pod 共享一个网络命名空间，Pod 内所有容器共用相同的网络栈（如网卡、TCP 连接）。  

通过切换网络命名空间，`netshoot` 可直接进入目标容器、主机或网络的命名空间进行排查，无需修改目标环境。  


## 基础使用方法  

### 1. Docker 环境  
#### 进入目标容器的网络命名空间  
若业务容器网络异常，可让 `netshoot` 共享其网络命名空间：  
```bash
docker run -it --net container:<容器名称/ID> nicolaka/netshoot
```

#### 进入主机网络命名空间  
若怀疑问题出在主机网络，可让 `netshoot` 使用主机网络：  
```bash
docker run -it --net host nicolaka/netshoot
```

#### 进入 Docker 网络的命名空间  
需配合 `nsenter` 工具（详见下文 `nsenter` 使用示例），需挂载 Docker 网络命名空间目录并以特权模式运行：  
```bash
docker run -it --privileged -v /var/run/docker/netns:/var/run/docker/netns nicolaka/netshoot
```


### 2. Kubernetes 环境  
#### 临时调试容器（Pod 网络）  
创建一个临时交互式容器，共享目标 Pod 的网络（默认行为）：  
```bash
kubectl run tmp-shell --rm -i --tty --image nicolaka/netshoot -- /bin/bash
```

#### 使用主机网络  
若需排查主机网络问题，创建使用主机网络的临时容器：  
```bash
kubectl run tmp-shell --rm -i --tty --overrides='{"spec": {"hostNetwork": true}}' --image nicolaka/netshoot -- /bin/bash
```


## 常见网络问题与工具集  
网络问题常导致性能下降，如延迟、路由错误、DNS 解析失败、防火墙拦截、ARP 表不完整等。`netshoot` 集成了 [Linux 可观测性工具图谱]([]) 推荐的核心工具，覆盖各类排查场景。  


### 已集成工具列表  
包含以下关键工具（部分工具使用示例见下文）：  
`apache2-utils, bash, bind-tools, bird, bridge-utils, busybox-extras, calicoctl, conntrack-tools, ctop, curl, dhcping, drill, ethtool, fping, httpie, iftop, iperf, iproute2, iptables, mtr, netcat-openbsd, nmap, openssl, scapy, socat, tcpdump, tcptraceroute, termshark, tshark, vim`  


## 工具使用示例  

### 1. iperf：测试网络性能  
**用途**：测量容器/主机间的带宽和延迟。  

#### 步骤：  
1. 创建覆盖网络：  
   ```bash
   docker network create -d overlay perf-test
   ```  
2. 启动服务端（监听 9999 端口）：  
   ```bash
   docker service create --name perf-test-a --network perf-test nicolaka/netshoot iperf -s -p 9999
   ```  
3. 启动客户端（连接服务端）：  
   ```bash
   docker service create --name perf-test-b --network perf-test nicolaka/netshoot iperf -c perf-test-a -p 9999
   ```  
4. 查看服务端日志，获取性能数据：  
   ```bash
   docker logs <perf-test-a 容器ID>
   ```  


### 2. tcpdump：抓包分析  
**用途**：捕获网络数据包，分析协议细节。  

#### 示例：  
在 `iperf` 测试场景中，进入服务端容器的网络命名空间，捕获 9999 端口流量：  
```bash
# 进入 perf-test-a 容器的网络命名空间
docker run -it --net container:perf-test-a.1.<容器ID> nicolaka/netshoot

# 捕获 eth0 网卡上 9999 端口的 TCP 包（-c 1 表示只抓1个包）
tcpdump -i eth0 port 9999 -c 1 -Xvv
```  


### 3. netstat：查看网络连接状态  
**用途**：检查端口监听、连接状态等。  

#### 示例：  
确认 `iperf` 服务端是否监听 9999 端口：  
```bash
# 进入服务端网络命名空间
docker run -it --net container:perf-test-a.1.<容器ID> nicolaka/netshoot

# 查看监听端口（-tulpn：TCP/UDP/监听/程序名）
netstat -tulpn
```  
输出中若显示 `0.0.0.0:9999`，说明端口正常监听。  


### 4. nmap：端口扫描  
**用途**：检测目标端口开放状态（开放/关闭/被过滤）。  

#### 示例：  
扫描目标主机 172.31.24.25 的 12376-12390 端口范围：  
```bash
docker run -it --privileged nicolaka/netshoot nmap -p 12376-12390 -dd 172.31.24.25
```  


### 5. iftop：实时带宽监控  
**用途**：类似 `top`，实时显示主机间带宽占用。  

#### 示例：  
在 `iperf` 测试中，监控服务端容器的 eth0 网卡流量：  
```bash
docker run -it --net container:perf-test-a.1.<容器ID> nicolaka/netshoot iftop -i eth0
```  


### 6. drill：DNS 解析测试  
**用途**：诊断 DNS 解析问题，查看域名解析过程。  

#### 示例：  
在 Docker 覆盖网络中，解析服务名 `perf-test-b`：  
```bash
docker run -it --net container:perf-test-a.1.<容器ID> nicolaka/netshoot drill perf-test-b
```  
输出中 `ANSWER SECTION` 会显示解析到的服务 VIP。  


### 7. netcat：TCP/UDP 连接测试  
**用途**：检测端口连通性，排查防火墙拦截。  

#### 示例：  
1. 创建覆盖网络并启动服务端（监听 8080 端口）：  
   ```bash
   docker network create -d overlay my-ovl
   docker service create --name service-a --network my-ovl nicolaka/netshoot nc -l 8080
   ```  
2. 启动客户端测试连接：  
   ```bash
   docker service create --name service-b --network my-ovl nicolaka/netshoot nc -vz service-a 8080
   ```  
3. 若客户端日志显示 `succeeded`，说明端口连通。  


### 8. nsenter：网络命名空间深入排查  
**用途**：进入 Docker 网络（如覆盖网络）自身的命名空间，查看底层网络配置（如网桥、VxLAN 接口）。  

#### 示例：  
1. 创建覆盖网络并启动服务：  
   ```bash
   docker network create -d overlay nsenter-test
   docker service create --name test-svc --replicas 3 --network nsenter-test busybox ping localhost
   ```  
2. 进入网络命名空间（网络 ID 为 `nsenter-test`，命名空间名为 `1-<网络ID前缀>`）：  
   ```bash
   docker run -it --privileged -v /var/run/docker/netns:/var/run/docker/netns nicolaka/netshoot
   nsenter --net=/var/run/docker/netns/1-nsenter-test sh
   ```  
3. 查看网络详情（如网桥接口、FDB 转发表）：  
   ```bash
   brctl show  # 显示网桥及关联接口
   bridge fdb show br br0  # 查看 L2 转发表
   ```  


### 9. ctop：容器资源监控  
**用途**：实时监控容器 CPU、内存、网络 I/O 等指标。  

#### 示例：  
挂载 Docker 套接字，启动 `ctop`：  
```bash
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nicolaka/netshoot ctop
```  


### 10. termshark：终端版 Wireshark  
**用途**：终端中捕获和分析数据包，支持 Wireshark 过滤规则。  

#### 示例：  
捕获主机 eth0 网卡的 ICMP 流量：  
```bash
docker run --rm --cap-add=NET_ADMIN --cap-add=NET_RAW -it nicolaka/netshoot termshark -i eth0 icmp
```  


## 反馈与协作  
netshoot 持续迭代，欢迎通过项目仓库提交问题或贡献代码。

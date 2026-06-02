---
image: networkstatic/iperf3
description: "这是一个用于网络性能和带宽测试的IPerf3 Docker镜像构建项目，旨在帮助用户通过容器化方式快速部署IPerf3工具，便捷地进行网络吞吐量、延迟、抖动等关键性能指标的测量与评估，适用于服务器、网络设备及通信链路的性能测试场景，提供一致、高效的测试环境，简化网络性能分析流程。"
source: https://xuanyuan.cloud/zh/r/networkstatic/iperf3
canonical: https://xuanyuan.cloud/zh/r/networkstatic/iperf3
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/networkstatic/iperf3" title="networkstatic/iperf3 Docker 镜像中文简介、标签列表与拉取命令">networkstatic/iperf3 — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/networkstatic/iperf3" title="networkstatic/iperf3 Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/networkstatic/iperf3</a>

# iperf3 Docker镜像：网络性能与带宽测试工具


## 项目资源
- 项目二进制文件及源代码：[[]]([])  
- Dockerfile的GitHub仓库：[github.com/nerdalert/iperf3]([])  


## 运行Docker镜像查看Iperf选项
通过以下命令可查看iperf3的所有可用选项：  
```bash
docker run -it --rm -p 5201:5201 networkstatic/iperf3 --help
```


## 使用方法
测试两台容器间的带宽需分两步：启动服务器端（监听端），再通过客户端（发起端）连接服务器进行测试。


### Iperf3服务器端
启动一个监听服务（默认端口5201），并命名容器为“iperf3-server”：  
```bash
docker run -it --rm --name=iperf3-server -p 5201:5201 networkstatic/iperf3 -s
```  
**参数说明**：  
- `--rm`：测试结束后自动删除容器，避免残留  
- `--name=iperf3-server`：显式命名容器，方便后续操作  
- `-p 5201:5201`：将容器内5201端口映射到主机，确保客户端可连接  
- `-s`：以服务器模式运行  

服务器启动后会显示以下信息，表示等待连接：  
```
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```


### Iperf3客户端
#### 步骤1：获取服务器容器IP  
客户端需知道服务器的IP地址，通过以下命令获取名为“iperf3-server”的容器IP：  
```bash
docker inspect --format "{{ .NetworkSettings.IPAddress }}" iperf3-server
```  
示例输出（实际IP以环境为准）：  
```
172.17.0.163
```

#### 步骤2：运行客户端测试  
启动客户端容器，连接服务器IP进行带宽测试：  
```bash
docker run -it --rm networkstatic/iperf3 -c 172.17.0.163
```  
**参数说明**：  
- `-c`：以客户端模式运行，后接服务器IP  

#### 测试输出示例  
客户端运行后会显示实时带宽数据，示例如下（数据仅为演示）：  
```
Connecting to host 172.17.0.163, port 5201
[  4] local 172.17.0.191 port 51148 connected to 172.17.0.163 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec  4.16 GBytes  35.7 Gbits/sec    0    468 KBytes
...（中间省略若干行）...
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-10.00  sec  42.0 GBytes  36.1 Gbits/sec    0             sender
[  4]   0.00-10.00  sec  42.0 GBytes  36.0 Gbits/sec                  receiver

iperf Done.
```


## 高级命令示例（一行测试）  
若需简化操作，可通过嵌套命令直接获取服务器IP并运行测试（适用于刚启动服务器的场景）：  
```bash
docker run -it --rm networkstatic/iperf3 -c $(docker inspect --format "{{ .NetworkSettings.IPAddress }}" $(docker ps -ql))
```  
**命令逻辑**：  
- `docker ps -ql`：返回最后启动的容器ID（即刚启动的服务器容器）  
- `docker inspect ...`：获取该容器的IP地址  
- 整体命令：直接以客户端模式连接该IP，完成测试  


## 致谢与相关工具  
- 感谢ESNET团队重新开发iperf3，提供了优秀的网络测试工具。  
- 如需将测试结果图形化展示，可参考工具：[nerdalert/cloud-bandwidth]([])

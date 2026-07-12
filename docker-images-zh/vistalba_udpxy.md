---
image: vistalba/udpxy
description: "Docker容器化的udpxy工具，用于将UDP流转换为HTTP流，实现网络流媒体转发，支持IPTV等场景的便捷部署与使用。"
source: https://xuanyuan.cloud/zh/r/vistalba/udpxy
canonical: https://xuanyuan.cloud/zh/r/vistalba/udpxy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/vistalba/udpxy" title="vistalba/udpxy Docker 镜像中文简介、标签列表与拉取命令">vistalba/udpxy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-udpxy 镜像文档


## 一、镜像概述和主要用途

docker-udpxy 是一个封装了 udpxy 服务的 Docker 镜像。udpxy 是一款轻量级的 UDP 组播转 HTTP 单播代理工具，其核心功能是将网络中的 UDP 组播流（如 IPTV 流、多媒体组播数据）转换为 HTTP 单播流，使不支持 UDP 组播的客户端（如手机、部分智能设备）可通过 HTTP 协议获取组播内容。该镜像旨在简化 udpxy 的部署流程，提供跨平台、可移植的组播流转发能力。


## 二、核心功能和特性

1. **UDP 组播转 HTTP 单播**  
   核心功能为接收 UDP 组播流并转换为 HTTP 单播流，支持客户端通过 HTTP GET 请求获取组播内容（如 `http://<udpxy-ip>:<port>/udp/<multicast-ip>:<multicast-port>`）。

2. **轻量级设计**  
   基于 Alpine 或极简 Linux 基础镜像构建，镜像体积小（通常 < 10MB），资源占用低，适合嵌入式设备或资源受限环境。

3. **跨平台兼容**  
   支持 Docker 兼容的所有平台（x86_64、ARM、ARM64 等），可部署于服务器、NAS、路由器等设备。

4. **灵活配置**  
   通过环境变量或配置文件自定义监听端口、客户端访问控制、日志级别等参数，无需修改镜像内部文件。

5. **低延迟转发**  
   采用高效的数据包转发机制，延迟控制在毫秒级，适合对实时性要求高的场景（如 IPTV 直播）。


## 三、使用场景和适用范围

1. **IPTV 流转发**  
   家庭或小型网络中，将运营商提供的 IPTV 组播流转换为 HTTP 流，供手机、平板等设备通过 HTTP 观看。

2. **企业网络组播内容分发**  
   企业内网中，将组播形式的培训视频、监控画面等内容转换为 HTTP 流，支持更多客户端（如无组播支持的终端）访问。

3. **家庭多媒体中心**  
   配合 Kodi、Plex 等媒体中心，将本地网络中的 UDP 组播媒体流（如摄像头、卫星电视盒输出）转换为 HTTP 流，实现多设备共享。

4. **网络隔离环境下的组播透传**  
   在不支持组播路由的网络（如跨 VLAN 环境）中，通过 udpxy 代理组播流，实现跨网段的内容分发。


## 四、使用方法和配置说明

### 4.1 快速启动（docker run）

通过 `docker run` 命令快速启动容器，默认配置下监听 8080 端口：

```bash
docker run -d \
  --name udpxy \
  -p 8080:8080 \
  --network=host \  # 如需接收宿主机网络的组播流，建议使用 host 网络（避免容器网络隔离导致组播不可达）
  --restart=always \
  vimagick/udpxy  # 假设镜像名为 vimagick/udpxy（实际需替换为具体镜像名称）
```

> 说明：`--network=host` 用于让容器直接使用宿主机网络栈，确保能接收宿主机所在网络的 UDP 组播流（部分环境下非必需，视网络拓扑而定）。


### 4.2 docker-compose 配置示例

创建 `docker-compose.yml` 文件，定义更灵活的部署配置：

```yaml
version: '3'
services:
  udpxy:
    image: docker.xuanyuan.run/vimagick/udpxy  # 替换为实际镜像名称
    container_name: udpxy
    restart: always
    ports:
      - "8080:8080"  # 宿主机端口:容器内端口（默认 8080）
    network_mode: host  # 推荐使用 host 网络以接收组播
    environment:
      - UDPXY_PORT=8080  # 监听端口（默认 8080）
      - UDPXY_LISTEN_ADDR=0.0.0.0  # 监听地址（默认 0.0.0.0，即所有网卡）
      - UDPXY_CLIENT_WHITELIST=192.168.1.0/24,10.0.0.0/8  # 允许访问的客户端 IP 网段（默认无限制）
      - UDPXY_LOG_LEVEL=1  # 日志级别（0=无日志，1=基本日志，2=详细日志，默认 1）
    # 如需持久化日志，可挂载日志目录（可选）
    volumes:
      - ./udpxy-logs:/var/log/udpxy
```

启动命令：  
```bash
docker-compose up -d
```


### 4.3 环境变量说明

通过环境变量自定义 udpxy 配置，支持的变量如下：

| 环境变量                | 说明                                                                 | 默认值          |
|-------------------------|----------------------------------------------------------------------|-----------------|
| `UDPXY_PORT`            | 服务监听端口                                                         | `8080`          |
| `UDPXY_LISTEN_ADDR`     | 监听地址（如 `0.0.0.0` 表示所有网卡，`192.168.1.100` 表示指定网卡）  | `0.0.0.0`       |
| `UDPXY_CLIENT_WHITELIST`| 允许访问的客户端 IP 或网段（逗号分隔，如 `192.168.1.0/24,10.0.0.1`） | 无限制（所有 IP）|
| `UDPXY_LOG_LEVEL`       | 日志级别：0（关闭）、1（基本日志）、2（详细日志，含数据包信息）      | `1`             |
| `UDPXY_MAX_CLIENTS`     | 最大并发客户端数（防止过载）                                         | `50`            |
| `UDPXY_BUFFER_SIZE`     | 数据包缓冲区大小（字节，如 `131072` 表示 128KB）                     | `131072`        |


### 4.4 配置参数说明

除环境变量外，可通过命令行参数直接传递 udpxy 原生参数（优先级高于环境变量）。例如，自定义监听端口和客户端白名单：

```bash
docker run -d \
  --name udpxy \
  -p 8081:8081 \
  --network=host \
  docker.xuanyuan.run/vimagick/udpxy \
  -p 8081 -a 192.168.1.100 -c 192.168.1.0/24  # -p 端口，-a 监听地址，-c 客户端白名单
```

udpxy 核心参数说明：

| 参数       | 作用                                  | 示例                  |
|------------|---------------------------------------|-----------------------|
| `-p <port>`| 指定监听端口                          | `-p 8080`             |
| `-a <addr>`| 指定监听 IP 地址（如 `192.168.1.100`）| `-a 0.0.0.0`          |
| `-c <cidr>`| 允许访问的客户端 CIDR 网段（多网段用逗号分隔） | `-c 192.168.1.0/24` |
| `-l <level>`| 日志级别（0-2）                       | `-l 2`                |
| `-m <num>` | 最大并发客户端数                      | `-m 30`               |


## 五、注意事项

1. **组播网络可达性**  
   若宿主机无法接收 UDP 组播流（如未加入组播组、网络设备禁用组播），udpxy 将无法转发内容。建议通过 `tcpdump` 工具在宿主机验证组播流是否可达（如 `tcpdump -i eth0 udp and multicast`）。

2. **网络模式选择**  
   默认桥接网络可能导致容器无法接收宿主机网络的组播流，推荐使用 `--network=host`（宿主机网络模式），或在桥接网络中配置组播路由（需 Docker 网络支持）。

3. **客户端访问格式**  
   客户端通过 HTTP URL 访问转换后的流，格式为：  
   `http://<udpxy-ip>:<port>/udp/<multicast-ip>:<multicast-port>`  
   示例：`http://192.168.1.100:8080/udp/239.255.1.1:5000`（转发组播地址 `239.255.1.1:5000` 的流）。

4. **性能优化**  
   高并发场景下，可适当调大 `UDPXY_BUFFER_SIZE` 和 `UDPXY_MAX_CLIENTS`，并确保宿主机 CPU/内存资源充足。


## 六、典型应用示例：IPTV 流转发

1. **场景**：家庭网络中，将光猫/路由器输出的 IPTV 组播流（如 `239.255.1.1:5000`）转换为 HTTP 流，供手机、平板观看。

2. **部署步骤**：  
   - 确保宿主机（如 NAS 或树莓派）可访问 IPTV 组播流（需接入光猫的 IPTV VLAN，或通过路由器配置组播路由）。  
   - 启动 udpxy 容器：  
     ```bash
     docker run -d \
       --name iptv-proxy \
       --network=host \
       --restart=always \
       docker.xuanyuan.run/vimagick/udpxy \
       -p 8080 -c 192.168.1.0/24  # 允许 192.168.1.x 网段客户端访问
     ```  
   - 客户端访问：在 VLC 或浏览器中输入 `http://192.168.1.100:8080/udp/239.255.1.1:5000`，即可播放 IPTV 流。

<!-- xuanyuan-docker-images-zh
image: safarov/freeswitch
source: https://xuanyuan.cloud/zh/r/safarov/freeswitch
canonical: https://xuanyuan.cloud/zh/r/safarov/freeswitch
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/safarov/freeswitch" title="safarov/freeswitch Docker 镜像中文简介、标签列表与拉取命令">safarov/freeswitch — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/safarov/freeswitch" title="safarov/freeswitch Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/safarov/freeswitch</a></p>

# FreeSwitch 最小化 Docker 容器介绍


## 关于容器
这是一款最小化的官方 FreeSwitch Docker 容器，支持在 host、bridge 及 swarm 网络环境中运行。容器体积精简至 149MB（压缩后 62MB），并在安全性上做了以下优化：  
1. 仅保留必要依赖库（libc、busybox、tcpdump、dumpcap、freeswitch 及相关依赖库），移除其他冗余组件；  
2. 从默认配置中删除“system”API 命令；  
3. 将默认 SIP 密码更新为随机值，提升初始安全性。  


## 环境变量说明
容器运行时支持通过以下环境变量进行配置：  

### 1. `SOUND_RATES`  
指定需下载安装的声音文件采样率，可选值为 `8000`、`16000`、`32000`、`48000`。如需指定多个值，用分号分隔，例如：  
`SOUND_RATES=8000:16000`  


### 2. `SOUND_TYPES`  
指定需下载安装的声音文件类型，可选值包括：`music`（音乐）、`en-us-callie`（美式英语-Callie 语音）、`en-us-allison`（美式英语-Allison 语音）、`ru-RU-elena`（俄语-Elena 语音）、`en-ca-june`（加拿大英语-June 语音）、`fr-ca-june`（加拿大法语-June 语音）、`pt-BR-karina`（巴西葡萄牙语-Karina 语音）、`sv-se-jakob`（瑞典语-Jakob 语音）、`zh-cn-sinmei`（中文普通话- Sinmei 语音）、`zh-hk-sinmei`（中文粤语- Sinmei 语音）。例如：  
`SOUND_TYPES=music:en-us-callie`  


### 3. `EPMD`  
控制是否启动 epmd 守护进程（用于 `mod_erlang` 和 `mod_kazoo` 模块），可选值 `true`（启动）或 `false`（不启动）。  


### 4. `DUMPCAP`  
控制是否启动 dumpcap 守护进程（用于 VoIP 故障排查和呼叫监控的抓包），可选配置：  
- `true`：使用默认参数启动，抓包选项为 `-i any -p -t -q -b duration:3600 -b files:48 -w /dumpcap/packets.pcap`，PCAP 文件保存至容器内 `/dumpcap` 目录；  
- `false`：不启动；  
- 自定义值：直接传入 dumpcap 命令参数（如 `-i eth0 -w /custom/path.pcap`）。  


## 容器使用步骤

### 1. 创建声音文件卷（可选）  
若需使用 FreeSwitch 的 MOH（音乐保持）或其他声音文件，需先创建存储卷；无需时可跳过此步：  
```sh
docker volume create --name freeswitch-sounds 
```  


### 2. 启动容器  
通过 `docker run` 命令启动容器，示例如下（根据实际需求调整参数）：  
```sh
docker run --net=host --name freeswitch \
           -e SOUND_RATES=8000:16000 \  # 指定采样率
           -e SOUND_TYPES=music:en-us-callie \  # 指定声音类型
           -v freeswitch-sounds:/usr/share/freeswitch/sounds \  # 挂载声音文件卷
           -v /etc/freeswitch/:/etc/freeswitch \  # 挂载本地配置目录（替换为实际路径）
           safarov/freeswitch  # 镜像名称
```  


## systemd 服务配置  
可通过 systemd 管理容器的启停，以下是两种网络模式的服务文件配置（适用于 Docker 主机）。  


### 服务文件放置与启用  
将服务文件保存至 `/etc/systemd/system/freeswitch-docker.service`，然后通过以下命令启用并启动：  
```sh
systemctl start freeswitch-docker.service  # 启动服务
systemctl enable freeswitch-docker.service  # 设置开机自启
```  


### Host 网络模式  
```sh
[Unit]
Description=freeswitch Container
After=docker.service network-online.target
Requires=docker.service

[Service]
Restart=always
TimeoutStartSec=0
# 合并 ExecStart/ExecStop 为单行，避免部分 systemd 版本 bug
ExecStart=/bin/sh -c 'docker rm -f freeswitch; \
          docker run -t --net=host --name freeswitch \
                 -e SOUND_RATES=8000:16000 \
                 -e SOUND_TYPES=music:en-us-callie \
                 -v freeswitch-sounds:/usr/share/freeswitch/sounds \
                 -v /etc/kazoo/freeswitch/:/etc/freeswitch \  # 替换为实际配置目录
                 freeswitch'  # 替换为实际镜像名称
ExecStop=-/bin/sh -c '/usr/bin/docker stop freeswitch; \
          /usr/bin/docker rm -f freeswitch;'

[Install]
WantedBy=multi-user.target
```  


### 默认 Bridge 网络模式  
```sh
[Unit]
Description=freeswitch Container
After=docker.service network-online.target
Requires=docker.service

[Service]
Restart=always
TimeoutStartSec=0
# 合并 ExecStart/ExecStop 为单行，避免部分 systemd 版本 bug
ExecStart=/bin/sh -c 'docker rm -f freeswitch; \
          docker run -t --network bridge --name freeswitch \
                 -p 5060:5060/udp -p 5060:5060 \  # 映射 SIP 端口
                 -e SOUND_RATES=8000 \
                 -e SOUND_TYPES=music:en-us-callie \
                 -v freeswitch-sounds:/usr/share/freeswitch/sounds \
                 -v /etc/freeswitch/:/etc/freeswitch \  # 替换为实际配置目录
                 safarov/freeswitch'  # 镜像名称

# 启动后配置 iptables，转发 RTP 端口（17000-17999）
ExecStartPost=/bin/sh -c 'sleep 5; \
          IP_ADDR=$(docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" freeswitch); \
          /sbin/iptables -A DOCKER -t nat -p udp ! -i docker0  --dport 17000:17999 -j DNAT --to $IP_ADDR:17000-17999; \
          /sbin/iptables -A DOCKER -p udp ! -i docker0 -o docker0 -d $IP_ADDR --dport 17000:17999 -j ACCEPT'

# 停止时清理 iptables 规则
ExecStop=-/bin/sh -c 'IP_ADDR=$(docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" freeswitch); \
          /sbin/iptables -D DOCKER -t nat -p udp ! -i docker0  --dport 17000:17999 -j DNAT --to $IP_ADDR:17000-17999; \
          /sbin/iptables -D DOCKER -p udp ! -i docker0 -o docker0 -d $IP_ADDR --dport 17000:17999 -j ACCEPT; \
          /usr/bin/docker stop freeswitch; \
          /usr/bin/docker rm -f freeswitch;'

[Install]
WantedBy=multi-user.target
```  


## 简化管理：配置 .bashrc 别名  
为方便通过 `fs_cli` 管理 FreeSwitch，可在 `.bashrc` 文件中添加别名：  
```sh
alias fs_cli='docker exec -i -t freeswitch /usr/bin/fs_cli'  # "freeswitch" 为容器名称
```  
保存后执行 `source ~/.bashrc` 使别名生效，之后直接输入 `fs_cli` 即可进入容器内的 FreeSwitch 控制台。  


## 自定义容器构建步骤  
该容器基于 scratch 镜像构建，通过添加打包为 tar.gz 的必要 FreeSwitch 文件实现。自定义构建步骤如下：  


### 1. 安装依赖包（Debian 系统）  
```sh
apt-get install freeswitch-conf-vanilla  # 安装 FreeSwitch 基础配置包
```  


### 2. 克隆 FreeSwitch 源码仓库  
```sh
git clone []  # 克隆源码
```  


### 3. 生成最小化文件归档  
```sh
cd freeswitch/docker/base_image  # 进入脚本目录
./make_min_archive.sh  # 执行归档生成脚本
```  


### 4. 构建自定义镜像  
```sh
docker build -t freeswitch_custom .  # "freeswitch_custom" 为自定义镜像名称
```  


## 参考链接  
[官方 FreeSwitch 容器 Dockerfile]([])

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/safarov/freeswitch" title="safarov/freeswitch Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/safarov/freeswitch</a></p>

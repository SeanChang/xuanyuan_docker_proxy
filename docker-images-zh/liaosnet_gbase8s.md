---
image: liaosnet/gbase8s
description: "本次更新操作是将系统升级至GBase8s数据库的3.6.3_3x2_1版本，该版本附带客户端软件开发工具包（CSDK），支持64位（x64）架构，其中版本号3.6.3_3x2_1标识具体迭代版本，CSDK组件为客户端开发提供工具支持，x64架构确保适配64位计算机系统运行环境，整体实现数据库版本的更新与功能组件的集成。"
source: https://xuanyuan.cloud/zh/r/liaosnet/gbase8s
canonical: https://xuanyuan.cloud/zh/r/liaosnet/gbase8s
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/liaosnet/gbase8s" title="liaosnet/gbase8s Docker 镜像中文简介、标签列表与拉取命令">liaosnet/gbase8s 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# GBase 8s 镜像说明  
最后更新：2025-08-05  
版本号示例：v8.8_3633x21_csdk_x64  


## 文件列表  

### **Dockerfile**  
```text
FROM docker.xuanyuan.run/scratch
ADD base_sys.tar.gz /
ADD docker_entrypoint.sh /usr/local/bin/
RUN groupadd -g 1000 gbasedbt && useradd -u 1000 -g gbasedbt -d /home/gbase -m -s /bin/bash gbasedbt
ADD v8.8_3633x21_csdk_x64.tar.gz /
EXPOSE 9088
ENTRYPOINT ["docker_entrypoint.sh"]
```  
注：不同数据库版本对应的 `ADD` 文件名需按实际版本调整。  


### **v8.8_3633x21_csdk_x64.tar.gz**  
GBase 8s 数据库安装、配置完成后的压缩包。  
注：不同数据库版本的文件名需对应调整。  


### **README.txt**  
说明文档，内容与本文档一致。  


## 使用方式  

### 从 docker.com 获取镜像  
```shell
docker pull docker.xuanyuan.run/liaosnet/gbase8s:v8.8_3633x21_csdk_x64
```  


### 自行构建镜像  
在包含上述文件的目录下执行：  
```shell
docker build -t liaosnet/gbase8s:v8.8_3633x21_csdk_x64 .
```  


### 运行镜像  
通过以下命令启动容器，需绑定端口并配置环境变量：  
```shell
docker run -d -p 19088:9088 \
  --name node01 --hostname node01 \
  -e SERVERNAME=gbase01 \
  -e USERPASS=GBase123$% \
  -e CPUS=1 \
  -e MEMS=2048 \
  -e ADTS=0 \
  docker.xuanyuan.run/liaosnet/gbase8s:v8.8_3633x21_csdk_x64
```  

#### 参数说明  
- `-p 19088:9088`：将主机 19088 端口映射到容器内数据库端口 9088（容器内端口固定为 9088）。  

**环境变量（-e）说明**：  
- `SERVERNAME`：数据库服务名称，默认值 `gbase01`。  
- `USERPASS`：默认用户 `gbasedbt` 的密码，示例值 `GBase123$%`。  
- `CPUS`：限制容器 CPU 核心数，示例值 `1`（整数）。  
- `MEMS`：限制容器内存总量（MB），示例值 `2048`（整数）。  
- `ADTS`：是否开启审计功能，`0` 为关闭（默认），`1` 为开启。  


#### 其它参数（集群场景用）  
- `MODE`：集群节点角色，可选值 `standard`（单机）、`primary`（主节点）、`secondary`（备节点）。  
- `LOCALIP`：本节点 IP 地址，集群模式下需指定。  
- `PAIRENAME`：对端集群实例名称，默认值 `gbase02`。  
- `PAIREIP`：对端节点 IP 地址，集群模式下需指定。  


## 数据库连接（JDBC）  

### 基础信息  
- **JDBC JAR 下载**：[]  
- **驱动类名**：`com.gbasedbt.jdbc.Driver`  
- **连接 URL**：  
  `jdbc:gbasedbt-sqli://IPADDR:19088/testdb:GBASEDBTSERVER=gbase01;DB_LOCALE=zh_CN.utf8;CLIENT_LOCALE=zh_CN.utf8;IFX_LOCK_MODE_WAIT=30;`  
  （其中 `IPADDR` 为 Docker 主机 IP，需确保主机 19088 端口开放）。  
- **默认用户/密码**：`gbasedbt` / `GBase123$%`  


### Maven 依赖  
```xml
<dependency>
    <groupId>com.gbasedbt</groupId>
    <artifactId>jdbc</artifactId>
    <version>3.6.3.32</version>
</dependency>
```

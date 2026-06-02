---
image: jeessy/ddns-go
description: "这是一款简单易用的动态域名解析（DDNS）服务，支持阿里云、腾讯云、Dnspod、Cloudflare、回调功能及华为云等多个主流平台，可帮助用户便捷实现动态IP地址与域名的实时绑定，适用于个人服务器、家庭网络设备等多种场景，为用户提供稳定可靠的动态域名解析解决方案。"
source: https://xuanyuan.cloud/zh/r/jeessy/ddns-go
canonical: https://xuanyuan.cloud/zh/r/jeessy/ddns-go
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jeessy/ddns-go" title="jeessy/ddns-go Docker 镜像中文简介、标签列表与拉取命令">jeessy/ddns-go — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/jeessy/ddns-go" title="jeessy/ddns-go Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/jeessy/ddns-go</a>

# DDNS-GO


DDNS-GO 是一款动态域名解析工具，能自动获取公网 IPv4/IPv6 地址，并将其解析到指定的域名服务。以下是详细介绍：


## 特性

- **多平台支持**：适配 Mac、Windows、Linux 系统，兼容 ARM、x86 架构。  
- **丰富服务商**：支持阿里云、腾讯云、Dnspod、Cloudflare、华为云、百度云、Porkbun、GoDaddy 等主流 DNS 服务商（完整列表见下方）。  
- **灵活获取 IP**：可通过接口、网卡或命令获取 IP（命令参考[通过命令获取IP]([])）。  
- **服务化运行**：支持以系统服务形式后台运行，默认每 5 分钟同步一次 IP。  
- **多配置能力**：可同时配置多个 DNS 服务商、解析多个域名（含多级域名）。  
- **便捷管理**：提供网页配置界面，默认禁止公网访问，可快速查看最近 50 条日志。  
- **扩展功能**：支持 Webhook 通知、自定义 TTL，部分服务商可传递自定义参数实现地域解析/多 IP 等功能（参数配置见[传递自定义参数]([])）。  


> [!NOTE]  
> 若需从公网访问配置界面，建议通过 Nginx 等反向代理启用 HTTPS，确保安全。更多问题可参考[FAQ]([])。


## 系统中使用

### 安装步骤  
1. 从 [Releases]([]) 下载对应系统的压缩包，解压后得到可执行文件 `ddns-go`（Windows 为 `ddns-go.exe`）。  

2. **安装服务**  
   - Mac/Linux：终端中执行 `sudo ./ddns-go -s install`  
   - Windows：以管理员身份打开 cmd，执行 `.\ddns-go.exe -s install`  

3. **配置**  
   打开浏览器访问 `[]  

4. **卸载服务（可选）**  
   - Mac/Linux：`sudo ./ddns-go -s uninstall`  
   - Windows：管理员 cmd 中执行 `.\ddns-go.exe -s uninstall`  


### 安装参数（可选）  
安装时可添加参数自定义配置，例如：  
- `-l`：监听地址（默认 `localhost:9876`）  
- `-f`：同步间隔时间（秒，默认 300 秒即 5 分钟）  
- `-cacheTimes`：每 N 次同步后与服务商比对 IP（避免频繁请求）  
- `-c`：自定义配置文件路径（默认在用户目录）  
- `-noweb`：不启动网页服务（需手动编辑配置文件）  
- `-resetPassword`：重置网页登录密码（如 `./ddns-go -resetPassword 123456`）  


### 使用示例  
- 每 10 分钟同步一次，指定配置文件路径：  
  ```bash
  ./ddns-go -s install -f 600 -c /Users/name/.ddns_go_config.yaml
  ```  
- 每 10 秒检查本地 IP 变化，每 30 分钟与服务商比对（减少请求频率）：  
  ```bash
  ./ddns-go -s install -f 10 -cacheTimes 180
  ```  


## Docker 中使用

### 基础运行（推荐）  
使用主机网络模式，挂载本地目录存储配置（将 `/opt/ddns-go` 替换为实际路径）：  
```bash
docker run -d --name ddns-go --restart=always --net=host -v /opt/ddns-go:/root jeessy/ddns-go
```  
启动后访问 `[] 配置。  


### 其他选项  
- **使用 ghcr.io 镜像**：  
  ```bash
  docker run -d --name ddns-go --restart=always --net=host -v /opt/ddns-go:/root ghcr.io/jeessy2/ddns-go
  ```  

- **自定义端口和间隔**：  
  ```bash
  docker run -d --name ddns-go --restart=always --net=host -v /opt/ddns-go:/root jeessy/ddns-go -l :9877 -f 600
  ```  

- **非 host 网络模式**：  
  ```bash
  docker run -d --name ddns-go --restart=always -p 9876:9876 -v /opt/ddns-go:/root jeessy/ddns-go
  ```  

- **重置密码**：  
  ```bash
  docker exec ddns-go ./ddns-go -resetPassword 123456 && docker restart ddns-go
  ```  


## 使用 IPv6  

### 前提条件  
设备需能正常获取 IPv6 地址并访问 IPv6 网络。  


### 不同场景配置建议  
- **Windows/Mac**：推荐直接通过「系统中使用」方式运行（桌面版 Docker 不支持 `--net=host` 模式）。  
- **群晖**：  
  1. 套件中心安装 Docker 并打开；  
  2. 注册表搜索 `ddns-go` 下载镜像；  
  3. 启动镜像时，「高级设置」中勾选「使用与 Docker Host 相同的网络」和「启动自动重新启动」；  
  4. 访问 `[] 配置。  
- **Linux（x86/ARM）**：推荐 Docker 的 `--net=host` 模式。  
- **虚拟机**：可能能获取 IPv6 地址，但需确保网络配置支持 IPv6 访问。  


## Webhook 通知  

IP 更新成功/失败时，可通过 Webhook 发送通知。支持自定义变量（如 `#{ipv4Addr}` 表示新 IPv4 地址），请求方式根据 RequestBody 自动判断（为空则 GET，否则 POST）。  


### 变量说明  
| 变量名          | 说明                          |  
|-----------------|-------------------------------|  
| `#{ipv4Addr}`   | 新的 IPv4 地址                |  
| `#{ipv4Result}` | IPv4 更新结果（未改变/失败/成功） |  
| `#{ipv4Domains}`| IPv4 解析的域名（多个用 `,` 分隔） |  
| `#{ipv6Addr}`   | 新的 IPv6 地址                |  
| `#{ipv6Result}` | IPv6 更新结果（未改变/失败/成功） |  
| `#{ipv6Domains}`| IPv6 解析的域名（多个用 `,` 分隔） |  


### 常见通知平台配置示例  
<details><summary>Server酱</summary>  
URL：  
```  
[]].send?title=公网IP变更&desp=IPv4更新为#{ipv4Addr}，结果：#{ipv4Result}  
```  
</details>  

<details><summary>Bark</summary>  
URL：  
```  
[]]/IPv4变更：#{ipv4Addr}，结果：#{ipv4Result}  
```  
</details>  

<details><summary>钉钉</summary>  
1. 群设置 → 智能群助手 → 添加机器人 → 自定义，勾选「自定义关键词」（如“IP变更”）；  
2. URL 填写钉钉提供的 Webhook 地址；  
3. RequestBody：  
```json  
{  
  "msgtype": "markdown",  
  "markdown": {  
    "title": "IP变更通知",  
    "text": "#### IP变更通知 \n - IPv4地址：#{ipv4Addr} \n - 更新结果：#{ipv4Result} \n"  
  }  
}  
```  
</details>  

更多平台配置（飞书、、 等）可参考[Webhook 配置参考]([])。  


## Callback  

通过自定义回调可支持更多 DNS 服务商。配置的每个域名会触发一次回调，支持变量（`#{ip}` `#{domain}` `#{recordType}` `#{ttl}`），请求方式同 Webhook。详细配置可参考[Callback 配置参考]([])。  


## 界面  

配置界面简洁直观，可快速修改参数、查看日志：  
![ddns-go 界面]([])  


## 开发 & 自行编译  

如需从源码编译，可使用项目提供的 Makefile：  
- 生成本地可执行文件：`make build`  
- 编译 Docker 镜像：`make build_docker_image`  


### 支持的域名服务商完整列表  
阿里云、腾讯云、Dnspod、Cloudflare、华为云、Callback、百度云、Porkbun、GoDaddy、Namecheap、NameSilo、Dynadot、DNSLA、时代互联、Eranet、Gcore。  


更多细节可参考项目 [Wiki]([]) 或 [FAQ]([])。

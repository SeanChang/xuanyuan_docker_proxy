---
image: boredazfcuk/icloudpd
description: "这是一个基于Alpine Linux 3.21.2系统的容器，专为运行iCloud照片下载器（iCloud Photos Downloader）命令行工具设计，提供轻量级、高效的运行环境，方便用户通过命令行操作快速下载iCloud中的照片资源。"
source: https://xuanyuan.cloud/zh/r/boredazfcuk/icloudpd
canonical: https://xuanyuan.cloud/zh/r/boredazfcuk/icloudpd
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/boredazfcuk/icloudpd" title="boredazfcuk/icloudpd Docker 镜像中文简介、标签列表与拉取命令">boredazfcuk/icloudpd 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## docker-icloudpd 介绍  


### 基本信息  
这是一个基于 Alpine Linux 的 Docker 容器，集成了 iCloud 照片下载器（iCloud Photos Downloader）。我用它来同步家里所有 iOS 设备的照片流到服务器——因为这是目前把多台设备照片备份到同一位置的唯一办法。  


### 核心功能  
- **安全存储凭证**：通过系统密钥环加密保存 iCloud 账号信息，避免明文暴露。  
- **格式转换**：支持将 HEIC 格式照片自动转为 JPG，方便跨设备查看。  
- **多平台通知**：可发送同步状态通知到 、Prowl、Pushover、WebHook、钉钉、、openhab、IYUU、企业微信、msmtp 及 Signal 等平台。  

**注意**：不支持 Apple 高级数据保护（ADP），使用前需先关闭 ADP，否则容器无法正常工作。  


### 新增特性  
#### 1. 远程重新认证（ 支持）  
借助  双向通信功能，现在可通过  聊天机器人重新认证 iCloud 凭证：  
- 给机器人发送“重新认证”消息（具体指令见配置文档）；  
- 容器会回复请求多因素认证（MFA）验证码；  
- 发送验证码后自动完成登录流程，无需从容器命令行重新初始化。  


#### 2. 本地重新认证更便捷  
现在只需在 Docker 命令行运行 `reauth.sh` 脚本，即可更新多因素认证的 Cookie（详细步骤见配置文档）。  


#### 3.  双向通信  
给  聊天发送消息，容器会立即触发照片同步，无需手动执行同步命令。  


#### 4. 内置 Nextcloud 同步  
配置 Nextcloud 后：  
- 所有下载的照片（包括 HEIC 转 JPG 后的文件）会自动上传到 Nextcloud 服务器；  
- 本地删除的照片，也会同步删除 Nextcloud 上的对应文件。  


### 配置说明  
Docker Hub 的 README 有 25,000 字符限制，完整配置文档（约 37,000 字）已移至 GitHub，具体设置方法请参考：  
[CONFIGURATION.md]([])  


### 捐赠支持  
若觉得有用，可通过以下地址捐赠：  
- Litecoin：LfmogjcqJXHnvqGLTYri5M8BofqqXQttk4  
- Ethereum：0x752F0Fc9c1D1a10Ae3ea429505a0bbe259D60C6c  
- ：1E8kUsm3qouXdVYvLMjLbw7rXNmN2jZesL 或 bc1q7mpp4253xeqsyafl4zkak6kpnfcsslakuscrzw

---
image: xgheaven/homebox
description: "家庭网络工具箱是一款专为用户组建家庭局域网时提供调试、检测及压测功能的实用工具集合，可帮助用户快速排查网络连接故障、验证设备兼容性、测试带宽稳定性，涵盖IP配置检查、端口扫描、网速压力测试等常用功能，助力用户高效搭建稳定、可靠的家庭网络环境，满足日常上网、智能家居设备互联等多样化需求。"
source: https://xuanyuan.cloud/zh/r/xgheaven/homebox
canonical: https://xuanyuan.cloud/zh/r/xgheaven/homebox
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/xgheaven/homebox" title="xgheaven/homebox Docker 镜像中文简介、标签列表与拉取命令">xgheaven/homebox 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Homebox


## 简介  
Homebox 是一款家庭网络工具箱，适用于家庭局域网组建过程中的调试、检测与压测工作。


## 注意事项  
使用时需注意：  
- 家庭内需配备性能较强的服务端，否则服务端可能成为性能瓶颈；  
- 测试端需使用 Chrome、Firefox 等现代新版浏览器；  
- 若测试高速网络，建议确保设备 CPU 性能充足。


## 特性  
- 面向现代浏览器设计  
- 支持最高 10G 浏览器测速  
- 内置 Ping 检测功能  
- 提供丰富的自定义测速参数  
- 服务端无需固态硬盘  
- UI 交互友好  
- 针对低速网络（<2.5G）优化测速资源占用  


## 截图  
深色模式界面  
![dark-theme](./doc/dark-theme.png)  

浅色模式界面  
![light-theme](./doc/light-theme.png)  


## 安装  

### Docker  
1. **前提条件**：需准备一台支持安装 Docker 的服务器（如群辉、FreeNas、unRaid、CentOS 等），目前暂支持 x86 架构服务器。  
2. 安装并启动镜像：`xgheaven/homebox`，默认暴露端口为 3300。  
3. 访问方式：在浏览器中输入 `[] 即可（若端口重映射，需使用映射后的端口）。  


### 二进制文件  
1. 前往 [Release]  下载对应版本的二进制文件。  
2. 解压后直接执行编译好的二进制文件即可启动。  


## 使用方法  
主要提供两种测试模式：  

- **单次测速**：依次执行 Ping、下载、上传测试，适合常规网络性能检测。  
- **持续压测**：无限制以最高速度压测链路，适用于设备移动中链路稳定性测试、多设备并发压测、路由器转发散热性能测试等场景。  


## 测试结果  
- 在 2017 款 13 寸 MacBook 上，低速配置下可实现 4G 下载速度、3G 上传速度。  
- 在 2019 款 16 寸 MacBook 上，开启高速模式后，最高可达到 12G 下载速度、10G 上传速度。  


## 技术支持  
基于以下技术开发：  
- Golang (gin)  
- TypeScript  
- React

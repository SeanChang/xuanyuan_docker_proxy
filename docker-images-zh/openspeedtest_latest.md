---
image: openspeedtest/latest
description: "OpenSpeedTest™速度测试是一款免费且开源的HTML5网络性能评估工具，它基于HTML5技术开发，无需安装额外软件即可便捷使用，适用于各类设备和网络环境，能够帮助用户快速测试并获取准确的网络性能数据，为用户在不同设备和网络条件下评估网络状况提供了高效实用的解决方案。"
source: https://xuanyuan.cloud/zh/r/openspeedtest/latest
canonical: https://xuanyuan.cloud/zh/r/openspeedtest/latest
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openspeedtest/latest" title="openspeedtest/latest Docker 镜像中文简介、标签列表与拉取命令">openspeedtest/latest — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/openspeedtest/latest" title="openspeedtest/latest Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/openspeedtest/latest</a>

# OpenSpeedTest：免费开源的HTML5网络性能测试工具


## 工具简介  
OpenSpeedTest是一款免费开源的HTML5网络性能测试工具，采用原生JavaScript开发，仅依赖`XMLHttpRequest`（XHR）、HTML、CSS、JS及SVG等浏览器内置Web API，无需任何第三方框架或库。部署简单，只需Nginx等静态Web服务器即可运行。项目始于2011年，2013年正式启用OpenSpeedTest.com作为专用域名。  


## 核心优势  

### 安全设计  
工具仅包含HTML、CSS、JS等静态文件，无需担心安全更新或隐藏漏洞，可放心用于安全环境。  

### 轻量高效  
原生JavaScript编写，无第三方依赖，测速脚本经gzip压缩后体积不足8kB，意外实现了高性能运行。  

### 跨设备支持  
兼容IE10及以上所有现代浏览器，可在任何带浏览器的设备上运行（电脑、手机、平板等）。  

### 全屏幕适配  
用户界面基于SVG开发，可自适应各种屏幕尺寸和分辨率。  


## 搭建个人测速服务器  

### 一、服务器基础要求  
需使用支持HTTP/1.1及以上协议的Web服务器（如Nginx、Apache、IIS、Express等），并满足以下配置：  
- 允许`GET`、`POST`、`HEAD`、`OPTIONS`请求，响应状态为`200 OK`；  
- 支持静态文件接收`POST`请求，响应状态为`200 OK`；  
- `client_max_body_size`设置为35MB及以上；  
- 超时时间大于60秒；  
- 建议关闭访问日志以提升性能；  
- 优化“首字节时间”（TTFB）；  
- 若部署在反向代理后，需将`post-body`内容长度调至35MB以上；  
- 支持HTTP2、HTTP3，上传测试时需等待并丢弃POST数据。  


### 二、快速部署：预配置应用  
提供多平台预打包应用，直接下载即可使用，无需手动配置服务器：  
- **桌面平台**：微软商店、Mac应用商店  
- **移动平台**：App Store（iOS）、Google Play（Android）  
- **包管理/容器**：Snap Store、Docker Hub、Helm Charts  
- **源码/手动部署**：GitHub  


### 三、Docker部署（推荐大规模/无界面场景）  
适合局域网、广域网或无互联网环境部署，基于`nginxinc/nginx-unprivileged:stable-alpine`镜像，资源占用低（非root用户运行）。  


#### 基础部署步骤  
1. 安装Docker后，执行以下命令启动容器：  
   ```bash  
   sudo docker run --restart=unless-stopped --name openspeedtest -d -p 3000:3000 -p 3001:3001 openspeedtest/latest  
   ```  

2. 或使用`docker-compose.yml`：  
   ```yaml  
   version: '3.3'  
   services:  
     speedtest:  
       restart: unless-stopped  
       container_name: openspeedtest  
       ports:  
         - '3000:3000'  # HTTP端口  
         - '3001:3001'  # HTTPS端口  
       image: openspeedtest/latest  
   ```  

3. 访问测试：  
   - HTTP：`[]  
   - HTTPS：`[]  


#### 自定义端口与SSL配置  
- **修改端口**：若需使用80/443端口，启动时映射为`-p 80:3000 -p 443:3001`。  
- **自动配置SSL（Let's Encrypt）**：  
  需公网IP、域名及邮箱，启动时添加环境变量：  
  ```bash  
  docker run -e ENABLE_LETSENCRYPT=True -e DOMAIN_NAME=speedtest.yourdomain.com -e USER_EMAIL=[邮箱已删除] --restart=unless-stopped --name openspeedtest -d -p 80:3000 -p 443:3001 openspeedtest/latest  
  ```  
- **自定义SSL证书**：  
  将证书文件命名为`nginx.crt`和`nginx.key`，挂载证书目录：  
  ```bash  
  sudo docker run -v /本地证书目录:/etc/ssl/ --restart=unless-stopped --name openspeedtest -d -p 3000:3000 -p 3001:3001 openspeedtest/latest  
  ```  


## 高级功能与配置  

### 1. 压力测试（连续测速）  
通过URL参数启动，支持预设时长或自定义秒数：  
- 预设值：`Low`（300秒）、`Medium`（600秒）、`High`（900秒）等，可缩写为首字母（如`S=L`即`Stress=Low`）。  
- 示例：`[]  


### 2. 自动运行测试  
- 页面加载后立即测试：`[]  
- 延迟指定秒数后测试：`[]  


### 3. 多参数组合  
支持同时传递多个参数（不区分大小写），例如：  
- 立即启动并持续300秒压力测试：`[] 或 `[]  


### 4. 其他实用参数  
| 参数          | 用途                          | 示例                                  |  
|---------------|-------------------------------|---------------------------------------|  
| `Host`/`H`    | 指定测试服务器                | `[] |  
| `Test`/`T`    | 单独运行下载/上传/PING测试    | `[] |  
| `Ping`/`P`    | 设置PING采样数（更精准）      | `[]   |  
| `Out`/`O`     | 设置请求超时时间（毫秒）      | `[]   |  


## 为什么需要自建测速服务器？  
- **场景1：家庭/办公室网络检测**：员工远程办公时，测试与办公室服务器的实际连接速度，确保业务流畅。  
- **场景2：ISP对比**：不同ISP的公网测速结果可能与实际访问内网/云服务器的速度不符，自建服务器可反映真实体验。  
- **场景3：网络故障排查**：当部分设备网速异常时，通过本地测速可定位问题（如VLAN配置错误、交换机故障）。  
- **场景4：中继器部署**：中继器可能降低网速，通过本地测速可确定最佳放置位置（兼顾覆盖与速度）。  
- **场景5：浏览器性能检查**：测试浏览器插件对网速的影响（如部分插件可能拖慢页面加载，通过无痕模式对比即可发现）。  


## 开源协议  
项目基于MIT协议开源，允许自由使用、修改和分发，详情见[GitHub仓库]([])。

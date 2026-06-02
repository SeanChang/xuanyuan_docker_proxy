---
image: iyuucn/iyuuplus
description: "IYUU自动辅种工具是一款专为PT下载用户设计的辅助软件，它能自动监控本地下载目录，通过分析已有种子文件的哈希值、文件名等信息，在用户配置的PT站点中智能搜索并下载缺失种子，实现自动辅种，有效帮助用户提升分享率，减少手动查找添加种子的操作，提高PT资源管理效率，是PT爱好者优化下载体验的实用工具。"
source: https://xuanyuan.cloud/zh/r/iyuucn/iyuuplus
canonical: https://xuanyuan.cloud/zh/r/iyuucn/iyuuplus
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/iyuucn/iyuuplus" title="iyuucn/iyuuplus Docker 镜像中文简介、标签列表与拉取命令">iyuucn/iyuuplus — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/iyuucn/iyuuplus" title="iyuucn/iyuuplus Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/iyuucn/iyuuplus</a>

# IYUUPlus开发版


## 简介  
IYUUPlus是一款基于PHP-CLI模式运行的常驻内存项目，集成WebUI界面，提供辅种、文件转移、下载管理、定时访问URL、动态域名DDNS等功能，并支持插件扩展。客户端完全开源，行为透明且安全可靠，用户可根据源码自由定制。作为自动辅种工具，它适配国内多数PT站点，支持下载器集群、多盘位、多下载目录及远程下载器连接。


## 免责声明  
使用前请务必阅读以下条款：  
IYUU工具本身安全，辅种过程不与PT站点服务器直接交互，仅将种子链接推送至下载器，由下载器主动操作。但需注意：  
1. 禁止手动跳校验，因此导致的账号封禁与IYUU无关；  
2. 官方或其他首发资源在出种前无法辅种，因个人作弊导致的封禁与IYUU无关；  
3. 使用工具造成的任何损失，IYUU不承担责任。如不接受本条款，请勿使用并删除已下载的源码。


## 工作原理  
IYUU自动辅种工具（IYUUAutoReseed）是PHP编写的Private Tracker辅种脚本，通过计划任务或常驻内存运行。其流程为：按设定频率调用Transmission、qBittorrent等下载器的API接口，提取做种任务的info_hash并提交至辅种服务器API（全程不与PT站交互）；根据返回数据拼接种子链接，推送至下载器，由下载器主动完成种子下载、校验及做种，实现多站点自动辅种。


## 使用指南  

### 使用文档  
详细说明可参考官方文档：[[]]([])  

### 运行要求  
- **最低PHP版本**：v8.3.0（推荐最新稳定版）  
- **必须开启的扩展**：  
```config
extension=curl
extension=fileinfo
extension=gd
extension=mbstring
extension=exif
extension=mysqli
extension=openssl
extension=pdo_mysql
extension=pdo_sqlite
extension=sockets
extension=sodium
extension=sqlite3
extension=zip
```

### 技术栈  
| 组件            | 版本     | 官网地址                                  |
|-----------------|----------|-------------------------------------------|
| Workerman       | 4.1.15   | []  |
| Webman          | 1.5.16   | []     |
| WebmanAdmin     | 0.6.20   | [] |
| PHP             | 8.3.0    | []                      |
| MYSQL           | 5.7.26   | []                    |
| Layui           | 2.8.12   | []                        |
| Vue             | 3.4.21   | []                        |

### 支持的下载器  
- Transmission  
- qBittorrent  

### Nginx反向代理配置  
如需配置反向代理，可参考以下示例：  
```conf
location ^~ / {
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header Host $host;
  proxy_set_header X-Forwarded-Proto $scheme;
  proxy_http_version 1.1;
  proxy_set_header Connection "";
  if (!-f $request_filename){
    proxy_pass [];
  }
}

location /app/d9422b72cffad23098ad301eea0f8419
{
  proxy_pass [];
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "Upgrade";
  proxy_set_header X-Real-IP $remote_addr;
}
```


## 版本发布与反馈  

### 版本发布页  
- 国内：[[]]([])  
- 国际：[[]]([])  

### 需求提交与错误反馈  
- QQ群：859882209（2000人）、41477250（1000人）、924099912（2000人）  
- Issues：[[]]([])  
- 博客：[[]]([])  


## 接口开发与贡献  

### 接口开发文档  
实时更新的接口文档：[[]]([])。开发者可基于接口扩展功能（如手机APP、Windows GUI程序、浏览器插件等），欢迎分享作品。  

### 感谢贡献者  
- [[]]([])  
- [[]]([])

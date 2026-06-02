<!-- xuanyuan-docker-images-zh
image: johngong/calibre-web
source: https://xuanyuan.cloud/zh/r/johngong/calibre-web
canonical: https://xuanyuan.cloud/zh/r/johngong/calibre-web
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [johngong/calibre-web — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/johngong/calibre-web "johngong/calibre-web Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/johngong/calibre-web

# 群晖NAS自用calibre-web方案


## 项目简介  
本文介绍群晖NAS上通过Docker部署的calibre-web电子书管理方案，整合了ebook-convert格式转换工具及calibre-server服务，支持多架构（amd64/arm64v8/arm32v7）。  

- **项目地址**：[GitHub]([])  
- **感谢上游项目**：  
  [calibre-web]([])、[calibre]([])  


## 版本信息  
| 名称           | 版本   | 说明                          |
|----------------|--------|-------------------------------|
| calibre-web    | 0.6.25 | 支持amd64;arm64v8;arm32v7     |
| calibre-server | 8.0.1  | 支持amd64;arm64v8;arm32v7     |
| kepubify       | 4.0.4  | 支持amd64;arm64v8;arm32v7     |


## 版本升级注意事项  
1. **功能冲突**：0.6.22版本新增“下载时嵌入元数据”功能，可能导致calibre-server与calibre-web冲突。若需同时启用，需设置环境变量`ENABLE_CALIBREDB_URLLIBRARYPATH=true`。  
2. **变量名变更**：0.6.16-5.35.0及以后版本，变量名从`USER`/`PASSWORD`/`WEBLANGUAGE`改为`CALIBRE_SERVER_USER`/`CALIBRE_SERVER_PASSWORD`/`CALIBRE_SERVER_WEB_LANGUAGE`（详见下方“变量名变更表”）。  
3. **中文目录支持**：新版通过环境变量`CALIBRE_ASCII_FILENAME=false`开启中文目录（非拼音），旧版CN版需手动替换，替换前务必备份书库。  
4. **自动添加图书**：新增“自动添加图书”功能（配置`autoaddbooks`文件夹，图书添加后自动删除），使用前建议备份图书。  
5. **arm架构限制**：arm版`ebook-convert`可能无法转换PDF格式；calibre-server的OPDS功能在arm设备上可能不可用。  
6. **元数据搜索**：0.6.16及以前版本未集成Google Scholar搜索；豆瓣搜索功能在0.6.18及以前需设置`ENABLE_DOUBAN_SEARCH=true`，0.6.16及以前需额外部署豆瓣API服务并配置`DOUBANIP`。  


## Docker命令行设置  

### 变量名变更对照  
| 版本                  | 0.6.16-5.35.0及以后          | 0.6.16-5.10.1及以前          |
|-----------------------|------------------------------|------------------------------|
| 1                     | `CALIBRE_SERVER_USER`        | `USER`                       |
| 2                     | `CALIBRE_SERVER_PASSWORD`    | `PASSWORD`                   |
| 3                     | `CALIBRE_SERVER_WEB_LANGUAGE`| `WEBLANGUAGE`                |

### 操作步骤  
1. **下载镜像**  
   | 镜像源       | 命令                                  |
   |--------------|---------------------------------------|
   | DockerHub    | `docker pull johngong/calibre-web:latest` |
   | GitHub       | `docker pull ghcr.io/gshang2017/calibre-web:latest` |

2. **创建容器**  
   ```bash
   docker create  \
      --name=calibre-web  \
      -p 8083:8083  \
      -p 8080:8080  \
      -v /本地配置文件路径:/config  \
      -v /本地书库路径:/library  \
      -v /本地自动添加文件夹路径:/autoaddbooks  \
      -e UID=1000  \
      -e GID=1000  \
      -e CALIBRE_SERVER_USER=用户名  \
      -e CALIBRE_SERVER_PASSWORD=用户密码 \
      --restart unless-stopped  \
      johngong/calibre-web:latest
   ```  

3. **运行容器**：`docker start calibre-web`  
4. **停止容器**：`docker stop calibre-web`  
5. **删除容器**：`docker rm calibre-web`  
6. **删除镜像**：`docker image rm johngong/calibre-web:latest`  


## 群晖Docker设置  

### 1. 卷配置  
| 参数                | 说明                                  |
|---------------------|---------------------------------------|
| 本地文件夹1:/library | 书库路径（calibre-web与calibre-server共用） |
| 本地文件夹2:/config  | 配置文件路径（存储calibre-web和calibre-server配置） |
| 本地文件夹3:/autoaddbooks | 自动添加图书的文件夹路径 |

### 2. 端口配置  
| 参数                | 说明                                  |
|---------------------|---------------------------------------|
| 本地端口1:8083      | calibre-web访问端口（默认用户名：admin，密码：admin123） |
| 本地端口2:8080      | calibre-server访问端口                |

### 3. 环境变量配置  
| 参数                                  | 说明                                                                 |
|---------------------------------------|----------------------------------------------------------------------|
| `UID=1000`                            | 用户ID，默认1000                                                     |
| `GID=1000`                            | 用户组ID，默认1000                                                   |
| `ENABLE_AUTOADDBOOKS=true`            | 开启自动添加图书（默认开启）                                         |
| `ENABLE_CALIBRE_SERVER=false`         | 开启calibre-server（默认关闭）                                       |
| `CALIBRE_SERVER_USER=用户名`          | calibre-server登录用户名                                             |
| `CALIBRE_SERVER_PASSWORD=用户密码`    | calibre-server登录密码                                               |
| `CALIBRE_ASCII_FILENAME=true`         | `false`时支持中文目录（默认`true`）                                  |
| `TZ=Asia/Shanghai`                    | 时区设置（默认Asia/Shanghai）                                        |
| `CALIBRE_WEB_LANGUAGE=zh_Hans_CN`     | calibre-web界面语言（默认中文，可选`en`）                            |


## 其他说明  
- **calibre-server上传**：配置用户名和密码后，可通过calibre-server上传图书。  
- **PDF字体设置**：转换PDF时需字体支持，将字体文件复制到`/config/fonts`（旧版为`/config/calibre-server/calibrefonts`），重启容器即可生效。  
- **多语言支持**：  
  - calibre-web支持语言：`en`/`cs`/`de`/`es`/`fr`/`zh_Hans_CN`/`zh_Hant_TW`等（通过`CALIBRE_WEB_LANGUAGE`设置）。  
  - calibre-server支持语言：`en`/`zh_CN`/`ja`/`ko`等（通过`CALIBRE_SERVER_WEB_LANGUAGE`设置）。

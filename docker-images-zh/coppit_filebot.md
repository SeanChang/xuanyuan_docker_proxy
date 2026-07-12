---
image: coppit/filebot
description: "这是一个运行FileBot媒体文件整理工具的Docker容器，支持UI交互（RDP/网页）和自动监控文件夹模式，可帮助用户重命名、分类媒体文件，提升管理效率。"
source: https://xuanyuan.cloud/zh/r/coppit/filebot
canonical: https://xuanyuan.cloud/zh/r/coppit/filebot
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/coppit/filebot" title="coppit/filebot Docker 镜像中文简介、标签列表与拉取命令">coppit/filebot 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-filebot

这是一个运行[FileBot](http://www.filebot.net/)媒体文件整理工具的Docker容器，支持用户界面（UI）和全自动模式。UI可通过RDP或HTTP访问；自动化模式下，只需将文件放入输入目录，即可自动清理并移动到输出目录。该镜像可在[Docker Hub](https://hub.docker.com/r/coppit/filebot/)获取。

## 核心功能
- 双模式支持：提供UI交互（RDP远程桌面+网页端）和自动化监控整理
- 媒体管理：自动重命名、分类电影/电视剧文件，支持字幕下载
- 自定义配置：可修改文件命名格式、用户权限、处理逻辑等
- 资源灵活：可按需启用/禁用UI，平衡资源占用

## 使用场景
- 家庭媒体服务器：自动整理下载的影视文件
- 批量处理：对大量媒体文件进行统一标准化命名
- 远程操作：通过网页或RDP远程管理媒体文件

## 部署示例
### 交互模式（启用UI）
```bash
docker run --name=FileBotUI -e WIDTH=1280 -e HEIGHT=720 -p 3389:3389 -p 8080:8080 -v /你的媒体目录:/media:rw -v /你的配置目录:/config:rw docker.xuanyuan.run/coppit/filebot
```
访问方式：  
1. 网页端：`http://主机IP:8080/`  
2. RDP客户端：连接`主机IP:3389`

### 非交互模式（自动化）
```bash
docker run --name=FileBot -d -v /你的输入目录:/input:rw -v /你的输出目录:/output:rw -v /你的配置目录:/config:rw docker.xuanyuan.run/coppit/filebot
```
说明：输入目录文件会自动整理到输出目录，建议两者不重叠

### 混合模式（UI+自动化）
```bash
docker run --name=FileBot -e WIDTH=1280 -e HEIGHT=720 -p 3389:3389 -p 8080:8080 -v /媒体目录:/media:rw -v /输入目录:/input:rw -v /输出目录:/output:rw -v /配置目录:/config:rw docker.xuanyuan.run/coppit/filebot
```
注意：避免在UI中操作输入目录，防止重复触发自动化

## 配置说明
1. **首次运行**：  
   - 生成`filebot.conf`（配置字幕下载）和`filebot.sh`（自定义处理逻辑）  
   - 编辑`filebot.sh`设置命名格式后重启容器  

2. **环境变量**：  
   - `USER_ID`/`GROUP_ID`：设置文件创建的用户/组ID（默认root）  
   - `UMASK`：文件权限掩码（默认0022）  
   - `ALLOW_REPROCESSING`：允许重新处理文件（需删除`amc-exclude-list.txt`）  
   - `USE_UI`：是否启用UI（yes/no，启用增加资源占用）  

3. **更新处理**：  
   容器更新后若出现`filebot.sh.new`，需合并自定义内容并更新VERSION行，再重启  

4. **高级优化**：  
   若输入/输出分离导致移动缓慢，可挂载单个`/media`目录，在`filebot.conf`中设置子目录作为输入/输出（避免嵌套）  

## 已知限制
- 依赖inotify接口监控文件变化，不支持网络共享目录
- 自动化模式下输入/输出目录重叠会导致重复处理问题

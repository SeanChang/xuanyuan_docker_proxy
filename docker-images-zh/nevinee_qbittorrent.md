<!-- xuanyuan-docker-images-zh
image: nevinee/qbittorrent
source: https://xuanyuan.cloud/zh/r/nevinee/qbittorrent
canonical: https://xuanyuan.cloud/zh/r/nevinee/qbittorrent
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/nevinee/qbittorrent" title="nevinee/qbittorrent Docker 镜像中文简介、标签列表与拉取命令">nevinee/qbittorrent — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/nevinee/qbittorrent" title="nevinee/qbittorrent Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/nevinee/qbittorrent</a></p>

# qBittorrent Docker镜像使用说明


## 重要说明  
为保障使用安全，自2023年9月5日更新的镜像起，创建容器时**必须新增设置两个环境变量**：  
- `QB_USERNAME`：qBittorrent登录用户名  
- `QB_PASSWORD`：qBittorrent登录密码  

容器将通过这两个变量初始化或修改登录信息。若未设置，或保持默认值（默认用户名`admin`、默认密码`adminadmin`），镜像附加的所有脚本、定时任务将**无法使用**。  
此外，镜像默认已安装Python，无需额外设置`INSTALL_PYTHON`环境变量。  
*详细背景可参考[相关说明]([])。*  


## 镜像声明  
本镜像为**官方原版增强版**，非魔改、非快验、非Enhanced版本：  
- qBittorrent自身功能/行为**未做任何修改**，与官方客户端完全一致，和PT站Tracker交互时反馈的信息均为官方原版数据。  
- 仅附加实用脚本，所有脚本通过qBittorrent官方API合法获取信息，运行行为限于本地，不与任何远端服务器交互。  
- 脚本代码完全开源，可在[Github]([])或[Gitee]([])查看。  
- **使用本镜像不会导致账号被封**。  


## 功能特点  
### 核心功能  
- **自动分类/打标签**：按种子`tracker`自动分类或打标签（支持关闭；可选择使用qBittorrent的“分类”或“标签”功能）。  
- **下载完成通知**：支持关闭；可选通知途径：钉钉（[效果图]([])）、、ServerChan、爱语飞飞、PUSHPLUS推送加、企业微信、Gotify；可搭配RSS自动下载使用，且支持运行自定义脚本。  
- **故障告警**：容器或服务故障时发送通知，途径同上。  
- **tracker状态监控**：按设定cron周期检查tracker状态，异常种子自动添加`TrackerError`标签，便于筛选；错误数量超阈值时触发通知。  

### 辅助功能  
- 批量修改tracker信息；  
- 检测指定文件夹下未做种的子文件夹/文件；  
- 生成做种文件清单、未做种文件清单；  
- 集成IYUUPlus标签，自动配置下载器，简化IYUUPlus设置；  
- 支持下载完成后触发EMBY/JELLYFIN媒体库扫描、ChineseSubFinder字幕自动下载（操作方法见[DIY指南]([])）。  


## 效果图参考  
功能操作效果（如批量修改tracker、生成种文件清单等）可查看以下链接：  
- [iyuu-help]([])  
- [change-tracker]([])  
- [remove-tracker]([])  
- [del-unseed-dir]([])  
- [report-seed-files]([])  


## 源代码与问题反馈  
### 代码仓库  
- Github：[devome/dockerfiles]([])  
- Gitee：[evine/dockerfiles]([])  

### 提交bug需提供信息  
反馈问题时请务必包含以下内容，否则可能无法处理：  
1. 容器创建命令或`docker-compose.yml`文件（密码请打码）；  
2. 使用的镜像tag及qBittorrent版本；  
3. 进入容器后运行 `bash -x /usr/local/bin/<命令名>`（如 `bash -x /usr/local/bin/report-seed-files`）的输出结果（密码请打码）。  

*镜像统计：[Docker Pulls]([]) | [Docker Stars]([]) | [GitHub Stars]([])*  


> 详细教程及全部说明见 [博客原文]([])。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/nevinee/qbittorrent" title="nevinee/qbittorrent Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/nevinee/qbittorrent</a></p>

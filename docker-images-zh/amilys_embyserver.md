---
image: amilys/embyserver
description: "Emby媒体服务器是用于集中管理、组织和流式传输电影、音乐、照片、剧集等各类媒体文件的版本应用程序，支持多平台设备访问，提供高清播放、自定义媒体库分类、用户权限管理及跨设备同步等功能。"
source: https://xuanyuan.cloud/zh/r/amilys/embyserver
canonical: https://xuanyuan.cloud/zh/r/amilys/embyserver
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amilys/embyserver" title="amilys/embyserver Docker 镜像中文简介、标签列表与拉取命令">amilys/embyserver — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/amilys/embyserver" title="amilys/embyserver Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/amilys/embyserver</a>

# Emby 容器版本更新及使用指南


## 版本信息
| 时间       | beta 版本    | latest 版本   |
|------------|--------------|---------------|
| 2025/09/29 | v4.9.1.36    | v4.9.1.80     |


## 新增功能说明

### 1. emby-erx Emby 增强/美化插件  
- **功能**：提供 Emby 界面美化与功能增强  
- **作者**：[Nolovenodie/emby-crx]([])  
- **启用方法**：  
  在 `/config/config/ext.sh` 中添加媒体库 ID（多个 ID 用逗号分隔，媒体库 ID 可从媒体库页面 URL 的 `parentId` 参数获取），重启容器后按 `Ctrl+F5` 刷新网页。  


### 2. dd-danmaku Emby 弹幕库插件  
- **功能**：为视频播放添加弹幕支持  
- **作者**：[RyoLee/dd-danmaku]([])  
- **启用/关闭**：在 `/config/config/ext.sh` 中通过配置 `extmod` 参数控制（详见下方扩展脚本说明）。  


### 3. emby 调用外部播放器  
- **功能**：支持调用外部播放器（如 Potplayer）播放内容  
- **作者**：[bpking1/embyExternalUrl]([])  
- **启用/关闭**：在 `/config/config/ext.sh` 中通过配置 `extmod` 参数控制。  


## ext.sh 扩展脚本配置说明  
### 脚本作用与位置  
`ext.sh` 是容器启动时自动运行的脚本，用于自定义功能（路径：`/docker/emby/config/ext.sh`）。脚本需手动更新（可删除原脚本后重启容器自动更新）。  

### 关键配置项说明  
打开脚本后，可修改以下参数实现功能控制：  
- **MediaId**：媒体库 ID（用逗号分隔），用于启用 emby-erx 美化插件（留空则不启用）。示例：`MediaId="21466,21463"`  
- **extmod**：扩展插件列表，控制外部播放、弹幕等功能。可选值：`embyLaunchPotplayer`（外部播放）、`ede.user`（弹幕）、`actorPlus`（未知演员隐藏）。示例：`extmod='["embyLaunchPotplayer","ede.user"]'`  

### 脚本示例（关键部分）  
```sh
#!/bin/sh

echo "Emby扩展启动脚本"

# 媒体库ID（启用emby-crx需填写）
MediaId=""  # 示例：MediaId="21466,21463"

# 扩展插件配置
extmod='["embyLaunchPotplayer","ede.user","actorPlus"]'  # 根据需求调整插件列表

sed -i '/\ extmod/s/\[.*\]/'$extmod'/g' /system/dashboard-ui/ext.js

exit 0
```


## 安装步骤（群晖 Docker 用户）  
1. **获取镜像**：在群晖 Docker 注册表中搜索并选择所需镜像版本。  
2. **容器配置**：勾选 **Privileged（高权限）** 启动容器（无需修改环境变量）。  
3. **目录映射**：将本地目录 `/docker/emby` 映射到容器内 `/config`。  
4. **激活 Emby Premiere**：进入 Emby 设置 → Emby Premiere，输入 `疯狂星期四V我50` 并保存。  
5. **刷新浏览器**：完成后刷新网页即可使用。  
6. **电视直播设置**：添加直播源后，需手动刷新指南数据。  
7. **清理镜像（可选）**：通过 SSH 执行 `docker image prune` 清理过时镜像。  


## 同版本更新方法  
1. **停止容器**：在群晖 Docker 中停止当前 Emby 容器。  
2. **更新镜像**：在 Docker 注册表中搜索并更新至目标版本。  
3. **重置容器**：进入 Docker → 容器 → 选中 Emby 容器 → 操作 → 重置。  
4. **启动容器**：重启容器后刷新浏览器完成更新。  


**安卓与电视客户端**：可通过链接 [[]]([]) 获取。

---
image: xkand/istoreos
description: "iStoreOS自动化构建Docker镜像，基于官方x86_64固件，支持PVE/LXC快速部署与版本追溯"
source: https://xuanyuan.cloud/zh/r/xkand/istoreos
canonical: https://xuanyuan.cloud/zh/r/xkand/istoreos
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [xkand/istoreos — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/xkand/istoreos)

含镜像标签、拉取命令、部署文档与相关推荐。

[xkand/istoreos Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/xkand/istoreos)

## iStoreOS 自动化构建项目说明

### 项目目标
通过 GitHub Actions 定时检测 iStoreOS 官方版本更新，自动构建并同步 Docker 镜像至仓库，支持 PVE/LXC 环境快速部署。

### 官方源与版本检测
- **官网地址**：https://fw.koolcenter.com/iStoreOS/x86_64_efi/
- **检测频率**：每 4 小时自动查询官方地址，通过版本号比对识别新版本。

### 版本标签规则
- **latest**：始终指向官方最新发布的版本镜像，适合追求稳定的用户。
- **日期时间标签**：格式为 YYYYMMDDHH（如 2025071110），精确到发布小时，便于历史版本回溯与管理。

### 自动化构建流程
1. **版本检测**：GitHub Actions 定时任务（Cron 0 */4 * * *）访问官方地址，校验新版本。
2. **镜像构建**：自动拉取官方固件，基于标准化流程构建 Docker 镜像。
3. **镜像发布**：推送至 GitHub 容器仓库（tonc/istoreos），同步更新 latest 和日期标签。

### 仓库与资源
- **GitHub 仓库**：https://github.com/tonc/istoreos
- **LXC 容器模板**：仓库内 Releases 页面提供 LXC 容器模板，适用于 PVE-LXC 环境。

### 技术细节
- **触发机制**：基于 GitHub Actions 的定时调度（Cron 0 */4 * * *），确保及时同步官方更新。
- **版本校验**：通过对比官方发布时间戳，避免重复构建。
- **镜像标签策略**：
  - latest：动态指向最新版本，适合自动化部署。
  - YYYYMMDDHH：精确到小时的时间戳标签，保障版本可追溯性。

### 适用场景
- **PVE/LXC 用户**：通过预置模板快速部署 iStoreOS 虚拟环境。
- **开发者**：基于 Docker 镜像进行二次开发或功能测试。
- **运维团队**：定时同步官方更新，确保环境安全性与稳定性。

### 部署方案示例
#### Docker 部署
```bash
docker pull tonc/istoreos:latest
# 运行容器（根据需求调整端口映射等参数）
docker run -d --name istoreos --restart always tonc/istoreos:latest
```

#### PVE-LXC 部署
1. 访问 GitHub 仓库 Releases 页面（https://github.com/tonc/istoreos/releases）下载 LXC 容器模板。
2. 在 PVE 管理界面中创建 LXC 容器，选择下载的模板进行部署。
3. 启动容器并完成初始化配置。

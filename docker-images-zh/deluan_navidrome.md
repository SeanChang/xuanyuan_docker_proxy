<!-- xuanyuan-docker-images-zh
image: deluan/navidrome
source: https://xuanyuan.cloud/zh/r/deluan/navidrome
canonical: https://xuanyuan.cloud/zh/r/deluan/navidrome
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/deluan/navidrome" title="deluan/navidrome Docker 镜像中文简介、标签列表与拉取命令">deluan/navidrome — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/deluan/navidrome" title="deluan/navidrome Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/deluan/navidrome</a></p>

# Navidrome Music Server Docker镜像

Navidrome是一个开源的基于Web的音乐收藏服务器和流媒体服务。它让您能够从任何浏览器或移动设备自由访问您的音乐收藏，如同您的个人Spotify！支持多用户，低资源占用，兼容多种音频格式，是自建个人音乐服务的理想选择。

## 核心功能与特性

- **超大音乐库支持**：轻松处理大型音乐收藏
- **多格式兼容**：流式传输几乎所有可用的音频格式
- **元数据支持**：读取并使用您精心整理的所有元数据（id3标签）
- **多用户管理**：每个用户拥有独立的播放次数、播放列表、收藏等
- **低资源占用**：例如，300GB（约29000首歌曲）的音乐库仅占用不到50MB RAM
- **跨平台运行**：支持macOS、Linux和Windows，同时提供Docker镜像
- **树莓派支持**：提供适用于树莓派的二进制文件和Docker镜像
- **自动监控更新**：自动监控音乐库变化，导入新文件并重新加载元数据
- **现代Web界面**：基于Material UI的响应式界面，支持主题定制，便于管理用户和浏览音乐库
- **客户端兼容**：兼容所有Subsonic/Madsonic/Airsonic客户端

## 使用场景

- **个人音乐服务器**：自建个人音乐库，随时随地通过网络访问
- **家庭共享**：多用户环境下，每个家庭成员拥有独立的音乐体验
- **低资源设备部署**：适合在树莓派等低配置设备上运行
- **替代商业音乐服务**：保护音乐收藏所有权，无需依赖第三方平台

## Docker使用方法

Docker镜像支持`linux/amd64`、`linux/arm/v7`和`linux/arm64`架构，包含运行Navidrome所需的所有组件。

### Docker Compose配置示例

```yaml
# 示例配置，根据需求自定义

version: "3"
services:
  navidrome:
    image: deluan/navidrome:latest
    ports:
      - "4533:4533"  # Web界面和API端口
    environment:
      # 可选：自定义配置选项
      ND_SCANSCHEDULE: 1h  # 音乐库扫描间隔（默认1h）
      ND_LOGLEVEL: info    # 日志级别（可选：debug, info, warn, error）
      ND_BASEURL: ""       # 基础URL（如使用反向代理时配置）
    volumes:
      - "./data:/data"              # 存储配置、数据库等数据
      - "/path/to/your/music:/music:ro"  # 音乐库目录（建议设为只读）
```

### 开发版镜像

如需使用最新开发版（master分支），可将镜像改为：`deluan/navidrome:develop`

更多详细配置说明，请参阅[官方Docker文档](https://www.navidrome.org/docs/installation/docker)。

## 界面截图

提供移动设备（登录界面、播放器、专辑视图）和桌面设备的响应式界面，支持现代浏览器和移动客户端。

## Subsonic API兼容性

Navidrome实现了Subsonic API，兼容各类Subsonic客户端。最新API功能支持情况可查看[兼容性表](https://www.navidrome.org/docs/developers/subsonic-api)。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/deluan/navidrome" title="deluan/navidrome Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/deluan/navidrome</a></p>

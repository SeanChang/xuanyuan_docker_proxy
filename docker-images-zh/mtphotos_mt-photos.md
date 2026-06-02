---
image: mtphotos/mt-photos
description: "MT Photos是一款为NAS（网络附加存储）用户准备的照片管理系统，主要用于帮助用户高效存储、整理和管理各类照片资源，满足NAS环境下对照片数据的集中化、便捷化管理需求，为用户提供专业的照片管理解决方案。"
source: https://xuanyuan.cloud/zh/r/mtphotos/mt-photos
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[mtphotos/mt-photos](https://xuanyuan.cloud/zh/r/mtphotos/mt-photos)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# MT Photos 安装使用指南


## 准备条件
- 硬件：需一台 **x86 架构** 的 NAS 或个人服务器；  
- 环境：MT Photos 基于 Docker 运行，需提前安装 Docker，安装方法可参考 [Docker 官方文档]([])；  
- 配置：建议设备总内存不低于 2G。  


## 基本原理
MT Photos 支持两种照片/视频管理方式：导入本地已有的文件，或通过 App 备份手机相册。核心操作是将存储文件的文件夹映射到 Docker 容器，实现数据持久化管理。


## 安装步骤（命令行方式）
以下为通用命令行安装流程，常用 NAS 系统（如群晖 DSM）的图文教程可参考官网说明。


### 1. 拉取 Docker 镜像
执行以下命令下载最新版本镜像：  
```bash
docker pull mtphotos/mt-photos:latest
```


### 2. 创建必要文件夹
Docker 容器删除后，内部文件会丢失，需在宿主机创建持久化文件夹并映射到容器。  
> 提示：请根据你的 NAS/服务器目录结构，将下方 `/appdata` 替换为实际路径（如群晖可放在 `/volume1/docker` 下）。  

```bash
# 创建配置和数据存储目录
mkdir /appdata/mt_photos/config
mkdir /appdata/mt_photos/upload
```

- **config 文件夹**：用于存储数据库文件、缩略图、视频预览等缓存数据；  
- **upload 文件夹**：用于存放通过 App 备份的照片和视频。  


### 3. 启动 Docker 容器
通过以下命令创建并运行容器，根据实际需求调整路径和参数：  

```bash
docker run -d \
  --name mt-photos \
  -v /appdata/mt_photos/config:/config \  # 映射配置目录（必须）
  -v /appdata/mt_photos/upload:/upload \  # 映射备份文件目录（必须）
  -v /photos/folder1:/folder1 \  # 映射本地已有照片文件夹（示例1）
  -v /photos/folder2:/folder2 \  # 映射本地已有照片文件夹（示例2，可添加多个）
  -p 8063:8063 \  # 端口映射（宿主机端口:容器端口）
  -e TZ=Asia/Shanghai \  # 设置时区（如上海）
  --restart unless-stopped \  # 容器退出后自动重启
  mtphotos/mt-photos  # 镜像名称
```

**关键说明**：  
- `config` 和 `upload` 目录为必须映射，确保数据持久化；  
- 本地已有照片/视频文件夹（如示例中的 `/photos/folder1`）可根据实际数量添加，无数量限制，格式为 `-v 宿主机路径:容器内路径`。  


## 初始化设置
容器启动后，需完成首次配置：  

1. **访问 Web 界面**：在浏览器输入 `[]]:8063`（替换 `[NAS/服务器IP]` 为实际IP，端口默认 8063）；  
2. **选择语言**：根据需求选择系统界面语言；  
3. **创建管理员**：设置登录账户和密码；  
4. **配置图库**：按引导完成基础图库参数设置；  
5. **功能启用**：按需开启人脸识别、GPS信息识别等附加功能。  


## 图文教程参考
如需更详细的步骤（如群晖 DSM、威联通 QTS 等系统的界面操作），可查看官方图文指南：[[]]([])


**官方网站**：  
- 国际版：[[]]([])  
- 中文版：[[]]([])

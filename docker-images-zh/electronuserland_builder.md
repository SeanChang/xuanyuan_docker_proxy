---
image: electronuserland/builder
description: "electron-builder是打包Electron应用的完整解决方案，用于构建跨平台桌面应用程序安装包。"
source: https://xuanyuan.cloud/zh/r/electronuserland/builder
canonical: https://xuanyuan.cloud/zh/r/electronuserland/builder
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/electronuserland/builder" title="electronuserland/builder Docker 镜像中文简介、标签列表与拉取命令">electronuserland/builder 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# electron-builder

## 镜像概述和主要用途

electron-builder 是一个完整的解决方案，用于打包和构建可分发的 [Electron](https://electronjs.org)、[Proton Native](https://proton-native.js.org/) 应用，支持 macOS、Windows 和 Linux 平台，开箱即支持自动更新功能。


## 核心功能和特性

### NPM 包管理
- 原生应用依赖编译（支持 Yarn）
- 自动排除开发依赖，无需显式忽略
- 支持双 package.json 结构，原生生产依赖场景下无需强制使用

### 代码签名
支持在 CI 服务器或开发机上对应用进行代码签名

### 自动更新
构建开箱即支持自动更新的应用包

### 多目标格式支持
- **全平台通用**：7z、zip、tar.xz、tar.7z、tar.lz、tar.gz、tar.bz2、dir（未打包目录）
- **macOS**：dmg、pkg、mas
- **Linux**：AppImage、snap、deb（Debian 包）、rpm、freebsd、pacman、p5p、apk
- **Windows**：nsis（安装程序）、nsis-web（网络安装程序）、portable（便携版）、AppX（Windows 应用商店）、MSI、Squirrel.Windows

### 工件发布
支持发布构建产物到 GitHub Releases、Amazon S3、DigitalOcean Spaces 和 Bintray

### 高级构建能力
- 支持对已打包应用重新打包为分发格式
- 支持分离构建步骤
- CI 环境下支持并行构建与发布，通过硬链接减少 IO 和磁盘空间占用
- 支持 electron-compile（构建时动态编译）

### 跨平台构建
提供 Docker 镜像，可在任意平台构建 Linux 或 Windows 应用

### Proton Native 支持
原生支持 Proton Native 应用构建

### 自动工具下载
自动按需下载所需工具文件（如 Windows 代码签名工具、AppX 制作工具），无需手动配置


## 使用场景和适用范围

适用于需要构建跨平台 Electron 或 Proton Native 应用的开发者，尤其适合以下场景：
- 需要生成多种分发格式（如安装包、压缩包、应用商店格式）的应用
- 应用需支持自动更新功能
- 需在 CI/CD 流程中集成代码签名
- 需要跨平台构建（如在 Linux 环境构建 Windows 应用）
- 项目包含原生 Node 模块依赖


## 安装方法

推荐使用 Yarn 而非 npm 进行安装：

```bash
yarn add electron-builder --dev
```


## 配置说明

通过应用 `package.json` 中的 `build` 字段进行配置，核心配置项示例：

```json
"build": {
  "appId": "com.example.app",          // 应用唯一标识
  "productName": "示例应用",             // 应用名称
  "version": "1.0.0",                   // 应用版本
  "mac": {
    "category": "public.app-category.utilities",  // macOS 应用类别
    "target": ["dmg", "zip"]                      // macOS 目标格式
  },
  "win": {
    "target": ["nsis", "portable"]                // Windows 目标格式
  },
  "linux": {
    "target": ["AppImage", "deb"]                 // Linux 目标格式
  },
  "files": [                               // 需要打包的文件
    "dist/**/*",
    "package.json"
  ],
  "asar": true                             // 是否使用 asar 归档（默认启用）
}
```

详细配置项可参考官方文档。


## 使用方法

### 快速设置指南

1. **配置 package.json 基础字段**  
   确保包含 `name`、`description`、`version` 和 `author` 标准字段：
   ```json
   {
     "name": "example-app",
     "description": "示例 Electron 应用",
     "version": "1.0.0",
     "author": "Your Name <your@email.com>"
   }
   ```

2. **添加构建配置**  
   在 `package.json` 中添加 `build` 配置段（见上文配置说明）

3. **准备应用图标**  
   提供应用图标（推荐尺寸：512x512px），放置于项目根目录或指定路径，配置示例：
   ```json
   "build": {
     "icon": "build/icon.png"  // 图标路径
   }
   ```

4. **配置构建脚本**  
   在 `package.json` 的 `scripts` 中添加构建命令：
   ```json
   "scripts": {
     "pack": "electron-builder --dir",    // 生成未打包目录（测试用）
     "dist": "electron-builder",          // 生成分发格式包
     "postinstall": "electron-builder install-app-deps"  // 安装原生依赖
   }
   ```

5. **处理原生依赖**  
   若应用包含自定义原生插件（非依赖项），需启用 node-gyp 重建：
   ```json
   "build": {
     "nodeGypRebuild": true
   }
   ```

6. **执行构建**  
   - 生成测试用未打包目录：
     ```bash
     yarn pack
     ```
   - 生成正式分发包：
     ```bash
     yarn dist
     ```

### 代码签名

生产环境应用需进行代码签名，签名配置示例（Windows/macOS）：

```json
"build": {
  "win": {
    "certificateFile": "./cert.pfx",       // Windows 证书文件
    "certificatePassword": "cert-password" // 证书密码
  },
  "mac": {
    "identity": "Developer ID Application: Your Name (ABC123XYZ)" // macOS 签名身份
  }
}
```


## Docker 跨平台构建示例

使用 electron-builder 提供的 Docker 镜像可实现跨平台构建，以下为常见场景示例：

### Linux 环境构建 Windows 应用

```bash
docker run --rm -v $(pwd):/app -w /app docker.xuanyuan.run/electronuserland/builder:wine \
  sh -c "yarn install && yarn dist --win"
```

### macOS 环境构建 Linux 应用

```bash
docker run --rm -v $(pwd):/app -w /app docker.xuanyuan.run/electronuserland/builder:linux \
  sh -c "yarn install && yarn dist --linux"
```

**参数说明**：
- `--rm`：构建完成后删除容器
- `-v $(pwd):/app`：挂载当前项目目录到容器内 `/app`
- `-w /app`：设置工作目录为 `/app`
- `electronuserland/builder:wine`：包含 Wine 的镜像（用于 Windows 构建）
- `electronuserland/builder:linux`：Linux 构建专用镜像


## 常见问题

| 问题                     | 解答                                   |
|--------------------------|----------------------------------------|
| 如何配置 electron-builder？ | 在 package.json 中添加 `build` 字段进行配置 |
| 遇到问题如何寻求帮助？     | 提交 issue 或加入官方讨论群组           |
| 发现 bug 如何反馈？       | 通过 GitHub 提交 issue                  |
| 如何支持项目开发？         | 可通过捐赠支持开发工作                 |


## 捐赠与支持

该项目为开源项目，开发维护依赖社区支持。如需优先处理特定 issue，可通过官方渠道进行捐赠。


## 赞助商

- [WorkFlowy](https://workflowy.com)
- [Tidepool](https://tidepool.org)

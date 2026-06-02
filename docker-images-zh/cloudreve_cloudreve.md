---
image: cloudreve/cloudreve
description: "这是一款支持多家云存储服务提供商的自托管文件管理与共享云盘系统，可帮助用户集中管理、分享存储于不同平台的文件，实现跨云存储的统一访问与操作，满足个人或团队对文件存储、管理及协作的多样化需求，兼具数据自主可控与多平台整合的优势。"
source: https://xuanyuan.cloud/zh/r/cloudreve/cloudreve
canonical: https://xuanyuan.cloud/zh/r/cloudreve/cloudreve
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cloudreve/cloudreve" title="cloudreve/cloudreve Docker 镜像中文简介、标签列表与拉取命令">cloudreve/cloudreve — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/cloudreve/cloudreve" title="cloudreve/cloudreve Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/cloudreve/cloudreve</a>

# Cloudreve  
自托管的多云文件管理系统  


## 项目导航  
官网 • [演示]([]) • [论坛]([]) • [文档]([]) • [下载]() • [群组]() • 许可证  


![系统截图]([])


## ✨ 特性  

- ☁️ 支持多存储后端：本地存储、远程存储、七牛云、阿里云OSS、腾讯云COS、又拍云、OneDrive及S3兼容API  
- 📤 直接上传/下载，支持速度限制  
- 💾 集成Aria2实现离线下载，支持多节点负载分担  
- 📚 文件压缩/解压、批量下载功能  
- 💻 全存储后端支持WebDAV协议  
- ⚡ 拖拽上传文件/文件夹，流式处理上传内容  
- 📦 拖拽式文件管理操作  
- 👨‍👩‍👧‍👦 多用户与多用户组权限管理  
- 🔗 生成带过期时间的文件/文件夹分享链接  
- 👁️ 在线预览多类型文件：视频、图片、音频、文本、Office文档、ePub等  
- 🎨 主题自定义（颜色、深色模式）、PWA应用、SPA架构、国际化支持  
- 🚀 单文件打包，开箱即用  


## 🔧 部署步骤  

### 基础部署  
1. 下载对应操作系统和CPU架构的二进制文件  
2. 解压并运行：  

```shell  
# 解压Cloudreve安装包  
tar -zxvf cloudreve_VERSION_OS_ARCH.tar.gz  

# 赋予执行权限  
chmod +x ./cloudreve  

# 启动服务  
./cloudreve  
```  

> 完整部署流程（含环境配置、服务注册等）可参考[快速开始文档]([])  


## 🔨 自行构建  

### 依赖准备  
需提前安装：`Go >= 1.18`、`node.js`、`yarn`、`zip`  

### 构建步骤  

#### 1. 克隆代码  
```shell  
git clone --recurse-submodules   
```  

#### 2. 构建静态资源  
```shell  
# 进入前端子模块  
cd assets  

# 安装依赖  
yarn install  

# 构建前端资源  
yarn run build  

# 清理无用map文件  
cd build && find . -name "*.map" -type f -delete  

# 返回主目录并打包静态资源  
cd ../../ && zip -r - assets/build >assets.zip  
```  

#### 3. 编译后端  
```shell  
# 获取版本信息（提交SHA和标签）  
export COMMIT_SHA=$(git rev-parse --short HEAD)  
export VERSION=$(git describe --tags)  

# 编译可执行文件  
go build -a -o cloudreve -ldflags "-s -w -X 'github.com//v3/pkg/conf.BackendVersion=$VERSION' -X 'github.com//v3/pkg/conf.LastCommit=$COMMIT_SHA'"  
```  

### 快速构建脚本  
使用项目根目录的`build.sh`简化流程：  
```shell  
./build.sh [-a] [-c] [-b] [-r]  
# 参数说明：  
# -a：仅构建前端资源  
# -c：仅构建后端二进制  
# -b：同时构建前后端  
# -r：为发布版进行交叉编译  
```  


## 🛠️ 技术栈  
- 后端：Go + Gin  
- 前端：React + Redux + Material-UI  


## 📜 许可证  
采用 GPL V3 开源协议

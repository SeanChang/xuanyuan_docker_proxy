<!-- xuanyuan-docker-images-zh
image: hectorqin/reader
source: https://xuanyuan.cloud/zh/r/hectorqin/reader
canonical: https://xuanyuan.cloud/zh/r/hectorqin/reader
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/hectorqin/reader" title="hectorqin/reader Docker 镜像中文简介、标签列表与拉取命令">hectorqin/reader — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/hectorqin/reader" title="hectorqin/reader Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/hectorqin/reader</a></p>

# 阅读3网页版工具介绍


## 项目说明  
阅读3网页版是一款无需手机、自带接口服务的在线阅读工具。接口服务基于 [lightink-server]([]) 修改，网页端基于 [阅读3.0Web端]([]) 修改。  

**在线体验**：[[]]([])  
> Demo服务器为腾讯云1M带宽，性能有限，请勿高负载使用  
> 注：Demo数据不定期清除  


## 主要功能  
- 书源管理  
- 书架管理  
- 书籍搜索  
- 书海浏览  
- 在线阅读  
- 移动端适配  
- 书籍换源  
- 多翻页方式  
- 手势操作支持  
- 自定义阅读主题  
- 自定义页面样式  


## 数据存储说明  

### 存储位置  
接口服务默认使用 `storage` 目录存储书源、目录等数据，可通过启动参数修改：  
```bash
-Dreader.app.storagePath=/path/to/storage  # 指定自定义存储路径
```  
客户端存储路径：  
- MacOS：`~/.reader/storage`  
- Windows/Linux：运行目录下的 `storage` 文件夹  


### 目录结构  
```bash
storage
├── assets                # 静态资源
│   ├── background        # 自定义阅读背景图片
│   └── reader.css        # 自定义CSS样式文件
├── cache                 # 缓存目录（含书籍封面等）
├── data                  # 核心数据
│   ├── bookInfoCache.json  # 搜索缓存
│   ├── bookSource.json     # 书源列表
│   ├── bookshelf.json      # 书架书籍列表
│   └── [书籍名称]          # 单本书籍缓存（含不同书源的目录）
└── windowConfig.json     # 窗口配置文件
```  


### 旧版数据迁移  
若从旧版覆盖安装新版，系统会自动迁移旧数据至新目录结构，并在存储目录父级生成备份 `storage-backup`（确认数据无误后可删除）。旧版目录结构参考：  
```bash
storage
├── bookInfoCache.json   # 搜索缓存
├── bookSource.json      # 书源列表
├── bookshelf.json       # 书架列表
├── windowConfig.json    # 窗口配置
└── [书籍名称]           # 书籍缓存（含书源目录）
```  


## 自定义功能  

### 阅读主题  
- **书架页面**：仅支持白天/黑夜模式  
- **阅读页面**：支持多款预设主题及自定义，可调整：  
  - 页面背景颜色  
  - 浮窗背景颜色  
  - 阅读背景颜色  
  - 阅读背景图片  


### 页面样式  
系统会加载 `reader-assets/reader.css` 文件，可在该文件中自定义页面样式（复杂样式可能需添加 `!important` 强制生效）。  


## 接口服务配置  
通过配置文件调整服务参数（示例）：  
```yml
reader:
  app:
    storagePath: storage   # 数据存储目录（默认）
    showUI: false          # 是否显示UI界面
    debug: false           # 调试模式开关
    packaged: false        # 是否为客户端打包模式
    secure: false          # 是否开启登录鉴权
    inviteCode: ""         # 注册邀请码（为空则开放注册）
    secureKey: ""          # 管理密码（鉴权开启时，用于增删书源）
  server:
    port: 8080             # 服务端口
    webUrl: []}  # Web访问地址
```  


## Docker部署  

### 方式1：使用预编译镜像  
```bash
docker run -d --restart=always --name=reader \
  -v $(PWD)/log:/log \          # 日志挂载
  -v $(PWD)/storage:/storage \  # 数据存储挂载
  -p 8080:8080 \                # 端口映射
  
```  

### 方式2：自行编译  
```bash
# 编译镜像
docker build -t reader:latest .

# 启动容器（参数同预编译镜像）
docker run -d --restart=always --name=reader ... reader:latest
```  

**访问地址**：  
- Web端：`[]  
- 接口地址：`[]

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/hectorqin/reader" title="hectorqin/reader Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/hectorqin/reader</a></p>

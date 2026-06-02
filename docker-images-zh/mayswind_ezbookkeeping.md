<!-- xuanyuan-docker-images-zh
image: mayswind/ezbookkeeping
source: https://xuanyuan.cloud/zh/r/mayswind/ezbookkeeping
canonical: https://xuanyuan.cloud/zh/r/mayswind/ezbookkeeping
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/mayswind/ezbookkeeping" title="mayswind/ezbookkeeping Docker 镜像中文简介、标签列表与拉取命令">mayswind/ezbookkeeping — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/mayswind/ezbookkeeping" title="mayswind/ezbookkeeping Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mayswind/ezbookkeeping</a></p>

# ezBookkeeping  
[![License]([])]([])  
[![Go Report]([])]([])  
[![Latest Release]([])]([])  


## 简介  
ezBookkeeping 是一款轻量级自托管个人财务应用，界面操作简单，记账功能实用。部署方便，一条 Docker 命令就能启动；资源占用低，扩展性强，不管是树莓派这类小型设备，还是 NAS、微型服务器，甚至大型集群环境都能稳定运行。  

应用同时适配手机和电脑使用，支持 PWA（渐进式 Web 应用）。你可以[添加到手机主屏幕]([])，像原生 App 一样操作。  

GitHub 地址：[[]]([])  
在线演示：[[]]([])  


## 主要特点  
- **开源且自托管**  
  - 注重隐私保护和数据掌控  
- **轻量快速**  
  - 性能经过优化，低配置设备也能流畅运行  
- **安装简单**  
  - 支持 Docker 部署  
  - 兼容 SQLite、MySQL、PostgreSQL 数据库  
  - 跨平台（Windows、macOS、Linux）  
  - 适配 x86、amd64、ARM 等架构  
- **界面友好**  
  - 针对手机和电脑分别优化界面  
  - 支持 PWA，手机使用体验接近原生应用  
  - 提供深色模式  
- **AI 辅助功能**  
  - 票据图片识别  
  - 支持 MCP（模型上下文协议），可对接 AI 服务  
- **功能全面的记账系统**  
  - 两级账户和分类体系  
  - 交易可附加图片  
  - 地图位置记录  
  - 支持周期性交易  
  - 提供高级筛选、搜索、数据可视化和分析工具  
- **多场景适配**  
  - 多语言和多币种支持  
  - 汇率自动更新  
  - 多时区适配  
  - 日期、数字、货币格式可自定义  
- **安全可靠**  
  - 双因素认证（2FA）  
  - 登录频率限制  
  - 应用锁定（支持 PIN 码、WebAuthn）  
- **数据灵活导入导出**  
  - 支持 CSV、OFX、QFX、QIF 等多种格式，兼容 GnuCash、Firefly III、Beancount 等工具  


## 界面截图  
### 桌面版  
[![ezBookkeeping]([])]([])  

### 移动版  
[![ezBookkeeping]([])]([])  


## 安装方法  
### Docker 部署  
可前往 [Docker Hub]([]) 查看所有镜像和版本标签。  

**最新正式版：**  
```bash  
$ docker run -p8080:8080 mayswind/ezbookkeeping  
```  

**每日构建版：**  
```bash  
$ docker run -p8080:8080 mayswind/ezbookkeeping:latest-snapshot  
```  


## 文档  
1. [英文]([])  
2. [中文 (简体)]([])  


## 开源协议  
[MIT]([])

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/mayswind/ezbookkeeping" title="mayswind/ezbookkeeping Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/mayswind/ezbookkeeping</a></p>

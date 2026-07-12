---
image: clamav/clamav
description: "ClamAV项目的官方基于Alpine的Docker镜像。"
source: https://xuanyuan.cloud/zh/r/clamav/clamav
canonical: https://xuanyuan.cloud/zh/r/clamav/clamav
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/clamav/clamav" title="clamav/clamav Docker 镜像中文简介、标签列表与拉取命令">clamav/clamav 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ClamAV

ClamAV®是一款开源防病毒引擎，用于检测木马、病毒、恶意软件及其他恶意威胁。

## 文档与FAQ
ClamAV文档托管于[docs.clamav.net](https://docs.clamav.net/)。每个版本的源码包中也包含文档副本，可供离线阅读。
您可通过向[Cisco-Talos/clamav-documentation](https://github.com/Cisco-Talos/clamav-documentation)提交改进来贡献文档。

## ClamAV新闻
有关当前及历史版本特性的信息，请阅读[发布说明](https://github.com/Cisco-Talos/clamav/blob/main/NEWS.md)。
通过阅读我们的[博客](http://blog.clamav.net)或关注Twitter账号`@clamav`了解ClamAV最新动态。

## ClamAV签名
任何人都可学习编写ClamAV签名。入门请参阅[签名编写手册](https://docs.clamav.net/manual/Signatures.html)。

## 安装说明

### 使用Docker
ClamAV可通过Docker运行。官方镜像基于Alpine，托管于[Docker Hub](https://hub.docker.com/r/clamav/clamav)。

#### Docker部署方案示例
##### 基本运行
```bash
docker run -d --name clamav docker.xuanyuan.run/clamav/clamav
```

##### 挂载数据卷（病毒库和配置）
```bash
docker run -d --name clamav -v /path/to/clamav/db:/var/lib/clamav -v /path/to/clamav/conf:/etc/clamav docker.xuanyuan.run/clamav/clamav
```

##### 使用clamdscan扫描文件
```bash
docker exec clamav clamdscan /path/to/file
```

详情请参阅在线手册中的[“Docker”章节](https://docs.clamav.net/manual/Installing/Docker.html)。

### 使用包管理器
有关通过包管理器安装的帮助，请参考在线手册中的[“包管理”章节](https://docs.clamav.net/manual/Installing/Packages.html)。

### 使用安装程序
可从[clamav.net/downloads](https://www.clamav.net/downloads)下载以下安装包：
- Linux：适用于x86_64和i686的Debian及RPM包（v0.104新增）
- macOS：适用于x86_64和arm64（通用）的PKG安装程序（v0.104新增）
- Windows：适用于win32和x64的MSI安装程序及便携ZIP包

使用方法请参阅在线手册中的[“安装程序安装”章节](https://docs.clamav.net/manual/Installing.html#installing-with-an-installer)。

### 从源码构建
分步指南请参考在线手册：
- [Unix/Linux/Mac](https://docs.clamav.net/manual/Installing/Installing-from-source-Unix.html)
- [Windows](https://docs.clamav.net/manual/Installing/Installing-from-source-Windows.html)
每个版本的源码包包含文档副本，可供离线阅读。所有构建选项参考`INSTALL.md`文件。开发者可参阅在线手册中的[“开发者指南”章节](https://docs.clamav.net/manual/Development.html)。

### 从旧版本升级
升级提示请访问[FAQ](https://docs.clamav.net/faq/faq-upgrade.html)。

## 加入ClamAV社区
与ClamAV社区联系的最佳方式是加入我们的[邮件列表](https://docs.clamav.net/faq/faq-ml.html)。您也可通过[ClamAV Discord聊天服务器](https://discord.gg/6vNAqWnVgw)加入社区。

## 贡献指南
ClamAV开发团队欢迎[代码贡献](https://github.com/Cisco-Talos/clamav)、[文档改进](https://github.com/Cisco-Talos/clamav-documentation)及[bug报告](https://github.com/Cisco-Talos/clamav/issues)。

## 许可信息
ClamAV在GNU通用公共许可证第2版（GPLv2）下授权，供公共/开源使用。详见`COPYING.txt`。

### 第三方代码
ClamAV包含部分来自第三方项目的代码，其许可与ClamAV不同，包括：
- tomsfastmath：公共领域
- Yara：Apache 2.0许可（源码需更新至BSD 3-Clause许可）
- 7z/lzma：公共领域
- libclamav的NSIS/NulSoft解析器包含zlib（宽松自由软件许可）、bzip2/libbzip2（类BSD许可）
- OpenBSD的libc/regex：BSD许可
- file：BSD许可
- str.c：包含BSD许可的strtol()、stroul()修改实现
- pngcheck (png.c)：MIT/X11风格许可
- getopt.c：MIT许可
- Curl：类MIT/X许可
- libmspack：LGPL许可
- UnRAR (libclamunrar)：非自由/受限开源许可（与GPLv2不兼容，运行时加载，不影响核心功能）
第三方许可副本见`COPYING`目录。

## 致谢
每个版本的贡献者信息见[发布说明](https://github.com/Cisco-Talos/clamav/blob/main/NEWS.md)。ClamAV由[ClamAV团队](https://www.clamav.net/about.html#credits)开发维护。

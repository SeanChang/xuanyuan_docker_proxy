---
image: vaultwarden/server
description: "Bitwarden服务器API的Rust替代实现，包含Web Vault，兼容官方客户端，适合资源受限环境的自托管部署。"
source: https://xuanyuan.cloud/zh/r/vaultwarden/server
canonical: https://xuanyuan.cloud/zh/r/vaultwarden/server
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/vaultwarden/server" title="vaultwarden/server Docker 镜像中文简介、标签列表与拉取命令">vaultwarden/server — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/vaultwarden/server" title="vaultwarden/server Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/vaultwarden/server</a>

### Bitwarden服务器API的Rust替代实现，兼容官方客户端，适合自托管部署

📢 注意：本项目曾用名Bitwarden_RS，为与官方Bitwarden服务器区分以避免混淆和商标/品牌问题已更名。详见[#1642](https://github.com/dani-garcia/vaultwarden/discussions/1642)了解更多说明。

---

[![Docker Pulls](https://img.shields.io/docker/pulls/vaultwarden/server.svg)](https://hub.docker.com/r/vaultwarden/server)
[![Dependency Status](https://deps.rs/repo/github/dani-garcia/vaultwarden/status.svg)](https://deps.rs/repo/github/dani-garcia/vaultwarden)
[![GitHub Release](https://img.shields.io/github/release/dani-garcia/vaultwarden.svg)](https://github.com/dani-garcia/vaultwarden/releases/latest)
[![GPL-3.0 Licensed](https://img.shields.io/github/license/dani-garcia/vaultwarden.svg)](https://github.com/dani-garcia/vaultwarden/blob/master/LICENSE.txt)
[![Matrix Chat](https://img.shields.io/matrix/vaultwarden:matrix.org.svg?logo=matrix)](https://matrix.to/#/#vaultwarden:matrix.org)

本镜像基于[Rust实现的Bitwarden API](https://github.com/dani-garcia/vaultwarden)构建。

**本项目与[Bitwarden](https://bitwarden.com/)项目及8bit Solutions LLC无关联。**

#### ⚠️**重要**⚠️：使用本服务器时，无论您使用何种客户端（移动、桌面、浏览器等），请直接向我们报告任何错误或建议（见本页底部联系方式）。**请勿使用官方支持渠道**。

---

## 核心功能

基本实现了Bitwarden API的全部功能，包括：

* 组织支持
* 附件功能
* Vault API支持
* 提供Vault界面静态文件服务
* 网站图标API
* Authenticator和U2F支持
* YubiKey和Duo支持

## 安装

拉取Docker镜像并从主机挂载卷以实现持久化存储：

```sh
docker pull vaultwarden/server:latest
docker run -d --name vaultwarden -v /vw-data/:/data/ -p 80:80 vaultwarden/server:latest
```

所有持久化数据将保存在`/vw-data/`目录下，您可根据需要调整主机路径。

**重要**：部分浏览器（如Chrome）在不安全上下文下禁用Web Crypto API，可能导致`Cannot read property 'importKey'`等错误。解决此问题需通过HTTPS访问Web Vault。

可通过[vaultwarden直接配置](https://github.com/dani-garcia/vaultwarden/wiki/Enabling-HTTPS)或第三方反向代理（[示例](https://github.com/dani-garcia/vaultwarden/wiki/Proxy-examples)）实现HTTPS。若有域名，可通过[Let's Encrypt](https://letsencrypt.org/)获取HTTPS证书，或使用[mkcert](https://github.com/FiloSottile/mkcert)等工具生成自签名证书。部分代理（如Caddy，见上述示例）可自动完成此步骤。

## 使用说明

有关配置和运行vaultwarden服务器的更多信息，请参考[vaultwarden wiki](https://github.com/dani-garcia/vaultwarden/wiki)。

## 联系与支持

如需提问、提供建议或新功能想法，或寻求配置/安装帮助，请[使用论坛](https://vaultwarden.discourse.group/)。

如发现vaultwarden本身的错误或崩溃问题，请[创建issue](https://github.com/dani-garcia/vaultwarden/issues/)。创建前请确保无类似issue已存在！

如需实时交流，我们通常在Matrix的[#vaultwarden:matrix.org](https://matrix.to/#/#vaultwarden:matrix.org)房间活动，欢迎加入！

### 赞助商

感谢以下对本项目的贡献！

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/netdadaltd">
        <img src="https://avatars.githubusercontent.com/u/77323954?s=75&v=4" width="75px;" alt="netdadaltd"/>
        <br />
        <sub><b>netDada Ltd.</b></sub>
      </a>
  </td>
  </tr>
</table>

<br/>

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/Gyarbij" style="width: 75px">
        <sub><b>Chono N</b></sub>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
       <a href="https://github.com/themightychris">
        <sub><b>Chris Alfano</b></sub>
      </a>
    </td>
  </tr>
</table>

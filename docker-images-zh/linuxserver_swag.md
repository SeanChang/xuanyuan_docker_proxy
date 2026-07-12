---
image: linuxserver/swag
description: "SWAG(Secure Web Application Gateway)是一个安全Web应用网关，集成Nginx反向代理、PHP支持、Certbot客户端(自动管理Let's Encrypt和ZeroSSL证书)以及fail2ban入侵防护，简化Web服务安全部署。"
source: https://xuanyuan.cloud/zh/r/linuxserver/swag
canonical: https://xuanyuan.cloud/zh/r/linuxserver/swag
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/swag" title="linuxserver/swag Docker 镜像中文简介、标签列表与拉取命令">linuxserver/swag 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/swag

SWAG（Secure Web Application Gateway，前身为letsencrypt，与Let's Encrypt™无关联）是一个安全Web应用网关，它设置了Nginx Web服务器和反向代理，支持PHP，并内置Certbot客户端，可自动完成免费SSL服务器证书的生成和更新过程（支持Let's Encrypt和ZeroSSL）。它还包含用于入侵防御的fail2ban。

## 应用设置

### 验证和初始设置

* 运行此容器前，请确保URL和子域名已正确转发到此容器的主机，且端口443（和/或80）未被主机上的其他服务（NAS界面、其他Web服务器等）占用。
* 如果需要动态DNS提供商，可以使用免费的duckdns.org，其中`URL`为`yoursubdomain.duckdns.org`，`SUBDOMAINS`可以是`www,ftp,cloud`（用于HTTP验证）或`wildcard`（用于DNS验证）。您可以使用我们的[duckdns镜像](https://hub.docker.com/r/linuxserver/duckdns/)来更新duckdns.org上的IP。
* 对于`http`验证，路由器互联网侧的端口80应转发到此容器的端口80
* 对于`dns`验证，请确保将您的凭据输入到`/config/dns-conf`下相应的ini文件（或某些插件的json文件）中
  * Cloudflare提供免费账户管理DNS，且与此镜像配合使用非常简单。确保它设置为"仅dns"而非"dns + 代理"
  * Google dns插件旨在与"Google Cloud DNS"（付费企业产品）一起使用，而非"Google Domains DNS"
  * DuckDNS仅支持两种类型的DNS验证证书（不能同时使用）：
    1. 仅覆盖主域名的证书（即`yoursubdomain.duckdns.org`，将`SUBDOMAINS`变量留空）
    2. 覆盖主域名的子域名的证书（即`*.yoursubdomain.duckdns.org`，将`SUBDOMAINS`变量设置为`wildcard`）
* `--cap-add=NET_ADMIN`是fail2ban修改iptables所必需的
* 设置完成后，导航至`https://example.com`访问默认主页（默认情况下禁用通过端口80的http访问，您可以通过编辑`/config/nginx/site-confs/default.conf`中的默认站点配置来启用它）。
* 证书每晚检查，如果30天内到期，则尝试续订。如果您的证书将在不到30天内过期，请查看`/config/log/letsencrypt`下的日志，了解续订失败的原因。建议在docker参数中输入您的电子邮件，以便在这种情况下收到Let's Encrypt的过期通知。

### Certbot插件

SWAG默认包含许多Certbot插件，但并非所有插件都能包含。
如果您需要未包含的插件，最快的获取方法是使用我们的[Universal Package Install Docker Mod](https://github.com/linuxserver/docker-mods/tree/universal-package-install)。

在容器上设置以下环境变量：

```yaml
docker run -d \
  --name=swag \
  --cap-add=NET_ADMIN \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e URL=example.com \
  -e VALIDATION=http \
  -e SUBDOMAINS=www, `#可选` \
  -e CERTPROVIDER= `#可选` \
  -e DNSPLUGIN=cloudflare `#可选` \
  -e PROPAGATION= `#可选` \
  -e EMAIL= `#可选` \
  -e ONLY_SUBDOMAINS=false `#可选` \
  -e EXTRA_DOMAINS= `#可选` \
  -e STAGING=false `#可选` \
  -e DISABLE_F2B= `#可选` \
  -e SWAG_AUTORELOAD= `#可选` \
  -e SWAG_AUTORELOAD_WATCHLIST= `#可选` \
  -p 443:443 \
  -p 80:80 `#可选` \
  -p 443:443/udp `#可选` \
  -v /path/to/swag/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/swag:latest
```

在`/config/dns-conf/<plugin>.ini`中设置所需的凭据（通常可在插件文档中找到）。
建议先使用`STAGING=true`获取证书，以确保插件正常工作。

### 安全和密码保护

* 容器检测到url和子域名的更改，在启动时吊销现有证书并生成新证书。
* 根据[RFC7919](https://datatracker.ietf.org/doc/html/rfc7919)，容器将[ffdhe4096](https://ssl-config.mozilla.org/ffdhe4096.txt)作为`dhparams.pem`提供。
* 如果您想为您的站点设置密码保护，可以使用htpasswd。在主机上运行以下命令生成htpasswd文件：`docker exec -it swag htpasswd -c /config/nginx/.htpasswd <username>`
* 您可以向`.htpasswd`添加多个用户:密码。对于第一个用户，使用上述命令，对于其他用户，使用不带`-c`标志的上述命令，因为`-c`会强制删除现有`.htpasswd`并创建新文件
* 您还可以使用ldap auth进行安全和访问控制。提供了一个示例、用户可配置的ldap.conf，它需要单独的镜像[linuxserver/ldap-auth](https://hub.docker.com/r/linuxserver/ldap-auth/)与ldap服务器通信。

### 站点配置和反向代理

* 默认站点配置位于`/config/nginx/site-confs/default.conf`。您可以随意修改此文件，也可以向此目录添加其他conf文件。但是，如果删除`default`文件，容器启动时将创建一个新的默认文件。
* 为流行应用添加了预设的反向代理配置文件。有关如何启用它们的说明，请参见`/config/nginx/proxy_confs`下的`README.md`文件。预设的conf文件位于并从[此仓库](https://github.com/linuxserver/reverse-proxy-confs)导入。
* 如果您希望隐藏您的站点不让搜索引擎爬虫发现，您可能会发现将以下配置行添加到您的站点配置中很有用，在服务器块内，在包含ssl.conf的行上方：`add_header X-Robots-Tag "noindex, nofollow, nosnippet, noarchive";`
这将"请求"Google等不要索引和列出您的站点。使用此选项时要小心，因为如果您在希望出现在搜索引擎上的站点上保留此行，最终会被除名
* 如果您希望将http重定向到https，则必须暴露端口80

### 在其他容器中使用证书

* 此容器包含自动生成的pfx和private-fullchain-bundle pem证书，其他应用如Emby和Znc需要这些证书。
  * 要在其他容器中使用这些证书，请执行以下任一操作：
  1. （更简单）在其他容器中挂载容器的配置文件夹（即`-v /path-to-swag-config:/swag-ssl`），在其他容器中，使用证书位置`/swag-ssl/keys/letsencrypt/`
  2. （更安全）在其他容器中挂载位于`/config`下的SWAG文件夹`etc`（即`-v /path-to-swag-config/etc:/swag-ssl`），在其他容器中，使用证书位置`/swag-ssl/letsencrypt/live/<your.domain.url>/`（这更安全，因为第一种方法与其他容器共享整个SWAG配置文件夹，包括www文件，而第二种方法只共享ssl证书）
  * 这些证书包括：
  1. `cert.pem`、`chain.pem`、`fullchain.pem`和`privkey.pem`，由Certbot生成，供nginx和各种其他应用使用
  2. `privkey.pfx`，一种Microsoft支持的格式，通常由dotnet应用（如Emby Server）使用（无密码）
  3. `priv-fullchain-bundle.pem`，捆绑私钥和fullchain的pem证书，供ZNC等应用使用

### 使用fail2ban

* 此容器默认包含5个jail的fail2ban设置：
  1. nginx-http-auth
  2. nginx-badbots
  3. nginx-botsearch
  4. nginx-deny
  5. nginx-unauthorized
* 要启用或禁用其他jail，请修改文件`/config/fail2ban/jail.local`
* 要修改过滤器和操作，不要编辑`.conf`文件，而是创建同名的`.local`文件并编辑这些文件，因为`.conf`文件在操作和过滤器更新时会被覆盖。`.local`文件将附加`.conf`文件中的内容（即`nginx-http-auth.conf` --> `nginx-http-auth.local`）
* 您可以通过`docker exec -it swag fail2ban-client status`检查哪些jail处于活动状态
* 您可以通过`docker exec -it swag fail2ban-client status <jail name>`检查特定jail的状态
* 您可以通过`docker exec -it swag fail2ban-client set <jail name> unbanip <IP>`解除IP禁令
* fail2ban-client的命令列表可在[此处](https://manpages.ubuntu.com/manpages/noble/man1/fail2ban-client.1.html)找到

### 更新配置

* 此容器创建许多nginx配置、代理示例等。
* 配置更新在变更日志中注明，但不会自动应用到您的文件。
* 如果您修改了变更日志中注明有更改的文件：
  1. 保持现有配置不变（没坏就不要修）
  2. 查看我们的仓库提交并自行应用新更改
  3. 删除列出更新的已修改配置文件，重启容器，重新应用您的更改
* 如果您没有修改变更日志中注明有更改的文件：
  1. 删除列出更新的配置文件，重启容器
* 代理示例更新未在变更日志中列出。请在此处查看更改：[https://github.com/linuxserver/reverse-proxy-confs/commits/master](https://github.com/linuxserver/reverse-proxy-confs/commits/master)
* 代理示例文件将被更新，但您重命名（启用）的代理文件不会。
* 您可以检查新示例并根据需要调整您的活动配置。

### QUIC支持

此镜像支持QUIC（也称为HTTP/3），但必须在每个代理conf和默认conf中显式启用，因为如果启用了监听器但不暴露443/UDP，可能会中断某些浏览器的连接。

要启用QUIC，请将443/UDP暴露给您的客户端，然后取消注释所有活动代理conf以及默认conf中的QUIC监听器，并重启容器。

您还应该取消注释`ssl.conf`中的`Alt-Svc`头，以便浏览器知道您提供QUIC连接。

建议[增加主机](https://quic-go.net/docs/quic/optimizations/#udp-buffer-sizes)上的UDP发送/接收缓冲区，方法是设置`net.core.rmem_max`和`net.core.wmem_max` sysctl。建议值为4-16Mb（4194304-16777216字节）。要在重启之间保持持久性，请使用`/etc/sysctl.d/`。

### 从旧版`linuxserver/letsencrypt`镜像迁移

请按照[此博客文章](https://www.linuxserver.io/blog/2020-08-21-introducing-swag#migrate)上的说明进行操作。

## 使用方法

```bash
docker run -d \
  --name=swag \
  --cap-add=NET_ADMIN \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e URL=example.com \
  -e VALIDATION=http \
  -e SUBDOMAINS=www, `#可选` \
  -e CERTPROVIDER= `#可选` \
  -e DNSPLUGIN=cloudflare `#可选` \
  -e PROPAGATION= `#可选` \
  -e EMAIL= `#可选` \
  -e ONLY_SUBDOMAINS=false `#可选` \
  -e EXTRA_DOMAINS= `#可选` \
  -e STAGING=false `#可选` \
  -e DISABLE_F2B= `#可选` \
  -e SWAG_AUTORELOAD= `#可选` \
  -e SWAG_AUTORELOAD_WATCHLIST= `#可选` \
  -p 443:443 \
  -p 80:80 `#可选` \
  -p 443:443/udp `#可选` \
  -v /path/to/swag/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/swag:latest
```

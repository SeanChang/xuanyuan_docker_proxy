---
image: curlimages/curl
description: "官方curl Docker镜像（http://curl.se）：用于通过URL传输数据的命令行工具和库。"
source: https://xuanyuan.cloud/zh/r/curlimages/curl
canonical: https://xuanyuan.cloud/zh/r/curlimages/curl
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/curlimages/curl" title="curlimages/curl Docker 镜像中文简介、标签列表与拉取命令">curlimages/curl 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 官方curl Docker镜像
这些是由curl Docker团队（curl-docker at haxx.se）或Jim Fuller（jim at webcomposite.com）维护的官方curl镜像。

最新镜像也可从[quay.io](https://quay.io/repository/curl/curl)获取。

## 最新标签及对应Dockerfile链接

* [8.16.0 (latest)](https://github.com/curl/curl-container/releases/tag/8.16.0) - curl 8.16.0

## 快速参考
* 帮助资源：[官方网站](https://curl.se/)、[邮件列表](https://curl.se/mail/)、[Everything Curl](https://curl.se/book.html)
* GitHub仓库：[curl/curl-docker](https://github.com/curl/curl-container)
* 问题反馈：https://github.com/curl/curl-container/issues
* 维护者：curl Docker团队（curl-container at curl.se）
* 许可证：[许可证信息](https://curl.se/docs/copyright.html)，第三方组件许可证请参见其文档

## 什么是Curl？
[curl](https://curl.se/)是一款用于通过URL传输数据的命令行工具和库。

[curl](https://curl.se/)广泛用于命令行或脚本中传输数据，也应用于汽车、电视机、路由器、打印机、音频设备、手机、平板、机顶盒、媒体播放器等设备，是数千款软件应用的互联网传输核心，每天影响数十亿用户。

支持以下协议（持续更新中）：
DICT、FILE、FTP、FTPS、Gopher、HTTP、HTTPS、IMAP、IMAPS、LDAP、LDAPS、POP3、POP3S、RTMP、RTSP、SCP、SFTP、SMB、SMBS、SMTP、SMTPS、Telnet和TFTP。curl支持SSL证书、HTTP POST、HTTP PUT、FTP上传、基于HTTP表单的上传、代理、HTTP/2、Cookie、用户密码认证（Basic、Plain、Digest、CRAM-MD5、NTLM、Negotiate和Kerberos）、文件传输续传、代理隧道等功能。

## 如何使用此镜像

### 获取Docker镜像
拉取最新版本：
```
> docker pull docker.xuanyuan.run/curlimages/curl:8.16.0
```

### 运行Docker镜像
通过以下命令验证镜像是否正常工作：
```
> docker run --rm curlimages/curl:8.16.0 --version
```
运行curl容器的具体示例：
```
> docker run --rm curlimages/curl:8.16.0 -L -v https://curl.se
```
若需处理文件，建议挂载目录：
```
> docker run --rm -it -v "$PWD:/work" curlimages/curl:8.16.0 -d@/work/test.txt https://httpbin.org/post
```

如需基础镜像，请查看[curl-base](https://hub.docker.com/repository/docker/curlimages/curl/general)。

## 构建信息
此版本curl使用以下configure选项构建：
```
--enable-static --disable-ldap --enable-ipv6 --enable-unix-sockets --with-ssl --with-libssh2 --with-nghttp2=/usr \
--prefix=/usr/local --with-gssapi
```
支持：
```
Protocols: dict file ftp ftps gopher gophers http https imap imaps mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS brotli HTTP2 HTTPS-proxy IPv6 Largefile libz NTLM NTLM_WB SSL TLS-SRP UnixSockets
```

## 如何验证镜像
镜像使用[sigstore](https://www.sigstore.dev/)签名。查看镜像签名：
```
cosign tree curlimages/curl:8.16.0
```
镜像通过cosign签名，可使用以下公钥验证：
```
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEwFTRXl79xRiAFa5ZX4aZ7Vkdqmji
5WY0zqc3bd6B08CsNftlYsu2gAqdWm0IlzoQpi2Zi5C437RTg/DgLQ6Bkg==
-----END PUBLIC KEY-----
```
将公钥保存至文件（如cosign.pub），并通过cosign验证：
```
cosign verify --key cosign.pub curlimages/curl:8.16.0
```

---
image: nginxinc/nginx-s3-gateway
description: "基于NGINX的认证和缓存网关，用于S3 API后端服务。"
source: https://xuanyuan.cloud/zh/r/nginxinc/nginx-s3-gateway
canonical: https://xuanyuan.cloud/zh/r/nginxinc/nginx-s3-gateway
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nginxinc/nginx-s3-gateway" title="nginxinc/nginx-s3-gateway Docker 镜像中文简介、标签列表与拉取命令">nginxinc/nginx-s3-gateway 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# NGINX S3网关

## 概述

本项目提供了一个基于NGINX的配置，使其能够作为AWS S3或其他S3兼容服务的认证和缓存网关。这允许代理私有S3桶，无需用户进行认证。在代理层中，可以配置额外功能，例如：

* 列出S3桶内容
* 使用替代S3的认证系统提供认证网关
* 缓存频繁访问的S3对象，以降低延迟并防止S3故障影响
* 对于无法通过S3 API认证的内部/微服务（如缺乏可用库），网关提供无需认证即可访问S3对象的途径
* 从网关向终端用户压缩对象（[gzip](https://github.com/nginxinc/nginx-s3-gateway/blob/master/examples/gzip-compression)、[brotli](https://github.com/nginxinc/nginx-s3-gateway/blob/master/examples/brotli-compression)）
* 保护S3桶免受任意公共访问和遍历
* 对S3对象进行速率限制
* 使用[WAF](https://github.com/nginxinc/nginx-s3-gateway/blob/master/examples/modsecurity)保护S3桶
* 在单一RESTful目录结构中，同时从S3桶提供静态资源和动态应用端点

所有这些功能都可以在标准NGINX配置中启用，因为本项目本质上是带有额外S3代理配置的NGINX。如果预定义配置足够，可直接使用；也可作为更自定义配置的基础示例。若预定义配置不满足需求，建议借鉴本项目的模式构建自己的配置。

## 使用方式

本项目可作为独立容器运行，或作为Systemd服务运行。两种模式使用相同的NGINX配置，功能上完全一致。但作为Systemd服务运行时，可配置其他服务（如[certbot](https://certbot.eff.org/)以支持[Let's Encrypt](https://letsencrypt.org/)）。

## 快速开始

有关构建和运行网关的详细信息，请参考[快速开始指南](https://github.com/nginxinc/nginx-s3-gateway/blob/master/docs/getting_started.md)。

## 配置

以容器或Systemd服务运行时，网关通过以下环境变量进行配置：

* `ALLOW_DIRECTORY_LIST` - 启用目录列表 - 可选值为true或false
* `AWS_SIGS_VERSION` - AWS签名API版本 - 可选值为2或4
* `DNS_RESOLVERS` - （可选）配置NGINX使用的DNS解析器（空格分隔）
* `S3_ACCESS_KEY_ID` - 访问密钥
* `S3_BUCKET_NAME` - 要代理请求的S3桶名称
* `S3_DEBUG` - 启用AWS签名调试输出的标志（默认：false）
* `S3_REGION` - API关联的区域
* `S3_SECRET_KEY` - 密钥访问密钥
* `S3_SERVER_PORT` - 连接的SSL/TLS端口
* `S3_SERVER_PROTO` - 连接S3服务器的协议 - `http`或`https`
* `S3_STYLE` - S3主机/路径方式 - `virtual`、`path`或`default`。`virtual`是使用DNS风格的桶+主机名:端口的方式（默认值）；`path`是将桶名作为URI路径第一个目录的方式，许多S3兼容服务使用此方式。更多信息参见此[AWS博客文章](https://aws.amazon.com/blogs/aws/amazon-s3-path-deprecation-plan-the-rest-of-the-story/)
* `PROXY_CACHE_VALID_OK` - 设置响应码200和302的缓存时间
* `PROXY_CACHE_VALID_NOTFOUND` - 设置响应码404的缓存时间
* `PROXY_CACHE_VALID_FORBIDDEN` - 设置响应码403的缓存时间

如果使用[AWS实例配置文件凭证](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html)，需从配置中省略`S3_ACCESS_KEY_ID`和`S3_SECRET_KEY`变量。

使用Docker运行时，可通过`--env-file`标志从文件设置上述环境变量。作为Systemd服务运行时，环境变量在`/etc/nginx/environment`文件中指定。文件格式示例可参考[settings.example](https://github.com/nginxinc/nginx-s3-gateway/blob/master/settings.example)文件。

## 开发

有关扩展或测试网关的更多信息，请参考[开发指南](https://github.com/nginxinc/nginx-s3-gateway/blob/master/docs/development.md)。

## 许可

所有包含的代码均根据[Apache 2.0许可](https://github.com/nginxinc/nginx-s3-gateway/blob/master/LICENSE.txt)授权。

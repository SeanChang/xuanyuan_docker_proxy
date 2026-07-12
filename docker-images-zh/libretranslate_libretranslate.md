---
image: libretranslate/libretranslate
description: "免费开源的机器翻译API，支持自托管，可离线使用，设置简单。"
source: https://xuanyuan.cloud/zh/r/libretranslate/libretranslate
canonical: https://xuanyuan.cloud/zh/r/libretranslate/libretranslate
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/libretranslate/libretranslate" title="libretranslate/libretranslate Docker 镜像中文简介、标签列表与拉取命令">libretranslate/libretranslate 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LibreTranslate

[在线试用！](https://libretranslate.com) | [API文档](https://libretranslate.com/docs) | [社区论坛](https://community.libretranslate.com/)

[![Python版本](https://img.shields.io/pypi/pyversions/libretranslate)](https://pypi.org/project/libretranslate) [![运行测试](https://github.com/uav4geo/LibreTranslate/workflows/Run%20tests/badge.svg)](https://github.com/uav4geo/LibreTranslate/actions?query=workflow%3A%22Run+tests%22) [![发布至DockerHub](https://github.com/uav4geo/LibreTranslate/workflows/Publish%20to%20DockerHub/badge.svg)](https://hub.docker.com/r/libretranslate/libretranslate) [![发布至GitHub容器 registry](https://github.com/uav4geo/LibreTranslate/workflows/Publish%20to%20GitHub%20Container%20Registry/badge.svg)](https://github.com/uav4geo/LibreTranslate/actions?query=workflow%3A%22Publish+to+GitHub+Container+Registry%22) [![Awesome Humane Tech](https://raw.githubusercontent.com/humanetech-community/awesome-humane-tech/main/humane-tech-badge.svg?sanitize=true)](https://github.com/humanetech-community/awesome-humane-tech)

免费开源的机器翻译API，完全支持自托管。与其他API不同，它不依赖谷歌或Azure等专有服务提供商来执行翻译。

![image](https://user-images.githubusercontent.com/1951843/121782367-23f90080-cb77-11eb-87fd-ed23a21b730f.png)

[在线试用！](https://libretranslate.com) | [API文档](https://libretranslate.com/docs)

## API示例

请求：

```javascript
const res = await fetch("https://libretranslate.com/translate", {
	method: "POST",
	body: JSON.stringify({
		q: "Hello!",
		source: "en",
		target: "es"
	}),
	headers: { "Content-Type": "application/json" }
});

console.log(await res.json());
```

响应：

```javascript
{
    "translatedText": "¡Hola!"
}
```

## 安装和运行

只需几步设置，即可运行自己的API服务器！

确保已安装Python（建议3.8或更高版本），然后执行：

```bash
pip install libretranslate
libretranslate [参数]
```

然后打开浏览器访问 http://localhost:5000

如果使用Windows，建议[通过Docker运行](#通过docker运行)。

在Ubuntu 20.04上，也可使用 https://github.com/argosopentech/LibreTranslate-init 提供的安装脚本。

## 构建和运行

如果需要修改代码，可从源代码构建并运行API：

```bash
git clone https://github.com/uav4geo/LibreTranslate
cd LibreTranslate
pip install -e .
libretranslate [参数]

# 或
python main.py [参数]
```

然后打开浏览器访问 http://localhost:5000

### 通过Docker运行

直接执行：

```bash
docker run -ti --rm -p 5000:5000 docker.xuanyuan.run/libretranslate/libretranslate
```

然后打开浏览器访问 http://localhost:5000

### 通过Docker构建

```bash
docker build [--build-arg with_models=true] -t libretranslate .
```

如果要在完全离线环境中运行Docker镜像，需添加`--build-arg with_models=true`参数，语言模型将在镜像构建过程中下载。否则，模型将在镜像/容器首次运行时下载。

运行构建的镜像：

```bash
docker run -it -p 5000:5000 docker.xuanyuan.run/libretranslate [参数]
```

或使用`docker-compose`构建并运行：

```bash
docker-compose up -d --build
```

> 可修改[`docker-compose.yml`](https://github.com/uav4geo/LibreTranslate/blob/main/docker-compose.yml)文件以适应部署需求，或使用额外的`docker-compose.prod.yml`文件进行部署配置。

## 参数说明

| 参数                | 描述                                  | 默认值                          | 环境变量名               |
|---------------------|---------------------------------------|---------------------------------|--------------------------|
| --host              | 设置服务器绑定的主机                  | `127.0.0.1`                     | LT_HOST                  |
| --port              | 设置服务器绑定的端口                  | `5000`                          | LT_PORT                  |
| --char-limit        | 设置字符限制                          | 无限制                          | LT_CHAR_LIMIT            |
| --req-limit         | 设置每个客户端每分钟的最大请求数      | 无限制                          | LT_REQ_LIMIT             |
| --batch-limit       | 设置批量请求中可翻译的最大文本数      | 无限制                          | LT_BATCH_LIMIT           |
| --ga-id             | 提供ID以在API客户端页面启用Google Analytics | 不跟踪                          | LT_GA_ID                 |
| --debug             | 启用调试环境                          | `False`                         | LT_DEBUG                 |
| --ssl               | 是否启用SSL                           | `False`                         | LT_SSL                   |
| --frontend-language-source | 设置前端默认源语言              | `en`                            | LT_FRONTEND_LANGUAGE_SOURCE |
| --frontend-language-target | 设置前端默认目标语言          | `es`                            | LT_FRONTEND_LANGUAGE_TARGET |
| --frontend-timeout  | 设置前端翻译超时时间（毫秒）          | `500`                           | LT_FRONTEND_TIMEOUT      |
| --api-keys          | 启用API密钥数据库以进行每用户速率限制查找 | 不使用API密钥                   | LT_API_KEYS              |
| --require-api-key-origin | 要求通过API密钥访问API（请求源匹配此域名除外） | 无域名源限制              | LT_REQUIRE_API_KEY_ORIGIN |
| --load-only         | 设置可用语言                          | argostranslate中的所有语言       | LT_LOAD_ONLY             |

注意：每个参数都有对应的环境变量，可用于替代默认值。环境变量会覆盖默认值，但优先级低于命令行参数。在Docker中使用环境变量尤为方便，其名称为命令行参数的大写蛇形形式，前缀为`LT`。

## 使用Gunicorn运行

```bash
pip install gunicorn
gunicorn --bind 0.0.0.0:5000 'wsgi:app'
```

可通过以下方式直接向Gunicorn传递应用参数：

```bash
gunicorn --bind 0.0.0.0:5000 'wsgi:app(api_keys=True)'
```

## 管理API密钥

LibreTranslate支持每用户限制配额，例如可向用户发放API密钥，使他们能享受更高的每分钟请求限制（需同时设置`--req-limit`）。默认情况下，所有用户基于`--req-limit`进行速率限制，但向REST端点传递可选的`api_key`参数可让用户享受更高请求限制。

只需使用`--api-keys`选项启动LibreTranslate即可启用API密钥。

### 添加新密钥

要创建一个每分钟120次请求限制的新API密钥：

```bash
ltmanage keys add 120
```

### 删除密钥

```bash
ltmanage keys remove <api-key>
```

### 查看密钥

```bash
ltmanage keys
```

## 语言绑定

可通过以下绑定使用LibreTranslate API：

- Rust: https://github.com/DefunctLizard/libretranslate-rs
- Node.js: https://github.com/franciscop/translate
- .Net: https://github.com/sigaloid/LibreTranslate.Net
- Go: https://github.com/SnakeSel/libretranslate
- Python: https://github.com/argosopentech/LibreTranslate-py

更多语言绑定即将推出！

## Discourse插件

可使用此[discourse翻译插件](https://github.com/LibreTranslate/discourse-translator)翻译[Discourse](https://discourse.org)主题。安装时只需修改`/var/discourse/containers/app.yml`：

```yaml
## 插件配置
## 详见 https://meta.discourse.org/t/19157
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - git clone https://github.com/discourse/docker_manager.git
          - git clone https://github.com/LibreTranslate/discourse-translator
          ...
```

然后执行`./launcher rebuild app`。在Discourse管理面板中，选择“LibreTranslate”作为翻译提供商，并设置相关端点配置。

## 在线镜像列表

以下是提供LibreTranslate API的在线资源列表，部分需要API密钥。如需添加新URL，请提交pull request。

| URL                          | 是否需要API密钥 | 联系方式          | 费用                  |
|------------------------------|----------------|-------------------|-----------------------|
| [libretranslate.com](https://libretranslate.com) | ✔️             | [UAV4GEO](https://uav4geo.com/contact) | $9/月，80次请求/分钟限制 |
| [libretranslate.de](https://libretranslate.de/)  | ❌             | -                 | -                     |
| [translate.mentality.rip](https://translate.mentality.rip) | ❌       | -                 | -                     |
| [translate.astian.org](https://translate.astian.org/) | ❌         | -                 | -                     |
| [translate.argosopentech.com](https://translate.argosopentech.com/) | ❌ | -                 | -                     |

## 路线图

欢迎提交pull request贡献代码！

- [x] Docker镜像（感谢[@vemonet](https://github.com/vemonet)！）
- [x] 自动检测输入语言（感谢[@vemonet](https://github.com/vemonet)！）
- [x] 用户认证/令牌
- [ ] 支持所有计算机语言的绑定
- [ ] [改进翻译质量](https://github.com/argosopentech/argos-parallel-corpus)

## FAQ

### 能否在生产环境中使用libretranslate.com的API服务器？

libretranslate.com的API应仅用于测试、个人使用或低频使用。如要在生产环境中运行应用，请[联系我们](https://uav4geo.com/contact)获取API密钥或讨论其他选项。

### 能否在反向代理（如Apache2）后使用？

可以，以下是将子域名（带HTTPS证书）重定向到本地Docker运行的LibreTranslate的Apache2配置示例：

```bash
sudo docker run -ti --rm -p 127.0.0.1:5000:5000 libretranslate/libretranslate
```

如希望同时通过`domain.tld:5000`和`subdomain.domain.tld`访问，可删除上述命令中的`127.0.0.1`（有助于排查Apache2或Docker容器问题）。

如需Docker在启动时自动运行（除非手动停止），添加`--restart unless-stopped`。

<details>
<summary>Apache配置</summary>
<br>

将[YOUR_DOMAIN]替换为完整域名，例如`translate.domain.tld`或`libretranslate.domain.tld`。

取消ErrorLog和CustomLog行的注释以记录请求。

```ApacheConf
#Libretranslate

#将http重定向到https
<VirtualHost *:80>
    ServerName http://[YOUR_DOMAIN]
    Redirect / https://[YOUR_DOMAIN]
    # ErrorLog ${APACHE_LOG_DIR}/error.log
    # CustomLog ${APACHE_LOG_DIR}/tr-access.log combined
 </VirtualHost>

#https
<VirtualHost *:443>
    ServerName https://[YOUR_DOMAIN]
    
    ProxyPass / http://127.0.0.1:5000/
    ProxyPassReverse / http://127.0.0.1:5000/

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/[YOUR_DOMAIN]/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/[YOUR_DOMAIN]/privkey.pem
    SSLCertificateChainFile /etc/letsencrypt/live/[YOUR_DOMAIN]/fullchain.pem
    
    # ErrorLog ${APACHE_LOG_DIR}/tr-error.log
    # CustomLog ${APACHE_LOG_DIR}/tr-access.log combined
</VirtualHost>
```

将此配置添加到现有站点配置中，或在`/etc/apache2/sites-available/new-site.conf`创建新文件，然后运行`sudo a2ensite new-site.conf`。

如需获取HTTPS子域名证书，安装`certbot`（snap），运行`sudo certbot certonly --manual --preferred-challenges dns`并输入信息（域名设为`subdomain.domain.tld`）。按提示在域名注册商处添加DNS TXT记录，证书和密钥将保存到`/etc/letsencrypt/live/{subdomain.domain.tld}/`。如不需要HTTPS，可注释SSL相关行。
</details>

## 致谢

本项目的实现很大程度上得益于[Argos Translate](https://github.com/argosopentech/argos-translate)提供的翻译引擎。

## 许可证

[GNU Affero General Public License v3](https://www.gnu.org/licenses/agpl-3.0.en.html)

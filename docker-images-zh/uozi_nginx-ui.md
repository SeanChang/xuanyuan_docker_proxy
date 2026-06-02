---
image: uozi/nginx-ui
description: "Nginx UI是一个基于Web的Nginx管理界面，支持配置编辑、Let's Encrypt证书自动部署与续期、服务器监控、日志查看等功能，采用Go和Vue开发，提供用户友好的操作界面，简化Nginx管理流程。"
source: https://xuanyuan.cloud/zh/r/uozi/nginx-ui
canonical: https://xuanyuan.cloud/zh/r/uozi/nginx-ui
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/uozi/nginx-ui" title="uozi/nginx-ui Docker 镜像中文简介、标签列表与拉取命令">uozi/nginx-ui — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/uozi/nginx-ui" title="uozi/nginx-ui Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/uozi/nginx-ui</a>

# Nginx UI

Nginx UI是由[0xJacky](https://jackyu.cn/)和[Hintay](https://blog.kugeek.com/)开发的另一个Nginx Web管理界面。它采用Go和Vue构建，以单可执行二进制文件形式分发，提供直观的Web界面用于管理Nginx服务器。

## 核心功能和特性

- **服务器监控**：实时统计CPU使用率、内存占用、负载平均值和磁盘使用情况等服务器指标
- **ChatGPT助手**：集成在线ChatGPT助手
- **证书管理**：一键部署和自动续期Let's Encrypt证书
- **配置编辑**：提供自研的NgxConfigEditor（友好的Nginx配置块编辑器）和支持语法高亮的Ace代码编辑器
- **日志查看**：在线查看Nginx日志
- **自动重载**：保存配置后自动测试配置文件并重载Nginx
- **Web终端**：内置Web终端功能
- **深色模式**：支持深色主题
- **响应式设计**：适配各种设备屏幕

## 国际化支持

- 英语
- 简体中文
- 繁体中文

欢迎贡献其他语言的翻译。

## 技术栈

- [Go 编程语言](https://go.dev)
- [Gin Web框架](https://gin-gonic.com)
- [GORM](http://gorm.io)
- [Vue 3](https://v3.vuejs.org)
- [Vite](https://vitejs.dev)
- [TypeScript](https://www.typescriptlang.org/)
- [Ant Design Vue](https://antdv.com)
- [vue3-gettext](https://github.com/jshmrtn/vue3-gettext)
- [vue3-ace-editor](https://github.com/CarterLi/vue3-ace-editor)
- [Gonginx](https://github.com/tufanbarisyildirim/gonginx)

## 使用方法

Nginx UI首次运行时，请在浏览器中访问`http://<服务器IP>:<监听端口>`完成后续配置。

### Docker部署

Docker镜像[uozi/nginx-ui:latest](https://hub.docker.com/r/uozi/nginx-ui)基于最新的Nginx镜像构建，可用于替换主机上的Nginx。通过将容器的80和443端口映射到主机，即可轻松完成替换。

#### 注意事项

1. 首次使用此容器时，确保映射到`/etc/nginx`的卷为空
2. 如需托管静态文件，可将目录映射到容器中

#### Docker命令部署

1. [安装Docker](https://docs.docker.com/install/)

2. 执行以下命令部署：

```bash
docker run -dit \
  --name=nginx-ui \
  --restart=always \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/nginx:/etc/nginx \
  -v /mnt/user/appdata/nginx-ui:/etc/nginx-ui \
  -p 8080:80 -p 8443:443 \
  uozi/nginx-ui:latest
```

3. 容器运行后，通过`http://<服务器IP>:8080/install`访问Nginx UI面板进行登录。

#### Docker Compose部署

1. [安装Docker Compose](https://docs.docker.com/compose/install/)

2. 创建`docker-compose.yml`文件：

```yaml
services:
    nginx-ui:
        stdin_open: true
        tty: true
        container_name: nginx-ui
        restart: always
        environment:
            - TZ=Asia/Shanghai
        volumes:
            - '/mnt/user/appdata/nginx:/etc/nginx'
            - '/mnt/user/appdata/nginx-ui:/etc/nginx-ui'
            - '/var/www:/var/www'
        ports:
            - 8080:80
            - 8443:443
        image: 'uozi/nginx-ui:latest'
```

3. 执行以下命令创建容器：

```bash
docker compose up -d
```

4. 容器运行后，通过`http://<服务器IP>:8080/install`访问Nginx UI面板进行登录。

## Nginx反向代理配置示例

```nginx
server {
    listen          80;
    listen          [::]:80;

    server_name     <你的服务器域名>;
    rewrite ^(.*)$  https://$host$1 permanent;
}

map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen  443       ssl;
    listen  [::]:443  ssl;
    http2   on;

    server_name         <你的服务器域名>;

    ssl_certificate     /path/to/ssl_cert;
    ssl_certificate_key /path/to/ssl_cert_key;

    location / {
        proxy_set_header    Host                $host;
        proxy_set_header    X-Real-IP           $remote_addr;
        proxy_set_header    X-Forwarded-For     $proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto   $scheme;
        proxy_http_version  1.1;
        proxy_set_header    Upgrade             $http_upgrade;
        proxy_set_header    Connection          $connection_upgrade;
        proxy_pass          http://127.0.0.1:9000/;
    }
}
```

## 贡献

开源社区的贡献是学习、启发和创造的重要源泉。任何贡献都将受到高度赞赏。

如果您有改进建议，请 Fork 本仓库并创建 Pull Request，或打开带有"enhancement"标签的Issue。别忘了给项目点星！

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 许可

本项目采用GNU Affero General Public License v3.0许可，详见[LICENSE](LICENSE)文件。使用、分发或贡献本项目即表示您同意此许可的条款和条件。

# 告别广告和追踪！5 分钟用 Docker searxng 搭建你的私人搜索引擎

![告别广告和追踪！5 分钟用 Docker searxng 搭建你的私人搜索引擎](https://img.xuanyuan.dev/docker/blog/docker-searxng.png)

*分类: searxng,部署教程 | 标签: searxng,部署教程 | 发布时间: 2026-04-27 02:29:35*

> 厌倦了满屏广告的搜索引擎？担心搜索隐私被泄露？本文教你用Docker一键部署开源元搜索引擎SearXNG，聚合Google、Bing、DuckDuckGo等多个搜索源，去广告、去追踪，打造完全属于你自己的私人搜索入口。

不知道你有没有这种感觉：现在用搜索引擎找东西，翻了三页全是广告，好不容易找到个有用的链接，点进去还是个垃圾站。更糟的是，你搜过什么，马上就会在各种APP上看到相关的广告，感觉自己的隐私被扒得一干二净。

算法不仅在给你喂饭，还在给你画地为牢。你看到的，只是别人想让你看到的。

有没有办法自己掌控搜索？答案是肯定的——**SearXNG**。

今天就教大家用Docker，5分钟搭建一个完全属于你自己的私人搜索引擎，从此告别广告和追踪。

## 什么是SearXNG？

SearXNG是一个开源的**元搜索引擎（Metasearch Engine）**。

简单来说，它不会自己去爬取网页，而是同时帮你去Google、Bing、DuckDuckGo等几十个搜索引擎搜索，然后把结果整合起来，去掉广告，去掉追踪代码，最后呈现给你一个干净、中立的搜索结果页面。

它的核心优势：
- ✅ **零广告**：没有任何商业广告，搜索结果纯粹
- ✅ **无追踪**：不会记录你的搜索历史，不会建立用户画像
- ✅ **多源聚合**：同时查询多个搜索引擎，结果更全面
- ✅ **完全可控**：所有代码开源，部署在自己的服务器上
- ✅ **高度可定制**：可以自由调整搜索源、界面风格、安全策略

一句话：**你的搜索，你自己做主**。

## 前置准备：Docker环境一键搞定

部署SearXNG最简单的方式就是用Docker，不用管各种依赖和配置，一行命令就能跑起来。

### Linux系统（含国产系统）一键安装
不管是Ubuntu、CentOS，还是银河麒麟、统信UOS、欧拉这些国产系统，直接复制下面这行命令，就能一键安装Docker、Docker Compose，还自动配置了国内镜像加速，解决下载慢的问题：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

### Windows/Mac用户
Windows和Mac用户直接下载Docker Desktop即可，图形化界面操作简单：
👉 [Docker Desktop官方下载](https://www.docker.com/get-started/)

安装完成后启动Docker，桌面状态栏会出现小鲸鱼图标，说明Docker正在运行。

### 验证安装
打开终端（Linux）或PowerShell（Windows），输入：
```bash
docker version
```
如果能看到Client和Server的版本信息，说明环境准备就绪。

## 快速上手：一行命令启动SearXNG

先来个最简单的版本，直接跑起来体验一下。

### 1. 拉取镜像

```bash
docker pull docker.xuanyuan.run/searxng/searxng:latest
```

看到类似输出说明成功：
```
Status: Downloaded newer image for docker.xuanyuan.run/searxng/searxng:latest
```

### 2. 启动容器
一行命令启动：

```bash
docker run -d --name searxng -p 18080:8080 docker.xuanyuan.run/searxng/searxng:latest
```

### 3. 访问测试
打开浏览器，输入：
```
http://localhost:18080
```
![searxng 首页](https://img.xuanyuan.dev/docker/blog/docker-searxng-1.png)

🎉 恭喜！你已经拥有一个属于自己的私人搜索引擎了！

![searxng 搜索结果页](https://img.xuanyuan.dev/docker/blog/docker-searxng-3.png)

界面非常简洁，没有任何广告，搜索结果干净清爽。你可以试试搜索任何内容，对比一下和你平时用的搜索引擎有什么不同。

![searxng 搜索设置页](https://img.xuanyuan.dev/docker/blog/docker-searxng-2.png)

## 常见问题：端口占用

如果你运行时报错：
```
Bind for 0.0.0.0:8080 failed: port is already allocated
```

说明你的8080端口已经被其他程序占用了。

### 解决方案一：换端口（推荐）
最简单的方法就是换一个端口，比如把18080改成其他未被占用的端口：

```bash
docker run -d --name searxng -p 18081:8080 docker.xuanyuan.run/searxng/searxng:latest
```

### 解决方案二：关闭占用进程
如果想继续使用8080端口，可以先关闭占用该端口的进程：

**Windows系统：**
```powershell
# 查看占用8080端口的进程ID
netstat -ano | findstr :8080

# 结束进程（把PID替换成上面查到的数字）
taskkill /F /PID PID
```

**Linux系统：**
```bash
# 查看占用8080端口的进程ID
lsof -i :8080

# 结束进程（把PID替换成上面查到的数字）
kill -9 PID
```

## 进阶部署：Docker Compose方案（推荐长期使用）

上面的快速启动方式只是"能用"，但如果你想长期使用，建议用Docker Compose部署，加上配置持久化和Redis缓存，稳定性会好很多。

### 1. 创建docker-compose.yml文件
新建一个文件夹，在里面创建`docker-compose.yml`文件，内容如下：

```yaml
version: "3.8"

services:
  searxng:
    image: docker.xuanyuan.run/searxng/searxng:latest
    container_name: searxng
    ports:
      - "18080:8080"
    volumes:
      # 配置文件持久化到本地
      - ./searxng:/etc/searxng
    environment:
      # 你的访问地址，改成你自己的域名或IP
      - SEARXNG_BASE_URL=http://localhost:18080/
    depends_on:
      - redis
    restart: unless-stopped

  redis:
    image: redis:alpine
    container_name: searxng-redis
    restart: unless-stopped
```

### 2. 启动服务
在文件所在目录执行：

```bash
docker compose up -d
```

等待几秒钟，服务就启动完成了，同样访问`http://localhost:18080`即可使用。

这种方式的好处：
- 配置文件保存在本地，升级容器不会丢失配置
- 加入Redis缓存，提高搜索速度，减少对上游搜索引擎的请求
- 设置了自动重启，服务器重启后服务会自动启动

## 自定义配置

启动后，会在当前目录生成`./searxng/settings.yml`文件，这就是SearXNG的主配置文件。

你可以根据自己的需求修改：
- **默认搜索引擎**：修改`default_engine`字段
- **语言设置**：修改`language`字段为`zh-CN`
- **启用/禁用搜索源**：在`engines`部分调整
- **请求间隔**：调整`request_timeout`和`max_request_timeout`，防止被搜索引擎封IP

修改完配置后，重启容器生效：
```bash
docker restart searxng
```

## 进阶玩法

如果你想把这个搜索引擎对外提供服务，或者追求更好的使用体验，可以试试这些进阶玩法。

### 1. 反向代理（强烈推荐）
不要直接把SearXNG的端口暴露在公网上，建议用Nginx或Caddy做反向代理，加上HTTPS加密。

以Nginx为例，配置示例：
```nginx
server {
    listen 80;
    server_name search.yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name search.yourdomain.com;

    ssl_certificate /path/to/your/cert.pem;
    ssl_certificate_key /path/to/your/key.pem;

    location / {
        proxy_pass http://127.0.0.1:18080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 2. 限流和鉴权
如果你的搜索引擎对外公开，一定要加上限流和鉴权，否则很容易被爬虫打爆，导致服务器资源耗尽。

可以用Nginx的`limit_req`模块做限流，或者用HTTP Basic Auth做简单的身份验证。

### 3. 代理支持（核心）
这是最关键的一点。因为SearXNG是用你的服务器IP去请求Google、Bing等搜索引擎，如果请求量比较大，很容易被封IP。

解决方法是配置代理池或者SOCKS5代理，让请求通过不同的IP出去。

在`settings.yml`中添加代理配置：
```yaml
outgoing:
  proxies:
    http: "socks5://127.0.0.1:1080"
    https: "socks5://127.0.0.1:1080"
```

## 写在最后

SearXNG是一个非常棒的工具，它让我们重新掌握了搜索的主动权。

如果你只是自己和家人用，快速启动的方式就足够了；如果你想对外提供服务，或者追求更好的稳定性，一定要用Docker Compose部署，加上反向代理、限流和代理支持。

自己掌控搜索结果，告别广告和追踪，这种感觉真的很爽。

如果你想了解更多关于SearXNG的信息，可以访问轩辕镜像的中文页面：
👉 [SearXNG 轩辕镜像中文页面](https://xuanyuan.cloud/zh/r/searxng/searxng)

赶紧动手试试吧，搭建一个属于你自己的私人搜索引擎！


# MoviePilot 配置与安装指南

![MoviePilot 配置与安装指南](https://img.xuanyuan.dev/docker/blog/docker-movepilot.png)

*分类: Docker,MoviePilot | 标签: MoviePilot,docker,部署教程 | 发布时间: 2025-10-07 12:54:27*

> MoviePilot是一款媒体库自动化管理工具，需要稳定访问TheMovieDb和Github的网络环境，推荐使用代理服务。软件依赖下载器（Qbittorrent/Transmission）、媒体服务器（Emby/Jellyfin/Plex）和CookieCloud同步服务。安装首选Docker方式，提供多种版本镜像和docker-compose模板，支持虚拟显示和浏览器仿真功能。同时支持Windows可执行文件、Synology套件和源代码运行。使用前需调整系统文件监控限制，并确保拥有PT站点进行用户认证。通过反向代理可实现域名访问，需配置长超时时间避免中断。

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

## 1. 网络
MoviePilot通过调用 [TheMovieDb](https://api.themoviedb.org) 的Api来读取和匹配媒体元数据，通过访问 [Github](https://github.com) 来执行程序升级、安装插件等。有顺畅连接上述网址的网络环境是能流畅使用本软件的前提。**推荐使用前两种方式**，网络质量更加稳定。

### 1.1 单独代理
搭建代理服务，并将代理地址填入MoviePilot的环境变量中，软件会自动对需要使用代理的请求使用代理服务器。具体可参考 [配置参考](/configuration) 章节设置代理服务器变量。

### 1.2 全局代理
将MoviePilot所在的网络接入代理，通过分流规则将软件的网络请求通过代理发出，同时剔除站点相关的网络请求。

### 1.3 防域名污染与中转加速
- 更换TheMovieDb的Api地址为`api.tmdb.org`、开启`DOH`、本地修改`hosts`文件协持`api.themoviedb.org`域名地址为可访问IP、使用`Cloudflare Workers`搭建代理中转等，综合使用以上方式调优TheMovieDb的网络访问，涉及调整系统设定的参考 [配置参考](/configuration) 章节。
- 使用Github中转访问支持能力器来加快Github文件下载请求，具体可参考 [配置参考](/configuration) 章节。

#### 1.3.1 Cloudflare Workers 参考代码：
```javascript
async function handleRequest(request) {
  // 从请求URL中获取 API查询参数
  const url = new URL(request.url)
  const searchParams = url.searchParams

  // 设置代理API请求的URL地址
  const apiUrl = `https://api.themoviedb.org/${url.pathname}?${searchParams.toString()}`

  // 设置API请求的headers
  const headers = new Headers(request.headers)
  headers.set('Host', 'api.themoviedb.org')

  // 创建API请求
  const response = await fetch(apiUrl, {
    method: request.method,
    headers: headers
  })

  // 返回API响应
  return response
}

addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})
```


## 2. 操作系统
部分功能基于文件系统监控实现（如`目录监控`等），监控的文件较多时，往往会因为操作系统默认允许的文件句柄数太小导致报错，相关功能失效，需在**宿主机**操作系统上（不是docker容器内）执行以下命令并重启生效：
```shell
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
echo fs.inotify.max_user_instances=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```


## 3. 站点
MoviePilot包括两大部分功能：`文件整理刮削`、`资源订阅下载`，其中`资源订阅下载`功能需要有可用的`PT站点`，**同时这些站点中需要有一个可用于认证**，关于用户认证请参考 [基础](/basic) 章节的相关说明。


## 4. 配套软件
MoviePilot只是媒体库自动化管理的一环，需要通过调用`下载器`来完成资源的下载，需要通过`媒体服务器`来管理和展示媒体资源，**同时通过媒体服务器Api来查询库存情况控制重复下载**，通过`CookieCloud`来快速同步站点Cookie和新增站点。安装前需要先完成配套软件的安装。

### 4.1 下载器
- **Qbittorrent**：版本要求 >= `4.3.9`
- **Transmission**：版本要求 >= `3.0`

### 4.2 媒体服务器
- **Emby**：建议版本 >= `4.8.0.45`
- **Jellyfin**：推荐使用`latest`分支
- **Plex**：无特定版本要求

### 4.3 CookieCloud
- **CookieCloud服务端**：可选，MoviePilot已经内置了CookieCloud服务端，如需独立安装可参考 [easychen/CookieCloud](https://github.com/easychen/CookieCloud) 说明
- **CookieCloud浏览器插件**：不管是使用CookieCloud独立服务端还是使用内置服务，都需要安装浏览器插件，访问 [此处](https://github.com/easychen/CookieCloud/releases) 下载安装到浏览器。

### 4.4 Docker管理器
如果你计划使用docker来部署MoviePilot，请确认你的环境是否可以方便地编辑容器配置，否则建议安装 [portainer](https://github.com/portainer/portainer) 来简化容器操作。
```shell
docker run -d --restart=always --name="portainer" -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock 6053537/portainer-ce
```

### 4.5 Overseerr/Jellyseerr
如果你希望将MoviePilot的自动化媒体管理能力开放给多个人使用，同时具有用户提交订阅申请与集中审批的功能，可以安装 `Overseerr`/`Jellyseerr`来配合实现更好的选片和申请审批使用体验。MoviePilot通过模拟`Radarr`和`Sonarr`的Api实现无缝集成，`Overseerr`/`Jellyseerr`负责选片和用户权限管理，MoviePilot负责订阅、下载和整理。参考下图：

![seerr.png](https://img.xuanyuan.dev/docker/blog/seerr.png)


## 5. Docker
MoviePilot在docker境像中同时还内置了`虚拟显示`、`浏览器仿真`、`内建重启`、`代理缓存`等特性，**推荐使用docker方式安装**。  
使用 `docker run -itd` 命令安装时，请去除其中的 `#` 开头的注释行，以防报错。

### 5.1 Linux Docker & Docker Compose 一键安装
#### 一键安装配置脚本
推荐方案：一键安装配置脚本  
该脚本支持多种Linux发行版，支持一键安装 docker、docker-compose 并且一键配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

### 5.2 Docker Run 命令（分版本）
#### 5.2.1 V2版本
```shell
docker run -itd \
    --name moviepilot-v2 \
    --hostname moviepilot-v2 \
    --network bridge \
    -p 3000:3000 \
    -p 3001:3001 \
    -v /media:/media \
    -v /moviepilot-v2/config:/config \
    -v /moviepilot-v2/core:/moviepilot/.cache/ms-playwright \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -e 'NGINX_PORT=3000' \
    -e 'PORT=3001' \
    -e 'PUID=0' \
    -e 'PGID=0' \
    -e 'UMASK=000' \
    -e 'TZ=Asia/Shanghai' \
    -e 'SUPERUSER=admin' \ #超级管理员用户名
    -e 'SUPERUSER_PASSWORD=你的初始登录密码' \ #超级管理员初始密码
    --restart always \
    jxxghp/moviepilot-v2:latest
```

#### 5.2.2 V1版本
```shell
docker run -itd \
    --name moviepilot \
    --hostname moviepilot \
    -p 3000:3000 \
    -v /media:/media \
    -v /moviepilot/config:/config \
    -v /moviepilot/core:/moviepilot/.cache/ms-playwright \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -e 'NGINX_PORT=3000' \
    -e 'PORT=3001' \
    -e 'PUID=0' \
    -e 'PGID=0' \
    -e 'UMASK=000' \
    -e 'TZ=Asia/Shanghai' \
    -e 'AUTH_SITE=iyuu' \
    -e 'IYUU_SIGN=xxxx' \
    -e 'SUPERUSER=admin' \
    -e 'API_TOKEN=建议大于16位的复杂字符串' \
    --restart always \
    jxxghp/moviepilot:latest
```

### 5.3 Docker Compose 配置（分版本）
#### 5.3.1 V2-全功能版
```shell
services:

  moviepilot:
    stdin_open: true
    tty: true
    container_name: moviepilot-v2
    hostname: moviepilot-v2
    ports:
     - '3000:3000'
     - '3001:3001'
    volumes:
      - '/media:/media' #媒体
      - '/moviepilot-v2/config:/config' #持久化配置
      - '/moviepilot-v2/core:/moviepilot/.cache/ms-playwright' #内核浏览器
      - '/var/run/docker.sock:/var/run/docker.sock:ro' #重启MP权限
      - '/tr/config/torrents:/torrents'  #TR种子位置
      - '/qbittorrent/data/data/BT_backup:/BT_backup' #QB种子位置
    environment:
      - 'NGINX_PORT=3000'
      - 'PORT=3001'
      - 'PUID=0'
      - 'PGID=0'
      - 'UMASK=000'
      - 'TZ=Asia/Shanghai'
      - 'SUPERUSER=admin'
      - 'SUPERUSER_PASSWORD=你的初始登录密码'
      - 'DB_TYPE=postgresql'
      - 'DB_POSTGRESQL_HOST=postgresql'
      - 'DB_POSTGRESQL_PORT=5432'
      - 'DB_POSTGRESQL_DATABASE=moviepilot'
      - 'DB_POSTGRESQL_USERNAME=moviepilot'
      - 'DB_POSTGRESQL_PASSWORD=pg_password'
      - 'CACHE_BACKEND_TYPE=redis'
      - 'CACHE_BACKEND_URL=redis://:redis_password@redis:6379'
    restart: always
    depends_on:
      postgresql:
        condition: service_healthy
      redis:
        condition: service_healthy
    image: jxxghp/moviepilot-v2:latest

  redis:
    volumes:
        - /volume1/docker/redis/data:/data
    image: redis
    command: redis-server --save 600 1 --requirepass redis_password
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  postgresql:
    image: postgres
    restart: always
    environment:
      POSTGRES_DB: moviepilot
      POSTGRES_USER: moviepilot
      POSTGRES_PASSWORD: pg_password
    volumes:
      - /volume1/docker/postgresql:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U moviepilot -d moviepilot"]
      interval: 10s
      timeout: 5s
      retries: 5

    # 最后这个迁移数据库的
  pgloader:
    image: dimitri/pgloader:latest
    volumes:
      - <MP配置文件路径>:/mp_config
    command: >
      pgloader
      sqlite:///mp_config/user.db
      postgresql://moviepilot:pg_password@postgresql:5432/moviepilot
    depends_on:
      postgresql:
        condition: service_healthy
```

#### 5.3.2 V2-纯净版
```shell
version: '3.3'
services:
  moviepilot:
    stdin_open: true
    tty: true
    container_name: moviepilot-v2
    hostname: moviepilot-v2
    network_mode: host
    volumes:
      - '/media:/media'
      - '/moviepilot-v2/config:/config'
      - '/moviepilot-v2/core:/moviepilot/.cache/ms-playwright'
      - '/var/run/docker.sock:/var/run/docker.sock:ro'

    environment:
      - 'NGINX_PORT=3000'
      - 'PORT=3001'
      - 'PUID=0'
      - 'PGID=0'
      - 'UMASK=000'
      - 'TZ=Asia/Shanghai'
      - 'SUPERUSER=admin' #超级管理员用户名
      - 'SUPERUSER_PASSWORD=你的初始登录密码' #超级管理员初始密码

    restart: always
    image: jxxghp/moviepilot-v2:latest
```

#### 5.3.3 V2-小白版
```shell
version: '3.3'
services:
  moviepilot:
    stdin_open: true  #是否打开标准输入流（交互模式），为 true 时容器可以保持运行并与用户交互
    tty: true  #是否分配伪终端，使容器的终端行为更像一个真实的终端
    container_name: moviepilot-v2  #容器的名称
    hostname: moviepilot-v2  #容器主机名

    # 网关设置
    network_mode: host  #内置的网关
    # networks:  #自定义网关
    #  - moviepilot

    # 端口映射，当network_mode的值为 host 时，将失效
    # ports:
      # 前端 UI 显示
      # - target: 3000  #容器内部端口设置为 3000
      #   published: 3000  #映射到宿主机的 3000 端口，允许外部访问
      #   protocol: tcp  #TCP 协议，可选udp
      # API 接口
      # - target: 3001  #容器内部端口设置为 3001
      #   published: 3001  #映射到宿主机的 3001 端口，允许外部访问
      #   protocol: tcp  #TCP 协议，可选udp

    # 目录映射：宿主机目录:容器内目录
    volumes:
      - '/media:/media'  #媒体库或下载库路径
      - '/moviepilot-v2/config:/config'  #moviepilot 的配置文件存放路径
      - '/moviepilot-v2/core:/moviepilot/.cache/ms-playwright'  #浏览器内核存放路径
      - '/var/run/docker.sock:/var/run/docker.sock:ro'  #用于获取宿主机的docker管理权，一般用于UI页面重启或自动更新

    # 环境变量：- '变量名=值‘
    environment:
      - 'NGINX_PORT=3000'  #UI页面的内部监听端口
      - 'PORT=3001'  #API接口的内部监听端口
      - 'PUID=0'  #设置应用运行时的用户 ID 为 0（root 用户）
      - 'PGID=0'  #设置应用运行时的组 ID 为 0（root 组）
      - 'UMASK=000'  #文件创建时的默认权限掩码，000 表示不限制权限
      - 'TZ=Asia/Shanghai'  #设置时区为上海（Asia/Shanghai）
      - 'SUPERUSER=admin'  #设置超级用户为 admin
      - 'SUPERUSER_PASSWORD=你的初始登录密码' #超级管理员初始密码
      - 'ADVANCED_MODE=false' #关闭高级模式，只显示简化设置项

    # 重启模式:
    restart: always  #始终重启
    image: jxxghp/moviepilot-v2:latest

# 当使用内置网关时，可不启用
# networks:
#   moviepilot:  #定义一个名为 moviepilot 的自定义网络
#     name: moviepilot  #网络的名称
```

#### 5.3.4 V1版本
```shell
version: '3.3'

services:

    moviepilot:
        stdin_open: true
        tty: true
        container_name: moviepilot
        hostname: moviepilot
        networks:
            - moviepilot
        ports:
            - target: 3000
              published: 3000
              protocol: tcp
        volumes:
            - '/media:/media'
            - '/moviepilot/config:/config'
            - '/moviepilot/core:/moviepilot/.cache/ms-playwright'
            - '/var/run/docker.sock:/var/run/docker.sock:ro'
        environment:
            - 'NGINX_PORT=3000'
            - 'PORT=3001'
            - 'PUID=0'
            - 'PGID=0'
            - 'UMASK=000'
            - 'TZ=Asia/Shanghai'
            - 'AUTH_SITE=iyuu'
            - 'IYUU_SIGN=xxxx'
            - 'SUPERUSER=admin'
            - 'API_TOKEN=建议大于16位的复杂字符串'
        restart: always
        image: jxxghp/moviepilot:latest

networks:
  moviepilot:
    name: moviepilot
```

### 5.4 Docker 相关说明
- `/media`为媒体文件目录，根据实际情况调整，需要注意的是，**如果你计划使用`硬链接`来整理文件，那么`文件下载目录`和整理后的`媒体库目录`只能映射一个根目录不能分开映射，否则将会导致跨盘无法硬链接。** 这是由docker的目录映射机制决定的，下面这些情况都会导致跨盘无法硬链接：
  1. 下载目录和媒体库目录分别属于两个不同的磁盘
  2. 下载目录和媒体库目录属于同一磁盘，但在两个不同的分区/存储空间/存储池中
  3. 下载目录和媒体库目录分别作为两个目录路径映射到docker容器中
- `/moviepilot/config`为配置文件、数据库文件、日志文件、缓存文件使用的文件目录，该目录将会存储所有设置和数据，需根据实际情况调整。
- `/moviepilot/core`为浏览器内核下载保存目录（**避免容器重置后重新下载浏览器内核**），需根据实际情况调整。
- `/var/run/docker.sock`用于内建重启时使用，建议映射。
- 默认使用`3000`为WEB服务端口，`3001`为Api服务端口，可根据实际情况调整。
- `AUTH_SITE`、`SUPERUSER`、`API_TOKEN`等其它变量请根据 [配置参考](/configuration) 说明调整和补充，上述为最基础配置，实际可以根据需要补充其它变量。


## 6. Windows
Windows环境下提供两种安装方式，推荐使用`安装版本`。

### 6.1 可执行文件版本
项目在编译时，将Python以及相关的代码打包到一个exe文件中使用，点击 [此处](https://github.com/jxxghp/MoviePilot/releases) 下载exe文件，双击运行后会自动生成`config`配置文件目录，以及`nginx`前端资源目录，正常运行后会操作系统任务栏会生成MoviePilot图标，输入`localhost:3000`可访问后端管理WEB。

- 如运行后无法正常解压，请使用**管理员权限**运行。
- 如被杀毒软拦截，则需要将运行目录加入**白名单**放行，因打包方式的原因有的杀毒软件会识判为病毒。
- **还需根据  [配置参考](/configuration) ，在 `Windows 系统属性 -> 高级设置 -> 环境变量`中添加认证等环境变量。**
- 由于该版本是预编译后再打包的方式，在功能上存在一定的限制，比如不支持`内建重启`、除`内置插件库`外不支持安装其它第三方插件库插件等。

### 6.2 安装版本
由 [Windows-MoviePilot](https://github.com/developer-wlj/Windows-MoviePilot) 项目提供，参考项目说明使用。

V2版本：[https://github.com/developer-wlj/Windows-MoviePilot/tree/v2](https://github.com/developer-wlj/Windows-MoviePilot/tree/v2)


## 7. Synology套件
DSM7 添加套件源：[https://spk7.imnks.com/](https://spk7.imnks.com/) ，安装后通过`MoviePilot配置`入口，根据  [配置参考](/configuration) 进行配置使用。

该套件由套件源作者维护，如有问题需要向套件源维护方寻求帮助。


## 8. 源代码运行
MoviePilot项目已拆分为多个项目，使用源码运行时需要手动将相关项目文件进行整合：

1. 使用`git clone`或者下载源代码包等方式下载主项目 [MoviePilot](https://github.com/jxxghp/MoviePilot) 文件到本地。
   ```shell
   git clone https://github.com/jxxghp/MoviePilot
   ```

2. 将工程 [MoviePilot-Plugins](https://github.com/jxxghp/MoviePilot-Plugins) `plugins`目录下的所有文件复制到`app/plugins`目录，`icons`目录下的所有文件复制到前端项目的`public/plugin_icon`目录下

3. 将工程 [MoviePilot-Resources](https://github.com/jxxghp/MoviePilot-Resources) resources目录下的所有文件复制到`app/helper`目录

4. 执行命令：`pip install -r requirements.txt` 安装依赖

5. 执行命令：`PYTHONPATH=. python app/main.py` 启动主服务（部分IDE提供一键启动、调试功能，请先设置工作目录为/app，并将环境变量文件设置为/config/app.env）

6. 根据前端项目 [MoviePilot-Frontend](https://github.com/jxxghp/MoviePilot-Frontend) 说明，启动前端服务


## 9. 反向代理
如需开启域名访问MoviePilot，则需要搭建反向代理服务。以`nginx`为例，需要添加以下配置项，否则可能会导致部分功能无法访问（`ip:port`修改为实际值）：
```nginx
location / {
    proxy_pass http://ip:port;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

反向代理使用SSL时，还需要开启http2，否则会导致日志加载时间过长或不可用：
```nginx
server {
    listen 443 ssl;
    http2 on;
    # ...
}
```

**代理服务连接超时时间应尽量长⼀些，比如10分钟，避免代理服务器强制中断请求。**


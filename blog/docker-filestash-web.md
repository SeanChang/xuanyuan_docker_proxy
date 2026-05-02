# 用 Docker 一键部署 Filestash：打造你的全能 Web 文件管理器

![用 Docker 一键部署 Filestash：打造你的全能 Web 文件管理器](https://img.xuanyuan.dev/docker/blog/docker-filestash.png)

*分类: Filestash,部署教程,文件管理 | 标签: Filestash,部署教程,文件管理 | 发布时间: 2026-04-23 02:15:44*

> 还在为不同存储协议装一堆客户端？SFTP、FTP、WebDAV、S3、云盘……每次都要切换工具，传个文件像“打地鼠”？今天给大家安利一个神器——Filestash，一个开源的 Web 文件管理器，把所有存储协议都收进浏览器里，用 Docker 几分钟就能搭好，运维、开发、日常用都超爽！

在服务器运维或开发过程中，我们经常需要远程管理文件，例如通过 SFTP、FTP、WebDAV、S3、NAS 等方式访问存储。传统工具通常需要安装客户端，例如 FileZilla、WinSCP 等。

如果希望 通过浏览器统一管理各种存储，可以使用 Filestash。

Filestash 是一个开源的 Web 文件管理器，支持多种存储协议，可以把各种存储统一在一个 Web 界面中进行管理。

---

## 一、Filestash 到底是什么？
Filestash 是个现代化的 Web 文件管理器，核心就是一句话：**用浏览器搞定所有文件管理需求**。

它支持的存储协议几乎覆盖了你能想到的所有场景：
- 服务器：SFTP、FTP
- 云存储：S3/MinIO、Google Drive、Dropbox
- 自建服务：WebDAV（Nextcloud、Alist、坚果云都能用）、Git、Samba（NAS）
- 本地文件：直接挂载服务器本地目录

而且不用装任何客户端，浏览器打开就能用，在线预览、拖拽上传、批量管理全搞定。

更多介绍可以查看 Filestash 镜像中文地址：https://xuanyuan.cloud/zh/r/machines/filestash

---

## 二、前置准备：Docker 环境一键搞定
部署 Filestash 之前，先把 Docker 环境搭好。这里给大家准备了适配全场景的一键安装脚本，Linux 系统直接用，国产系统（银河麒麟、欧拉）也支持。

### 1. Linux 系统 Docker 一键安装
#### 🧪 测试环境（快速体验，仅限非生产）
直接一条命令，自动安装 Docker、Docker Compose，还配置好轩辕镜像加速：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

#### 🏭 生产环境（推荐，安全优先）
企业/正式环境建议先审计脚本再执行，更稳妥：
```bash
# 1. 下载脚本到本地
wget https://xuanyuan.cloud/docker.sh -O docker-install.sh

# 2. （可选但推荐）脚本源码，确认脚本安全
less docker-install.sh  # 也可以用vim、cat查看内容

# 3. 执行脚本安装
bash docker-install.sh
```

### 2. Windows / Mac 用户
直接去 [Docker 官网](https://www.docker.com/products/docker-desktop/) 下载 Docker Desktop，安装启动即可，图形化操作很简单。

---

## 三、一键部署 Filestash
这里给大家分系统提供**一键启动命令**，复制粘贴就能运行，新手零门槛。

### 方式 1：Linux / macOS 系统（终端执行）
```bash
docker run -d \
--name filestash \
-p 8334:8334 \
--restart unless-stopped \
docker.xuanyuan.run/machines/filestash:latest
```

### 方式 2：Windows 系统（PowerShell 专用命令）
打开 **Windows PowerShell**（建议管理员权限运行），直接复制粘贴这条完整命令：
```powershell
docker run -d --name filestash -p 8334:8334 --restart unless-stopped docker.xuanyuan.run/machines/filestash:latest
```

### 方式 3：Docker Compose 部署（全系统通用，NAS 或长期使用推荐）
创建 `docker-compose.yml` 文件，写入以下内容：
```yaml
version: "3"

services:
  filestash:
    image: docker.xuanyuan.run/machines/filestash:latest
    container_name: filestash
    ports:
      - "8334:8334"
    restart: unless-stopped
```

然后在文件所在目录执行启动命令：
```bash
# Linux/macOS/PowerShell 通用
docker compose up -d
```

---

## 四、第一次访问与初始化
容器启动成功后，打开浏览器访问：
- 服务器部署：`http://你的服务器IP:8334`
- 本地部署：`http://localhost:8334`

首次进入会先让你设置一个管理员密码，设置完成就能进入主界面了。

![设置一个管理员密码](https://img.xuanyuan.dev/docker/blog/docker-filestash-1.png)

---

## 五、核心玩法：连接你的各种存储
Filestash 本身不存文件，只是个“文件管理前端”，核心就是连接已有的存储系统。下面给大家演示几个最常用的场景。

### 场景 1：连接 Linux 服务器（SFTP）
选 SFTP 协议，填服务器信息：
- Hostname：你的服务器 IP 或域名
- Username：服务器登录用户名（比如 root）
- Password：服务器登录密码
- Port：默认 22，如果你改了 SSH 端口就填对应的

![连接 Linux 服务器（SFTP）](https://img.xuanyuan.dev/docker/blog/docker-filestash-4.png)

填完点“连接”，直接就能在浏览器里管理服务器文件了，上传、下载、编辑、解压都支持。

![浏览器里管理服务器文件](https://img.xuanyuan.dev/docker/blog/docker-filestash-5.png)

### 场景 2：连接 WebDAV 服务（Nextcloud/Alist/坚果云）
WebDAV 支持很多自建和公共服务，比如 Alist、Nextcloud、坚果云，配置也很简单：
- 协议选 WebDAV
- URL：你的 WebDAV 地址，比如 `https://alist.example.com/dav`
- Username：WebDAV 用户名
- Password：WebDAV 密码

### 场景 3：连接 S3/MinIO 对象存储
不管是 AWS S3，还是自建的 MinIO，都能直接连：
- 协议选 S3
- Endpoint：对象存储的地址（比如 MinIO 就是 `http://你的MinIOIP:9000`）
- AccessKey/SecretKey：对象存储的密钥
- Bucket：要访问的桶名
- Region：根据你的存储填写（MinIO 可以随便填，比如 `us-east-1`）

### 场景 4：Windows 挂载本地目录（管理电脑硬盘文件）
如果想直接管理 Windows 本地磁盘（如 D 盘），在 PowerShell 执行这条命令：
```powershell
docker run -d --name filestash -p 8334:8334 -v D:\:/data --restart unless-stopped docker.xuanyuan.run/machines/filestash:latest
```
登录时选择 `LOCAL`，路径填写 `/data`，即可直接访问 Windows D 盘。

---

## 六、进阶配置：反向代理与后台设置
### 1. 用域名访问（Nginx 反向代理）
如果不想每次都输 IP+端口，可以用 Nginx 配置反向代理，用域名访问：
```nginx
server {
    listen 80;
    server_name filestash.example.com;  # 换成你的域名

    location / {
        proxy_pass http://127.0.0.1:8334;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```
配置完成后重载 Nginx，就能通过 `http://filestash.example.com` 访问了，还能后续配置 HTTPS 加密访问。

### 2. 管理员后台设置
访问 `http://你的地址:8334/admin` 就能进入后台，这里可以配置存储预设、用户权限、S3 模板等。

后台里还能看到运行状态，比如当前是以非 root 用户运行，以及版本信息、企业版升级提示等，生产环境建议配置 HTTPS 加密访问，避免明文传输数据。

---

## 七、总结：Filestash 适合谁用？
Filestash 不是万能的，但对很多人来说是“效率神器”：
- 运维/开发：统一管理多台服务器的文件，不用来回切换 SFTP 客户端
- NAS 用户：给家里的 NAS 搭个 Web 管理界面，在外网也能方便访问
- 多网盘用户：把 Alist、Nextcloud、坚果云都接进来，一个界面搞定所有云盘
- 轻量文件预览：给同事分享文件，直接发个链接，对方用浏览器就能看，不用装客户端

搭配 Alist、MinIO 这些工具，还能搭一个“多存储统一管理平台”，把所有文件都管起来。


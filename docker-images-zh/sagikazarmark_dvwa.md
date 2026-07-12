---
image: sagikazarmark/dvwa
description: "该Docker镜像封装了DVWA（Damn Vulnerable Web Application），一个展示常见Web漏洞的易受攻击应用，用于帮助安全从业者和爱好者学习、实践Web安全测试技术。"
source: https://xuanyuan.cloud/zh/r/sagikazarmark/dvwa
canonical: https://xuanyuan.cloud/zh/r/sagikazarmark/dvwa
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sagikazarmark/dvwa" title="sagikazarmark/dvwa Docker 镜像中文简介、标签列表与拉取命令">sagikazarmark/dvwa 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述与用途
该Docker镜像包含DVWA（Damn Vulnerable Web Application），这是一个“极其易受攻击”的Web应用程序，旨在演示最常见的Web相关漏洞。它主要用于安全从业者、学生和爱好者学习Web安全测试技术，实践漏洞利用方法。

## 免责声明
由于镜像包含严重的安全漏洞，强烈不建议将其部署在任何接近生产系统的环境中（已警告）。  
为降低在本地运行时的风险，建议使用Docker或虚拟机进行隔离，但不提供任何担保。  
请同时阅读DVWA官方的[免责声明](https://github.com/ethicalhack3r/DVWA#disclaimer)。

## 使用方法
### 拉取镜像
首先从Docker Hub拉取镜像：  
```bash
docker pull docker.xuanyuan.run/sagikazarmark/dvwa
```

### 启动容器
使用以下命令启动容器：  
```bash
docker run --rm -it -p 8080:80 docker.xuanyuan.run/sagikazarmark/dvwa
```
**注意**：`-it` 参数是必需的，以便通过SIGINT（Ctrl+C）停止容器。

### 访问与登录
1. 在浏览器中访问 `http://localhost:8080`。  
2. 使用默认凭据登录：用户名 `admin`，密码 `password`。  
3. 你会看到安装界面，所有选项应为绿色（除了验证码，后续会说明）。  
4. 点击 **Create / Reset Database** 按钮创建或重置数据库。  
5. 完成后，点击 **login** 链接重新登录，即可开始使用。  

**重要**：使用完毕后请务必停止容器！

## 环境详情
该镜像旨在模拟普通（易受攻击）的Web应用环境，包含完整的LAMP栈：  
- 操作系统：Debian Jessie  
- 软件版本：  
  - PHP 5.6.30  
  - Apache 2.4.10  
  - MySQL 5.5.54  

### 数据库配置
MySQL默认凭据：  
- 用户：`root`  
- 密码：`p@ssw0rd`  
- 数据库：`dvwa`  

### 特殊配置
- PHP：`allow_url_include` 已开启（DVWA必需）。  
- MySQL：  
  - 禁用 `bind_address`，允许 `root` 用户从任何地址登录（方便主机访问数据库）。  
  - 开启 `general_log`（日志位置：`/var/log/mysql/mysql.log`），用于监控查询。  
  - 关闭 `secure-file-priv`，允许SQL注入中的文件操作。  
- 目录：`/var/www/html` 设为全局可写，增加脆弱性。  
- 验证码：DVWA配置中会读取 `RECAPTCHA_PUBLIC_KEY` 和 `RECAPTCHA_PRIVATE_KEY` 环境变量。

## 使用技巧
### 以守护进程模式启动
**不推荐**（容易忘记停止容器），但可用于释放终端：  
将 `--rm` 替换为 `-d`：  
```bash
docker run -d -p 8080:80 docker.xuanyuan.run/sagikazarmark/dvwa
```
可指定容器名称以便管理：  
```bash
docker run -d --name dvwa -p 8080:80 docker.xuanyuan.run/sagikazarmark/dvwa
```
停止并删除容器：  
```bash
docker stop dvwa
docker rm dvwa
```

### 暴露MySQL到主机
添加端口映射 `-p 3336:3306` 以允许主机访问容器内的MySQL：  
```bash
docker run --rm -it -p 8080:80 -p 3336:3306 docker.xuanyuan.run/sagikazarmark/dvwa
```
连接MySQL：  
```bash
mysql -h 127.0.0.1 -P 3336 -u root -pp@ssw0rd
```
使用 `mytop` 监控数据库：  
```bash
mytop --password="p@ssw0rd" --port=3336 --database="dvwa" --host="127.0.0.1"
```

### 配置验证码（Recaptcha）
验证码需要注册，步骤如下：  
1. 访问 [Google Recaptcha](https://www.google.com/recaptcha/admin/create) 创建密钥。  
2. 启动容器时传入环境变量：  
```bash
docker run -d --name dvwa -p 8080:80 -e RECAPTCHA_PUBLIC_KEY=你的公钥 -e RECAPTCHA_PRIVATE_KEY=你的私钥 docker.xuanyuan.run/sagikazarmark/dvwa
```

### 使用lnav查看日志
[lnav](http://lnav.org) 是强大的日志分析工具，支持Apache和MySQL日志格式。  

#### 查看Apache日志
容器会将Apache日志输出到STDOUT，可通过Docker日志查看：  
```bash
docker logs -f dvwa | lnav
```
过滤漏洞页面的访问日志：  
```
:filter-in GET /vulnerabilities
```
搜索并高亮SQL注入中的id参数：  
```
/(?<=id=)(.*)(?=&Submit=Submit HTTP)
```

#### 查看MySQL查询日志
MySQL日志未输出到STDOUT，需通过exec获取：  
```bash
docker exec dvwa sh -c "tail -f /var/log/mysql/mysql.log" | lnav
```
过滤SELECT查询：  
```
:filter-in SELECT
```
按 `Ctrl+R` 恢复未过滤状态。

## 为什么选择此镜像？
尽管已有多个DVWA Docker镜像，本镜像具有以下优势：  
1. **质量与可靠性**：提供详细文档和Dockerfile，确保透明性和可维护性。  
2. **环境真实性**：基于Debian Jessie构建，接近真实生产环境，而非特殊的Dockerized LAMP栈。  
3. **轻量高效**：镜像大小约360MB，仅5层（相比其他流行镜像的41层），启动更快。

## 许可证
本镜像使用 [MIT许可证](LICENSE)。请查看LICENSE文件获取详细信息。

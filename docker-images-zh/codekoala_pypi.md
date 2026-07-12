---
image: codekoala/pypi
description: "这是一个简单的PyPI服务器镜像，用于托管内部Python包及适合专有产品使用的包版本，支持上传内部包、镜像第三方包、身份验证等功能。"
source: https://xuanyuan.cloud/zh/r/codekoala/pypi
canonical: https://xuanyuan.cloud/zh/r/codekoala/pypi
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/codekoala/pypi" title="codekoala/pypi Docker 镜像中文简介、标签列表与拉取命令">codekoala/pypi 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PyPI服务器镜像

## 镜像概述
这是一个轻量的PyPI服务器镜像，旨在帮助用户托管内部Python包及适合专有产品场景的包版本，支持本地存储、身份验证和第三方包镜像等功能。

## 核心功能
- 支持本地目录挂载存储Python包（tarball、zip、wheel、egg等格式）
- 提供基于htpasswd的身份验证机制，保障包上传安全
- 允许上传内部Python项目包到私有服务器
- 支持镜像第三方Python包到本地，提升依赖安装效率
- 可通过环境变量配置包覆盖、认证动作等自定义行为

## 使用场景
- 企业内部Python包的集中管理与分发
- 专有产品依赖包的私有托管与版本控制
- 第三方Python包的本地镜像缓存，解决网络访问问题
- 团队内部共享自定义Python工具包

## 配置说明
可通过以下环境变量调整镜像行为：
- `PYPI_ROOT`：容器内包存储路径，默认`/srv/pypi`
- `PYPI_PORT`：容器监听端口，默认`80`
- `PYPI_PASSWD_FILE`：认证文件路径，默认`/srv/pypi/.htpasswd`
- `PYPI_OVERWRITE`：是否允许覆盖已有包，默认`false`
- `PYPI_AUTHENTICATE`：需认证的操作列表（不区分大小写），默认`update`
- `PYPI_EXTRA`：`pypi-server`的额外启动参数

## 部署示例
### 直接运行容器
1. 准备本地目录和认证文件：
   ```bash
   sudo mkdir -p /srv/pypi             # 本地包存储目录
   sudo touch /srv/pypi/.htpasswd      # 包上传认证文件
   ```
2. 启动容器：
   ```bash
   docker run -t -i --rm \
       -h pypi.local \
       -v /srv/pypi:/srv/pypi:rw \
       -p 8080:80 \
       --name pypi \
       docker.xuanyuan.run/codekoala/pypi
   ```
启动后访问`http://localhost:8080`查看服务器首页。

### 构建自定义镜像
克隆仓库后执行以下命令构建最新版本：
```bash
make build
```
运行自定义镜像：
```bash
make run
```
容器暴露在主机8080端口，访问`http://localhost:8080`验证功能。

## 添加内部包
1. 创建认证用户：
   ```bash
   htpasswd -s /srv/pypi/.htpasswd 你的用户名
   ```
2. 配置`~/.pypirc`文件：
   ```ini
   [distutils]
   index-servers =
       pypi
       internal

   [pypi]
   username: pypi官方用户名
   password: pypi官方密码

   [internal]
   repository: http://localhost:8080
   username: 你的认证用户名
   password: 你的认证密码
   ```
3. 上传项目包：
   ```bash
   python setup.py sdist upload -r internal
   ```

## 添加第三方包
下载单个包到本地目录：
```bash
pip install -d /srv/pypi 包名
```
批量下载requirements文件中的依赖：
```bash
pip install -d /srv/pypi -r requirements.txt
```
根据Python版本选择`pip2`或`pip3`。

## 更新镜像包
检查并更新第三方包：
```bash
pypi-server -U /srv/pypi
```
命令会显示各包的更新状态及操作指引。

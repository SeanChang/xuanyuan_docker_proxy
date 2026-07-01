# 手把手教你用 Docker 部署 Python

![手把手教你用 Docker 部署 Python](https://img.xuanyuan.dev/docker/blog/docker-python.png)

*分类: Docker部署教程 | 标签: python,docker,部署教程 | 发布时间: 2025-10-03 07:06:23*

> 本文介绍了通过Docker部署Python的全流程，包括从轩辕镜像查看、下载Python镜像（含多种拉取方式），到以快速部署、挂载本地项目、docker-compose管理三种方式部署容器，还涵盖安装第三方库、构建自定义镜像的进阶实践及常见问题解决办法。

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

### 手把手教你用 Docker 部署 Python
Python 是一门应用广泛的语言，常见于数据分析、AI、Web 开发等场景。通过 Docker 部署 Python，可以做到快速安装、环境隔离、跨平台运行。下面我们基于 **轩辕镜像** 来完整演示 Python 在 Docker 中的部署方法。

#### 1、查看 Python 镜像详情
你可以在 轩辕镜像 中找到 Python 镜像页面：
👉 https://xuanyuan.cloud/r/library/python

在镜像页面中，会看到多种拉取方式，下面我们逐一说明。

#### 2、下载 Python 镜像
##### 2.1 使用轩辕镜像拉取
```bash
docker pull docker.xuanyuan.run/library/python:3.12
```

##### 2.2 拉取后改名
```bash
docker pull docker.xuanyuan.run/library/python:3.12 \
&& docker tag docker.xuanyuan.run/library/python:3.12 python:3.12 \
&& docker rmi docker.xuanyuan.run/library/python:3.12
```
这样后续就可以直接用官方标准名 `python:3.12`。

##### 2.3 使用免登录方式拉取（推荐）
```bash
docker pull xxx.xuanyuan.run/library/python:3.12
```
带重命名的完整命令：
```bash
docker pull xxx.xuanyuan.run/library/python:3.12 \
&& docker tag xxx.xuanyuan.run/library/python:3.12 python:3.12 \
&& docker rmi xxx.xuanyuan.run/library/python:3.12
```

##### 2.4 官方直连方式
如果网络能直连 Docker Hub，可以直接：
```bash
docker pull python:3.12
```

##### 2.5 查看是否拉取成功
```bash
docker images
```
输出类似：
```
REPOSITORY   TAG     IMAGE ID       CREATED       SIZE
python       3.12    9a2c9eabc123   2 weeks ago   1.02GB
```

#### 3、部署 Python 容器
下面演示三种方式：快速部署 → 挂载项目 → docker-compose 管理。

##### 3.1 快速部署（最简方式）
适合测试、运行交互式 Python 环境：
```bash
docker run -it --name py-test python:3.12
```
说明：
- `-it`：进入交互式终端
- `--name py-test`：容器名称
- `python:3.12`：使用 Python 3.12 镜像

进入后会看到 Python REPL：
```python
Python 3.12.5 (main, Sep 14 2024, 10:15:00)
>>> print("Hello from Xuanyuan Python!")
Hello from Xuanyuan Python!
```
退出：输入 `exit()` 或 `Ctrl+D`。

##### 3.2 挂载本地项目（推荐方式）
适合实际项目开发，将宿主机代码挂载到容器内。

第一步：准备目录
```bash
mkdir -p /data/python-app
cd /data/python-app
```

第二步：写一个测试程序
```bash
echo 'print("Hello from Xuanyuan Python App!")' > app.py
```

第三步：启动容器并挂载目录
```bash
docker run -it --name py-app \
  -v /data/python-app:/app \
  -w /app \
  python:3.12 python app.py
```
说明：
- `-v /data/python-app:/app`：挂载宿主机目录到容器
- `-w /app`：指定容器内工作目录
- `python app.py`：执行程序

输出应为：
```
Hello from Xuanyuan Python App!
```

##### 3.3 使用 docker-compose 部署（适合企业级项目）
第一步：创建项目目录
```bash
mkdir -p /data/py-compose
cd /data/py-compose
```

第二步：准备应用
写一个 `main.py`：
```python
print("Python running in Docker with docker-compose!")
```

第三步：编写 `docker-compose.yml`
```yaml
version: '3'
services:
  python-app:
    image: python:3.12
    container_name: python-service
    working_dir: /app
    volumes:
      - ./app:/app
    command: python main.py
    restart: always
```
目录结构：
```
/data/py-compose
 ├─ docker-compose.yml
 └─ app
     └─ main.py
```

第四步：启动服务
```bash
docker compose up -d
```

查看状态
```bash
docker compose ps
```

查看日志
```bash
docker compose logs -f
```

输出：
```
python-service  | Python running in Docker with docker-compose!
```

#### 4、进阶实践
##### 4.1 安装第三方库
运行交互式容器，使用 pip 安装：
```bash
docker run -it --name py-pandas python:3.12 bash
pip install pandas
```

或者在项目目录添加 `requirements.txt`：
```
flask
requests
```
然后容器启动时自动安装：
```bash
docker run -it -v /data/python-app:/app -w /app python:3.12 pip install -r requirements.txt
```

##### 4.2 构建自定义 Python 镜像
在项目中写一个 `Dockerfile`：
```dockerfile
FROM python:3.12

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

CMD ["python", "app.py"]
```

构建镜像：
```bash
docker build -t my-python-app .
```

运行：
```bash
docker run -it --name py-custom my-python-app
```

#### 5、常见问题
##### 5.1 进入容器后 Python 环境丢失？
默认进入是 `/bin/bash`，需要手动执行 `python`。也可以直接：
```bash
docker exec -it py-app python
```

##### 5.2 如何持久化依赖环境？
- 使用 `requirements.txt + pip install`
- 或者构建自定义镜像（见上文 4.2）

##### 5.3 容器内时区不对？
加 `-e TZ=Asia/Shanghai`：
```bash
docker run -it -e TZ=Asia/Shanghai python:3.12
```

##### 5.4 如何运行 Flask / Django Web 项目？
以 Flask 为例，在 `app.py`：
```python
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello Flask from Docker!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

运行容器：
```bash
docker run -d --name py-flask -p 5000:5000 \
  -v /data/python-app:/app -w /app \
  python:3.12 pip install flask && python app.py
```

访问 `http://服务器IP:5000` 即可。

#### 结尾
至此，你已经掌握了 Python 在 Docker 中的部署全流程：
- 拉取镜像（轩辕镜像 / 官方）
- 快速运行 Python 环境
- 挂载项目目录运行代码
- 使用 docker-compose 管理服务
- 构建自定义镜像和运行 Web 应用

对于初学者，可以先尝试「快速部署」和「挂载目录」；对于工程师，推荐使用「docker-compose」或「自定义镜像」来管理依赖和部署。

👉 在实践中遇到问题，可以通过 `docker logs 容器名` 查看日志，或参考 Python 官方文档。


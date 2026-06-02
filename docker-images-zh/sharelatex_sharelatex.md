---
image: sharelatex/sharelatex
description: "官方的ShareLaTeX社区版Docker镜像是一款基于Docker容器化技术构建的开源在线LaTeX协作编辑工具，支持多人实时协作编写、编译和预览LaTeX文档，适用于学术论文、技术报告、书籍等各类文档的高效排版，为用户提供便捷的本地化部署方案，无需复杂配置即可快速搭建功能完备的LaTeX编辑环境，满足科研人员、学生及技术文档撰写者的协作编辑需求。"
source: https://xuanyuan.cloud/zh/r/sharelatex/sharelatex
canonical: https://xuanyuan.cloud/zh/r/sharelatex/sharelatex
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sharelatex/sharelatex" title="sharelatex/sharelatex Docker 镜像中文简介、标签列表与拉取命令">sharelatex/sharelatex — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/sharelatex/sharelatex" title="sharelatex/sharelatex Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/sharelatex/sharelatex</a>

## ShareLaTeX社区版官方Docker镜像介绍


### 一、简介  
这是ShareLaTeX社区版的官方Docker镜像，由ShareLaTeX开发团队维护。基于容器化技术，它把LaTeX编辑环境、协作工具、依赖组件打包成标准化容器，方便用户在本地电脑或服务器上快速部署，省去手动配置系统环境的麻烦。


### 二、能用来做什么？  
#### 1. 个人本地编辑  
如果你需要写LaTeX文档（比如论文、简历），但不想在电脑上装复杂的LaTeX发行版（如TeX Live），用这个镜像启动容器后，直接通过浏览器访问就能编辑，像在线工具一样方便，还不用担心网络问题。  

#### 2. 团队协作写文档  
课题组、实验室多人合写论文时，用它部署到团队服务器，所有人通过浏览器访问同一个地址，能实时看到彼此的修改、添加批注，不用来回传文件，效率更高。  

#### 3. 临时测试环境  
如果需要测试某个LaTeX模板（比如期刊要求的格式）是否兼容，直接启动容器，用完关掉，不会在电脑上留下冗余文件。  


### 三、怎么部署使用？  
#### 准备工作  
- 先在电脑/服务器上装好Docker（推荐版本20.10以上，太低可能有兼容性问题）。  
- 确保设备至少有2GB内存、5GB空闲硬盘空间（跑LaTeX编译会占一定资源）。  


#### 具体步骤  
##### 1. 拉取镜像  
打开命令行（Windows用PowerShell，Linux/macOS用终端），输入以下命令，从Docker Hub下载官方镜像：  
```bash
docker pull sharelatex/sharelatex:latest
```  
（`latest`是最新稳定版标签，需要特定版本可以换成具体版本号，比如`4.0.1`）  

##### 2. 启动容器  
镜像拉好后，用下面的命令启动容器。注意替换`/本地路径/数据存储`为你电脑上的实际文件夹（比如Windows可以是`D:\sharelatex_data`，Linux/macOS可以是`/home/user/sharelatex_data`）：  
```bash
docker run -d \
  --name my-sharelatex \  # 给容器起个名字，方便后续管理
  -p 80:80 \  # 把容器的80端口映射到电脑的80端口（浏览器访问用）
  -v /本地路径/数据存储:/var/lib/sharelatex \  # 挂载数据卷，保存文档、用户配置等（重要！不然容器删了数据就没了）
  --restart always \  # 电脑重启后容器自动启动，不用手动再开
  sharelatex/sharelatex:latest
```  

如果你的80端口被其他程序占用（比如已装了Nginx），可以换个端口，比如`-p 8080:80`，后面访问时用`8080`端口。  

##### 3. 访问使用  
容器启动后，等1~2分钟（首次启动会初始化数据库，慢一点），打开浏览器，输入：  
- 本地部署：`[]  
- 服务器部署：`[]  

首次访问会让你创建管理员账户，填完后就能登录，开始用了。  


### 四、注意事项  
#### 1. 数据一定要存本地  
前面命令里的`-v /本地路径/数据存储:/var/lib/sharelatex`这行很重要！容器本身是临时的，删掉容器后，里面的数据会丢失。挂载到本地文件夹后，文档、用户信息才会一直保存。  

#### 2. 端口别冲突  
如果启动时提示“端口已被占用”，检查电脑上是不是有其他程序用了80端口（比如IIS、Apache），把`-p 80:80`换成`-p 其他端口:80`（比如`-p 9000:80`），访问时用新端口。  

#### 3. 定期备份数据  
虽然数据存在本地文件夹了，但以防电脑硬盘坏了，建议定期把`/本地路径/数据存储`这个文件夹复制到U盘或云盘备份。  

#### 4. 更新镜像  
想升级到新版本时，先停掉旧容器，再拉新镜像，最后用同样的命令启动（数据卷路径不变，数据会保留）：  
```bash
docker stop my-sharelatex  # 停掉旧容器
docker rm my-sharelatex    # 删除旧容器（数据在本地，删容器不影响）
docker pull sharelatex/sharelatex:latest  # 拉新镜像
# 重新启动容器（用之前的命令，记得改回你的本地路径）
docker run -d --name my-sharelatex -p 80:80 -v /本地路径/数据存储:/var/lib/sharelatex --restart always sharelatex/sharelatex:latest
```  


### 五、其他说明  
- 管理员账户可以在后台添加普通用户、设置权限（比如限制谁能编辑文档）。  
- 如果需要HTTPS加密访问（比如公网服务器），可以在容器前面加个Nginx反向代理，配SSL证书（具体方法可以搜“Nginx反向代理Docker容器 HTTPS”）。  
- 更多高级配置（比如改默认编辑器主题、装额外LaTeX包），可以看[官方GitHub文档]([])（有英文说明）。  

按上面的步骤操作，基本能满足日常使用需求了。

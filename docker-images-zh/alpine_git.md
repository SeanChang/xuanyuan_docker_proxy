---
image: alpine/git
description: "这是一个运行于Alpine Linux系统中的简易Git容器，Alpine Linux以其极致精简的特性为基础，使得该容器在保持Git核心功能的同时，具备轻量高效的运行表现，尤其适用于各类小型Linux发行版环境，能够满足资源受限场景下的版本控制需求，为嵌入式系统、边缘设备或轻量级开发环境提供便捷的Git服务支持。"
source: https://xuanyuan.cloud/zh/r/alpine/git
canonical: https://xuanyuan.cloud/zh/r/alpine/git
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alpine/git" title="alpine/git Docker 镜像中文简介、标签列表与拉取命令">alpine/git — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/alpine/git" title="alpine/git Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/alpine/git</a>

### docker-git-alpine：基于Alpine Linux的轻量Git容器  


#### 简介  
这是一个运行在Alpine Linux上的轻量Git容器，尤其适合RancherOS等没有包管理器的小型Linux发行版。  
[![DockerHub Badge]([])]([])  


#### 重要更新说明  
- **GitHub Action流水线切换**：自2024年10月3日起，自动化构建和部署流水线已从Circle CI迁移至GitHub Action（相关PR：#68、#70）。  
- **多架构镜像支持**：2021年5月23日新增此功能，具体说明：  
  1. v2.30.2和1.0.30版本已手动推送多架构镜像；  
  2. 旧版本不再更新为多架构镜像；  
  3. 此后新版本均支持多架构（`--platform linux/amd64,linux/arm/v7,linux/arm64/v8,linux/arm/v6,linux/ppc64le,linux/s390x,linux/386`）；  
  4. 仅保证`amd64`架构可用（其他架构无测试环境，如有问题需提交PR修复）；  
  5. 拉取/运行命令与其他架构无差异，例如在ARM设备（如Mac M1芯片）上直接执行`docker pull alpine/git:v2.30.2`即可获取对应镜像。  


#### 相关链接  
- **GitHub仓库**：[]  
- **CI构建日志**：[]  
- **Docker镜像标签**：[]  


### 使用方法  

#### 基础用法  
```bash
docker run -ti --rm -v ${HOME}:/root -v $(pwd):/git alpine/git <git_command>
```  
例如，克隆本仓库：  
```bash
docker run -ti --rm -v ${HOME}:/root -v $(pwd):/git alpine/git clone []  


#### 可选用法1：简化命令（推荐）  
为减少重复输入，可将以下函数添加到`~/.bashrc`或`~/.profile`中：  
```bash
# 编辑~/.profile，添加以下内容
function git () {
    (docker run -ti --rm -v ${HOME}:/root -v $(pwd):/git alpine/git "$@")
}
```  
保存后执行`source ~/.profile`生效。之后即可像使用本地Git一样直接运行命令，例如：  
```bash
git clone []  


#### 可选用法2：通过别名快速调用  
```bash
alias git="docker run -ti --rm -v $(pwd):/git -v $HOME/.ssh:/root/.ssh alpine/git"
```  
**注意**：  
- 切换仓库时需重新定义别名；  
- 仅在Git仓库根目录下使用。  


#### 可选用法3：以当前用户身份运行（避免权限问题）  
```bash
alias git='docker run -ti --rm -u$(id -u):$(id -g) -e HOME=${HOME} -v /etc/passwd:/etc/passwd -v /etc/group:/etc/group -v ${HOME}:${HOME} -v $(pwd):/git alpine/git'
```  
**优势**：  
- 通过映射`/etc/passwd`和`/etc/group`文件，以当前用户（非root）身份运行，确保文件权限正确；  
- 可在任意目录使用（`$(pwd)`会在执行时动态获取当前路径）。  


### 操作演示  
```bash
# 进入目标目录
cd application

# 设置别名（可选用法2示例）
alias git="docker run -ti --rm -v $(pwd):/git -v $HOME/.ssh:/root/.ssh alpine/git"

# 克隆私有仓库（需本地SSH密钥）
git clone [邮箱已删除]:YOUR_ACCOUNT/YOUR_REPO.git

# 进入仓库目录，重新定义别名（切换仓库时需执行）
cd YOUR_REPO
alias git="docker run -ti --rm -v $(pwd):/git -v $HOME/.ssh:/root/.ssh alpine/git"

# 编辑文件后提交
git add . 
git status
git commit -m "test"
git push -u origin master
```  


### 支持的协议  
支持git、http/https、ssh协议，详情可参考Git官方文档：[Git on the Server - The Protocols]([])  


### 自动化构建说明  
- 每周自动构建，生成支持多架构的最新Alpine镜像；  
- 从镜像中提取Git版本号，以`v${GIT_VERSION}`格式打标签；  
- 同步更新`latest`标签。

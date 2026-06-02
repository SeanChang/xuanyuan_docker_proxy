---
image: alpine/ansible
description: "在Docker中运行ansible和ansible-playbook"
source: https://xuanyuan.cloud/zh/r/alpine/ansible
canonical: https://xuanyuan.cloud/zh/r/alpine/ansible
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alpine/ansible" title="alpine/ansible Docker 镜像中文简介、标签列表与拉取命令">alpine/ansible — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/alpine/ansible" title="alpine/ansible Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/alpine/ansible</a>

# Ansible 镜像

## 特性
- 支持多架构
- 基于Alpine系统，镜像体积小
- 镜像标签与Ansible核心版本对应

## Dockerfile 来源
[https://github.com/alpine-docker/multi-arch-libs/blob/master/ansible/Dockerfile](https://github.com/alpine-docker/multi-arch-libs/blob/master/ansible/Dockerfile)

## 每日CI构建日志
无

## Docker镜像标签
[https://hub.docker.com/repository/docker/alpine/ansible/tags](https://hub.docker.com/repository/docker/alpine/ansible/tags)

## 使用方法

### 配置别名运行ansible
```
alias ansible="docker run -ti --rm -v ~/.ssh:/root/.ssh -v ~/.aws:/root/.aws -v $(pwd):/apps -w /apps alpine/ansible ansible"
ansible <后续命令>
```

### 配置别名运行ansible-playbook
```
alias ansible-playbook="docker run -ti --rm -v ~/.ssh:/root/.ssh -v ~/.aws:/root/.aws -v $(pwd):/apps -w /apps alpine/ansible ansible-playbook"
ansible-playbook -i inventory <后续命令>
```

## 构建与测试

### 环境变量设置
确保已配置以下环境变量：
```
export CIRCLE_BRANCH=master
export DOCKER_USERNAME=xxxx
export DOCKER_PASSWORD=xxxx
```

### 本地构建镜像
```
git clone https://github.com/alpine-docker/multi-arch-libs.git
cd multi-arch-libs
./build.sh ansible
```

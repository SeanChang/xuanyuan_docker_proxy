---
image: unsloth/unsloth
description: "Unsloth Docker镜像是一个预构建容器，包含LLM微调与强化学习开源框架Unsloth的所有依赖，无需额外设置即可快速使用。支持Jupyter Lab和SSH双访问模式，适用于Windows、Linux、WSL及多数NVIDIA GPU，可立即开始LLM微调工作。"
source: https://xuanyuan.cloud/zh/r/unsloth/unsloth
canonical: https://xuanyuan.cloud/zh/r/unsloth/unsloth
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/unsloth/unsloth" title="unsloth/unsloth Docker 镜像中文简介、标签列表与拉取命令">unsloth/unsloth 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Unsloth Docker镜像

[Unsloth](https://github.com/unslothai/unsloth)是一个用于LLM（大语言模型）微调与强化学习（RL）的开源框架。

本镜像为预构建Docker容器，包含所有依赖组件，无需额外设置即可立即使用Unsloth。**[参考使用指南](https://docs.unsloth.ai/get-started/install-and-update/docker)**。

## 🚀 快速开始

该容器需要安装[NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)。

```bash
docker run -d -e JUPYTER_PASSWORD="mypassword" \
  -p 8888:8888 -p 2222:22 \
  -v $(pwd)/work:/workspace/work \
  --gpus all \
  unsloth/unsloth
```

通过`http://localhost:8888`访问Jupyter Lab，即可开始微调工作！

## 📋 特性

- **预安装Unsloth环境** - 无需在笔记本中安装依赖包，直接`import unsloth`即可运行
- **即用型[笔记本](https://docs.unsloth.ai/get-started/unsloth-notebooks)** - `unsloth-notebooks/`目录包含微调示例笔记本
- **双访问模式** - 同时支持Jupyter Lab和SSH访问
- **非root用户配置** - 使用`unsloth`用户运行，增强安全性
- **环境兼容性** - 支持Windows、Linux、WSL及多数NVIDIA GPU，包括[Blackwell架构](https://docs.unsloth.ai/basics/fine-tuning-llms-with-blackwell-rtx-50-series-and-unsloth)

## 🔧 配置选项

### 环境变量

| 变量名 | 描述 | 默认值 | 可选值 |
|--------|------|--------|--------|
| `JUPYTER_PORT` | 容器内Jupyter Lab端口 | `8888` | 任意有效端口 |
| `JUPYTER_PASSWORD` | Jupyter Lab密码 | `unsloth` | 任意字符串 |
| `SSH_KEY` | SSH认证公钥 | 无 | SSH公钥字符串 |
| `USER_PASSWORD` | `unsloth`用户密码（用于sudo操作） | `unsloth` | 任意字符串 |

### 端口映射

将容器端口映射到主机系统：
```bash
-p <主机端口>:<容器端口>
```

**必要映射：**
- Jupyter Lab: `-p 8000:8888`（或自定义端口）
- SSH访问: `-p 2222:22`（或自定义端口）

### 卷挂载

**⚠️ 注意：** 容器不会在运行之间持久化数据。使用卷挂载保存工作内容。

```bash
-v <本地主机目录>:<容器目录>
```

**推荐挂载：**
- `-v $(pwd)/work:/workspace/work` - 挂载当前目录下的`work`文件夹
- `-v ~/notebooks:/workspace/notebooks` - 挂载本地笔记本目录

## 📖 使用示例

### 完整示例
```bash
docker run -d -e JUPYTER_PORT=8000 \
  -e JUPYTER_PASSWORD="mypassword" \
  -e "SSH_KEY=$(cat ~/.ssh/container_key.pub)" \
  -e USER_PASSWORD="unsloth2024" \
  -p 8000:8000 -p 2222:22 \
  -v $(pwd)/work:/workspace/work \
  --gpus all \
  unsloth/unsloth
```

### 设置SSH密钥
若没有SSH密钥对：
```bash
# 生成新密钥对
ssh-keygen -t rsa -b 4096 -f ~/.ssh/container_key

# 在docker run中使用公钥
-e "SSH_KEY=$(cat ~/.ssh/container_key.pub)"

# 通过SSH连接
ssh -i ~/.ssh/container_key -p 2222 unsloth@localhost
```

## 🗂️ 容器结构

- `/workspace/work/` - 挂载的工作目录
- `/workspace/unsloth-notebooks/` - 包含Unsloth微调示例笔记本的目录
- `/home/unsloth/` - `unsloth`用户的主目录

## 🔒 安全注意事项

- 默认以非root用户`unsloth`运行，提升安全性
- 使用`USER_PASSWORD`进行容器内sudo操作
- SSH访问需通过公钥认证
- **已支持Blackwell GPU架构**

## 🤝 获取帮助

- 查阅[Unsloth文档](https://docs.unsloth.ai/)
- 在Reddit社区提问：[r/unsloth](https://reddit.com/unsloth)
- 查看`unsloth-notebooks/`目录中的示例笔记本

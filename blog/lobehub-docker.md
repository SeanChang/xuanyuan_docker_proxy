# LobeHub Docker 容器化部署指南

![LobeHub Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-lobehub.png)

*分类: Docker,lobehub | 标签: lobehub,docker,部署教程 | 发布时间: 2025-11-23 12:54:34*

> LobeHub 旗下的 LobeChat 是一款功能丰富的智能 AI 对话平台，具备强大的大语言模型交互能力与多样化的扩展功能。该平台在2023年推出了多模型服务商支持、本地大语言模型运行、模型视觉识别、语音会话（TTS & STT）、文生图（Text to Image）、插件系统等核心特性，还适配了移动设备并支持渐进式网页应用（PWA）；2024年进一步升级，新增思维链（CoT）、分支对话、白板（Artifacts）、文件上传与知识库管理、本地/云端数据存储，以及身份验证系统和多用户管理等功能，能够满足个人与团队在AI交互、协作等场景下的多样化需求。为了方便用户在私有设备上部署使用，LobeHub 提供了 Docker 镜像，本文将详细介绍其 Docker 容器化部署的具体步骤。

LobeHub 旗下的 LobeChat 是一款功能丰富的智能 AI 对话平台，具备强大的大语言模型交互能力与多样化的扩展功能。该平台在2023年推出了多模型服务商支持、本地大语言模型运行、模型视觉识别、语音会话（TTS & STT）、文生图（Text to Image）、插件系统等核心特性，还适配了移动设备并支持渐进式网页应用（PWA）；2024年进一步升级，新增思维链（CoT）、分支对话、白板（Artifacts）、文件上传与知识库管理、本地/云端数据存储，以及身份验证系统和多用户管理等功能，能够满足个人与团队在AI交互、协作等场景下的多样化需求。为了方便用户在私有设备上部署使用，LobeHub 提供了 Docker 镜像，本文将详细介绍其 Docker 容器化部署的具体步骤。

## 环境准备：安装Docker容器环境
若你的设备尚未安装 Docker，需先完成环境部署，以 Ubuntu/CentOS 系统为例，执行以下命令安装：
```bash
$ apt install docker.io
```
若已安装 Docker，可直接跳过此步骤。

## Docker Compose 部署方式
Docker Compose 支持通过配置文件统一管理容器服务，适合需要固定配置的部署场景，具体步骤如下：

### 1. 编写 docker-compose.yml 配置文件
创建并编辑 `docker-compose.yml` 文件，写入以下配置内容：
```yaml
version: "3.8"
services:
  lobe-chat:
    image: xxx.xuanyuan.run/lobehub/lobe-chat
    container_name: lobe-chat
    restart: always
    ports:
      - 3210:3210
    environment:
      OPENAI_API_KEY: sk-xxxx
      OPENAI_PROXY_URL: https://api-proxy.com/v1
      ACCESS_CODE: lobe66
      NPM_CONFIG_REGISTRY: https://registry.npmmirror.com
      PIP_INDEX_URL: https://mirrors.aliyun.com/pypi/simple/
      PIP_TRUSTED_HOST: mirrors.aliyun.com
      GOPROXY: https://goproxy.cn,direct
      YARN_REGISTRY: https://registry.npmmirror.com
      HF_ENDPOINT: https://hf-mirror.com

```
**配置说明**：
- `ports`：将容器的3210端口映射到主机的3210端口，若主机3210端口被占用，可修改为其他端口（如`3211:3210`）；
- `OPENAI_API_KEY`：使用 LobeChat 必须配置的参数，需替换为实际的 OpenAI API Key；
- `ACCESS_CODE`：建议设置，可防止未授权访问导致 API Key 泄露。

### 2. 启动 LobeChat 服务
在 `docker-compose.yml` 文件所在目录下，执行以下命令启动服务：
```bash
$ docker-compose up -d
```
该命令会以守护进程模式启动 LobeChat 容器。

## Docker 指令一键部署
若无需复杂的配置管理，可直接通过 Docker 命令一键部署，支持基础部署和带代理的部署两种方式。

### 1. 基础部署
执行以下命令启动 LobeChat 容器：
```fish
$ docker run -itd \
  -e OPENAI_API_KEY=sk-xxxx \
  -e ACCESS_CODE=lobe66 \
  --name lobe-chat xxx.xuanyuan.run/lobehub/lobe-chat
```

### 2. 带代理的部署
若需要通过代理访问 OpenAI 服务，可添加 `OPENAI_PROXY_URL` 环境变量配置代理地址：
```fish
$ docker run -itd \
  -p 3210:3210 \
  -e OPENAI_API_KEY=sk-xxxx \
  -e OPENAI_PROXY_URL=https://api-proxy.com/v1 \
  -e ACCESS_CODE=lobe66 \
  --name lobe-chat xxx.xuanyuan.run/lobehub/lobe-chat
```

## 可选配置：Crontab 自动更新脚本
为了及时获取 LobeChat 的最新版本，可配置自动更新脚本，通过 Crontab 实现定时更新，具体步骤如下：

### 1. 创建环境变量配置文件（可选）
若部署时需要配置多个环境变量，可新建 `lobe.env` 文件，写入变量信息：
```plaintext
OPENAI_API_KEY=sk-xxxx
OPENAI_PROXY_URL=https://api-proxy.com/v1
ACCESS_CODE=arthals2333
OPENAI_MODEL_LIST=-gpt-4,-gpt-4-32k,-gpt-3.5-turbo-16k,gpt-3.5-turbo-1106=gpt-3.5-turbo-16k,gpt-4-0125-preview=gpt-4-turbo,gpt-4-vision-preview=gpt-4-vision
```

### 2. 编写自动更新脚本
创建 `auto-update-lobe-chat.sh` 脚本文件，写入以下内容：
```bash
#!/bin/bash
# auto-update-lobe-chat.sh

# 设置代理（可选）
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890

# 拉取最新的镜像并将输出存储在变量中
output=$(docker pull lobehub/lobe-chat:latest 2>&1)

# 检查拉取命令是否成功执行
if [ $? -ne 0 ]; then
  exit 1
fi

# 检查输出中是否包含特定的字符串
echo "$output" | grep -q "Image is up to date for lobehub/lobe-chat:latest"

# 如果镜像已经是最新的，则不执行任何操作
if [ $? -eq 0 ]; then
  exit 0
fi

echo "Detected Lobe-Chat update"

# 删除旧的容器
echo "Removed: $(docker rm -f Lobe-Chat)"

# 运行新的容器（若使用env文件，需替换/path/to/lobe.env为实际路径）
echo "Started: $(docker run -d --network=host --env-file /path/to/lobe.env --name=Lobe-Chat --restart=always lobehub/lobe-chat)"

# 打印更新的时间和版本
echo "Update time: $(date)"
echo "Version: $(docker inspect lobehub/lobe-chat:latest | grep 'org.opencontainers.image.version' | awk -F'"' '{print $4}')"

# 清理不再使用的镜像
docker images | grep 'lobehub/lobe-chat' | grep -v 'lobehub/lobe-chat-database' | grep -v 'latest' | awk '{print $3}' | xargs -r docker rmi > /dev/null 2>&1
echo "Removed old images."
```
给脚本添加可执行权限：
```bash
chmod +x auto-update-lobe-chat.sh
```

### 3. 配置 Crontab 定时任务
执行 `crontab -e` 编辑定时任务，添加以下内容，实现每5分钟执行一次更新脚本：
```bash
*/5 * * * * /path/to/auto-update-lobe-chat.sh >> /path/to/auto-update-lobe-chat.log 2>&1
```
注意将 `/path/to/` 替换为脚本和日志文件的实际路径。

## 获取 OpenAI API Key
API Key 是使用 LobeChat 进行大语言模型会话的必要信息，可通过以下两种方式获取：

### OpenAI 官方渠道
- 注册 OpenAI 账户（需使用国际手机号、非大陆邮箱）；
- 登录后前往 API Keys 页面，点击 `Create new secret key` 创建并获取 API Key；
- 新账户通常有5美元的免费额度，有效期为三个月，长期使用需绑定外币信用卡。


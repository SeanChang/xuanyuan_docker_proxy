---
image: petamage/openclaw
description: "提供即用型OpenClaw环境的Docker镜像，无需繁琐的单独配置，由Petapod社区维护，可快速部署和使用。"
source: https://xuanyuan.cloud/zh/r/petamage/openclaw
canonical: https://xuanyuan.cloud/zh/r/petamage/openclaw
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/petamage/openclaw" title="petamage/openclaw Docker 镜像中文简介、标签列表与拉取命令">petamage/openclaw — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/petamage/openclaw" title="petamage/openclaw Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/petamage/openclaw</a>

# OpenClaw

> 由[Petapod](https://petapod.com/)社区维护

**OpenClaw环境的Docker镜像**

## 🚀 安装

从Docker Hub拉取镜像：

```bash
docker pull petamage/openclaw
```

---

## 🔐 环境变量

该容器需要以下环境变量：

| 变量名                  | 描述                                  |
|-------------------------|---------------------------------------|
| `SETUP_PASSWORD`         | OpenClaw初始设置密码                  |
| `OPENCLAW_GATEWAY_TOKEN` | 网关令牌（64字符随机字符串）          |
| `INTERNAL_GATEWAY_PORT`  | 内部网关端口（默认：`7777`）          |

### 示例值

```env
SETUP_PASSWORD=your_setup_password
OPENCLAW_GATEWAY_TOKEN=64_CHARACTER_RANDOM
INTERNAL_GATEWAY_PORT=7777
```

> ⚠️ **安全注意事项**
> 不要将真实密码或令牌提交到公共仓库。

---

## ▶️ 使用方法

### 交互式运行容器

```bash
docker run -it \
  -e SETUP_PASSWORD=your_setup_password \
  -e OPENCLAW_GATEWAY_TOKEN=64_CHARACTER_RANDOM \
  -e INTERNAL_GATEWAY_PORT=7777 \
  petamage/openclaw
```

### 后台运行容器（分离模式）

```bash
docker run -d \
  -e SETUP_PASSWORD=your_setup_password \
  -e OPENCLAW_GATEWAY_TOKEN=64_CHARACTER_RANDOM \
  -e INTERNAL_GATEWAY_PORT=7777 \
  petamage/openclaw
```

---

## 📁 使用.env文件（推荐）

创建.env文件：

```env
SETUP_PASSWORD=your_setup_password
OPENCLAW_GATEWAY_TOKEN=64_CHARACTER_RANDOM
INTERNAL_GATEWAY_PORT=7777
```

运行容器：

```bash
docker run -d --env-file .env petamage/openclaw
```

---

## 🧩 关于

`petamage/openclaw`提供即用型**OpenClaw**环境，无需单独配置各个参数。

---

## 🏷 标签

* `latest` — 稳定构建版本

---

## 🛠 系统要求

* Docker Engine 20+
* 支持系统：Linux / macOS / Windows（需安装Docker Desktop）

---

## 📄 许可证

请参考OpenClaw项目许可证或您自己的项目许可。

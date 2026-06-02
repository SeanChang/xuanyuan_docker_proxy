<!-- xuanyuan-docker-images-zh
image: phitux/dailytxt
source: https://xuanyuan.cloud/zh/r/phitux/dailytxt
canonical: https://xuanyuan.cloud/zh/r/phitux/dailytxt
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/phitux/dailytxt" title="phitux/dailytxt Docker 镜像中文简介、标签列表与拉取命令">phitux/dailytxt — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/phitux/dailytxt" title="phitux/dailytxt Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/phitux/dailytxt</a></p>

# DailyTxT Docker镜像文档

## 概述
DailyTxT Docker镜像是一个基于Svelte前端和Go后端的加密日记Web应用，旨在提供安全、私密的日记记录解决方案。该镜像包含完整的Web服务，支持用户注册管理、加密数据存储、管理员配置及自定义访问控制，适用于需要安全存储个人或团队私密文本数据的场景。

## 核心功能和特性
- **加密数据存储**：日记数据以加密格式持久化存储，保障数据隐私安全
- **用户管理**：支持用户注册（可控制开关）、登录认证和会话管理
- **管理员面板**：提供管理员界面，支持配置调整（如注册权限、用户管理）
- **灵活配置**：支持自定义会话过期时间、数据缩进格式、子路径部署等
- **安全控制**：可限制用户注册、设置管理员密码、控制访问范围
- **持久化存储**：通过卷挂载实现数据持久化，防止容器重启导致数据丢失

## 使用场景和适用范围
- 个人用户记录私密日记或敏感笔记
- 需要安全存储文本数据的个人或小型团队
- 对数据隐私有较高要求的私密内容管理场景
- 需快速部署且配置简单的Web应用需求

## 详细使用方法和配置说明

### 前提条件
- 已安装Docker和Docker Compose
- 具备基本的容器管理和网络配置知识

### 部署步骤

#### 1. 创建docker-compose配置文件
使用以下模板创建`docker-compose.yml`文件，根据实际需求修改参数：

```yaml
services:
  dailytxt:
    # 选择正确的镜像标签（建议使用最新稳定版2.x.x）
    image: phitux/dailytxt:2.x.x
    container_name: dailytxt
    restart: unless-stopped
    volumes:
      # 左侧为宿主机目录（需修改为实际路径），用于持久化存储数据
      - ./data:/data
    environment:
      # 生成安全密钥：运行`openssl rand -base64 32`获取
      - SECRET_TOKEN=...

      # JSON文件格式化缩进值（不需要可删除此行）
      - INDENT=4

      # 允许新用户注册（首次创建用户后建议设为false）
      - ALLOW_REGISTRATION=true

      # 管理员密码（用于访问管理员面板）
      - ADMIN_PASSWORD=your_admin_password

      # 登录Cookie过期天数
      - LOGOUT_AFTER_DAYS=40

      # 子路径部署时设置（如/dailytxt，不需要可删除此行）
      # - BASE_PATH=/dailytxt
    ports:
      # 左侧为宿主机端口，右侧固定为容器内80端口
      - 127.0.0.1:8000:80
```

#### 2. 配置参数说明
调整上述配置文件中的关键参数：

- **数据存储**：`volumes`中的`./data`需替换为宿主机实际目录（如`/opt/dailytxt/data`），确保数据持久化
- **安全密钥**：`SECRET_TOKEN`必须通过`openssl rand -base64 32`生成高强度密钥，不可省略
- **注册控制**：`ALLOW_REGISTRATION`建议仅首次部署时设为`true`，创建初始用户后改为`false`，后续通过管理员面板临时启用
- **管理员密码**：`ADMIN_PASSWORD`需设置强密码，用于访问管理员功能
- **端口映射**：`ports`左侧端口可修改（如`8080:80`），建议保留`127.0.0.1:`前缀限制本地访问，通过反向代理（如Nginx）提供公网HTTPS访问

#### 3. 启动服务
在配置文件所在目录执行以下命令启动容器：
```bash
docker-compose up -d
```

#### 4. 访问应用
服务启动后，通过`http://127.0.0.1:8000`（或配置的其他端口）访问应用：
- 首次使用：注册用户（需`ALLOW_REGISTRATION=true`）并登录
- 管理员功能：通过设置的`ADMIN_PASSWORD`登录管理员面板，调整系统配置

## 环境变量配置说明
| 环境变量名 | 描述 | 默认值 | 示例 |
|------------|------|--------|------|
| `SECRET_TOKEN` | 数据加密密钥，必须通过`openssl rand -base64 32`生成 | 无（必填） | `xYjK3pQrT7vB9nM2zA4sD6fG8hJ0kL1m` |
| `INDENT` | JSON数据文件缩进空格数（格式化输出） | 无（不格式化） | `4` |
| `ALLOW_REGISTRATION` | 是否允许新用户注册 | `false` | `true` |
| `ADMIN_PASSWORD` | 管理员面板访问密码 | 无（必填） | `SecureAdmin123!` |
| `LOGOUT_AFTER_DAYS` | 登录Cookie过期天数 | `40` | `30` |
| `BASE_PATH` | 子路径部署基础路径（如`/dailytxt`） | 无（根路径） | `/dailytxt` |

## 注意事项
- **安全建议**：避免将80端口直接暴露公网，建议通过Nginx配置HTTPS加密访问
- **数据备份**：定期备份`volumes`挂载的宿主机目录，防止数据丢失
- **注册管理**：创建初始用户后立即禁用`ALLOW_REGISTRATION`，通过管理员面板控制用户添加
- **版本更新**：升级镜像时需先备份数据，修改`image`标签为新版本后执行`docker-compose up -d`

## 总结
DailyTxT Docker镜像提供了一个轻量、安全的加密日记解决方案，通过简单配置即可快速部署，支持灵活的自定义和安全控制，适合个人及小型团队的私密文本记录需求。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/phitux/dailytxt" title="phitux/dailytxt Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/phitux/dailytxt</a></p>

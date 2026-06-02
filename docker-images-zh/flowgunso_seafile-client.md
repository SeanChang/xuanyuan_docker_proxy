<!-- xuanyuan-docker-images-zh
image: flowgunso/seafile-client
source: https://xuanyuan.cloud/zh/r/flowgunso/seafile-client
canonical: https://xuanyuan.cloud/zh/r/flowgunso/seafile-client
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/flowgunso/seafile-client" title="flowgunso/seafile-client Docker 镜像中文简介、标签列表与拉取命令">flowgunso/seafile-client — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/flowgunso/seafile-client" title="flowgunso/seafile-client Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/flowgunso/seafile-client</a></p>

# Seafile Client Docker 镜像文档

![Pipeline status](https://gitlab.com/flrnnc-oss/docker-seafile-client/badges/3.7.0/pipeline.svg)
![Docker image size](https://user-content.gitlab-static.net/c92776ecf4007e8ac10063419254991f8217f433/68747470733a2f2f696d672e736869656c64732e696f2f646f636b65722f696d6167652d73697a652f666c726e6e632f73656166696c652d636c69656e742f6c61746573743f6c6f676f3d646f636b6572266c6162656c3d496d61676525323073697a6526636f6c6f723d253233303737386238)
![Docker pulls](https://user-content.gitlab-static.net/1b649e78c3fa4ee4cfad1ade55f56a13a6106938/68747470733a2f2f696d672e736869656c64732e696f2f646f636b65722f70756c6c732f666c726e6e632f73656166696c652d636c69656e743f6c6f676f3d646f636b6572266c6162656c3d50756c6c7326636f6c6f723d253233303737386238)
![License](https://user-content.gitlab-static.net/330f9edd1053e955aaa7cd5c73219806c4c33f82/68747470733a2f2f696d672e736869656c64732e696f2f6769746c61622f6c6963656e73652f31313332323239313f6c6162656c3d4c6963656e736526636f6c6f723d666361333236266c6f676f3d676e75)
![Release](https://user-content.gitlab-static.net/24cc08936649c7de219fc320e20adf3c87ddd535/68747470733a2f2f696d672e736869656c64732e696f2f6769746c61622f762f72656c656173652f31313332323239313f6c6f676f3d6769746c6162266c6162656c3d536f75726365253230636f646526636f6c6f723d666361333236)


## 镜像概述与主要用途

本镜像用于将一个或多个 Seafile 库同步到本地，并将其作为卷（volume）共享给其他容器。支持双因素认证（2FA）、库密码保护、上传/下载速度限制，且每周更新以确保安全性。


## 核心功能与特性

- **多库同步**：支持同步一个或多个 Seafile 库
- **安全认证**：支持密码保护的库及双因素认证（2FA）
- **性能控制**：可配置上传和下载速度限制（字节为单位）
- **SSL 灵活性**：支持跳过 SSL 证书验证（适用于自签名证书场景）
- **权限管理**：通过 UID/GID 设置文件所有权，适配容器间权限共享
- **持续更新**：镜像每周构建，确保包含最新安全补丁


## 支持的标签

镜像标签与 Seafile 版本对应，支持以下标签：

- `9`, `9.0`, `9.0.15`, `latest`  
- `9.0.13`  
- `8`, `8.0`, `8.0.10`  


## 使用方法

### 快速启动 Seafile 客户端

#### Docker 命令行

以下命令启动 Seafile 客户端并同步单个库：

```bash
docker run \ 
    -e SEAF_SERVER_URL="https://seafile.example/" \  # Seafile 服务器地址
    -e SEAF_USERNAME="a_seafile_user" \               # 账号用户名
    -e SEAF_PASSWORD="SoMePaSSWoRD" \                 # 账号密码
    -e SEAF_LIBRARY="an-hexadecimal-library-uuid" \   # 库 UUID
    -v /本地路径/库数据:/library \                     # 挂载库数据卷（本地路径需替换）
    -v /本地路径/客户端数据:/seafile \                 # 挂载客户端配置数据卷（本地路径需替换）
    flrnnc/seafile-client:latest
```

#### Docker Compose

以下配置启动 Seafile 客户端并同步两个库（其中一个带密码保护）：

```yaml
version: "3"

services:
  seafile-client:
    image: flrnnc/seafile-client:latest
    volumes:
      - audio:/library/audio       # 音频库数据卷（同步到 /library/audio）
      - documents:/library/documents  # 文档库数据卷（同步到 /library/documents）
      - client:/seafile            # 客户端配置数据卷（持久化认证信息等）
    environment:
      SEAF_SERVER_URL: "https://seafile.example/"  # Seafile 服务器地址
      SEAF_USERNAME: "a_seafile_user"              # 账号用户名
      SEAF_PASSWORD: "SoMePaSSWoRD"                # 账号密码
      SEAF_LIBRARY_AUDIO: "audio-library-uuid"      # 音频库 UUID（标识符为 AUDIO）
      SEAF_LIBRARY_AUDIO_PASSWORD: "auDioLiBRaRyPaSSWoRD"  # 音频库密码
      SEAF_LIBRARY_DOCUMENTS: "documents-library-uuid"  # 文档库 UUID（标识符为 DOCUMENTS）

volumes:
  audio:    # 音频库数据卷（可被其他容器挂载）
  documents:  # 文档库数据卷（可被其他容器挂载）
  client:   # 客户端配置数据卷
```


### 库同步配置

#### 单库同步

通过以下环境变量配置单个库同步：
- `SEAF_LIBRARY`：库的 UUID（必填）
- `SEAF_LIBRARY_PASSWORD`：库的密码（可选，若库无密码则无需设置）

同步路径固定为 `/library`。


#### 多库同步

通过**标识符**区分多个库，格式为 `SEAF_LIBRARY_[标识符]` 和 `SEAF_LIBRARY_[标识符]_PASSWORD`：
- `[标识符]`：需为唯一单字（如 AUDIO、DOCUMENTS）
- `SEAF_LIBRARY_[标识符]`：对应库的 UUID（必填）
- `SEAF_LIBRARY_[标识符]_PASSWORD`：对应库的密码（可选）

同步路径为 `/library/[标识符]`（如 `AUDIO` 库同步到 `/library/audio`）。


## 配置说明

### 环境变量详解

| 环境变量                          | 描述                                                                 | 必填 | 示例值                                  |
|-----------------------------------|----------------------------------------------------------------------|------|-----------------------------------------|
| `SEAF_SERVER_URL`                 | Seafile 服务器 URL（含协议，如 https://）                            | 是   | `https://seafile.example.com`           |
| `SEAF_USERNAME`                   | Seafile 账号用户名                                                   | 是   | `user@example.com`                      |
| `SEAF_PASSWORD`                   | Seafile 账号密码（与 `SEAF_TOKEN` 二选一）                           | 否   | `SecurePass123!`                        |
| `SEAF_TOKEN`                      | Seafile API 令牌（优先级高于 `SEAF_PASSWORD`）                       | 否   | `abcdef1234567890`                      |
| `SEAF_LIBRARY`                    | 单库模式下的库 UUID                                                  | 单库是 | `a1b2c3d4-e5f6-7890-abcd-1234567890ab`  |
| `SEAF_LIBRARY_[标识符]`           | 多库模式下的库 UUID（`[标识符]` 为唯一单字）                         | 多库是 | `d4c3b2a1-f5e6-0987-dcba-0987654321fe`  |
| `SEAF_LIBRARY_PASSWORD`           | 单库模式下的库密码                                                  | 否   | `LibraryPass456!`                       |
| `SEAF_LIBRARY_[标识符]_PASSWORD`  | 多库模式下对应库的密码                                               | 否   | `AudioLibPass789!`                      |
| `SEAF_2FA_SECRET`                 | 双因素认证密钥（仅在启用 2FA 时需设置，从 Seafile 2FA 配置页获取）   | 否   | `JBSWY3DPEHPK3PXPIXDAUMXEDOXIUCDXWC32CS`|
| `SEAF_UPLOAD_LIMIT`               | 上传速度限制（字节/秒）                                             | 否   | `1000000`（即 1MB/s）                   |
| `SEAF_DOWNLOAD_LIMIT`             | 下载速度限制（字节/秒）                                             | 否   | `2000000`（即 2MB/s）                   |
| `SEAF_SKIP_SSL_CERT`              | 是否跳过 SSL 证书验证（任意非空值均为启用，默认不启用）              | 否   | `true`（启用跳过）                      |
| `UID`                             | 运行客户端进程的用户 UID（用于控制文件所有权）                       | 否   | `1000`（与宿主机用户 UID 一致）         |
| `GID`                             | 运行客户端进程的用户组 GID（用于控制文件所有权）                     | 否   | `1000`（与宿主机用户组 GID 一致）       |


### Docker Secrets 支持

所有环境变量均支持通过 Docker Secrets 传递敏感信息，格式为 `[变量名]_FILE`，值为包含敏感数据的文件路径。例如：

```yaml
environment:
  SEAF_PASSWORD_FILE: /run/secrets/seafile_password  # 从 secrets 读取密码
secrets:
  seafile_password:
    file: ./seafile_password.txt  # 本地密码文件路径
```


## 完整部署示例

以下示例展示多库同步、2FA 认证、上传/下载限制及文件权限配置：

```yaml
version: "3"

services:
  seafile-client:
    image: flrnnc/seafile-client:latest
    volumes:
      - media:/library/media       # 媒体库数据卷（供 Plex 等容器挂载）
      - docs:/library/docs         # 文档库数据卷（供 Nextcloud 等容器挂载）
      - seafile-config:/seafile    # 客户端配置数据卷
    environment:
      SEAF_SERVER_URL: "https://seafile.example.com"       # 服务器地址
      SEAF_USERNAME: "admin@example.com"                   # 账号用户名
      SEAF_TOKEN: "abcdef1234567890"                       # API 令牌（替代密码）
      SEAF_LIBRARY_MEDIA: "a1b2c3d4-e5f6-7890-abcd-1234567890ab"  # 媒体库 UUID
      SEAF_LIBRARY_MEDIA_PASSWORD: "MediaLib!2024"          # 媒体库密码
      SEAF_LIBRARY_DOCS: "d4c3b2a1-f5e6-0987-dcba-0987654321fe"   # 文档库 UUID
      SEAF_2FA_SECRET: "JBSWY3DPEHPK3PXPIXDAUMXEDOXIUCDXWC32CS"   # 2FA 密钥
      SEAF_UPLOAD_LIMIT: "500000"                           # 上传限制 500KB/s
      SEAF_DOWNLOAD_LIMIT: "2000000"                         # 下载限制 2MB/s
      SEAF_SKIP_SSL_CERT: "true"                            # 跳过 SSL 验证（自签名证书）
      UID: "1000"                                           # 匹配宿主机用户 UID
      GID: "1000"                                           # 匹配宿主机用户组 GID

volumes:
  media:
  docs:
  seafile-config:
```


## 故障排除

- **同步失败**：检查 `SEAF_SERVER_URL` 是否正确，网络是否通畅，或通过 `SEAF_SKIP_SSL_CERT` 排除证书问题。
- **2FA 认证失败**：确保 `SEAF_2FA_SECRET` 正确（需在 2FA 设置时获取，为 QR 码中的密钥）。
- **权限问题**：通过 `UID` 和 `GID` 调整文件所有权，确保其他容器可访问挂载的卷。

如需进一步帮助：
- 在 [Seafile 论坛](https://forum.seafile.com/t/docker-client-to-sync-files-with-containers/8573) 提问
- 在 [GitLab 仓库](https://gitlab.com/flrnnc-oss/docker-seafile-client/) 提交 issue


## 迁移说明

本仓库已迁移至新命名空间 **[flrnnc/seafile-client](https://hub.docker.com/repository/docker/flrnnc/seafile-client/)**。迁移原因：`flrnnc` 命名空间用于统一发布我开发的开源 Docker 镜像，便于管理和识别。建议更新部署配置，使用新镜像地址 `flrnnc/seafile-client`。<|FCResponseEnd|># Seafile Client Docker 镜像文档

![Pipeline status](https://gitlab.com/flrnnc-oss/docker-seafile-client/badges/3.7.0/pipeline.svg)
![Docker image size](https://user-content.gitlab-static.net/c92776ecf4007e8ac10063419254991f8217f433/68747470733a2f2f696d672e736869656c64732e696f2f646f636b65722f696d6167652d73697a652f666c726e6e632f73656166696c652d636c69656e742f6c61746573743f6c6f676f3d646f636b6572266c6162656c3d496d61676525323073697a6526636f6c6f723d253233303737386238)
![Docker pulls](https://user-content.gitlab-static.net/1b649e78c3fa4ee4cfad1ade55f56a13a6106938/68747470733a2f2f696d672e736869656c64732e696f2f646f636b65722f70756c6c732f666c726e6e632f73656166696c652d636c69656e743

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/flowgunso/seafile-client" title="flowgunso/seafile-client Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/flowgunso/seafile-client</a></p>

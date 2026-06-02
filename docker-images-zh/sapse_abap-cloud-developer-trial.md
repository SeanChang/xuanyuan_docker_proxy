---
image: sapse/abap-cloud-developer-trial
description: "该Docker镜像文档包含系统要求、拉取、运行、故障排除及许可更新等操作指南，但未明确其核心功能与用途。"
source: https://xuanyuan.cloud/zh/r/sapse/abap-cloud-developer-trial
canonical: https://xuanyuan.cloud/zh/r/sapse/abap-cloud-developer-trial
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sapse/abap-cloud-developer-trial" title="sapse/abap-cloud-developer-trial Docker 镜像中文简介、标签列表与拉取命令">sapse/abap-cloud-developer-trial — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/sapse/abap-cloud-developer-trial" title="sapse/abap-cloud-developer-trial Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/sapse/abap-cloud-developer-trial</a>

# ABAP Cloud Developer Trial Docker镜像文档


## 1. 镜像概述与主要用途

ABAP Cloud Developer Trial 是 SAP 提供的基于 Docker 容器的 ABAP 开发环境镜像，主要用于教育、演示和学习目的。该镜像包含完整的 ABAP 平台（AS ABAP）、SAP HANA MDC 数据库及 SAP Cloud Connector，支持开发者在本地环境中快速搭建 ABAP 开发环境，无需复杂的基础设施配置。

> **注意**：本镜像为免费提供，仅用于教育和演示，不提供 SAP 官方技术支持，仅通过 SAP 社区获取支持。


## 2. 核心功能与特性

- **完整 ABAP 开发环境**：包含 AS ABAP 运行时，支持 ABAP 编程、调试及测试。
- **SAP HANA MDC 数据库**：内置 SAP HANA 多租户数据库容器，满足数据存储需求。
- **SAP Cloud Connector**：集成云连接器，支持本地环境与 SAP BTP 云服务的连接。
- **预配置用户与客户端**：默认提供 DEVELOPER 用户（客户端 001）及管理员用户（SAP*，客户端 000），简化登录流程。
- **Docker 容器化部署**：基于 Docker 技术，跨平台支持（Linux、Windows、macOS），部署便捷。


## 3. 使用场景与适用范围

- **ABAP 开发者学习**：供新手开发者学习 ABAP 编程、SAP 系统配置及开发流程。
- **演示环境搭建**：快速搭建 ABAP 应用演示环境，用于技术展示或培训。
- **教育与培训**：高校或企业内部 ABAP 技术培训的实践环境。


## 4. 系统要求

### 4.1 硬件要求
- **CPU**：至少 4 核
- **内存**：推荐 32GB（Docker 分配至少 16GB，Windows 建议分配 20GB）
- **磁盘空间**：至少 170GB（镜像压缩后约 23GB，解压后 >53GB）


### 4.2 操作系统要求

#### 4.2.1 Linux
- 4 CPU、16GB RAM（Docker 分配）、150GB 磁盘空间。


#### 4.2.2 macOS
- **推荐配置**：Apple Silicon（M 系列）或 Intel 处理器，32GB RAM，macOS Sequoia 15.5+，Docker Desktop 4.41.2+。
- **Docker 配置**：分配 4 CPU、16GB RAM、170GB 磁盘空间。


#### 4.2.3 Windows
需通过 WSL 2 运行（不支持 Hyper-V）：
1. 安装 Docker Desktop 并选择 "WSL" 选项。
2. 在用户目录（如 `C:\Users\MyUser`）创建 `.wslconfig` 文件，内容如下：
   ```ini
   [wsl2]
   memory=20GB  # 推荐分配 20GB
   localhostForwarding=true
   ```
3. 执行命令重启 WSL：
   ```bash
   wsl --shutdown
   ```
4. 重启 Docker Desktop，确保分配 4 CPU、16GB RAM（总内存推荐 32GB）及 170GB 磁盘空间。


## 5. 镜像拉取

### 5.1 前提条件
- 已注册 [Docker 中心](https://hub.docker.com/) 账号，并通过 `docker login` 命令或 Docker Desktop 登录。
- 同意 SAP DEVELOPER 许可证（启动容器时会提示）。
- 确保 Docker 已分配足够磁盘空间（解压后需 >53GB）及内存（至少 16GB）。


### 5.2 拉取命令
```bash
docker pull sapse/abap-cloud-developer-trial:<TAGNAME>
```
> **说明**：`<TAGNAME>` 需替换为具体版本标签，可在 Docker 中心镜像页面的 "Tags" 选项卡获取。


## 6. 容器运行与管理

### 6.1 创建并启动容器

#### 6.1.1 Linux 系统
```bash
docker run --stop-timeout 3600 -it --name a4h -h vhcala4hci sapse/abap-cloud-developer-trial:<TAGNAME>
```

#### 6.1.2 Windows/macOS 系统
需映射端口以支持外部访问：
```bash
docker run --stop-timeout 3600 -i --name a4h -h vhcala4hci \
  -p 3200:3200 -p 3300:3300 -p 8443:8443 -p 30213:30213 -p 50000:50000 -p 50001:50001 \
  sapse/abap-cloud-developer-trial:<TAGNAME> -skip-limits-check
```

**参数说明**：
- `--stop-timeout 3600`：容器停止超时时间（秒），确保 HANA 数据写入磁盘。
- `-h vhcala4hci`：强制主机名，系统依赖此主机名启动。
- `-p <host>:<container>`：端口映射，具体端口用途见 [7. 连接方式](#7-连接方式)。
- `-skip-limits-check`：跳过 Linux 内核限制检查（Windows/macOS 必需）。
- `-agree-to-sap-license`：自动同意许可证（建议添加，避免重复提示）。


### 6.2 停止容器
需确保 HANA 数据持久化，通过以下命令优雅停止：
```bash
# 方法 1：在启动容器的终端按 Ctrl-C
# 方法 2：执行命令
docker stop -t 7200 a4h  # -t 7200 表示等待 2 小时超时
```


### 6.3 重启容器
```bash
docker start -ai a4h
```
- `-a`：附加到容器输出流，查看启动日志。
- `-i`：交互模式，支持处理启动过程中的提示。


## 7. 连接方式

### 7.1 端口说明
容器默认使用以下端口，需通过 `-p` 参数映射至主机：

| 端口   | 用途                  |
|--------|-----------------------|
| 3200   | SAPGUI 实例 00        |
| 3300   | RFC 实例 00           |
| 8443   | SAP Cloud Connector   |
| 30213  | SAP HANA MDC 数据库   |
| 50000  | AS ABAP HTTP          |
| 50001  | AS ABAP HTTPS         |


### 7.2 SAPGUI 连接
1. 添加系统：应用服务器为 `localhost`（端口映射时）或容器 IP，实例号 `00`，SID `A4H`。
2. 登录信息：
   - 用户：`DEVELOPER`
   - 客户端：`001`（开发）或 `000`（管理员）
   - 密码：  
     - 2023 SP00 版本：`ABAPtr2023#00`  
     - 2022 SP01 版本：`ABAPtr2022#01`  


### 7.3 浏览器访问
通过以下 URL 访问 AS ABAP 服务：
- HTTP：`http://localhost:50000`
- HTTPS：`https://localhost:50001`

**主机名配置**：若访问时提示主机名 `vhcala4hci` 无法解析，需修改本地 `hosts` 文件：
```
# Windows：C:\Windows\System32\drivers\etc\hosts
# Linux/macOS：/etc/hosts
127.0.0.1  vhcala4hci  # 端口映射时
# 或 <容器IP>  vhcala4hci  # 未映射端口时（通过 docker inspect a4h 获取容器IP）
```


### 7.4 SAP Cloud Connector (SCC)
#### 启动 SCC：
```bash
docker exec -it a4h bash
/usr/local/sbin/rcscc_daemon start
```

#### 检查状态：
```bash
/usr/local/sbin/rcscc_daemon status
```

#### 停止 SCC：
```bash
/usr/local/sbin/rcscc_daemon stop
exit  # 退出容器终端
```

#### 访问 SCC：
通过浏览器访问 `https://localhost:8443`，登录信息：
- 用户：`Administrator`
- 密码：`manage`


## 8. 许可证更新

### 8.1 ABAP 许可证（AS ABAP）
默认许可证有效期为 3 个月，需通过以下方式更新：

#### 方法 1：通过 SAPGUI（事务码 SLICENSE）
1. 使用 `SAP*` 用户登录客户端 `000`（密码同 DEVELOPER）。
2. 执行事务码 `SLICENSE`，复制硬件密钥。
3. 在 [SAP 许可证页面](https://go.support.sap.com/minisap/#/minisap) 获取 A4H 系统的演示许可证。
4. 返回 `SLICENSE`，选择“安装”导入新许可证，然后用 DEVELOPER 用户（客户端 001）删除旧许可证。

#### 方法 2：通过 Docker 命令
- **新容器**：启动时挂载许可证文件：
  ```bash
  docker run ... -v <本地许可证文件路径>:/opt/sap/ASABAP_license sapse/abap-cloud-developer-trial:<TAGNAME>
  ```
- **现有容器**：复制许可证文件至容器：
  ```bash
  docker cp <本地许可证文件路径> a4h:/opt/sap/ASABAP_license
  # 触发更新（容器运行中）
  docker exec -it a4h /usr/local/bin/asabap_license_update
  ```


### 8.2 HANA 许可证
HANA 许可证更新方式与 ABAP 类似，区别在于：
- 许可证文件路径为 `/opt/sap/HDB_license`。
- 更新脚本为 `/usr/local/bin/hdb_license_update`。
- 可通过 `DBA Cockpit > System Information > License` 检查有效期。


## 9. 故障排除

### 9.1 系统限制检查失败
**错误信息**：`Cannot continue because of insufficient system limits configuration!`  
**解决**：添加 `-skip-limits-check` 参数（Windows/macOS 必需），或在 Linux 主机上调整系统参数（如 `sysctl`、`ulimit`）。


### 9.2 容器名称冲突
**错误信息**：`Conflict. The container name "/a4h" is already in use...`  
**解决**：删除旧容器：`docker rm -f a4h`，再重新创建。


### 9.3 内存不足
**症状**：容器启动缓慢或崩溃。  
**解决**：确保 Docker 分配至少 16GB RAM（Windows 通过 `.wslconfig` 设置，macOS/Linux 在 Docker Desktop 中配置）。


### 9.4 SAP Cloud Connector 启动错误
**错误信息**：`Command lsof -i :8443 failed`  
**解决**：忽略此错误（不影响功能），或重启 SCC：`/usr/local/sbin/rcscc_daemon restart`。


## 10. 已知问题

- **初始功能启动缓慢**：首次运行事务码或应用时，因动态加载组件可能较慢。
- **许可证提示重复**：未添加 `-agree-to-sap-license` 时，每次启停容器需手动同意许可证。
- **macOS 端口限制**：必须通过 `-p` 映射端口，不支持 `--net=host`（Docker for Mac 限制）。


## 11. 支持与联系

本镜像仅提供 SAP 社区支持，可在 [SAP Community ABAP 论坛](https://community.sap.com/t5/forums/postpage/choose-node/true/product-id/833755570260738661924709785639136/board-id/technology-questions) 提问并添加标签 `#abap_trial`。

**主要联系人**：
- Julie Plummer <julie.plummer@sap.com>
- Ralf Henning <ralf.henning@sap.com>
- Jakub Filak <jakub.filak@sap.com>


## 12. 开源法律声明
详见 [SAP 开源法律声明](https://support.sap.com/content/dam/launchpad/en_us/osln/osln/73554900100900008093_20240117061308.pdf)。

# 5 分钟私有化部署 GLPI：IT 资产与服务台一键上线，免费开源资产管理

![5 分钟私有化部署 GLPI：IT 资产与服务台一键上线，免费开源资产管理](https://img.xuanyuan.dev/docker/blog/glpi.png)

*分类: GLPI,Docker,轩辕镜像,ITSM,资产管理,服务台,私有化部署,部署教程 | 标签: GLPI,Docker,轩辕镜像,ITSM,资产管理,服务台,私有化部署,部署教程 | 发布时间: 2026-06-25 08:21:41*

> 5 分钟跟做教程：Docker Compose 私有化部署 GLPI，轩辕镜像加速拉取，免费 IT 资产台账与 ITIL 服务台一键上线。含老旧 CPU 兼容、Compose 排错与默认管理员 glpi/glpi，Ubuntu 24.04 实测。

*本文基于 [glpi/glpi:11.0-nightly](https://xuanyuan.cloud/zh/r/glpi/glpi) 与 [mysql:8.0-debian](https://xuanyuan.cloud/zh/r/library/mysql) 镜像，Ubuntu 24.04 服务器实测*

想 **5 分钟** 在自己服务器上搭一套 **免费的 IT 资产管理系统** 和 **ITIL 服务台**，数据完全自主可控？**GLPI**（Gestionnaire Libre de Parc Informatique）是开源免费的资产与运维平台，覆盖资产台账、工单、变更、合同、许可证等模块，适合中小企业与运维团队 **私有化部署**。

GLPI **不能单容器运行**，需要配套 **MySQL** 数据库。本文带你用 **Docker Compose** 完成 **IT 资产与服务台一键上线**：轩辕镜像加速拉取、编写 `.env` 与 `docker-compose.yml`、处理老旧 CPU 等实测踩坑，最后在浏览器登录后台——全程约 **5 分钟** 可跟做。**超级管理员默认账号：用户名 `glpi`，密码 `glpi`**（首次登录建议立即修改）。

国内用户从 Docker Hub 拉取可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速域 `docker.xuanyuan.run`。官方镜像说明见 [Docker Hub glpi/glpi](https://hub.docker.com/r/glpi/glpi)，源码仓库 [glpi-project/glpi](https://github.com/glpi-project/glpi)。

---

## 附录：各平台分发标题与摘要

> 标题思路：**时间钩子 + 私有化/免费收益**；「IT 资产与服务台一键上线」作核心卖点；版本号、轩辕镜像写进摘要，不堆在标题里。

| 平台 | 推荐标题 | 摘要（前两句，可按平台微调） |
|------|----------|------------------------------|
| 轩辕官方博客 | 5 分钟私有化部署 GLPI：IT 资产与服务台一键上线，免费开源资产管理 | 想 5 分钟搭一套免费 IT 资产与服务台？本文 Docker Compose 私有化部署 GLPI，从拉镜像到登录后台全程可跟做。轩辕镜像加速，默认账号 glpi/glpi，Ubuntu 24.04 实测。 |
| 微信公众号 | 5 分钟搞定免费资产管理：GLPI 私有化部署 IT 服务台 | 不用买商业软件，Docker 一键上线 GLPI：资产台账、工单、合同管理全都有。附完整命令与默认登录账号 glpi/glpi。 |
| CSDN / 掘金 | 5 分钟私有化部署 GLPI：Docker 免费 IT 资产与服务台（Compose 实测） | GLPI 开源 ITSM 私有化部署教程：轩辕镜像加速、8080 访问、IT 资产与服务台一键上线。含老旧 CPU 兼容与六张功能截图。 |
| 知乎 | 5 分钟搭建私有 IT 资产管理系统？GLPI Docker 一键部署服务台 | 免费开源 GLPI 私有化部署，浏览器管理资产与工单；Compose 双容器启动，登录 glpi/glpi，Ubuntu 服务器实测步骤可复制。 |
| 阿里云开发者社区 | 5 分钟上线 IT 资产与服务台：阿里云 ECS 私有化部署 GLPI | 阿里云 ECS 用 Docker Compose 私有化部署 GLPI，免费资产管理 + ITIL 服务台，轩辕镜像加速拉取镜像。 |
| 腾讯云开发者社区 | 5 分钟搞定免费资产管理：腾讯云 CVM 部署 GLPI 服务台 | 腾讯云 CVM 零基础私有化部署 GLPI，IT 资产与服务台一键上线，附 Compose 配置与常见问题。 |
| 华为云社区 | GLPI 私有化部署：5 分钟 Docker 上线免费 IT 资产与服务台 | 华为云服务器 Docker Compose 部署 GLPI 完整步骤，覆盖资产登记、工单看板与老旧 CPU 踩坑。 |
| B站专栏 / 视频简介 | 【5 分钟部署】GLPI 私有化上线：免费 IT 资产与服务台 | 视频配套：Docker 私有化部署 GLPI，演示登录、资产登记、合同管理与服务台看板。 |
| 个人博客 | 5 分钟私有化部署 GLPI：免费资产管理与服务台实测记录 | 私有 IT 资产管理系统部署笔记：Compose 命令、默认账号、六张截图与 FAQ 汇总。 |

---

## 一、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 Ubuntu 24.04） |
| 内存 | ≥ 4 GB（GLPI + MySQL 双容器） |
| CPU | 双核即可；老旧 VPS 可能仅 **x86-64-v1**（缺 `popcnt`/`sse4_2`） |
| 磁盘 | ≥ 10 GB（镜像 + 数据库 + GLPI 数据卷） |
| 端口 | **8080**（映射容器 80；80 空闲时可改 `80:80`） |

> **踩坑提示**：
> - 本文主镜像 **`11.0-nightly`** 为每日自动构建的预览版，适合测试尝鲜；生产环境建议改用 `11.0` 稳定版标签，并用 digest 固定。
> - **`mysql:8.0` 默认标签勿用**：现指向 Oracle Linux 9，老旧 CPU 会报 `Fatal glibc error: CPU does not support x86-64-v2`，须改用 **`mysql:8.0-debian`**（详见第三节）。
> - MySQL 使用 `MYSQL_RANDOM_ROOT_PASSWORD=yes`，**root 密码只在 `db` 容器首次启动日志中出现**。
> - 自动安装需 `.env` 中 5 个 `GLPI_DB_*` 变量齐全；齐全时首次访问会自动建库，否则进入 Web 安装向导。

**镜像版本对照**：

| 标签 | 适用场景 |
|------|----------|
| `glpi/glpi:11.0-nightly` | 本文主镜像，体验 GLPI 11 每日预览版 |
| `glpi/glpi:11.0` / `latest` | 生产环境推荐 |
| `mysql:8.0-debian` | 老旧 CPU 首选数据库镜像 |
| `mysql:8.0` | 仅新 CPU（x86-64-v2）可用 |

---

## 二、安装 Docker

若尚未安装 Docker，可使用轩辕镜像一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

验证：

```bash
docker --version
docker compose version
```

更多安装说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。若 `docker compose` 不可用，见文末 **FAQ Q1**。

---

## 三、拉取镜像

```bash
docker pull docker.xuanyuan.run/glpi/glpi:11.0-nightly
docker pull docker.xuanyuan.run/library/mysql:8.0-debian
```

成功时终端显示 `Status: Downloaded newer image for ...`。

**部署前预检**（确认数据库镜像能在本机 CPU 上运行）：

```bash
docker run --rm docker.xuanyuan.run/library/mysql:8.0-debian mysql --version
```

若报 `CPU does not support x86-64-v2`，依次尝试：

```bash
docker run --rm docker.xuanyuan.run/library/mysql:8.0-oraclelinux8 mysql --version
docker run --rm docker.xuanyuan.run/library/mysql:8.0.32 mysql --version
```

| 官方镜像 | 轩辕加速拉取 | 说明 |
|----------|--------------|------|
| `glpi/glpi:11.0-nightly` | `docker.xuanyuan.run/glpi/glpi:11.0-nightly` | [glpi/glpi](https://xuanyuan.cloud/zh/r/glpi/glpi) |
| `mysql:8.0` | `docker.xuanyuan.run/library/mysql:8.0` | **勿用**（Oracle Linux 9，需 x86-64-v2） |
| `mysql:8.0-debian` | `docker.xuanyuan.run/library/mysql:8.0-debian` | **老旧 CPU 首选** |
| `mysql:8.0-oraclelinux8` | `docker.xuanyuan.run/library/mysql:8.0-oraclelinux8` | 备选 |
| `mysql:8.0.32` | `docker.xuanyuan.run/library/mysql:8.0.32` | 兜底固定版本 |

详见 [docker-library/mysql#1055](https://github.com/docker-library/mysql/issues/1055)。

---

## 四、创建目录并编写 Compose

工作目录使用 **`/www/wwwroot/glpi`**（独立目录，勿与其他项目混用）。权限不足时可改为 `$HOME/glpi`，下文路径同步替换。

```bash
mkdir -p /www/wwwroot/glpi
cd /www/wwwroot/glpi
```

### 4.1 创建 `.env`

```bash
vim .env
```

内容示例（**请将数据库密码改为强密码，建议纯字母数字**）：

```env
GLPI_DB_HOST=db
GLPI_DB_PORT=3306
GLPI_DB_NAME=glpi
GLPI_DB_USER=glpi
GLPI_DB_PASSWORD=YourStrongPass123
```

### 4.2 创建 `docker-compose.yml`

```bash
vim docker-compose.yml
```

完整内容（与 Ubuntu 24.04 实测一致）：

```yaml
name: glpi

services:
  glpi:
    image: docker.xuanyuan.run/glpi/glpi:11.0-nightly
    restart: unless-stopped
    volumes:
      - glpi_data:/var/glpi
    env_file: .env
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "8080:80"

  db:
    image: docker.xuanyuan.run/library/mysql:8.0-debian
    restart: unless-stopped
    volumes:
      - db_data:/var/lib/mysql
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: "yes"
      MYSQL_DATABASE: ${GLPI_DB_NAME}
      MYSQL_USER: ${GLPI_DB_USER}
      MYSQL_PASSWORD: ${GLPI_DB_PASSWORD}
    healthcheck:
      test: ["CMD-SHELL", "mysqladmin ping -h 127.0.0.1 -u\"$$MYSQL_USER\" -p\"$$MYSQL_PASSWORD\" || exit 1"]
      start_period: 30s
      interval: 5s
      timeout: 5s
      retries: 15

volumes:
  glpi_data:
  db_data:
```

各参数说明：

| 参数 | 说明 |
|------|------|
| `glpi_data:/var/glpi` | 持久化 config、files、marketplace、logs |
| `db_data` | MySQL 数据目录 |
| `8080:80` | 宿主机 8080 → 容器 80；80 空闲可改 `80:80` |
| `mysql:8.0-debian` | 老旧 CPU 必须用 `-debian` 后缀，勿写 `mysql:8.0` |
| `depends_on` + `healthcheck` | 等数据库就绪后再启动 GLPI |

### 4.3 启动服务

```bash
docker compose up -d
docker compose ps
docker compose logs -f
```

首次启动 MySQL 初始化约 **30～60 秒**，GLPI 自动安装约 **1～3 分钟**。若此前因 `db` unhealthy 导致 GLPI 停在 `Created` 状态，修好数据库后执行：

```bash
docker compose up -d
```

---

## 五、读懂启动日志

### 5.1 获取 MySQL root 密码（维护用）

```bash
docker compose logs db | grep -i "GENERATED ROOT PASSWORD"
```

示例输出：

```
db-1  | [Note] [Entrypoint]: GENERATED ROOT PASSWORD: xxxxxxxxxxxxxxxx
```

此密码仅用于数据库维护；GLPI 应用连接使用 `.env` 中的 `glpi` 用户。

### 5.2 判断 MySQL 是否就绪

日志中出现：

```
/usr/sbin/mysqld: ready for connections. Version: '8.0.xx'
```

表示数据库已启动。`mbind: Operation not permitted` 为常见警告，一般可忽略。

### 5.3 命令行健康检查

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080
docker compose ps
```

期望：HTTP 返回 **200** 或 **302**；`glpi` 与 `db` 均为 `Up`，`db` 显示 `(healthy)`。

若 `curl` 返回 `000`，说明 8080 无服务监听，先确认 `glpi` 容器是否为 `Up`（见 FAQ Q3）。

---

## 六、浏览器访问与登录

在浏览器打开（将 `YOUR_SERVER_IP` 换成服务器 IP，实测局域网示例 `192.168.1.18`）：

```
http://YOUR_SERVER_IP:8080
```

若进入安装向导而非登录页，说明自动安装未执行，可手动填写数据库信息：

| 字段 | 填写 |
|------|------|
| SQL 主机（Hostname） | `db` |
| SQL 用户 | `glpi` |
| SQL 密码 | `.env` 中 `GLPI_DB_PASSWORD` |
| 数据库名 | `glpi` |

也可访问 `http://YOUR_SERVER_IP:8080/index.php?noAUTO=1` 跳过自动安装流程。

### 6.1 使用默认账号登录

**超级管理员**（本文实测登录账号）：

| 字段 | 值 |
|------|-----|
| 用户名 | `glpi` |
| 密码 | `glpi` |

登录源选择 **「GLPI 内部数据库」**，点击 **「登录」**：

![GLPI 登录页：用户名与密码均为 glpi，登录源选 GLPI 内部数据库](https://img.xuanyuan.dev/docker/blog/glpi-1.png)

*图 1：部署成功后的 GLPI 登录页，超级管理员用户名与密码默认均为 `glpi`*

> **安全提示**：超级管理员用户名和密码默认均为 **`glpi`**。首次登录后页面顶部会出现橙色安全提示，要求修改 `glpi`、`post-only`、`tech`、`normal` 四个默认用户密码，公网暴露前务必完成修改。

其他演示账号（可选）：

| 用户名 | 密码 | 角色 |
|--------|------|------|
| `tech` | `tech` | 技术员 |
| `normal` | `normal` | 普通用户 |
| `post-only` | `postonly` | 仅发帖用户 |

### 6.2 登录后首页与界面语言

登录成功后进入 **主页** 仪表盘。首次访问会加载演示数据，顶部蓝色横幅可点击 **「禁用演示」** 清空示例数据：

![GLPI 主页仪表盘：资产统计卡片、工单趋势图与默认密码安全提示](https://img.xuanyuan.dev/docker/blog/glpi-2.png)

*图 2：登录后的 GLPI 主页，含软件/电脑/工单等统计卡片与安全提示横幅*

界面默认可能为英文。点击右上角用户头像，在 **「语言」** 下拉中选择 **「简体中文」** 即可切换：

![GLPI 切换简体中文：右上角用户菜单中的语言选项](https://img.xuanyuan.dev/docker/blog/glpi-3.png)

*图 3：通过用户菜单将界面语言切换为简体中文*

---

## 七、功能实测（跟做验证部署成功）

以下步骤用于确认服务不仅「能登录」，还能完成 IT 资产管理与服务台常见操作。

### 7.1 资产管理：新增电脑

左侧导航 **「资产」→「电脑」**，点击 **「+ 添加」**，填写名称、状态、制造商等字段后保存：

![GLPI 新增电脑：资产模块下的电脑登记表单](https://img.xuanyuan.dev/docker/blog/glpi-4.png)

*图 4：在资产模块中新增一台电脑，验证 IT 资产管理功能可用*

### 7.2 合同管理：新增合同

左侧 **「管理」→「合同」**，点击 **「+ 添加」**，填写合同名称、起止日期、续约周期等信息：

![GLPI 新增合同：管理模块下的合同登记表单](https://img.xuanyuan.dev/docker/blog/glpi-5.png)

*图 5：在管理模块中登记合同，验证供应商与合同管理能力*

### 7.3 服务台：工单看板

左侧 **「支持协助」** 进入服务台看板，可查看工单、故障、变更等统计与趋势图：

![GLPI 服务台看板：工单、故障、变更统计与近一年趋势图](https://img.xuanyuan.dev/docker/blog/glpi-6.png)

*图 6：服务台模块看板，展示工单处理概况与分类统计*

至此，**拉镜像 → Compose 启动 → 登录 glpi/glpi → 资产登记 → 合同管理 → 服务台看板** 全流程验证完成。

---

## 八、可选进阶配置

### 8.1 禁用自动安装 / 自动更新

在 `.env` 追加：

```env
GLPI_SKIP_AUTOINSTALL=true
GLPI_SKIP_AUTOUPDATE=true
```

禁用自动安装后，访问 Web 需手动填写数据库连接信息（主机 `db`，用户/库名/密码同 `.env`）。

### 8.2 时区支持

```bash
# 1. 授权 glpi 用户读取时区表（root 密码见第五节）
docker compose exec db mysql -u root -p -e "GRANT SELECT ON mysql.time_zone_name TO 'glpi'@'%'; FLUSH PRIVILEGES;"

# 2. 在 GLPI 容器初始化时区
docker compose exec glpi /var/www/glpi/bin/console database:enable_timezones
```

### 8.3 自定义 PHP 配置

宿主机创建 `custom-config.ini`：

```ini
memory_limit = 256M
```

在 `docker-compose.yml` 的 `glpi` 服务下增加：

```yaml
    volumes:
      - glpi_data:/var/glpi
      - ./custom-config.ini:/usr/local/etc/php/conf.d/custom-config.ini:ro
```

### 8.4 Nginx 反向代理（示例）

```nginx
server {
    listen 80;
    server_name glpi.example.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 8.5 生产环境镜像标签

将 `glpi` 服务镜像改为稳定版：

```yaml
image: docker.xuanyuan.run/glpi/glpi:11.0
```

建议用 digest 固定构建，避免标签漂移。

---

## 九、升级镜像

数据保存在 named volume 中，升级保留卷即可：

```bash
cd /www/wwwroot/glpi
docker pull docker.xuanyuan.run/glpi/glpi:11.0-nightly
docker pull docker.xuanyuan.run/library/mysql:8.0-debian
docker compose up -d
```

跨大版本升级前建议备份 `glpi_data` 与 `db_data` 卷。

---

## 十、常见问题 FAQ

**Q1：`docker compose up -d` 报 `unknown shorthand flag: 'd' in -d`？**

说明 **Compose V2 未安装**。若 `docker compose -v` 只显示 `Docker version 29.1.3`（无 Compose 版本），可按下述方式处理。

**Ubuntu 官方 `docker.io` 包**（非 Docker 官方 apt 源）请安装 **`docker-compose-v2`**：

```bash
sudo apt update
sudo apt install -y docker-compose-v2
docker compose version
```

> 勿执行 `apt install docker-compose-plugin`——Ubuntu 默认源无此包，会报 `E: Unable to locate package docker-compose-plugin`。该包仅存在于 [Docker 官方 apt 源](https://docs.docker.com/engine/install/ubuntu/)。

若仍不可用，可手动安装插件：

```bash
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
docker compose version
```

或安装独立命令（全文将 `docker compose` 替换为 `docker-compose`）：

```bash
sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose up -d
```

**Q2：`db` 日志报 `Fatal glibc error: CPU does not support x86-64-v2`？**

`mysql:8.0` 默认标签指向 Oracle Linux 9，老旧 CPU 无法运行。改用 `mysql:8.0-debian`（首选）或 `mysql:8.0-oraclelinux8`，再不行固定 `mysql:8.0.32`。用 `docker run --rm <镜像> mysql --version` 预检后，`docker compose down -v` 清卷重装。

**Q3：本机 `curl 127.0.0.1:8080` 返回 `000`，浏览器 `ERR_CONNECTION_REFUSED`？**

8080 无进程监听，**不是**客户端防火墙问题。执行 `docker compose ps -a`：若 `glpi` 为 `Created` 或 `Exited`，执行 `docker compose up -d glpi` 并查看 `docker compose logs glpi`。常见原因：此前 `db` unhealthy 导致 GLPI 从未启动，修好数据库后需再次 `up -d`。

**Q4：`db` 一直 `unhealthy`？**

检查 healthcheck 是否使用 `CMD-SHELL` 与 `$$MYSQL_USER`/`$$MYSQL_PASSWORD`；确认 `.env` 密码无特殊字符；`start_period` 建议 30s。修改 compose 后 `docker compose down -v` 重装（**会删除数据库卷**）。

**Q5：GLPI 一直显示安装向导？**

检查 `.env` 五个 `GLPI_DB_*` 是否齐全；确认 `db` 为 healthy。手动安装时：主机 `db`，用户 `glpi`，密码见 `.env`，库名 `glpi`。

**Q6：超级管理员用户名密码是什么？**

**用户名 `glpi`，密码 `glpi`**。登录后请立即修改默认密码。

**Q7：如何查看 MySQL root 密码？**

`docker compose logs db | grep -i "GENERATED ROOT PASSWORD"`。

**Q8：8080 被占用怎么办？**

将 compose 中 `"8080:80"` 改为 `"8090:80"`，浏览器访问 `http://YOUR_SERVER_IP:8090`。

**Q9：`11.0-nightly` 与 `11.0` 有什么区别？**

`11.0-nightly` 为每日自动构建的预览版，适合体验新功能；生产环境建议 `11.0` 稳定版标签并固定 digest。

---

## 总结

本文完成了 GLPI **5 分钟级私有化部署**，实现 **IT 资产与服务台一键上线**：

- 使用轩辕镜像加速拉取 `glpi/glpi:11.0-nightly` 与 `mysql:8.0-debian`
- Docker Compose 双容器 **私有化部署**，工作目录 `/www/wwwroot/glpi`
- 免费开源 **IT 资产管理** + **ITIL 服务台**，数据留在自有服务器
- 处理 Ubuntu `docker-compose-v2` 安装与老旧 CPU 的 MySQL 标签选择
- 8080 端口访问，**超级管理员默认账号 `glpi` / `glpi`**
- 浏览器实测登录、简体中文切换、资产登记、合同管理与服务台看板（六张配图）
- 覆盖 db healthcheck、GLPI 未启动、连接拒绝等实测踩坑

**延伸阅读：**

- [Docker Hub glpi/glpi](https://hub.docker.com/r/glpi/glpi)
- [glpi-project/glpi](https://github.com/glpi-project/glpi)
- [glpi/glpi 轩辕镜像页](https://xuanyuan.cloud/zh/r/glpi/glpi)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)
- [Docker 一键安装脚本](https://xuanyuan.cloud/docker.sh)

如果你在拉取 Docker 镜像时遇到速度慢、超时等问题，可以试试 [轩辕镜像](https://xuanyuan.cloud) 的加速服务；镜像页支持一键复制拉取命令。欢迎收藏 [glpi/glpi](https://xuanyuan.cloud/zh/r/glpi/glpi) 镜像页，获取最新标签与更新说明。


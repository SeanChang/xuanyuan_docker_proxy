# TRENDRADAR Docker 容器化部署指南

![TRENDRADAR Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-trendradar.png)

*分类: Docker,TRENDRADAR | 标签: trendradar,docker,部署教程 | 发布时间: 2025-11-16 04:55:03*

> TRENDRADAR（中文名称：趋势雷达）是一款专注于多平台热点聚合与智能推送的容器化应用。该工具以轻量部署、高效聚合为核心目标，支持从知乎、抖音、B站、微博等11个主流平台实时抓取热点内容，并通过企业微信、飞书、钉钉、Telegram、邮件、ntfy等多渠道推送。其核心特性包括智能内容筛选、热点趋势分析、个性化算法排序及AI深度分析功能，帮助用户从海量信息中精准获取关注的热点话题，减少对传统信息平台的依赖。

## 概述

TRENDRADAR（中文名称：趋势雷达）是一款专注于多平台热点聚合与智能推送的容器化应用。该工具以轻量部署、高效聚合为核心目标，支持从知乎、抖音、B站、微博等11个主流平台实时抓取热点内容，并通过企业微信、飞书、钉钉、Telegram、邮件、ntfy等多渠道推送。其核心特性包括智能内容筛选、热点趋势分析、个性化算法排序及AI深度分析功能，帮助用户从海量信息中精准获取关注的热点话题，减少对传统信息平台的依赖。

本指南将详细介绍TRENDRADAR的Docker容器化部署流程，包括环境准备、镜像拉取、容器配置、功能验证及生产环境优化方案，旨在为用户提供一套完整、可复现的部署方案。


## 环境准备

### Docker环境安装

TRENDRADAR基于Docker容器化部署，需先确保服务器已安装Docker环境。推荐使用轩辕云提供的一键安装脚本，可自动完成Docker及相关组件的安装与配置：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

> 脚本执行过程中可能需要sudo权限，请确保当前用户具备相应权限。安装完成后，可通过`docker --version`验证Docker是否成功安装。


### 轩辕镜像访问支持配置

为提升Docker镜像拉取访问表现，特别是国内用户访问Docker Hub的效率，上述一键脚本已自动配置轩辕镜像访问支持服务：

- **作用**：通过国内高速节点缓存，加速从Docker Hub下载镜像，解决跨境网络延迟问题
- **原理**：镜像源仍为Docker Hub，轩辕节点仅作为缓存代理，确保镜像完整性与官方一致
- **配置**：无需手动操作，一键脚本已完成`/etc/docker/daemon.json`配置，重启Docker后自动生效

> 访问支持能力仅影响镜像拉取访问表现，不改变镜像内容及使用方式。如需验证加速配置，可执行`docker info`查看Registry Mirrors字段是否包含`xxx.xuanyuan.run`。


## 镜像准备

### 镜像信息确认

TRENDRADAR官方镜像信息如下：
- **镜像名称**：wantcat/trendradar
- **推荐标签**：latest（稳定版）
- **镜像类型**：用户/组织镜像（多段名称，包含斜杠"/"）


### 镜像拉取命令

根据镜像名称格式（包含斜杠），采用轩辕访问支持地址的多段镜像拉取规则：

```bash
# 拉取最新稳定版镜像
docker pull xxx.xuanyuan.run/wantcat/trendradar:latest
```

> 如需指定其他版本，可将`latest`替换为具体标签，标签列表可参考[轩辕镜像标签页面](https://xuanyuan.cloud/r/wantcat/trendradar/tags)。


### 镜像验证

拉取完成后，通过以下命令验证镜像是否成功获取：

```bash
docker images | grep trendradar
```

预期输出示例：
```
xxx.xuanyuan.run/wantcat/trendradar   latest    abc12345   2 weeks ago   500MB
```


## 容器部署

### 部署前准备

#### 1. 创建工作目录

为实现配置文件持久化与数据备份，建议创建专用工作目录：

```bash
# 创建主目录及子目录（官方推荐结构）
mkdir -p config output
# 或使用绝对路径
mkdir -p /opt/trendradar/{config,output}
```

- `config`：存储配置文件（关键词、推送设置等）
- `output`：存储历史数据、生成的网页报告


#### 2. 配置文件准备

TRENDRADAR核心配置文件包括`config.yaml`（主配置）和`frequency_words.txt`（关键词配置）。官方推荐直接从GitHub下载配置文件模板：

**方式一：使用 wget 下载（Linux/macOS）**

```bash
# 下载配置文件到 config 目录
wget https://raw.githubusercontent.com/sansan0/TrendRadar/master/config/config.yaml -P config/
wget https://raw.githubusercontent.com/sansan0/TrendRadar/master/config/frequency_words.txt -P config/
```

**方式二：手动下载**

1. 访问 https://raw.githubusercontent.com/sansan0/TrendRadar/master/config/config.yaml → 右键"另存为" → 保存到 `config/config.yaml`
2. 访问 https://raw.githubusercontent.com/sansan0/TrendRadar/master/config/frequency_words.txt → 右键"另存为" → 保存到 `config/frequency_words.txt`

完成后的目录结构应该是：

```
当前目录/
└── config/
    ├── config.yaml
    └── frequency_words.txt
```

> 配置文件下载完成后，可根据实际需求修改配置项。如使用环境变量配置，配置文件可作为默认模板。


### 核心配置说明

#### 1. `config.yaml` 关键配置项

编辑`config/config.yaml`，根据需求调整以下核心参数：

```yaml
# 报告模式配置（daily/current/incremental）
report:
  mode: "daily"  # 当日汇总模式，适合日常总结
  # current - 当前榜单模式，定时推送最新榜单
  # incremental - 增量监控模式，仅推送新增内容

# 推送时间窗口（可选，默认关闭）
notification:
  push_window:
    enabled: true  # 启用时间窗口控制
    time_range:
      start: "08:00"  # 推送开始时间
      end: "22:00"    # 推送结束时间

# 爬虫配置
crawler:
  enable_crawler: true  # 是否启用爬虫

# 通知配置
notification:
  enable_notification: true  # 是否启用通知
  # Webhook 配置可通过环境变量设置，优先级高于配置文件
```

**⚙️ 环境变量覆盖机制（v3.0.5+）**

TRENDRADAR支持通过环境变量直接覆盖配置文件设置，优先级：**环境变量 > config.yaml**。常用环境变量如下：

| 环境变量 | 对应配置 | 示例值 | 说明 |
|---------|---------|--------|------|
| `ENABLE_CRAWLER` | `crawler.enable_crawler` | `true` / `false` | 是否启用爬虫 |
| `ENABLE_NOTIFICATION` | `notification.enable_notification` | `true` / `false` | 是否启用通知 |
| `REPORT_MODE` | `report.mode` | `daily` / `incremental` / `current` | 报告模式 |
| `PUSH_WINDOW_ENABLED` | `notification.push_window.enabled` | `true` / `false` | 推送时间窗口开关 |
| `PUSH_WINDOW_START` | `notification.push_window.time_range.start` | `08:00` | 推送开始时间 |
| `PUSH_WINDOW_END` | `notification.push_window.time_range.end` | `22:00` | 推送结束时间 |
| `FEISHU_WEBHOOK_URL` | `notification.webhooks.feishu_url` | `https://...` | 飞书 Webhook |

详细配置说明可参考[轩辕镜像文档（TRENDRADAR）](https://xuanyuan.cloud/r/wantcat/trendradar)中的配置章节。


#### 2. `frequency_words.txt` 关键词配置

该文件用于定义热点筛选规则，支持普通词、必须词（+前缀）、过滤词（!前缀）及词组分隔（空行）：

```txt
# 科技热点组
AI
ChatGPT
+发布
!广告

# 财经热点组
A股
上证指数
+涨跌
!预测

# 汽车热点组
比亚迪
特斯拉
+销量
```

> 关键词顺序影响优先级，靠前的关键词匹配结果将优先展示。


### 容器启动命令

**方式一：快速体验（一行命令）**

使用`docker run`命令启动容器，挂载本地目录实现持久化：

```bash
docker run -d --name trend-radar \
  -v ./config:/app/config:ro \
  -v ./output:/app/output \
  -e FEISHU_WEBHOOK_URL="你的飞书webhook" \
  -e DINGTALK_WEBHOOK_URL="你的钉钉webhook" \
  -e WEWORK_WEBHOOK_URL="你的企业微信webhook" \
  -e TELEGRAM_BOT_TOKEN="你的telegram_bot_token" \
  -e TELEGRAM_CHAT_ID="你的telegram_chat_id" \
  -e EMAIL_FROM="你的发件邮箱" \
  -e EMAIL_PASSWORD="你的邮箱密码或授权码" \
  -e EMAIL_TO="收件人邮箱" \
  -e CRON_SCHEDULE="*/30 * * * *" \
  -e RUN_MODE="cron" \
  -e IMMEDIATE_RUN="true" \
  xxx.xuanyuan.run/wantcat/trendradar:latest
```

**方式二：使用绝对路径（推荐生产环境）**

```bash
docker run -d --name trend-radar \
  --restart always \
  -v /opt/trendradar/config:/app/config:ro \
  -v /opt/trendradar/output:/app/output \
  -e FEISHU_WEBHOOK_URL="你的飞书webhook" \
  -e DINGTALK_WEBHOOK_URL="你的钉钉webhook" \
  -e WEWORK_WEBHOOK_URL="你的企业微信webhook" \
  -e TELEGRAM_BOT_TOKEN="你的telegram_bot_token" \
  -e TELEGRAM_CHAT_ID="你的telegram_chat_id" \
  -e EMAIL_FROM="你的发件邮箱" \
  -e EMAIL_PASSWORD="你的邮箱密码或授权码" \
  -e EMAIL_TO="收件人邮箱" \
  -e CRON_SCHEDULE="*/30 * * * *" \
  -e RUN_MODE="cron" \
  -e IMMEDIATE_RUN="true" \
  -e TZ=Asia/Shanghai \
  xxx.xuanyuan.run/wantcat/trendradar:latest
```

参数说明：
- `--name trend-radar`：容器名称（官方推荐使用连字符）
- `--restart always`：容器退出时自动重启，确保服务持续运行
- `-v ./config:/app/config:ro`：挂载配置文件目录（只读模式，`:ro` 表示只读）
- `-v ./output:/app/output`：挂载输出目录（存储历史数据和生成的报告）
- `-e FEISHU_WEBHOOK_URL`：飞书 Webhook 地址（可选，根据需要配置）
- `-e DINGTALK_WEBHOOK_URL`：钉钉 Webhook 地址（可选）
- `-e WEWORK_WEBHOOK_URL`：企业微信 Webhook 地址（可选）
- `-e TELEGRAM_BOT_TOKEN` / `TELEGRAM_CHAT_ID`：Telegram 推送配置（可选）
- `-e EMAIL_FROM` / `EMAIL_PASSWORD` / `EMAIL_TO`：邮件推送配置（可选）
- `-e CRON_SCHEDULE`：定时任务调度（Cron 表达式，示例：每30分钟执行一次）
- `-e RUN_MODE="cron"`：运行模式（cron 定时模式）
- `-e IMMEDIATE_RUN="true"`：立即执行一次（容器启动后立即运行，不等待定时任务）
- `-e TZ=Asia/Shanghai`：设置时区为上海（避免日志时间与本地不一致）

> **注意**：推送渠道配置可通过环境变量直接设置，无需修改 `config.yaml`。环境变量优先级高于配置文件，适合在 NAS 或其他 Docker 环境中快速配置。


### 容器状态检查

启动后通过以下命令确认容器运行状态：

```bash
# 查看容器状态
docker ps | grep trend-radar

# 查看实时日志
docker logs -f trend-radar
```

预期日志输出示例：
```
2025-01-01 09:00:00 [INFO] TrendRadar v3.0.5 started successfully
2025-01-01 09:00:05 [INFO] Loaded config from /app/config/config.yaml
2025-01-01 09:00:10 [INFO] Start fetching data from platforms...
2025-01-01 09:00:15 [INFO] Immediate run enabled, executing now...
```


## 功能测试

### 基础可用性验证

#### 1. 数据输出检查

TRENDRADAR会将生成的热点报告保存到 `output` 目录，检查输出文件：

```bash
# 查看输出目录内容
ls -lh ./output
# 或使用绝对路径
ls -lh /opt/trendradar/output
```

预期输出包含HTML格式的热点报告文件（如 `report_20250101.html`）及数据文件。


#### 2. 日志完整性检查

查看数据抓取与推送日志，验证核心功能是否正常：

```bash
# 查看容器日志（推荐方式）
docker logs trend-radar | grep "fetching data"
docker logs trend-radar | grep "pushed to"
# 查看最近100行日志
docker logs --tail 100 trend-radar
```

预期输出包含平台数据抓取成功信息（如"Fetched 20 items from 知乎"）及推送成功记录（如"pushed to 企业微信: 5 items"）。


### 核心功能测试

#### 1. 热点聚合测试

修改`frequency_words.txt`添加测试关键词（如"测试热点"），观察是否能捕获相关内容：

```bash
# 添加测试关键词
echo -e "\n测试热点\n+测试" >> ./config/frequency_words.txt
# 或使用绝对路径
echo -e "\n测试热点\n+测试" >> /opt/trendradar/config/frequency_words.txt

# 重启容器使配置生效
docker restart trend-radar

# 查看匹配日志
docker logs trend-radar | grep "匹配关键词"
```

预期日志中出现"匹配关键词: 测试热点"相关记录。


#### 2. 推送功能测试

以企业微信推送为例，验证消息是否送达：

1. 确保环境变量 `WEWORK_WEBHOOK_URL` 已正确配置（或 `config.yaml` 中企业微信配置正确）
2. 查看推送日志确认无错误：`docker logs trend-radar | grep "wecom push"` 或 `docker logs trend-radar | grep "企业微信"`
3. 检查企业微信应用消息列表，是否收到热点汇总推送

> **提示**：推荐使用环境变量配置推送渠道，修改后重启容器即可生效，无需修改配置文件。


#### 3. AI分析功能测试（v3.0.0+）

TRENDRADAR支持基于MCP协议的AI分析功能，可通过MCP客户端（如Claude、Cursor）进行自然语言查询。MCP服务默认运行在容器内，如需外部访问需配置端口映射。

> **注意**：AI分析功能需要配置MCP服务器，具体配置方法请参考[项目官方GitHub仓库](https://github.com/sansan0/TrendRadar)中的MCP配置文档。


## 生产环境建议

### 数据持久化优化

#### 1. 目录权限精细化

生产环境避免使用777权限，建议根据容器内用户ID设置权限：

```bash
# 查看容器内应用用户ID（假设为1000）
docker exec -it trend-radar id appuser
# 设置目录所有者为该用户ID
chown -R 1000:1000 /opt/trendradar
# 设置权限（config目录只读，output目录可写）
chmod -R 755 /opt/trendradar/config
chmod -R 755 /opt/trendradar/output
```


#### 2. 定期备份策略

配置定时任务备份关键数据：

```bash
# 创建备份脚本
cat > /opt/trendradar/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/backup/trendradar"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR
# 备份配置文件和数据（注意：config目录为只读，output目录包含数据）
tar -zcvf $BACKUP_DIR/trendradar_backup_$TIMESTAMP.tar.gz /opt/trendradar/config /opt/trendradar/output
# 保留最近30天备份
find $BACKUP_DIR -name "trendradar_backup_*.tar.gz" -mtime +30 -delete
EOF

# 添加执行权限
chmod +x /opt/trendradar/backup.sh
# 添加到crontab（每天凌晨3点执行）
echo "0 3 * * * /opt/trendradar/backup.sh" >> /var/spool/cron/root
```


### 性能与稳定性优化

#### 1. 资源限制配置

根据服务器配置限制容器CPU/内存使用，避免资源耗尽：

```bash
# 停止现有容器
docker stop trend-radar && docker rm trend-radar
# 带资源限制启动（示例：限制1核CPU，2GB内存）
docker run -d \
  --name trend-radar \
  --restart always \
  --cpus 1 \
  --memory 2g \
  -v /opt/trendradar/config:/app/config:ro \
  -v /opt/trendradar/output:/app/output \
  -e FEISHU_WEBHOOK_URL="你的飞书webhook" \
  -e CRON_SCHEDULE="*/30 * * * *" \
  -e RUN_MODE="cron" \
  -e IMMEDIATE_RUN="true" \
  -e TZ=Asia/Shanghai \
  xxx.xuanyuan.run/wantcat/trendradar:latest
```


#### 2. 日志轮转配置

避免日志文件过大，配置Docker日志驱动实现自动轮转：

```bash
# 创建或更新日志轮转配置文件
cat > /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": ["https://xxx.xuanyuan.run"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF
# 重启Docker生效
systemctl restart docker

# 重新启动容器以应用日志配置
docker restart trend-radar
```

> 配置后，单个日志文件最大10MB，保留3个历史文件。可通过 `docker logs trend-radar` 查看日志。


### 安全加固

#### 1. 网络隔离

通过Docker网络隔离限制容器网络访问：

```bash
# 创建专用网络
docker network create trendradar-net --subnet 172.28.0.0/16
# 启动容器时指定网络（TRENDRADAR无需暴露端口，仅需出站访问）
docker run -d \
  --name trend-radar \
  --network trendradar-net \
  --restart always \
  -v /opt/trendradar/config:/app/config:ro \
  -v /opt/trendradar/output:/app/output \
  -e FEISHU_WEBHOOK_URL="你的飞书webhook" \
  -e CRON_SCHEDULE="*/30 * * * *" \
  -e RUN_MODE="cron" \
  xxx.xuanyuan.run/wantcat/trendradar:latest
```

> **注意**：TRENDRADAR主要进行数据抓取和推送，无需暴露Web端口。如需要AI分析功能的MCP服务，可单独配置端口映射。


#### 2. 配置文件加密

对于包含敏感信息（如API密钥、推送令牌）的配置文件，可使用加密工具保护：

```bash
# 使用git-crypt加密配置文件
cd /opt/trendradar/config
git init && git-crypt init
# 添加敏感文件到加密列表
echo "config.yaml" > .gitattributes
git add .gitattributes config.yaml && git commit -m "加密配置文件"
```


### 监控与告警

#### 1. 容器健康检查

TRENDRADAR主要通过日志和输出文件判断运行状态，可通过检查输出目录或日志来监控：

```bash
# 检查容器运行状态
docker ps | grep trend-radar

# 检查最近是否有新输出文件生成
ls -lt /opt/trendradar/output | head -5

# 检查日志中是否有错误
docker logs --tail 50 trend-radar | grep -i error

# 使用重启策略确保容器持续运行
docker run -d \
  --name trend-radar \
  --restart always \
  -v /opt/trendradar/config:/app/config:ro \
  -v /opt/trendradar/output:/app/output \
  -e CRON_SCHEDULE="*/30 * * * *" \
  -e RUN_MODE="cron" \
  xxx.xuanyuan.run/wantcat/trendradar:latest
```


#### 2. 日志监控告警

使用ELK或Prometheus+Grafana监控日志异常：

```bash
# 示例：使用promtail收集Docker日志到Loki
docker run -d \
  --name promtail \
  -v /var/lib/docker/containers:/var/lib/docker/containers:ro \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /etc/promtail-config.yaml:/etc/promtail/config.yml \
  grafana/promtail:latest
```

配置Prometheus告警规则，监控容器日志，当出现"推送失败"、"数据抓取错误"等高频率日志时触发告警。也可通过检查 `output` 目录文件生成时间判断服务是否正常运行。


## 故障排查

### 常见问题及解决方案

#### 1. 容器启动失败

**现象**：`docker ps`无容器进程，`docker logs`显示权限错误  
**排查**：  
```bash
# 查看详细错误日志
docker logs trend-radar
# 查看容器退出状态
docker ps -a | grep trend-radar
```
**解决方案**：  
- 权限问题：调整挂载目录权限（如`chown -R 1000:1000 /opt/trendradar`，确保 `output` 目录可写）  
- 配置文件错误：检查 `config.yaml` 格式是否正确，可使用在线YAML验证工具  
- 环境变量格式错误：确保环境变量值使用引号包裹，特殊字符需转义  


#### 2. 数据抓取失败

**现象**：日志显示"Failed to fetch data from 知乎"或"爬虫未启用"  
**排查**：  
```bash
# 检查网络连通性
docker exec -it trend-radar curl -I https://www.zhihu.com
# 检查爬虫是否启用
docker exec -it trend-radar grep "enable_crawler" /app/config/config.yaml
# 或检查环境变量
docker exec -it trend-radar env | grep ENABLE_CRAWLER
```
**解决方案**：  
- 网络问题：检查服务器网络策略，确保允许访问目标平台域名（知乎、B站、微博等）  
- 爬虫未启用：在 `config.yaml` 中设置 `crawler.enable_crawler: true` 或使用环境变量 `ENABLE_CRAWLER=true`  
- API限制：部分平台需配置Cookie或API密钥，参考[项目官方GitHub仓库](https://github.com/sansan0/TrendRadar)中的配置说明  


#### 3. 推送功能异常

**现象**：日志显示"推送失败"或"Webhook错误"  
**排查**：  
```bash
# 查看推送相关日志
docker logs trend-radar | grep -i "push\|webhook\|推送"
# 检查环境变量配置
docker exec -it trend-radar env | grep -E "WEBHOOK|EMAIL|TELEGRAM"
```
**解决方案**：  
- 配置错误：核对Webhook URL是否正确（飞书、钉钉、企业微信等），确保URL完整且包含协议头（`https://`）  
- 网络限制：确保服务器可访问推送服务API（如企业微信 `https://qyapi.weixin.qq.com`、飞书 `https://open.feishu.cn` 等），检查防火墙规则  
- 权限不足：确保企业微信应用有"消息推送"权限，或检查Webhook是否有效（可通过curl测试）  
- 邮件配置：如使用邮件推送，确保 `EMAIL_PASSWORD` 使用的是邮箱授权码而非登录密码  


#### 4. AI分析功能无响应（v3.0.0+）

**现象**：MCP客户端无法连接或AI查询无响应  
**排查**：  
```bash
# 检查MCP服务是否运行（如配置了HTTP模式）
docker exec -it trend-radar curl -I http://localhost:3333/mcp
# 查看MCP服务日志
docker logs trend-radar | grep -i mcp
```
**解决方案**：  
- MCP服务未启动：检查容器日志确认MCP服务启动状态，参考[项目官方GitHub仓库](https://github.com/sansan0/TrendRadar)中的MCP配置文档  
- 配置错误：检查MCP服务配置，确认传输模式（STDIO或HTTP）和端口设置  
- 客户端连接问题：如使用HTTP模式，确保客户端可访问MCP服务地址（默认端口3333），检查防火墙规则  


### 高级排查工具

#### 1. 容器内调试

```bash
# 以调试模式启动容器（覆盖启动命令）
docker run --rm -it --name trendradar-debug \
  -v /opt/trendradar/config:/app/config:ro \
  -v /opt/trendradar/output:/app/output \
  xxx.xuanyuan.run/wantcat/trendradar:latest bash

# 或进入运行中的容器
docker exec -it trend-radar bash
```

在容器内可直接执行应用命令，排查配置文件加载、依赖缺失等问题。可检查 `/app/config` 和 `/app/output` 目录内容。


#### 2. 性能分析

使用`docker stats`监控容器资源占用，定位性能瓶颈：

```bash
# 实时监控资源使用
docker stats trend-radar
# 查看容器资源使用历史
docker stats --no-stream trend-radar
```

若CPU占用过高，可调整定时任务频率（修改 `CRON_SCHEDULE` 环境变量，如从 `*/30 * * * *` 改为 `0 * * * *` 每小时执行一次）或检查关键词配置是否过于宽泛导致匹配数据量过大。


## 参考资源

### 官方文档与镜像资源
- [TRENDRADAR镜像文档（轩辕）](https://xuanyuan.cloud/r/wantcat/trendradar)  
- [TRENDRADAR镜像标签列表](https://xuanyuan.cloud/r/wantcat/trendradar/tags)  
- [项目官方GitHub仓库](https://github.com/sansan0/TrendRadar)（含完整配置指南与功能说明）  


### 相关工具与协议
- [Docker官方文档](https://docs.docker.com/)  
- [MCP协议规范](https://modelcontextprotocol.io/)（AI分析功能基础）  
- [企业微信应用开发文档](https://developer.work.weixin.qq.com/document/path/90665)  


### 社区与支持
- [TRENDRADAR GitHub Issues](https://github.com/sansan0/TrendRadar/issues)（问题反馈与功能请求）  
- [轩辕云容器技术社区](https://xuanyuan.cloud/community)（镜像使用交流）  


## 总结

本文详细介绍了TRENDRADAR的Docker容器化部署方案，从环境准备、镜像拉取到容器配置、功能验证，提供了一套完整的实施指南。TRENDRADAR作为多平台热点聚合工具，通过容器化部署可快速实现热点追踪与智能推送，适用于投资者、自媒体人、企业管理者等多种用户场景。


### 关键要点
- **环境配置**：使用轩辕一键脚本快速部署Docker环境，自动配置镜像访问支持，提升国内访问访问表现  
- **镜像拉取**：根据镜像名称（含斜杠）采用多段镜像拉取规则，命令为`docker pull xxx.xuanyuan.run/wantcat/trendradar:latest`  
- **配置核心**：通过`config.yaml`（报告模式、推送设置）和`frequency_words.txt`（关键词筛选）实现个性化热点管理，推荐使用环境变量覆盖配置（v3.0.5+）  
- **持久化策略**：挂载本地目录`./config`（只读）和`./output`（可写）确保配置和数据持久化，避免容器重启后数据丢失  
- **容器启动**：使用官方推荐的`docker run`命令，配置环境变量设置推送渠道和定时任务，容器名为`trend-radar`（带连字符）  
- **功能验证**：通过输出文件检查、日志检查、推送测试三步验证部署有效性，确保核心功能正常  


### 后续建议
- **深入配置优化**：根据使用场景调整报告模式（`daily`/`current`/`incremental`）和推送时间窗口，提升热点匹配精准度  
- **环境变量配置**：充分利用环境变量覆盖机制（v3.0.5+），在NAS或Docker管理界面中直接配置推送渠道，无需修改配置文件  
- **高级功能探索**：尝试v3.0.0+新增的AI分析功能，通过MCP协议对接Claude、Cursor等客户端，实现自然语言查询热点趋势  
- **监控体系建设**：通过检查`output`目录文件生成时间和容器日志监控服务状态，设置异常告警（如抓取失败、推送延迟）  
- **版本管理**：定期关注[轩辕镜像标签页面](https://xuanyuan.cloud/r/wantcat/trendradar/tags)，及时更新镜像以获取新功能与安全修复  
- **docker-compose部署**：生产环境推荐使用docker-compose方式部署，便于管理和配置环境变量，参考[项目官方GitHub仓库](https://github.com/sansan0/TrendRadar)中的docker-compose配置示例  


通过本文档的部署方案，用户可在30分钟内完成TRENDRADAR的容器化部署，实现多平台热点的一站式聚合与推送，有效提升信息获取效率。如需进一步定制化配置，可参考项目官方GitHub仓库或[轩辕镜像文档](https://xuanyuan.cloud/r/wantcat/trendradar)获取更多技术细节。


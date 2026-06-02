---
image: whyour/qinglong
description: "一款支持TypeScript、JavaScript、Python3及Shell多种编程语言的定时任务管理面板，可帮助用户高效创建、配置和监控各类定时任务，满足不同开发场景下的自动化需求，提升任务执行的稳定性与管理效率。"
source: https://xuanyuan.cloud/zh/r/whyour/qinglong
canonical: https://xuanyuan.cloud/zh/r/whyour/qinglong
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/whyour/qinglong" title="whyour/qinglong Docker 镜像中文简介、标签列表与拉取命令">whyour/qinglong — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/whyour/qinglong" title="whyour/qinglong Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/whyour/qinglong</a>

# 青龙：定时任务管理平台


## 项目介绍  
青龙（Qinglong）是一款支持多脚本语言的定时任务管理平台，可便捷管理脚本、环境变量及任务调度，适用于自动化脚本运行场景。支持 Python3、JavaScript、Shell、TypeScript 等语言，提供在线管理、日志查看、秒级任务设置等功能，兼容多终端操作。


## 核心特性  
- **多语言支持**：兼容 Python3、JavaScript、Shell、TypeScript 脚本  
- **全在线管理**：支持脚本、环境变量、配置文件的在线编辑与维护  
- **日志可视化**：实时查看任务运行日志，便于问题排查  
- **精细化调度**：支持秒级任务设置，满足高频调度需求  
- **系统通知**：集成系统级通知功能，任务状态及时触达  
- **多模式适配**：支持深色模式及移动端操作  


## 安装方式  

### Docker（推荐）  
提供 `latest`（基于 Alpine）和 `debian`（基于 Debian-slim）两种镜像。若需依赖 Alpine 不支持的库，建议使用 `debian` 镜像：  
```bash
# 拉取最新镜像（Alpine 基础）
docker pull whyour/qinglong:latest  
# 拉取 Debian 基础镜像（依赖兼容性更好）
docker pull whyour/qinglong:debian  
```

### npm 安装  
支持 Debian/Ubuntu/CentOS/Alpine 系统，需预先安装 Node.js 和 Python3：  
```bash
npm i @whyour/qinglong  
```


## 内置命令  

### task 命令（任务执行）  
用于手动触发或配置任务执行，支持多种运行模式：  
```bash
# 按顺序执行，若设置随机延迟则延迟运行  
task <file_path>  

# 立即顺序执行（无视延迟），前台输出日志并记录到文件  
task <file_path> now  

# 并发执行（无视延迟），直接记录日志，支持指定账号  
task <file_path> conc <env_name> <account_number>(可选)  

# 指定账号立即执行（无视延迟）  
task <file_path> desi <env_name> <account_number>  

# 设置任务超时时间（单位：秒）  
task -m <max_time> <file_path>  

# 向脚本传递参数（-- 后为脚本参数）  
task <file_path> -- -u username -p password  
```

### ql 命令（系统管理）  
用于平台维护、脚本管理及环境修复：  
```bash
# 更新并重启青龙  
ql update  

# 运行自定义脚本 extra.sh  
ql extra  

# 添加单个脚本（从 URL 拉取）  
ql raw <file_url>  

# 从仓库拉取指定脚本（支持白/黑名单过滤）  
ql repo <repo_url> <whitelist> <blacklist> <dependence> <branch>  

# 删除指定天数前的日志  
ql rmlog <days>  

# 启动机器人  
ql bot  

# 检测并修复青龙环境  
ql check  

# 重置登录错误次数  
ql resetlet  

# 禁用两步登录  
ql resettfa  
```

#### 命令参数说明  
| 参数名         | 说明                                                                 |
|----------------|----------------------------------------------------------------------|
| file_url       | 单个脚本的网络地址                                                   |
| repo_url       | 脚本仓库的 Git 地址                                                 |
| whitelist      | 拉取仓库时的白名单（脚本路径需包含的字符串）                         |
| blacklist      | 拉取仓库时的黑名单（脚本路径需排除的字符串）                         |
| dependence     | 仓库依赖文件（从仓库复制到 scripts 目录，不受黑名单限制）             |
| branch         | 拉取仓库的分支名称                                                   |
| days           | 保留日志的天数                                                       |
| file_path      | 任务执行的脚本文件路径                                               |
| env_name       | 并发或指定执行时所需的环境变量名                                     |


## 部署步骤  

### Docker 部署（推荐）  
```bash
docker run -dit \
  -v $PWD/ql/data:/ql/data \  # 挂载数据目录到当前路径下的 ql/data  
  -p 5700:5700 \              # 端口映射（容器内默认 5700，若修改 QlPort 需同步调整）  
  -e QlBaseUrl="/" \          # 部署路径（默认根路径，如需子路径可修改，如 /ql）  
  -e QlPort="5700" \          # 服务端口（默认 5700，与端口映射保持一致）  
  --name qinglong \           # 容器名称  
  --hostname qinglong \       # 容器主机名  
  --restart unless-stopped \  # 自动重启策略（异常退出时重启）  
  whyour/qinglong:latest      # 使用的镜像（latest 或 debian）  
```

### Docker-compose 部署  
```bash
# 安装 docker-compose（若未安装）  
curl -L [] -s`-`uname -m` -o /usr/local/bin/docker-compose  
chmod +x /usr/local/bin/docker-compose  

# 创建目录并拉取配置文件  
mkdir qinglong && cd qinglong  
wget []  

# 启动服务  
docker-compose up -d  
# 停止服务  
docker-compose down  
```

### Podman 部署  
```bash
podman run -dit \
  --network bridge \          # 使用桥接网络  
  -v $PWD/ql/data:/ql/data \  # 挂载数据目录  
  -p 5700:5700 \              # 端口映射  
  -e QlBaseUrl="/" \          # 部署路径  
  -e QlPort="5700" \          # 服务端口  
  --name qinglong \           # 容器名称  
  --hostname qinglong \       # 容器主机名  
  docker.io/whyour/qinglong:latest  # 镜像地址  
```

### 本地部署  
需纯净系统环境，手动安装 Node.js 和 Python3：  
```bash
# 全局安装青龙  
npm install -g @whyour/qinglong  

# 启动时按提示设置环境变量（数据目录和工作目录）  
export QL_DIR="/path/to/ql"  
export QL_DATA_DIR="/path/to/ql/data"  

# 启动服务  
qinglong  
```


## 开发环境搭建  
```bash
# 克隆代码仓库  
git clone [邮箱已删除]:whyour/qinglong.git  
cd qinglong  

# 复制环境变量模板并配置  
cp .env.example .env  

# 安装依赖（推荐使用 pnpm）  
npm install -g pnpm@8.3.1  
pnpm install  

# 启动开发服务  
pnpm start  
```
浏览器访问 `[] 即可打开开发环境界面。


## 相关链接  
- **演示地址**：[]  
- **反馈渠道**：[]  
- ** 频道**：  
- **打赏开发者**：[]  


## 名称由来  
青龙，又名苍龙，是中国传统文化中“天之四灵”之一，与白虎、朱雀、玄武并称四象。按五行学说，青龙代表东方，属木，象征春季，对应八卦中的震卦。《后汉书·律历志下》记载：“日周于天，一寒一暑，四时备成，万物毕改，摄提迁次，青龙移辰，谓之岁。”  

在二十八宿中，青龙是东方七宿（角、亢、氐、房、心、尾、箕）的总称，道教中称“孟章”，与白虎同为守护神。平台以此命名，寓意如青龙般精准调度、生生不息。

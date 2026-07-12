---
image: hitokoto/api
description: "Hitokoto官方一言接口程序，基于Teng-koa实现，提供高扩展性，支持请求统计、JS回调、多进程运行、遥测等功能，适用于构建可扩展的一言API服务。"
source: https://xuanyuan.cloud/zh/r/hitokoto/api
canonical: https://xuanyuan.cloud/zh/r/hitokoto/api
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hitokoto/api" title="hitokoto/api Docker 镜像中文简介、标签列表与拉取命令">hitokoto/api 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Hitokoto API

## 镜像概述和主要用途
本项目是基于Teng-koa实现的一言接口程序。相较于单纯的一言程序，此框架提供了扩展性，可用于搭建具备请求统计、多格式返回、多进程运行等功能的一言API服务。项目致力于框架的可维护性与可扩展性，未来计划通过多版本重构进一步优化性能。

## 核心功能和特性
相较于v0（PHP版本），新增以下功能：
- 请求统计
- 支持返回JS回调函数
- 支持length区间返回
- 返回JS格式支持
- 支持GBK编码
- 开源数据集
- 支持遥测
- 支持多进程运行
- A/B无感知更新数据
- 官方扩展（如网易云音乐接口）

## 外部依赖
- Redis

## 日志说明
- 调试日志、警告信息输出至`Console`
- 错误日志仅保存`error`级别，文件路径：`./data/logs/hitokoto_error.log`

## 使用方法和配置说明

### 常规使用
需预先配置Node.js环境（>=16.x）及`yarn`（注：本项目使用Yarn v2，需将Yarn版本更新至v1.22.4或更高，不支持NPM、CNPM、PNPM管理依赖）。

1. 克隆仓库：
   ```bash
   git clone https://github.com/hitokoto-osc/hitokoto-api.git your_workdir
   ```
2. 进入工作目录：
   ```bash
   cd your_workdir
   ```
3. 安装依赖：
   ```bash
   yarn workspaces focus --production
   ```
4. 复制并配置文件：
   ```bash
   cp config.example.yml ./data/config.yml
   ```
   根据需求修改`./data/config.yml`配置
5. 启动程序：
   ```bash
   yarn start
   ```

### 容器使用
#### 常规容器部署（需预先安装Redis）
```bash
docker run \
-v /path/to/your/data/dir:/usr/src/app/data \
--network host \
docker.xuanyuan.run/hitokoto/api
```
> 注：使用共享网络模式，需确保8000端口未被占用

#### Docker Compose部署（含Redis依赖）
可通过项目提供的docker-compose配置文件部署，自动集成Redis依赖（需自行下载配置文件）。

## 性能测试
以下为参考性能数据，测试环境：Windows 10 20H2 x64（WSL 1），启用8个Workers（单机测试，非Ubuntu真机环境，数据仅供参考）：

```bash
$ node -v
v16.1.0
$ wrk -t8 -c1000 -d10s --latency http://127.0.0.1:8000
Running 10s test @ http://127.0.0.1:8000
  8 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    85.06ms   18.51ms 180.85ms   74.85%
    Req/Sec     1.47k   222.90     2.30k    82.00%
  Latency Distribution
     50%   87.66ms
     75%   95.61ms
     90%  104.91ms
     99%  124.37ms
  117210 requests in 10.06s, 125.89MB read
Requests/sec:  11650.18
Transfer/sec:     12.51MB
```

## 关于贡献
可参考开发者文档了解框架基本运作机理，便于开发扩展功能（如新增音乐接口等）。项目团队持续基于Alinode、DeepScan、CodeClimate分析结果优化框架，计划通过多版本重构解决历史问题。

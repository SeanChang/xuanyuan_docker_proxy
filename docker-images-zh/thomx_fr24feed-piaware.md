---
image: thomx/fr24feed-piaware
description: "整合dump1090、Fr24feed、FlightAware、ADSB Exchange和Plane Finder的Docker镜像，用于向FlightRadar24、FlightAware等平台提供航班数据，支持通过Web界面在地图上查看飞机位置，需配合RTL-SDR USB接收器使用。"
source: https://xuanyuan.cloud/zh/r/thomx/fr24feed-piaware
canonical: https://xuanyuan.cloud/zh/r/thomx/fr24feed-piaware
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/thomx/fr24feed-piaware" title="thomx/fr24feed-piaware Docker 镜像中文简介、标签列表与拉取命令">thomx/fr24feed-piaware 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Fr24feed、FlightAware与dump1090整合Docker镜像

![构建状态](https://github.com/Thom-x/docker-fr24feed-piaware-dump1090/workflows/Docker/badge.svg?branch=master)
![GitHub issues](https://img.shields.io/github/issues/Thom-x/docker-fr24feed-piaware-dump1090)

![最新镜像版本](https://img.shields.io/docker/v/thomx/fr24feed-piaware?sort=semver)
![Docker镜像大小（最新语义化版本）](https://img.shields.io/docker/image-size/thomx/fr24feed-piaware)

![许可证](https://img.shields.io/github/license/Thom-x/docker-fr24feed-piaware-dump1090)

> 请考虑关注本项目作者[Thom-x](https://github.com/Thom-x)，并为项目点赞以表示支持。

Fr24feed、FlightAware和dump1090的Docker镜像。

向FlightRadar24和FlightAware提供数据，让您能在地图上查看飞机位置。

---

![dump1090 Web应用截图](https://raw.githubusercontent.com/Thom-x/docker-fr24feed-piaware-dump1090/master/screenshot.png)

# 系统要求

- Docker
- RTL-SDR DVBT USB加密狗（RTL2832）

# 快速开始

运行以下命令：

```
docker run -d -p 8080:8080 -p 8754:8754 \
	--device=/dev/bus/usb:/dev/bus/usb \
	-v "/etc/localtime:/etc/localtime:ro" \
	-e "FR24FEED_FR24KEY=我的分享密钥" \
	-e "PIAWARE_FEEDER_DASH_ID=我的 feeder ID" \
	-e "HTML_SITE_LAT=我的站点纬度" \
	-e "HTML_SITE_LON=我的站点经度" \
	-e "HTML_SITE_NAME=我的站点名称" \
	-e "PANORAMA_ID=我的全景ID" \
	-e "LAYERS_OWM_API_KEY=我的OWM API密钥" \
	-e "SERVICE_ENABLE_ADSBEXCHANGE=true" \
	-e "ADSBEXCHANGE_UUID=我的UUID" \
	-e "ADSBEXCHANGE_STATION_NAME=我的站点名称" \
	-e "MLAT_EXACT_LAT=我的精确站点纬度" \
	-e "MLAT_EXACT_LON=我的精确站点经度" \
	-e "MLAT_ALTITUDE_MSL_METERS=我的站点海拔高度（米，MSL）" \
	-e "SERVICE_ENABLE_PLANEFINDER=true" \
	-e "PLANEFINDER_SHARECODE=分享码" \
	--tmpfs /run:exec,size=32M \
	--tmpfs /planefinder/log:exec,size=32M \
	--tmpfs /usr/lib/fr24/public_html/data:size=32M \
	docker.xuanyuan.run/thomx/fr24feed-piaware
```

访问 http://docker主机IP:8080 查看接收数据的地图，访问 http://docker主机IP:8754 查看FR24 Feeder配置面板。

注意：如果不需要某个功能，可从命令中移除对应的环境变量，例如 `-e "PANORAMA_ID=我的全景ID"` 或 `-e "LAYERS_OWM_API_KEY=我的OWM API密钥"`。  
注意：`--tmpfs` 用于避免在硬盘/SD卡上写入数据。  
注意：`-v "/etc/localtime:/etc/localtime:ro"` 对MLAT功能是必需的，否则可能出现时间同步问题。

# 配置

## 通用配置

要禁用某个服务，可添加以下环境变量：

| 环境变量                          | 值     | 描述                     | 默认值 |
|-----------------------------------|--------|--------------------------|--------|
| `SERVICE_ENABLE_DUMP1090`         | `false`| 禁用dump1090服务         | `true` |
| `SERVICE_ENABLE_PIAWARE`          | `false`| 禁用piaware服务          | `true` |
| `SERVICE_ENABLE_FR24FEED`         | `false`| 禁用fr24feed服务         | `true` |
| `SERVICE_ENABLE_HTTP`             | `false`| 禁用HTTP服务             | `true` |
| `SERVICE_ENABLE_IMPORT_OVER_NETCAT` | `false`| 禁用通过netcat导入数据 | `false` |
| `SERVICE_ENABLE_ADSBEXCHANGE`     | `false`| 禁用ADSB Exchange数据馈送 | `false` |
| `SERVICE_ENABLE_PLANEFINDER`      | `false`| 禁用Plane Finder数据馈送 | `false` |

示例：`-e "SERVICE_ENABLE_HTTP=false"`

## FlightAware配置

在 https://flightaware.com/account/join/ 注册账号。

运行以下命令：

```
docker run -it --rm \
	-e "SERVICE_ENABLE_DUMP1090=false" \
	-e "SERVICE_ENABLE_HTTP=false" \
	-e "SERVICE_ENABLE_FR24FEED=false" \
	-e "SERVICE_ENABLE_PIAWARE=false" \
	docker.xuanyuan.run/thomx/fr24feed-piaware /usr/bin/piaware -plainlog
```

容器启动后，会显示feeder ID，请记录下来。等待5分钟后，访问 https://fr.flightaware.com/adsb/piaware/claim（使用Docker主机的IP），认领接收器，然后退出容器。

添加环境变量 `PIAWARE_FEEDER_DASH_ID` 并设置为您的feeder ID。

| 环境变量                  | 配置属性          | 默认值   |
|---------------------------|-------------------|----------|
| `PIAWARE_FEEDER_DASH_ID`  | `feeder-id（必需）`| 空       |
| `PIAWARE_RECEIVER_DASH_TYPE` | `receiver-type` | `other`  |
| `PIAWARE_RECEIVER_DASH_HOST` | `receiver-host` | `127.0.0.1` |
| `PIAWARE_RECEIVER_DASH_PORT` | `receiver-port` | `30005`  |

示例：`-e "PIAWARE_RECEIVER_DASH_TYPE=other"`

## FlightRadar24配置

运行以下命令：

```
docker run -it --rm \
	-e "SERVICE_ENABLE_DUMP1090=false" \
	-e "SERVICE_ENABLE_HTTP=false" \
	-e "SERVICE_ENABLE_PIAWARE=false" \
	-e "SERVICE_ENABLE_FR24FEED=false" \
	docker.xuanyuan.run/thomx/fr24feed-piaware /bin/bash
```

然后执行：`/fr24feed/fr24feed/fr24feed --signup` 并按照提示操作，技术步骤的答案不影响，只需记录最后的分享密钥。

最后运行 `cat /etc/fr24feed.ini` 查看分享密钥，然后退出容器。

添加环境变量 `FR24FEED_FR24KEY` 并设置为您的分享密钥。

| 环境变量                          | 配置属性                | 默认值           |
|-----------------------------------|-------------------------|------------------|
| `FR24FEED_RECEIVER`               | `receiver`              | `beast-tcp`      |
| `FR24FEED_FR24KEY`                | `fr24key（必需）`       | 空               |
| `FR24FEED_HOST`                   | `host`                  | `127.0.0.1:30005`|
| `FR24FEED_BS`                     | `bs`                    | `no`             |
| `FR24FEED_RAW`                    | `raw`                   | `no`             |
| `FR24FEED_LOGMODE`                | `logmode`               | `1`              |
| `FR24FEED_LOGPATH`                | `logpath`               | `/tmp`           |
| `FR24FEED_MLAT`                   | `mlat`                  | `yes`            |
| `FR24FEED_MLAT_DASH_WITHOUT_DASH_GPS` | `mlat-without-gps` | `yes`            |

示例：`-e "FR24FEED_FR24KEY=0123456789"`

## ADS-B Exchange配置

通过 https://www.adsbexchange.com/myip/gen-uuid/ 生成UUID，添加环境变量 `ADSBEXCHANGE_UUID` 并设置为该UUID。多接收器时，每个接收器需使用不同UUID。

添加环境变量 `SERVICE_ENABLE_ADSBEXCHANGE` 并设为 `true`。

| 环境变量                  | 配置属性                | 默认值   |
|---------------------------|-------------------------|----------|
| `SERVICE_ENABLE_ADSBEXCHANGE` | 启用此数据馈送客户端 | `false`  |
| `ADSBEXCHANGE_UUID`       | `uuid（必需）`          | 空       |
| `ADSBEXCHANGE_STATION_NAME` | 站点名称           | 空       |
| `ADSBEXCHANGE_MLAT`       | `mlat`                  | `true`   |

配置MLAT坐标以确保ADSB Exchange的MLAT功能正常（见下文MLAT坐标部分）。若不想提供精确坐标，可将 `ADSBEXCHANGE_MLAT` 设为 `false`（此时不会获取MLAT结果，也不会贡献MLAT数据）。

添加环境变量 `ADSBEXCHANGE_STATION_NAME`，用于MLAT地图/同步状态。可在 https://map.adsbexchange.com/mlat-map/ 搜索站点名称检查MLAT是否正常工作（MLAT地图标记会随机偏移以保护隐私）。

ADSB Exchange Anywhere地图可通过以下链接访问：https://www.adsbexchange.com/api/feeders/?feed=我的UUID

示例：`-e "SERVICE_ENABLE_ADSBEXCHANGE=true" -e "ADSBEXCHANGE_UUID=8398f51e-a61d-11ec-b909-0242ac120002" -e "ADSBEXCHANGE_STATION_NAME=我的站点"`

## MLAT精确坐标配置

从以下网站获取精确坐标和海拔高度（米，MSL）：

- https://www.freemaptools.com/elevation-finder.htm
- https://www.mapcoordinates.net/en

坐标误差需控制在约10米内以确保MLAT精度。

| 环境变量                  | 配置属性                | 默认值   |
|---------------------------|-------------------------|----------|
| `MLAT_EXACT_LAT`          | 十进制纬度              | 空       |
| `MLAT_EXACT_LON`          | 十进制经度              | 空       |
| `MLAT_ALTITUDE_MSL_METERS` | 海拔高度（米，MSL）    | 空       |

## Plane Finder配置

首次使用需获取PlaneFinder分享码。

运行临时容器启动 `pfclient` 配置向导：

```
docker run -it --rm \
	-p 30053:30053 \
	-e "SERVICE_ENABLE_DUMP1090=false" \
	-e "SERVICE_ENABLE_HTTP=false" \
	-e "SERVICE_ENABLE_PIAWARE=false" \
	-e "SERVICE_ENABLE_FR24FEED=false" \
	docker.xuanyuan.run/thomx/fr24feed-piaware /planefinder/pfclient
```

容器启动后，会显示类似 `2020-04-11 06:45:25.823307 [-] We were unable to locate a configuration file and have entered configuration mode by default. Please visit: http://172.22.7.12:30053 to complete configuration.` 的消息，在浏览器中访问 `http://docker主机IP:30053`（替换为Docker主机IP），完成配置向导并保存生成的分享码。

添加环境变量 `SERVICE_ENABLE_PLANEFINDER` 并设为 `true`。

| 环境变量                | 配置属性                  | 默认值   |
|-------------------------|---------------------------|----------|
| `PLANEFINDER_SHARECODE` | 生成的分享码（必需）      | 空       |

示例：`-e "SERVICE_ENABLE_PLANEFINDER=true" -e "PLANEFINDER_SHARECODE=65dsfsd56f"`

## 添加自定义属性

**注意**：可通过添加以 `PIAWARE_...` 或 `FR24FEED_...` 开头的环境变量，向piaware或fr24feed配置文件添加任何属性。

示例：

| 环境变量                          | 配置属性        | 值      | 配置文件         |
|-----------------------------------|-----------------|---------|------------------|
| `FR24FEED_TEST=value`             | `test`          | `value` | `fr24feed.init`  |
| `FR24FEED_TEST_DASH_TEST=value2`  | `test-test`     | `value2`| `fr24feed.init`  |
| `PIAWARE_TEST=value`              | `test`          | `value` | `piaware.conf`   |

## Dump1090与Web界面

| 环境变量                                  | 默认值           | 描述                                                                 |
|-------------------------------------------|------------------|----------------------------------------------------------------------|
| `HTML_SITE_LAT`                           | `45.0`           | 站点纬度                                                             |
| `HTML_SITE_LON`                           | `9.0`            | 站点经度                                                             |
| `HTML_SITE_NAME`                          | `My Radar Site`  | 站点名称                                                             |
| `HTML_DEFAULT_TRACKER`                    | `FlightAware`    | 默认航班追踪网站，可选 `FlightAware` 或 `Flightradar24`              |
| `HTML_RECEIVER_STATS_PAGE_FLIGHTAWARE`    | 空               | FlightAware接收器统计页面URL，通常为https://flightaware.com/adsb/stats/user/ |
| `HTML_RECEIVER_STATS_PAGE_FLIGHTRADAR24`  | 空               | Flightradar24接收器统计页面URL，通常为https://www.flightradar24.com/account/feed-stats/?id=<ID> |
| `HTML_FR24_FEEDER_STATUS_PAGE`            | 空               | 本地FR24 Feeder状态页面URL，通常为http://<docker主机IP>:8754/（取决于启动时指定的端口） |
| `DUMP1090_ADDITIONAL_ARGS`                | 空               | dump1090额外参数，例如：`--json-location-accuracy 2`                 |

示例：`-e "HTML_SITE_NAME=我的站点"`

## DUMP1090转发

| 环境变量                          | 默认值   | 描述                                                             |
|-----------------------------------|----------|------------------------------------------------------------------|
| `SERVICE_ENABLE_IMPORT_OVER_NETCAT` | `false`  | 启用netcat转发远程dump1090服务器的beast输出到本地dump1090的beast输入 |
| `DUMP1090_LOCAL_PORT`             | 空       | 需与 `DUMP1090_ADDITIONAL_ARGS` 中的 `--net-bi-port` 指定的端口相同 |
| `DUMP1090_REMOTE_HOST`            | 空       | 远程dump1090服务器IP                                             |
| `DUMP1090_REMOTE_PORT`            | 空       | 远程dump1090服务器 `--net-bo-port` 参数指定的端口                 |

## RTL_TCP转发

**警告**：此类转发占用大量带宽，WiFi环境下可能不稳定。

| 环境变量              | 默认值   | 描述                                                                 |
|-----------------------|----------|----------------------------------------------------------------------|
| `RTL_TCP_OVER_NETCAT` | `false`  | 结合dump1090和netcat从rtl_tcp服务器获取数据（约需35-40Mbit/s带宽）。示例RTL_TCP命令：`./rtl_tcp -a 0.0.0.0 -f 1090000000 -s 2400000 -p 30005 -P 28 -g -10` |
| `RTL_TCP_REMOTE_HOST` | 空       | rtl_tcp服务器IP                                                     |
| `RTL_TCP_REMOTE_PORT` | 空       | rtl_tcp服务器端口                                                   |

## 地形限制环（可选）

无需此功能可忽略。

在 http://www.heywhatsthat.com 创建接收器位置的全景图。

| 环境变量              | 默认值       | 描述                                  |
|-----------------------|--------------|---------------------------------------|
| `PANORAMA_ID`         |              | 全景ID                                |
| `PANORAMA_ALTS`       | `1000,10000` | 逗号分隔的海拔高度列表（米）          |

注意：全景ID对应全景图URL中的 `id` 参数（http://www.heywhatsthat.com/?view=XXXX）。若不想每次启动容器时下载限制数据，可

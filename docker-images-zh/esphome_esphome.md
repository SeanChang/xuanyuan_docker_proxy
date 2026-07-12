---
image: esphome/esphome
description: "ESPHome Docker镜像用于通过简单配置文件为ESP8266、ESP32等物联网开发板生成定制固件，简化智能家居等物联网设备的编程与部署。"
source: https://xuanyuan.cloud/zh/r/esphome/esphome
canonical: https://xuanyuan.cloud/zh/r/esphome/esphome
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/esphome/esphome" title="esphome/esphome Docker 镜像中文简介、标签列表与拉取命令">esphome/esphome 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ESPHome Docker 镜像文档


## 镜像概述和主要用途

ESPHome 是一个开源工具，用于为 ESP8266、ESP32 等 ESP 系列微控制器快速构建自定义固件。通过 Docker 镜像部署 ESPHome，可实现环境隔离、跨平台一致运行，简化固件开发、编译与设备管理流程。该镜像主要用途包括：  
- 为 ESP 设备生成定制化固件  
- 通过 YAML 配置文件定义设备行为（如传感器数据采集、执行器控制）  
- 支持固件的本地或 OTA（空中）更新  
- 与 Home Assistant 等智能家居系统无缝集成  


## 核心功能和特性

### 核心功能  
- **YAML 配置驱动**：无需编写代码，通过简洁的 YAML 文件定义设备逻辑  
- **自动代码生成**：根据 YAML 配置自动生成 Arduino/ESP-IDF 代码，降低开发门槛  
- **OTA 更新**：支持通过 Wi-Fi 远程更新设备固件，无需物理接触设备  
- **多平台支持**：兼容 ESP8266、ESP32、ESP32-C3/C6/S2/S3 等主流 ESP 芯片  
- **丰富组件库**：内置传感器（温湿度、光照、PIR 等）、执行器（继电器、LED 等）、通信协议（MQTT、HTTP 等）支持  

### 关键特性  
- **Home Assistant 集成**：自动发现设备并创建实体，支持状态同步与控制  
- **实时日志**：设备运行日志实时输出，便于调试  
- **依赖管理**：自动处理 Arduino 库依赖，无需手动配置  
- **安全机制**：支持固件加密、OTA 密码验证，保障设备安全  


## 使用场景和适用范围

### 适用用户  
- 智能家居爱好者：构建自定义传感器、智能开关、环境监测设备  
- DIY 电子开发者：快速实现 ESP 设备功能原型，无需深入底层开发  
- 物联网项目部署者：批量管理 ESP 设备固件，支持规模化配置更新  

### 典型场景  
- 温湿度监测节点（搭配 DHT11/DHT22 传感器）  
- 智能照明控制（PWM 调光、RGB 灯带控制）  
- 门窗状态监测（磁性传感器 + Wi-Fi 上报）  
- 能耗监测设备（电流/电压传感器数据采集）  
- 工业环境监控（温湿度、气体浓度等多参数监测）  


## 使用方法和配置说明

### 前提条件  
- 已安装 Docker Engine（20.10+ 版本推荐）  
- 本地设备可访问 ESP 微控制器（通过 USB 串口或 Wi-Fi，视更新方式而定）  
- 本地目录用于存放 ESPHome 配置文件（如 `./esphome`）  


### Docker 基础使用（`docker run`）

#### 1. 首次运行（生成配置文件）  
```bash
docker run -it --rm \
  -v "$(pwd)/esphome:/config" \
  --device=/dev/ttyUSB0:/dev/ttyUSB0 \  # 若通过 USB 连接 ESP 设备，需映射串口
  esphome/esphome wizard my_device.yaml
```
- `wizard`：启动配置向导，生成初始 `my_device.yaml` 文件（需输入设备名称、ESP 平台、Wi-Fi 信息等）  
- `-v "$(pwd)/esphome:/config"`：挂载本地 `esphome` 目录到容器内，用于持久化配置文件  


#### 2. 编译并上传固件（USB 模式）  
```bash
docker run -it --rm \
  -v "$(pwd)/esphome:/config" \
  --device=/dev/ttyUSB0:/dev/ttyUSB0 \
  docker.xuanyuan.run/esphome/esphome run my_device.yaml
```
- `run`：编译固件并通过 USB 上传到设备（需确保设备已通过 USB 连接主机）  


#### 3. 编译并 OTA 更新（Wi-Fi 模式）  
若设备已联网，可通过 OTA 远程更新：  
```bash
docker run -it --rm \
  -v "$(pwd)/esphome:/config" \
  docker.xuanyuan.run/esphome/esphome run my_device.yaml --device my_device.local
```
- `--device my_device.local`：指定设备的网络地址（需与设备 YAML 中 `name` 字段一致）  


### Docker Compose 配置

创建 `docker-compose.yml` 实现持久化部署，支持 Web 界面管理：  
```yaml
version: '3'
services:
  esphome:
    image: docker.xuanyuan.run/esphome/esphome
    container_name: esphome
    volumes:
      - ./esphome:/config  # 配置文件目录
      - /etc/localtime:/etc/localtime:ro  # 同步主机时区
    ports:
      - "6052:6052"  # Web 界面端口
    restart: unless-stopped
    environment:
      - USERNAME=admin  # Web 界面登录用户名（可选）
      - PASSWORD=your_secure_password  # Web 界面登录密码（可选）
      - TZ=Asia/Shanghai  # 时区设置
```
启动服务：  
```bash
docker-compose up -d
```
访问 `http://<主机IP>:6052` 打开 ESPHome Web 界面，可通过图形化界面管理配置文件、编译和上传固件。


### 配置文件结构与示例

ESPHome 设备配置通过 YAML 文件定义，核心结构如下：  
```yaml
esphome:
  name: my_device  # 设备名称（用于网络识别，如 my_device.local）
  platform: ESP32  # 芯片平台（ESP8266/ESP32/ESP32-C3 等）
  board: nodemcu-32s  # 开发板型号（参考 ESPHome 文档支持列表）

wifi:
  ssid: "YourWiFiSSID"  # Wi-Fi 名称
  password: "YourWiFiPassword"  # Wi-Fi 密码
  ap:  # 若 Wi-Fi 连接失败，启动热点
    ssid: "my_device_fallback"
    password: "fallback_password"

# OTA 更新配置
ota:
  password: "ota_update_password"  # OTA 更新密码（建议设置）

# 日志配置（输出到串口/Web 界面）
logger:

# Home Assistant 集成（自动发现设备）
api:

# Web 服务器（可选，提供设备状态页面）
web_server:
  port: 80

# 传感器示例（DHT22 温湿度传感器）
sensor:
  - platform: dht
    pin: D4  # 传感器连接引脚
    temperature:
      name: "Room Temperature"  # Home Assistant 中显示的名称
    humidity:
      name: "Room Humidity"
    update_interval: 60s  # 数据更新间隔
```


## 配置参数与环境变量

### 环境变量（Docker 运行时）  
| 变量名       | 说明                                  | 默认值       |
|--------------|---------------------------------------|--------------|
| `USERNAME`   | Web 界面登录用户名（启用认证时必填）  | 无           |
| `PASSWORD`   | Web 界面登录密码（启用认证时必填）    | 无           |
| `TZ`         | 时区（如 `Asia/Shanghai`）            | `UTC`        |
| `LOG_LEVEL`  | 日志级别（`DEBUG`/`INFO`/`WARNING`） | `INFO`       |


### 核心配置参数（YAML 文件）  
| 参数路径               | 说明                                  | 示例值                |
|------------------------|---------------------------------------|-----------------------|
| `esphome.name`         | 设备网络名称                          | `my_device`           |
| `esphome.platform`     | 芯片平台                              | `ESP32`               |
| `wifi.ssid`            | Wi-Fi 名称                            | `"YourWiFiSSID"`      |
| `ota.password`         | OTA 更新密码                          | `"secure_ota_pass"`   |
| `sensor[].platform`    | 传感器类型（如 `dht`/`bme280`）       | `"dht"`               |
| `sensor[].pin`         | 传感器连接引脚                        | `D4`                  |


## 参考链接  
- [ESPHome 官方文档](https://esphome.io/)  
- [ESPHome GitHub 仓库](https://github.com/esphome/esphome)  
- [设备支持列表](https://esphome.io/components/)  
- [问题跟踪](https://github.com/esphome/issues/issues)  
- [功能请求](https://github.com/esphome/feature-requests/issues)

---
image: tjhowse/modbus4mqtt
description: "Modbus TCP与MQTT之间的桥接工具，支持通过YAML配置实现数据转换与转发，稳定可靠，适用于工业物联网等场景下不同协议设备的数据互通。"
source: https://xuanyuan.cloud/zh/r/tjhowse/modbus4mqtt
canonical: https://xuanyuan.cloud/zh/r/tjhowse/modbus4mqtt
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tjhowse/modbus4mqtt" title="tjhowse/modbus4mqtt Docker 镜像中文简介、标签列表与拉取命令">tjhowse/modbus4mqtt 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# modbus4mqtt Docker镜像文档

## 镜像概述

modbus4mqtt是一款轻量级的协议转换工具，作为Modbus TCP设备与MQTT broker之间的桥接器，实现两类协议设备的数据双向互通。通过简洁的YAML配置文件定义数据映射规则，支持Modbus寄存器数据采集、格式转换及MQTT消息转发，同时具备可靠的错误处理和自动重连机制，适用于各类需要整合Modbus设备与MQTT生态的场景。

## 核心功能与特性

- **协议桥接**：同时支持Modbus TCP客户端和MQTT客户端功能，实现双向数据流转
- **灵活配置**：通过YAML文件定义Modbus设备参数、寄存器映射关系及MQTT主题规则
- **数据转换**：支持寄存器数据的单位转换、缩放、偏移等自定义处理
- **高可靠性**：内置Modbus连接超时重试、MQTT自动重连及断线缓存机制
- **轻量设计**：资源占用低，可在嵌入式设备或边缘节点稳定运行
- **日志监控**：详细的日志输出，便于调试和问题排查

## 使用场景

- **工业物联网(IIoT)**：将PLC、传感器等Modbus TCP设备数据接入MQTT-based工业数据平台
- **智能家居**：整合Modbus协议的智能电表、温控器等设备数据到MQTT智能家居系统
- **数据采集**：在环境监测、能源管理等系统中，实现不同协议设备的数据统一汇聚
- **远程监控**：通过MQTT实现对Modbus设备的远程状态监控与控制指令下发

## 使用方法

### 前提条件

- 已安装Docker或Docker Compose
- 可访问的Modbus TCP设备（IP地址、端口、寄存器信息已知）
- 可访问的MQTT broker（地址、端口、认证信息已知）
- 自定义的YAML配置文件（推荐命名为`config.yaml`）

### Docker Run 示例

```bash
docker run -d \
  --name modbus4mqtt \
  -v /path/to/your/config.yaml:/app/config.yaml \
  -e LOG_LEVEL=info \
  docker.xuanyuan.run/tjhowse/modbus4mqtt
```

### Docker Compose 示例

创建`docker-compose.yml`文件：

```yaml
version: '3'
services:
  modbus4mqtt:
    image: docker.xuanyuan.run/tjhowse/modbus4mqtt
    container_name: modbus4mqtt
    restart: unless-stopped
    volumes:
      - ./config.yaml:/app/config.yaml  # 挂载本地配置文件
    environment:
      - LOG_LEVEL=info  # 日志级别：debug, info, warn, error
    networks:
      - iot_network  # 如需与其他服务（如MQTT broker）同网络

networks:
  iot_network:
    driver: bridge
```

启动服务：

```bash
docker-compose up -d
```

## 配置说明

### 配置文件（YAML）

核心配置通过挂载的`config.yaml`文件实现，典型结构如下：

```yaml
modbus:
  devices:
    - name: "temperature_sensor"  # 设备名称（自定义）
      address: "192.168.1.100"    # Modbus设备IP地址
      port: 502                   # Modbus端口（默认502）
      timeout: 5                  # 连接超时时间（秒）
      scan_interval: 10           # 数据扫描间隔（秒）
      registers:
        - name: "room_temp"       # 寄存器名称（自定义）
          type: "holding"         # 寄存器类型：coil, discrete, input, holding
          address: 0              # 寄存器地址
          count: 1                # 读取数量
          mqtt_topic: "sensors/temp"  # MQTT发布主题
          unit: "°C"              # 数据单位（可选）
          scale: 0.1              # 缩放因子（如寄存器值123 → 123*0.1=12.3）
          offset: 0               # 偏移值（如 value = raw_value * scale + offset）
          writeable: false        # 是否支持通过MQTT写入（true/false）

mqtt:
  broker: "mqtt://192.168.1.200"  # MQTT broker地址（支持mqtt://或mqtts://）
  port: 1883                      # MQTT端口（默认1883，mqtts默认8883）
  username: "mqtt_user"           # MQTT认证用户名（可选）
  password: "mqtt_pass"           # MQTT认证密码（可选）
  client_id: "modbus4mqtt_bridge" # MQTT客户端ID（自定义，需唯一）
  keepalive: 60                   # 心跳间隔（秒）
  qos: 1                          # 消息QoS级别（0/1/2）
  retain: false                   # 消息是否保留
  command_topic: "modbus/commands" # 接收写入指令的MQTT主题（如writeable=true时）
```

### 环境变量

| 变量名       | 描述                     | 默认值       | 可选值                     |
|--------------|--------------------------|--------------|----------------------------|
| `LOG_LEVEL`  | 日志输出级别             | `info`       | `debug`, `info`, `warn`, `error` |
| `CONFIG_PATH`| 配置文件路径（容器内）   | `/app/config.yaml` | 自定义路径（需同步挂载） |

## 注意事项

- 确保Modbus设备与容器网络互通，MQTT broker地址可访问
- 配置文件中寄存器地址需与设备实际寄存器映射一致（注意部分设备使用0-based或1-based地址）
- 对于写入功能（`writeable: true`），需确保MQTT消息格式与寄存器要求匹配（如整数、浮点数）
- 高扫描频率（短`scan_interval`）可能增加网络和设备负载，建议根据实际需求调整

## 故障排查

- 查看容器日志：`docker logs modbus4mqtt`
- 检查配置文件格式：使用`yamllint`验证`config.yaml`语法
- 测试Modbus连接：使用`modbus-cli`等工具验证设备是否可访问
- 测试MQTT连接：使用`mosquitto_sub`/`mosquitto_pub`验证broker连通性

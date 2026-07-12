---
image: apache/karaf
description: "Apache Karaf是一个轻量级、模块化的OSGi运行时容器，用于部署和管理企业级应用，支持热部署、动态配置和模块化开发，适用于构建灵活可扩展的分布式系统。"
source: https://xuanyuan.cloud/zh/r/apache/karaf
canonical: https://xuanyuan.cloud/zh/r/apache/karaf
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/karaf" title="apache/karaf Docker 镜像中文简介、标签列表与拉取命令">apache/karaf 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Apache Karaf Docker镜像文档

### 镜像概述和主要用途
Apache Karaf是基于OSGi规范的开源运行时容器，提供模块化应用的部署、管理和运行环境。该Docker镜像封装了Apache Karaf运行时环境，简化了企业级模块化应用的部署流程，支持快速启动、动态更新和资源隔离，适用于构建微服务架构、分布式系统和模块化企业应用。


### 核心功能和特性
- **OSGi标准支持**：完全兼容OSGi 4.2/5.0规范，支持模块化应用开发与部署
- **热部署能力**：无需重启容器即可更新应用模块，提高系统可用性
- **轻量级设计**：精简的运行时核心，最小化资源占用，适合边缘计算和容器化环境
- **多维度管理**：提供命令行控制台(SSH)、Web管理界面和JMX监控接口
- **动态配置**：支持配置文件热更新，通过Karaf配置管理服务实时生效
- **扩展性**：丰富的特性模块(Feature)，如JPA、JAX-RS、CXF等，可按需安装
- **安全机制**：内置用户认证、权限控制和加密配置，保障应用运行安全


### 使用场景和适用范围
- **企业级应用部署**：作为模块化应用的运行容器，支持复杂业务系统的拆分与集成
- **微服务架构**：构建基于OSGi的微服务集群，实现服务动态发现和负载均衡
- **边缘计算环境**：轻量级特性适合资源受限的边缘设备部署
- **开发测试环境**：快速搭建模块化应用的开发调试环境，支持热更新加速迭代
- **遗留系统现代化**：将传统应用拆分为OSGi模块，实现增量迁移和功能扩展


### 使用方法和配置说明

#### 基本运行命令
```bash
docker run -d \
  --name karaf-container \
  -p 8181:8181 \  # HTTP管理端口
  -p 8101:8101 \  # SSH控制台端口
  -v karaf-data:/opt/karaf/data \  # 持久化数据卷
  apache/karaf:latest
```

#### Docker Compose配置示例
```yaml
version: '3'
services:
  karaf:
    image: docker.xuanyuan.run/apache/karaf:latest
    container_name: karaf-service
    ports:
      - "8181:8181"   # Web管理端口
      - "8101:8101"   # SSH控制台端口
      - "1099:1099"   # JMX端口
    volumes:
      - karaf-data:/opt/karaf/data
      - ./custom-features:/opt/karaf/deploy  # 自定义特性部署目录
    environment:
      - JAVA_OPTS="-Xms256m -Xmx512m"  # JVM参数配置
      - KARAF_USER=admin                # 管理员用户名
      - KARAF_PASSWORD=admin123         # 管理员密码
    restart: unless-stopped

volumes:
  karaf-data:  # 持久化Karaf数据和配置
```


#### 核心配置说明

##### 端口映射
| 端口 | 用途 |
|------|------|
| 8101 | SSH管理控制台端口，默认用户/密码：karaf/karaf |
| 8181 | Web管理界面端口，访问路径：http://localhost:8181/system/console |
| 1099 | JMX监控端口，用于远程监控和管理 |
| 44444 | RMI注册端口，用于OSGi服务远程调用 |


##### 环境变量配置
| 环境变量 | 描述 | 默认值 |
|----------|------|--------|
| JAVA_OPTS | JVM运行参数 | -Xmx512m -Djava.awt.headless=true |
| KARAF_HOME | Karaf安装目录 | /opt/karaf |
| KARAF_USER | SSH控制台管理员用户名 | karaf |
| KARAF_PASSWORD | SSH控制台管理员密码 | karaf |
| KARAF_OPTS | Karaf启动参数 | 空 |


##### 数据持久化
通过挂载以下目录实现数据持久化：
- `/opt/karaf/data`：存储运行时数据、日志和临时文件
- `/opt/karaf/etc`：配置文件目录（如users.properties、org.ops4j.pax.logging.cfg）
- `/opt/karaf/deploy`：自动部署目录，放入的OSGi bundle会被自动加载


### 基本操作示例

#### 进入Karaf控制台
```bash
# 通过SSH连接容器内Karaf控制台
ssh karaf@localhost -p 8101
# 输入密码（默认：karaf）后进入命令行界面
```

#### 部署应用模块
```bash
# 将OSGi bundle复制到deploy目录自动部署
docker cp ./myapp-bundle.jar karaf-container:/opt/karaf/deploy/

# 或通过Karaf控制台手动安装
karaf@root()> bundle:install -s mvn:com.example/myapp/1.0.0
```

#### 安装特性模块
```bash
# 安装预定义特性（如CXF、JPA）
karaf@root()> feature:install cxf jpa
```

#### 查看运行状态
```bash
# 查看已部署bundle状态
karaf@root()> bundle:list

# 查看服务状态
karaf@root()> service:list
```


### 注意事项
- 生产环境中需修改默认管理员密码，通过`KARAF_USER`和`KARAF_PASSWORD`环境变量配置
- 自定义配置文件建议通过数据卷挂载，避免容器重建后配置丢失
- 高并发场景下可调整`JAVA_OPTS`优化JVM参数（如堆内存、GC策略）
- 镜像标签遵循Apache Karaf版本号（如`4.4.6`），建议指定具体版本而非`latest`以确保稳定性

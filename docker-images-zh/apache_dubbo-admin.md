---
image: apache/dubbo-admin
description: "Apache Dubbo管理平台镜像，用于分布式服务的注册、监控、配置及治理，提供可视化界面实现服务全生命周期管理。"
source: https://xuanyuan.cloud/zh/r/apache/dubbo-admin
canonical: https://xuanyuan.cloud/zh/r/apache/dubbo-admin
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/dubbo-admin" title="apache/dubbo-admin Docker 镜像中文简介、标签列表与拉取命令">apache/dubbo-admin 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Dubbo Admin 技术文档

## 1. 镜像概述与主要用途

Dubbo Admin 是 Apache Dubbo 生态系统的管理控制台，提供服务治理、配置管理与监控功能。作为 Dubbo 微服务架构的可视化管理工具，其核心用途包括服务注册状态监控、配置动态调整、服务依赖关系展示等，支持 Dubbo 2.7 版本的服务治理规范，并兼容 Dubbo 2.6 版本。该工具包含前端 UI（基于 Vue.js）和后端 Server（基于 Spring Boot）两部分，可独立部署或通过 Docker 快速启动。

## 2. 核心功能与特性

### 2.1 服务治理兼容性
- 遵循 Dubbo 2.7 服务治理标准，同时兼容 Dubbo 2.6 版本，治理能力覆盖服务注册、发现、路由规则配置等核心场景。

### 2.2 可视化管理界面
- 基于 Vue.js 和 Vue Cli 构建的前端界面，支持服务列表展示、配置编辑、状态监控等功能，界面直观易用。

### 2.3 后端架构
- 后端 Server 为标准 Spring Boot 项目，支持灵活配置与扩展，可集成多种注册中心（如 ZooKeeper、Nacos）。

### 2.4 API 文档支持
- 集成 Swagger，提供 RESTful API 自动文档，便于接口调试与二次开发。

## 3. 使用场景与适用范围

- **生产环境服务管理**：对 Dubbo 微服务集群进行注册中心配置、服务参数动态调整、调用链路监控。
- **开发环境调试**：支持前端热重载与后端独立运行，便于开发阶段快速验证功能变更。
- **分布式架构监控**：实时展示服务注册状态、健康度及依赖关系，辅助排查服务可用性问题。

## 4. 使用方法

### 4.1 Docker 快速部署

#### 4.1.1 直接运行 Docker 镜像
```bash
docker run -d -p 8080:8080 --name dubbo-admin docker.xuanyuan.run/apache/dubbo-admin:latest
```

#### 4.1.2 Docker Compose 配置示例
基于官方 `stack.yml` 整理的 `docker-compose.yml`：
```yaml
version: '3'
services:
  dubbo-admin:
    image: docker.xuanyuan.run/apache/dubbo-admin:latest
    ports:
      - "8080:8080"
    environment:
      - admin.registry.address=zookeeper://zk:2181  # 注册中心地址（需替换为实际地址）
    depends_on:
      - zk  # 若依赖 ZooKeeper，可添加注册中心服务定义
  zk:
    image: docker.xuanyuan.run/zookeeper:3.7
    ports:
      - "2181:2181"
```
启动命令：
```bash
docker-compose up -d
```

### 4.2 生产环境部署步骤

1. **克隆源码**  
   ```bash
   git clone https://github.com/apache/dubbo-admin.git
   cd dubbo-admin
   ```

2. **配置注册中心地址**  
   编辑 `dubbo-admin-server/src/main/resources/application.properties`，指定注册中心：
   ```properties
   admin.registry.address=zookeeper://127.0.0.1:2181  # 替换为实际注册中心地址
   ```

3. **构建项目**  
   ```bash
   mvn clean package -Dmaven.test.skip=true
   ```

4. **启动服务**  
   - 方式一：通过 Maven 启动  
     ```bash
     mvn --projects dubbo-admin-server spring-boot:run
     ```
   - 方式二：通过 Jar 包启动  
     ```bash
     cd dubbo-admin-distribution/target
     java -jar dubbo-admin-0.1.jar  # 版本号以实际构建结果为准
     ```

5. **访问控制台**  
   浏览器访问 `http://localhost:8080`，默认用户名/密码为 `root/root`。

## 5. 配置说明

后端 Server 核心配置通过 `application.properties` 定义，关键配置项如下：

| 配置项                          | 说明                     | 默认值/示例                          |
|---------------------------------|--------------------------|--------------------------------------|
| `admin.registry.address`        | 注册中心地址             | `zookeeper://127.0.0.1:2181`         |
| `server.port`                   | 服务端口                 | `8080`                               |
| `admin.config-center`           | 配置中心地址（可选）     | `nacos://127.0.0.1:8848`             |
| `admin.metadata-report.address` | 元数据中心地址（可选）   | `zookeeper://127.0.0.1:2181`         |

更多配置详见 [Dubbo Admin 配置文档](https://github.com/apache/dubbo-admin/wiki/Dubbo-Admin-configuration)。

## 6. 开发环境设置

### 6.1 运行后端 Server
后端为标准 Spring Boot 项目，可在 Java IDE（如 IntelliJ IDEA）中直接运行 `dubbo-admin-server` 模块的 `DubboAdminApplication` 类。

### 6.2 运行前端 UI
1. 进入 UI 目录：  
   ```bash
   cd dubbo-admin-ui
   ```
2. 配置 npm 镜像（可选，解决网络问题）：  
   ```bash
   npm config set registry https://registry.npmmirror.com
   ```
3. 安装依赖并启动开发服务：  
   ```bash
   npm install && npm run dev
   ```
4. 访问 UI：前端默认运行在 `http://localhost:8081`，支持热重载。

## 7. Swagger 支持

部署后，通过 `http://localhost:8080/swagger-ui.html` 访问 RESTful API 文档，可查看所有接口定义及数据模型。

## 8. 许可证

Apache Dubbo Admin 基于 Apache 2.0 许可证开源，详见 [LICENSE](https://github.com/apache/dubbo-admin/blob/develop/LICENSE)。

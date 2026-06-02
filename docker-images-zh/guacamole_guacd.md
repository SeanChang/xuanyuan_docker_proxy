---
image: guacamole/guacd
description: "Apache Guacamole Web应用使用的原生服务器端代理，是部署Guacamole或使用Guacamole核心API的应用所必需的组件。"
source: https://xuanyuan.cloud/zh/r/guacamole/guacd
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[guacamole/guacd](https://xuanyuan.cloud/zh/r/guacamole/guacd)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# guacd Docker镜像文档

## 镜像概述和主要用途

guacd 是 [Apache Guacamole Web应用](https://guacamole.apache.org/) 使用的原生服务器端代理。若要部署 Guacamole 或使用 [Guacamole 核心API](https://guacamole.apache.org/api-documentation) 的应用，必须运行 guacd 服务。

## 核心功能和特性

- 作为 Guacamole Web 应用的服务器端代理，处理客户端与远程桌面协议的通信
- 提供标准端口 4822 用于应用连接，支持 Docker 内部容器及外部服务访问
- 轻量级设计，易于集成到基于 Guacamole 的部署架构中

## 使用场景和适用范围

- 与 Guacamole Docker 镜像配合构建完整的 Web 远程桌面服务
- 为依赖 Guacamole 核心 API 的自定义应用提供后端代理支持
- 需在 Docker 环境中部署远程桌面代理服务的场景

## 使用方法和配置说明

### 供 Guacamole Docker 镜像使用

通过以下命令启动 guacd，供 Guacamole Docker 镜像连接：

```bash
docker run --name some-guacd -d guacamole/guacd
```

**说明**：  
guacd 默认监听 4822 端口，此端口仅对显式链接到 `some-guacd` 容器的 Docker 容器开放，外部无法直接访问。

### 供 Docker 外部服务使用

若需允许 Docker 外部服务（如独立运行的 Tomcat 实例）访问 guacd，需将端口映射到主机：

```bash
docker run --name some-guacd -d -p 4822:4822 guacamole/guacd
```

**安全注意事项**：  
guacd 本身不提供认证机制，暴露端口到公网存在安全风险。仅在必要时使用此方式，并严格限制访问来源，确保只有可信应用可连接。

### 从应用连接到 guacd

通过 Docker 容器链接功能，使应用连接到 guacd：

```bash
docker run --name some-app --link some-guacd:guacd -d application-that-uses-guacd
```

**说明**：  
`--link some-guacd:guacd` 参数会在 `some-app` 容器中创建指向 `some-guacd` 容器的网络链接，应用可通过 `guacd` 主机名访问代理服务。

## 问题反馈

如遇到功能异常或漏洞，请通过 [Apache Guacamole JIRA](https://issues.apache.org/jira/browse/GUACAMOLE/) 提交 issue 进行反馈。

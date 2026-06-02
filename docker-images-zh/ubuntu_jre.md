---
image: ubuntu/jre
description: "这是一种基于Ubuntu的无发行版Java运行时环境，它通过精简系统组件以减少攻击面、提升安全性，尤其适用于容器化应用场景，其长期支持版本系列由Canonical负责持续维护与更新。"
source: https://xuanyuan.cloud/zh/r/ubuntu/jre
canonical: https://xuanyuan.cloud/zh/r/ubuntu/jre
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/jre" title="ubuntu/jre Docker 镜像中文简介、标签列表与拉取命令">ubuntu/jre — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ubuntu/jre" title="ubuntu/jre Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ubuntu/jre</a>

# Chiselled Ubuntu JRE Docker 镜像


## 简介  
本文档介绍的 JRE Docker 镜像由 Canonical 官方提供，基于 Ubuntu 系统构建。该镜像会持续接收安全更新，并支持滚动升级至更新的 JRE 版本或 Ubuntu 发行版。**本仓库可免费使用，且不受用户速率限制**。


## 关于 JRE  
该镜像内置的 Java 运行时环境（JRE）基于 [OpenJDK 项目]([])——这是 Java 平台标准版（Java SE）的免费开源实现。自 Java SE 7 起，OpenJDK 成为其官方参考实现（详情可参考 [OpenJDK 官网]([])）。请注意，Java 是 Oracle 及其关联公司的注册商标。


## 关于 Chiselled Ubuntu  
Chiselled Ubuntu 是一类轻量级 OCI 镜像，**不含 bash、包管理器及 OpenJDK 开发工具**，仅作为兼容 Java 应用的运行时终阶段基础镜像。想了解更多可参考 [Ubuntu 官方博客]([])，也可根据应用需求[自定义 Chiselled Ubuntu 基础镜像]([])。  

### 版本差异说明  
- **8 和 17 版本**：基于 Dockerfile 构建，入口点为 `java`。直接运行即可调用 Java：  
  ```bash
  $ docker run --rm ubuntu/jre:17_edge
  Usage: java [options] <mainclass> [args...]
  ```  

- **11 和 21 及以上版本**：基于 Rockcraft 构建（即 "rocks" 格式），入口点为 `pebble enter`。需通过 `exec` 命令调用 Java：  
  ```bash
  $ docker run --rm ubuntu/jre:21_edge exec java
  Usage: java [options] <mainclass> [args...]
  ```  


## 使用方法  

### 本地启动镜像  
根据 JRE 版本选择对应命令：  

#### 适用于 8 和 17 版本  
```bash
docker run -d --name jre-container -e TZ=UTC ubuntu/jre:17-22.04_edge
```  

#### 适用于 11 和 21 版本  
```bash
docker run -d --name jre-container -e TZ=UTC ubuntu/jre:21-24.04_edge exec java
```  

> 说明：直接运行镜像会输出 OpenJRE 帮助信息，因为镜像需配合已编译的 Java 应用使用。  


### 示例：运行 Hello World 应用  
以下通过简单的 Hello World 应用演示完整使用流程。  

#### 1. 编写 Java 代码  
创建 `HelloWorld.java`：  
```java
// HelloWorld.java
class HelloWorld {
    public static void main(String args[]) {
        System.out.println("Hello, World");
    }
}
```  

#### 2. 构建并运行容器  
根据 JRE 版本使用不同 Dockerfile：  

##### 适用于 8 和 17 版本  
```dockerfile
# Dockerfile (8/17 版本)
FROM ubuntu:22.04 AS builder
RUN apt-get update && apt-get install -y openjdk-8-jdk
WORKDIR /app
ADD HelloWorld.java .
RUN javac -source 8 -target 8 HelloWorld.java -d .  # 编译 Java 文件

FROM ubuntu/jre:8-22.04_edge  # 使用 Chiselled Ubuntu JRE 镜像
WORKDIR /
COPY --from=builder /app/HelloWorld.class .  # 复制编译后的类文件
CMD ["HelloWorld"]  # 运行应用
```  

##### 适用于 11 和 21 版本  
```dockerfile
# Dockerfile (11/21 版本)
FROM ubuntu:24.04 AS builder
RUN apt-get update && apt-get install -y openjdk-8-jdk
WORKDIR /app
ADD HelloWorld.java .
RUN javac -source 8 -target 8 HelloWorld.java -d .

FROM ubuntu/jre:21-24.04_edge
COPY --from=builder /app/HelloWorld.class .
CMD ["exec", "java", "-cp", "/", "HelloWorld"]  # 通过 pebble 执行 java 命令
```  

构建并运行：  
```bash
docker build -t hello-jre .
docker run --rm hello-jre  # 输出 "Hello, World"
```  


## 标签与架构  

### 安全维护说明  
- ![LTS]([]) **LTS 渠道**：提供长达 5 年的免费安全维护。  
- ![ESM]([]) **ESM 渠道**：通过 Canonical 受限仓库提供最长 10 年的商业安全维护（详情见[官方说明]([])）。  


### 标签详情  
| 主要标签                | 其他可用标签                                                                 | 支持期限 | 当前版本                     | 架构支持       |
|-------------------------|-----------------------------------------------------------------------------|----------|------------------------------|----------------|
| **`11-24.04_stable`**   | `11-24.04`, `11-24.04_beta`, `11-24.04_candidate`, `11-24.04_edge`          | -        | JRE 11 on Ubuntu 24.04 LTS   | `arm64`, `amd64` |
| `21-24.04_stable`       | `21-24.04`, `21-24.04_beta`, `21-24.04_candidate`, `21-24.04_edge`          | -        | JRE 21 on Ubuntu 24.04 LTS   | `amd64`, `arm64` |
| `17-22.04_edge`         | `17-22.04_93`, `17-22.04_edge_93`, `17_edge`                               | -        | JRE 17 on Ubuntu 22.04 LTS   | `amd64`, `arm64` |
| `8-22.04_edge`          | `8-22.04_93`, `8-22.04_edge_93`, `8_edge`, `edge`                          | -        | JRE 8 on Ubuntu 22.04 LTS    | `amd64`, `arm64` |

> **标签说明**：渠道稳定性从高到低为 `stable` → `candidate` → `beta` → `edge`。若列出 `beta`，则 `edge` 同样可用；若列出 `stable`，则所有四个渠道均可用。镜像会按 `edge` → `beta` → `candidate` → `stable` 顺序迭代发布。  


## 商业使用与扩展安全维护（ESM）渠道  
若需商业分发，或需要 ESM 支持及未列出的渠道/版本，请联系 Canonical 团队（邮箱：[邮箱已删除]，或参考[官方联系方式]([])）。  


## 测试与调试  

### 查看容器日志  
```bash
docker logs -f jre-container  # 替换为实际容器名
```  

### 11/21 版本应用日志查看  
对于 11 和 21 版本，需通过 pebble 查看应用日志：  
```bash
docker exec jre-container pebble logs  # 替换为实际容器名
```  


## 问题反馈与功能需求  
如发现镜像漏洞或需新增功能，请在 Launchpad 提交 issue：  
[[]]([])  

提交时请按格式填写标题：`jre: <问题摘要>`，并附上镜像完整 digest（可通过以下命令获取）：  
```bash
docker images --no-trunc --quiet ubuntu/jre:<标签>  # 替换为实际标签
```  


## 已弃用渠道及标签  
以下渠道（标签）不再更新，请尽快升级至新版本；若无法升级，可[联系 Canonical]([])获取支持。  

| 渠道（Track） | 版本（Version） | 停止维护（EOL） | 升级路径（Upgrade Path） |
|--------------|----------------|-----------------|--------------------------|
| _`track`_    |                |                 |                          |

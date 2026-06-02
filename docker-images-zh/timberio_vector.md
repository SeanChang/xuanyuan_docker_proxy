<!-- xuanyuan-docker-images-zh
image: timberio/vector
source: https://xuanyuan.cloud/zh/r/timberio/vector
canonical: https://xuanyuan.cloud/zh/r/timberio/vector
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/timberio/vector" title="timberio/vector Docker 镜像中文简介、标签列表与拉取命令">timberio/vector — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/timberio/vector" title="timberio/vector Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/timberio/vector</a></p>

### Vector 介绍


#### 相关链接  
[官网]([]) • [文档]([]) • [社区]([]) • [GitHub]([])  


#### 工具概述  
Vector 是一款[开源]([])可观测性管道工具，支持通过单一工具[收集]([])、[转换]([])、[路由]([])日志、指标和事件数据。  

采用[Rust]([])开发，Vector 注重[性能]([])、[准确性]([])和[运维友好性]([])，编译后为单一静态二进制文件，可部署在整个基础设施中，作为轻量[守护进程]([])、[边车容器]([])或高效[服务]([])运行。借助 Vector，您可重新掌控可观测性数据的所有权和管理。  

该工具由 Datadog[社区开源工程团队]([])维护。  


## 配置  
如上文所述，可通过`-c`标志传递[自定义 Vector 配置文件]([])。由于[默认的`/etc/vector/vector.toml`配置文件]([])无实际功能，建议自定义配置。  


## 部署  
Vector 的部署方式取决于具体用例和环境，详情可参考[部署文档]([])。  


## 更新  
只需使用新版本标签运行以下命令即可更新：  
```bash
docker pull timberio/vector:X.X.X-alpine && \
  docker run timberio/vector:X.X.X-alpine
```  
请根据需求从[变体](#变体)和[版本](#版本)中选择合适的镜像。  


## 镜像  

### 变体  

#### alpine  
基于[`alpine` Docker 镜像]([])（轻量级 Linux 发行版，基于 musl libc 和 BusyBox）构建，体积显著更小，推荐使用（轻量且可靠）。  
```bash
docker run timberio/vector:0.10.0-alpine
```  

#### debian  
基于[`debian-slim`镜像]([])构建，是`debian`镜像的精简版。  
```bash
docker run timberio/vector:0.10.0-debian
```  

#### distroless-\*  
基于[distroless]([])构建，仅包含运行二进制文件的必要组件：  
- `distroless-static`：使用 musl x86 静态链接构建  
- `distroless-libc`：动态链接，依赖 distroless/base/cc 提供的 libc  


### 架构  
Vector 镜像支持多架构：x86_64、ARM64、ARMv7，Docker 会自动适配。  


### 版本  
Vector Docker 镜像标签说明如下（标签会随[版本发布]([])自动更新）：  

| 版本类型       | 标签格式示例                          |  
|----------------|---------------------------------------|  
| 最新主版本     | `timberio/vector:latest-alpine`       |  
| 最新次版本     | `timberio/vector:<主版本>.X-alpine`   |  
| 最新补丁版本   | `timberio/vector:<主版本.次版本>.X-alpine` |  
| 特定版本       | `timberio/vector:<主版本.次版本.补丁>-alpine` |  
| 最新 nightly 版 | `timberio/vector:nightly-alpine`      |  
| 特定 nightly 版 | `timberio/vector:nightly-<YYYY-MM-DD>-alpine` |  


### 源码文件  
Vector Docker 源码文件位于[GitHub 仓库]([])。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/timberio/vector" title="timberio/vector Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/timberio/vector</a></p>

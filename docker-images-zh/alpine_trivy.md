---
image: alpine/trivy
description: "用于扫描Docker镜像漏洞和密钥的安全工具。"
source: https://xuanyuan.cloud/zh/r/alpine/trivy
canonical: https://xuanyuan.cloud/zh/r/alpine/trivy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alpine/trivy" title="alpine/trivy Docker 镜像中文简介、标签列表与拉取命令">alpine/trivy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Alpine/Trivy 容器镜像技术文档


## 镜像概述和主要用途

**镜像名称**：`alpine/trivy`  
**基础镜像**：Alpine Linux  
**主要用途**：轻量级容器镜像漏洞扫描工具，基于Trivy构建，用于检测容器镜像中的操作系统漏洞、语言特定依赖漏洞及敏感信息（秘密），支持本地和远程镜像扫描，适用于CI/CD流程集成、安全审计等场景。


## 核心功能与特性

- **多类型漏洞检测**：支持操作系统级漏洞（如Alpine、Debian等发行版包漏洞）和语言特定漏洞（如Python、Java、Node.js等依赖包漏洞）。  
- **秘密扫描**：内置敏感信息检测功能，可识别镜像中的密钥、令牌等敏感数据（默认启用，可通过参数禁用）。  
- **按严重级别筛选**：支持按漏洞严重级别（CRITICAL、HIGH、MEDIUM、LOW、UNKNOWN）筛选结果，聚焦高风险漏洞。  
- **本地/远程镜像支持**：可扫描本地构建的镜像（如`demo`）或远程仓库镜像（如`quay.io/keycloak/keycloak`）。  
- **缓存优化**：支持漏洞数据库缓存，避免重复下载，加速扫描过程（通过挂载本地缓存目录实现）。  


## 使用场景和适用范围

- **容器镜像构建流程**：在镜像构建完成后执行扫描，确保镜像无高危漏洞再进入部署流程。  
- **CI/CD Pipeline集成**：作为自动化流程的一环，在代码合并或镜像推送前触发扫描，阻断带漏洞的镜像流转。  
- **定期安全审计**：对生产环境使用的镜像定期扫描，跟踪新披露漏洞（NVD等来源更新后）。  
- **第三方镜像评估**：引入第三方镜像（如公共仓库镜像）前，通过扫描评估其安全风险。  


## 使用方法和配置说明

### 前置条件

- 已安装Docker环境（需Docker守护进程运行，确保`/var/run/docker.sock`可访问）。  


### 基本使用方法

#### 1. 扫描本地镜像（所有漏洞）

扫描本地构建的镜像（如`demo`），输出所有严重级别的漏洞：

```bash
docker run -ti --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \  # 允许Trivy访问Docker守护进程
  -v ~/.cache:/root/.cache \                      # 挂载缓存目录，缓存漏洞数据库
  alpine/trivy image demo                         # 扫描本地镜像"demo"
```

**输出说明**：  
结果包含镜像OS信息（如`alpine 3.18.4`）、漏洞总数及详情表格（库名称、CVE编号、严重级别、修复版本等）。


#### 2. 按严重级别筛选扫描

仅扫描并输出HIGH和CRITICAL级别的漏洞（适用于聚焦高风险问题）：

```bash
docker run -ti --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.cache:/root/.cache \
  docker.xuanyuan.run/alpine/trivy image --severity HIGH,CRITICAL demo # --severity指定严重级别，逗号分隔
```


#### 3. 扫描远程仓库镜像

扫描远程仓库中的镜像（如`quay.io/keycloak/keycloak`）：

```bash
docker run -ti --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.cache:/root/.cache \
  docker.xuanyuan.run/alpine/trivy image quay.io/keycloak/keycloak # 直接指定远程镜像地址
```

**简化命令**：通过alias定义快捷命令，方便重复使用：  
```bash
alias scan="docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock -v ~/.cache:/root/.cache alpine/trivy image --severity HIGH,CRITICAL"
scan quay.io/keycloak/keycloak  # 使用别名快速扫描
```


#### 4. 加速扫描：禁用秘密扫描

默认情况下，Trivy同时启用漏洞扫描和秘密扫描。若需加速扫描（如已知无需检测秘密），可通过`--scanners vuln`仅启用漏洞扫描：

```bash
docker run -ti --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.cache:/root/.cache \
  docker.xuanyuan.run/alpine/trivy image --scanners vuln demo # 仅扫描漏洞，禁用秘密扫描
```


### Docker Compose部署示例

以下为通过docker-compose集成Trivy扫描的示例（扫描指定镜像并输出结果到文件）：

```yaml
# docker-compose.yml
version: '3'
services:
  trivy-scan:
    image: docker.xuanyuan.run/alpine/trivy
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ~/.cache:/root/.cache
      - ./scan-results:/results  # 挂载目录用于保存扫描结果
    command: image --severity HIGH,CRITICAL --output /results/report.txt demo  # 输出结果到文件
```

**执行扫描**：  
```bash
docker-compose up
```

扫描结果将保存至`./scan-results/report.txt`。


## 常用配置参数说明

| 参数           | 说明                                                                 | 示例                          |
|----------------|----------------------------------------------------------------------|-------------------------------|
| `--severity`   | 指定漏洞严重级别，多级别用逗号分隔（CRITICAL,HIGH,MEDIUM,LOW,UNKNOWN） | `--severity HIGH,CRITICAL`    |
| `--scanners`   | 指定扫描类型，`vuln`（漏洞）、`secret`（秘密），默认两者均启用        | `--scanners vuln`             |
| `--output`     | 将扫描结果输出到指定文件                                             | `--output /results/report.txt`|
| `--image-ref`  | 待扫描的镜像名称或地址（本地或远程）                                 | `demo` 或 `quay.io/keycloak/keycloak` |


## 注意事项

1. **缓存目录持久化**：挂载`~/.cache:/root/.cache`可缓存Trivy的漏洞数据库（默认路径`/root/.cache/trivy`），避免每次扫描重复下载，显著提升效率。  
2. **Docker权限**：确保当前用户对`/var/run/docker.sock`有读写权限，否则Trivy无法访问Docker守护进程。  
3. **定期更新镜像**：`alpine/trivy`镜像需定期更新，以获取Trivy工具及漏洞数据库的最新版本。  
4. **结果解读**：扫描结果中的“Fixed Version”表示修复漏洞的版本，建议及时更新镜像基础层或依赖包至该版本。

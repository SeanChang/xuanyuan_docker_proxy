---
image: buildkite/test-engine-client
description: "提供Buildkite Test Engine Client（bktec）的Docker镜像，用于在Docker环境中运行该测试引擎客户端工具。"
source: https://xuanyuan.cloud/zh/r/buildkite/test-engine-client
canonical: https://xuanyuan.cloud/zh/r/buildkite/test-engine-client
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/buildkite/test-engine-client" title="buildkite/test-engine-client Docker 镜像中文简介、标签列表与拉取命令">buildkite/test-engine-client 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Buildkite Test Engine Client (bktec) Docker镜像文档


## 1. 镜像概述和主要用途

### 1.1 概述
Buildkite Test Engine Client (bktec) Docker镜像是封装了Buildkite Test Engine Client工具的容器化解决方案。该镜像旨在提供一个隔离、一致且易于部署的环境，用于与Buildkite Test Engine交互，执行、管理和监控测试任务。

### 1.2 主要用途
- 作为Buildkite Test Engine的客户端代理，接收并执行测试任务
- 在容器环境中标准化测试执行流程，确保跨环境一致性
- 集成到CI/CD管道中，实现测试任务的自动化调度与结果上报
- 简化本地开发环境与远程测试引擎的对接流程


## 2. 核心功能和特性

### 2.1 核心功能
- 与Buildkite Test Engine服务端建立安全连接并接收测试任务
- 执行多种类型的测试（单元测试、集成测试、E2E测试等）
- 实时上报测试进度、结果及日志至Test Engine
- 支持测试任务的重试、中断及优先级调度

### 2.2 关键特性
- **环境隔离**：容器化运行测试任务，避免宿主环境依赖冲突
- **版本一致性**：固定bktec版本，确保测试执行环境可追溯
- **轻量级设计**：基于Alpine Linux构建，镜像体积小，启动速度快
- **多框架支持**：兼容主流测试框架（JUnit、PyTest、RSpec等）
- **配置灵活**：通过环境变量或配置文件自定义客户端行为
- **安全传输**：支持TLS加密与Buildkite Test Engine通信


## 3. 使用场景和适用范围

### 3.1 典型使用场景
- **CI/CD管道集成**：在Jenkins、GitHub Actions、GitLab CI等管道中嵌入bktec容器，自动触发测试任务
- **本地开发测试**：开发人员在本地启动bktec容器，连接远程Test Engine验证代码变更
- **跨平台测试**：在不同架构（x86_64、ARM）的容器环境中执行相同测试，验证兼容性
- **大规模测试分发**：通过多实例部署bktec，并行处理Test Engine分发的测试任务
- **测试环境标准化**：统一团队成员及CI环境的测试执行环境，消除"在我机器上能运行"问题

### 3.2 适用范围
- 开发团队：本地调试与测试验证
- QA团队：自动化测试执行与结果分析
- DevOps/平台团队：构建标准化测试基础设施
- 企业级应用：需要大规模、分布式测试能力的组织


## 4. 使用方法和配置说明

### 4.1 基本使用（`docker run`）
```bash
docker run -d \
  --name bktec-client \
  -e BUILDKITE_API_TOKEN="your-buildkite-api-token" \
  -e TEST_ENGINE_URL="https://test-engine.buildkite.com" \
  -e LOG_LEVEL="info" \
  -v /path/to/local/test/files:/tests \
  docker.xuanyuan.run/buildkite/bktec:latest
```

### 4.2 Docker Compose配置示例
```yaml
version: "3.8"
services:
  bktec:
    image: docker.xuanyuan.run/buildkite/bktec:latest
    container_name: bktec-client
    restart: unless-stopped
    environment:
      - BUILDKITE_API_TOKEN=${BUILDKITE_API_TOKEN}  # 从环境变量注入，避免硬编码
      - TEST_ENGINE_URL=https://test-engine.buildkite.com
      - LOG_LEVEL=debug
      - TEST_WORKDIR=/tests
      - MAX_CONCURRENT_TESTS=4
    volumes:
      - ./local-test-files:/tests  # 挂载本地测试文件到容器
      - ./bktec-config:/etc/bktec  # 挂载自定义配置文件
    networks:
      - buildkite-network  # 与Buildkite Agent共享网络

networks:
  buildkite-network:
    driver: bridge
```


## 4.3 配置说明

### 4.3.1 环境变量配置
| 环境变量名               | 描述                                     | 默认值                          | 是否必填 |
|--------------------------|------------------------------------------|---------------------------------|----------|
| `BUILDKITE_API_TOKEN`     | Buildkite API访问令牌，用于身份验证      | -                               | 是       |
| `TEST_ENGINE_URL`         | Buildkite Test Engine服务端URL           | `https://test-engine.buildkite.com` | 否       |
| `LOG_LEVEL`               | 日志级别（debug/info/warn/error）        | `info`                          | 否       |
| `TEST_WORKDIR`            | 容器内测试执行工作目录                   | `/tests`                        | 否       |
| `MAX_CONCURRENT_TESTS`    | 最大并发测试任务数                       | `2`                             | 否       |
| `CONNECT_TIMEOUT`         | 与Test Engine连接超时时间（秒）          | `30`                            | 否       |
| `LOG_OUTPUT_PATH`         | 日志输出文件路径（容器内）               | `/var/log/bktec.log`            | 否       |
| `PROXY_URL`               | 代理服务器URL（如需通过代理连接Test Engine） | -                               | 否       |

### 4.3.2 配置文件挂载
如需更复杂的配置（如测试框架适配、任务过滤规则等），可通过挂载配置文件实现。默认配置文件路径为 `/etc/bktec/config.yaml`，示例配置：
```yaml
# /etc/bktec/config.yaml 示例
test-frameworks:
  - name: junit
    command: mvn test
    pattern: "**/target/surefire-reports/*.xml"
  - name: pytest
    command: pytest
    pattern: "**/pytest-results.xml"
task-filters:
  exclude-tags: ["flaky", "manual"]
  include-labels: ["smoke", "regression"]
retry-policy:
  max-retries: 2
  delay-seconds: 10
```

挂载方式（在`docker run`中添加）：
```bash
-v /path/to/local/config.yaml:/etc/bktec/config.yaml
```


## 5. 与Buildkite Agent集成

在Buildkite CI流程中，可通过Agent插件形式调用bktec容器执行测试：
```yaml
# buildkite-agent.yml 配置片段
steps:
  - label: "Run tests via bktec"
    command: docker-compose run bktec /bin/sh -c "bktec run --test-suite=unit"
    plugins:
      - docker-compose#v4.12.0:
          run: bktec
          config: docker-compose.yml
```


## 6. 注意事项

- **API令牌安全**：`BUILDKITE_API_TOKEN` 包含敏感权限，建议通过CI/CD平台的密钥管理功能注入（如GitHub Secrets、GitLab CI Variables），避免硬编码
- **网络配置**：确保容器可访问Test Engine URL（需开放对应端口，如443），如使用私有Test Engine，需配置`TEST_ENGINE_URL`指向内部地址
- **资源限制**：根据测试任务复杂度，通过`--memory`和`--cpus`限制容器资源，避免影响宿主或其他容器
- **日志管理**：如启用文件日志（`LOG_OUTPUT_PATH`），建议挂载日志目录至宿主，便于持久化存储和分析


## 7. 版本信息
- 基础镜像：`alpine:3.18`
- 支持架构：`amd64`、`arm64`
- 最新稳定版本：`buildkite/bktec:latest`（对应bktec v1.5.0）
- 版本标签规则：`buildkite/bktec:<bktec-version>-alpine`（如`buildkite/bktec:1.5.0-alpine`）

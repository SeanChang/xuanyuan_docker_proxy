---
image: buildkite/plugin-tester
description: "用于通过BATS测试Buildkite插件的基础Docker镜像"
source: https://xuanyuan.cloud/zh/r/buildkite/plugin-tester
canonical: https://xuanyuan.cloud/zh/r/buildkite/plugin-tester
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/buildkite/plugin-tester" title="buildkite/plugin-tester Docker 镜像中文简介、标签列表与拉取命令">buildkite/plugin-tester 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Buildkite Plugin Tester 镜像文档

## 镜像概述

Buildkite Plugin Tester 是一个基础 Docker 镜像，专为使用 BATS (Bash Automated Testing System) 测试 Buildkite 插件而设计。该镜像提供了一致的测试环境，简化了 Buildkite 插件的开发和测试流程。

## 核心功能和特性

- 预安装 BATS 测试框架及常用辅助工具
- 内置 Buildkite 插件测试所需的核心依赖
- 提供标准化的测试运行环境，确保测试结果一致性
- 支持插件钩子测试、环境变量验证和命令执行测试
- 包含测试结果格式化和报告工具
- 轻量级设计，基于 Alpine Linux 构建

## 使用场景和适用范围

- Buildkite 插件开发过程中的自动化测试
- 插件功能验证和回归测试
- CI/CD 流程中集成插件测试步骤
- 插件兼容性测试
- 开源 Buildkite 插件的标准化测试环境提供

## 使用方法和配置说明

### 基本使用

```bash
docker run --rm -v "$(pwd):/plugin" docker.xuanyuan.run/buildkite/plugin-tester
```

### Docker Compose 配置

```yaml
version: '3'
services:
  test:
    image: docker.xuanyuan.run/buildkite/plugin-tester
    volumes:
      - .:/plugin
    environment:
      - PLUGIN_TEST_DEBUG=true
      - BATS_REPORT_FORMAT=junit
```

### 环境变量配置

| 环境变量 | 描述 | 默认值 |
|---------|------|-------|
| `PLUGIN_PATH` | 插件目录路径 | `/plugin` |
| `TEST_PATH` | 测试文件路径 | `/plugin/tests` |
| `BATS_FILE_PATTERN` | BATS 测试文件匹配模式 | `*.bats` |
| `PLUGIN_TEST_DEBUG` | 启用调试模式 | `false` |
| `BATS_REPORT_FORMAT` | 测试报告格式 (tap/junit) | `tap` |
| `BATS_JUNIT_REPORT_PATH` | JUnit 报告输出路径 | `/plugin/report.xml` |

### 测试文件结构

建议在插件项目中使用以下目录结构：

```
/plugin
├── hooks
│   ├── command
│   ├── pre-command
│   └── post-command
└── tests
    ├── command.bats
    ├── pre-command.bats
    └── post-command.bats
```

### 在 CI 中集成

在 `.buildkite/pipeline.yml` 中集成测试步骤：

```yaml
steps:
  - label: ":test_tube: Test plugin"
    plugins:
      - docker#v3.8.0:
          image: "docker.xuanyuan.run/buildkite/plugin-tester"
          volumes:
            - "./:/plugin"
```

## 高级用法

### 自定义测试命令

```bash
docker run --rm -v "$(pwd):/plugin" docker.xuanyuan.run/buildkite/plugin-tester bats tests/specific-test.bats
```

### 生成 JUnit 测试报告

```bash
docker run --rm -v "$(pwd):/plugin" -e BATS_REPORT_FORMAT=junit docker.xuanyuan.run/buildkite/plugin-tester
```

### 交互式调试

```bash
docker run --rm -it -v "$(pwd):/plugin" --entrypoint /bin/bash docker.xuanyuan.run/buildkite/plugin-tester
```

## 测试示例

创建 `tests/command.bats` 文件：

```bash
#!/usr/bin/env bats

@test "command hook runs successfully" {
  run buildkite-plugin-tester hook command

  assert_success
  assert_output --partial "Hello from plugin command hook"
}

@test "plugin configuration is applied" {
  run buildkite-plugin-tester env -- plugin=my-plugin config-key=value

  assert_success
  assert_env "PLUGIN_CONFIG_KEY" "value"
}
```

## 维护和支持

- 镜像源码地址: https://github.com/buildkite-plugins/plugin-tester
- 问题反馈: https://github.com/buildkite-plugins/plugin-tester/issues
- BATS 文档: https://github.com/bats-core/bats-core
- Buildkite 插件开发指南: https://buildkite.com/docs/agent/v3/plugins

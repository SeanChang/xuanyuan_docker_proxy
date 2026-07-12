---
image: espressif/idf-rust
description: "支持在Espressif SoC上进行Rust开发的容器镜像，提供开发环境及工具链支持。"
source: https://xuanyuan.cloud/zh/r/espressif/idf-rust
canonical: https://xuanyuan.cloud/zh/r/espressif/idf-rust
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/espressif/idf-rust" title="espressif/idf-rust Docker 镜像中文简介、标签列表与拉取命令">espressif/idf-rust 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Rust on Espressif SoCs Docker镜像

## 镜像概述和主要用途
该Docker镜像提供了在Espressif设备上开发Rust应用所需的环境。源仓库地址：https://github.com/esp-rs/rust-build

## 核心功能和特性
- **支持平台**：提供适用于`linux/arm64`和`linux/amd64`架构的镜像标签。
- **标签命名规则**：针对每个Xtensa Rust版本，采用`<chip>_<rust-toolchain-version>`格式命名。例如`esp32_1.64.0.0`包含ESP32设备的`1.64.0.0`版本Xtensa Rust工具链，支持`std`和`no_std`应用开发。
- **特殊标签**：
  - `<chip>`为`all`时，兼容所有Espressif目标设备；
  - `<rust-toolchain-version>`为`latest`时，使用最新版本Xtensa Rust工具链。

## 使用场景和适用范围
适用于开发Espressif SoC（如ESP32系列）上Rust应用的开发者，可满足`std`和`no_std`应用的开发需求。

## 使用方法和配置说明
### 标签选择
根据目标芯片和工具链版本选择标签，格式示例：
```
# 特定芯片+特定版本工具链
esp32_1.64.0.0

# 所有芯片+最新工具链
all_latest

# 特定芯片+最新工具链
esp32c3_latest
```

### 基础使用示例
拉取镜像：
```bash
docker pull ***-ghcr.xuanyuan.run/esp-rs/rust-build:<chip>_<rust-toolchain-version>
```
（注：具体仓库地址请以源仓库说明为准）

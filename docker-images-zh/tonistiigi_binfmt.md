---
image: tonistiigi/binfmt
description: "这是一个通过Docker镜像进行分发的跨平台模拟器集合，它集成了多种不同平台的模拟器工具，能够支持在各类操作系统环境下便捷地运行和测试不同平台的应用程序，借助Docker容器化技术，确保了模拟器运行环境的一致性、部署的简便性以及跨系统使用的灵活性，为开发者和测试人员提供了高效、统一的模拟测试解决方案。"
source: https://xuanyuan.cloud/zh/r/tonistiigi/binfmt
canonical: https://xuanyuan.cloud/zh/r/tonistiigi/binfmt
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [tonistiigi/binfmt — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/tonistiigi/binfmt)

含镜像标签、拉取命令、部署文档与相关推荐。

[tonistiigi/binfmt Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/tonistiigi/binfmt)

# 基于Docker镜像的跨平台模拟器集合  

该镜像可用于安装节点原生不支持的架构模拟器，以便运行和构建任意架构的容器。  
问题反馈：[]  


## 最新发布版本  

- [`latest`]([])、[`qemu-v10.0.4`]([])  
- [`qemu-v9.2.2`]([])  
- [`qemu-v8.1.5`]([])  
- [`qemu-v7.0.0`]([])  
- [`desktop-v10.0.4`]([])、[`desktop-v9.2.0`]([])（桌面版，包含Docker Desktop附加补丁）  

部署流程：[]  


## 开发版本（master分支）  

- [`master`]([])（基于master分支的开发构建）  


## 使用方法  

### 安装模拟器  

#### 安装所有模拟器  
```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```

#### 安装指定模拟器  
```bash
docker run --privileged --rm tonistiigi/binfmt --install arm64,riscv64,arm
```


### 查看当前支持的架构和已安装模拟器  
```bash
docker run --privileged --rm myuser/binfmt
```

输出示例（JSON格式）：  
```json
{
  "supported": [
    "linux/amd64",
    "linux/arm64",
    "linux/riscv64",
    "linux/ppc64le",
    "linux/s390x",
    "linux/386",
    "linux/arm/v7",
    "linux/arm/v6"
  ],
  "emulators": [
    "qemu-aarch64",
    "qemu-arm",
    "qemu-ppc64le",
    "qemu-riscv64",
    "qemu-s390x"
  ]
}
```


### 卸载模拟器  
```bash
docker run --privileged --rm tonistiigi/binfmt --uninstall qemu-aarch64
```


## GitHub Action使用  

在GitHub Actions环境中，可通过 [`setup-qemu-action`]([]) 加载此镜像：  
```yaml
- name: Set up QEMU
  uses: docker/setup-qemu-action@v1
```


## 支持的架构  

- amd64  
- arm64  
- arm/v7  
- s390x  
- ppc64le  
- riscv64  
- 386

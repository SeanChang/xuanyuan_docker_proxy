---
image: rocm/vllm-ci
description: "该仓库用于托管vllm项目持续集成（CI）流程所需的镜像，旨在为vllm-ci相关的自动化构建、测试及部署环节提供稳定的镜像存储与管理支持，确保CI流程高效、可靠地运行，满足vllm项目在开发迭代过程中对集成环境的镜像需求，助力项目快速验证代码变更、保障软件质量。"
source: https://xuanyuan.cloud/zh/r/rocm/vllm-ci
canonical: https://xuanyuan.cloud/zh/r/rocm/vllm-ci
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rocm/vllm-ci" title="rocm/vllm-ci Docker 镜像中文简介、标签列表与拉取命令">rocm/vllm-ci — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/rocm/vllm-ci" title="rocm/vllm-ci Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/rocm/vllm-ci</a>

# vllm-ci 镜像托管仓库  


## 仓库定位  
本仓库用于集中托管 vllm 项目 CI（持续集成）流程所需的各类镜像，确保 CI 环节中环境一致性、流程稳定性，减少因镜像版本或依赖问题导致的构建/测试失败。  


## 主要功能  
1. **镜像存储**：包含 CI 流程各阶段所需镜像（如基础构建镜像、测试环境镜像、依赖预安装镜像等）。  
2. **版本管理**：通过标签（tag）区分镜像版本，支持回溯历史版本（如 `vllm-ci-base:v1.0`、`vllm-ci-test:latest`）。  
3. **流程适配**：镜像配置与 vllm 项目 CI 脚本（如 GitHub Actions、GitLab CI 配置）直接对应，开箱即用。  


## 使用说明  

### 1. 获取镜像  
通过 Docker 命令直接拉取仓库中的镜像，示例：  
```bash  
# 拉取基础构建镜像（含 Python、CUDA 等基础依赖）  
docker pull [仓库地址]/vllm-ci-base:latest  

# 拉取测试环境镜像（含 pytest、torch 等测试工具）  
docker pull [仓库地址]/vllm-ci-test:v2.1  
```  
> 注：`[仓库地址]` 需替换为实际镜像仓库地址（如 Docker Hub 或私有仓库地址）。  


### 2. 镜像更新流程  
当 CI 流程需新增依赖、调整环境配置时，按以下步骤更新镜像：  
- **提交修改**：修改对应镜像的 Dockerfile（位于仓库 `dockerfiles/` 目录下，如 `dockerfiles/base.Dockerfile`），并提交 PR。  
- **审核与合并**：PR 通过代码审核后合并至主分支，触发自动构建流程（通过 CI 脚本调用 `docker build` 并推送至仓库）。  
- **版本标记**：构建完成后，根据更新内容添加标签（如重大更新用 `vX.Y`，小修复用 `vX.Y.Z`）。  


### 3. 镜像命名规范  
为便于识别和使用，镜像名称遵循以下格式：  
```  
vllm-ci-[用途]:[版本标签]  
```  
- **用途**：如 `base`（基础构建）、`test`（测试环境）、`docs`（文档生成）等。  
- **版本标签**：`latest`（最新稳定版）、`vX.Y`（版本号）、`dev`（开发中版本）等。  


## 注意事项  
1. **依赖同步**：若项目依赖（如 Python 版本、CUDA 版本）更新，需同步更新对应镜像并重新构建，避免 CI 流程因环境不匹配失败。  
2. **安全检查**：镜像构建前需通过依赖漏洞扫描（如 `trivy`），确保无高危安全风险。  
3. **问题反馈**：使用中若遇镜像相关问题（如依赖缺失、启动失败），可在仓库 Issues 中提交，标题格式：`[镜像问题] [镜像名称]:[版本] - 具体描述`。  


## 维护与贡献  
- **维护者**：vllm 项目 CI 维护团队负责镜像更新、版本管理及问题响应。  
- **贡献指南**：如需新增镜像或优化现有镜像，可 Fork 仓库后修改 Dockerfile 并提交 PR，PR 需附修改说明（如“新增 docs 镜像，支持自动生成 API 文档”）。

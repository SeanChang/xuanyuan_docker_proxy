---
image: koalaman/shellcheck
description: "ShellCheck是一款用于Shell脚本分析的工具，可检查脚本中的语法错误、潜在问题及优化建议。"
source: https://xuanyuan.cloud/zh/r/koalaman/shellcheck
canonical: https://xuanyuan.cloud/zh/r/koalaman/shellcheck
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/koalaman/shellcheck" title="koalaman/shellcheck Docker 镜像中文简介、标签列表与拉取命令">koalaman/shellcheck 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# koalaman/shellcheck 镜像文档


## 1. 镜像概述和主要用途

`koalaman/shellcheck` 是 [ShellCheck](https://github.com/koalaman/shellcheck) 的官方 Docker 镜像。ShellCheck 是一款针对 shell 脚本的静态分析工具，可检测脚本中的语法错误、潜在问题、不符合最佳实践的写法及常见陷阱，帮助开发者编写更健壮、可靠的 shell 脚本。


## 2. 核心功能和特性

- **静态分析能力**：无需执行脚本即可检测语法错误、未定义变量、逻辑缺陷等问题。  
- **多场景适配**：支持通过文件名、通配符或 shebang 识别脚本文件，灵活适配不同检查需求。  
- **轻量级设计**：镜像仅包含静态链接的 `shellcheck` 二进制文件，无额外 Unix 用户空间工具，体积小巧。  
- **版本化标签**：提供 `latest`（最新提交）、`stable`（稳定版）及具体版本（如 `v0.10.0`）标签，满足不同稳定性需求。  


## 3. 使用场景和适用范围

- **本地开发**：开发者在编写 shell 脚本后，快速进行本地语法和逻辑检查。  
- **CI/CD 集成**：作为代码检查环节集成到 CI 工作流，确保提交或构建前脚本质量。  
- **镜像集成**：将 `shellcheck` 二进制文件复制到自定义 Docker 镜像，扩展基础镜像功能。  


## 4. 详细使用方法和配置说明

### 4.1 从命令行运行最新版本

通过 `docker run` 命令直接运行镜像，挂载当前目录到容器的 `/mnt` 目录（脚本需位于当前目录），可查看版本信息或检查脚本：

```bash
# 查看版本信息
docker run --rm -it -v "$(pwd):/mnt" docker.xuanyuan.run/koalaman/shellcheck:latest --version
```

**参数说明**：  
- `--rm`：容器退出后自动删除。  
- `-it`：交互模式，分配终端。  
- `-v "$(pwd):/mnt"`：将宿主机当前目录挂载到容器的 `/mnt` 目录，使容器可访问宿主机脚本文件。  


### 4.2 创建 Shell 别名

为简化命令，可将 `docker run` 命令添加为 shell 别名（如 `.bashrc` 或 `.zshrc`）：

```bash
# 添加别名到 .bashrc
echo 'alias shellcheck="docker run --rm -it -v \"\$(pwd):/mnt\" koalaman/shellcheck:stable"' >> ~/.bashrc

# 重启终端或执行以下命令使别名生效
source ~/.bashrc

# 验证别名
shellcheck --version
```

**说明**：使用 `stable` 标签可确保获取稳定版本，避免频繁更新导致命令行为变化。


### 4.3 集成到 CI 工作流

#### 4.3.1 通过通配符检查脚本

检查当前目录下所有 `.sh` 后缀的脚本：

```bash
docker run --rm -it -v "$(pwd):/mnt" docker.xuanyuan.run/koalaman/shellcheck:stable *.sh
```

#### 4.3.2 递归按文件名检查

通过 `find` 命令递归查找所有 `.sh` 后缀的脚本并检查：

```bash
find . -name '*.sh' -exec docker run --rm -it -v "$(pwd):/mnt" koalaman/shellcheck:stable {} +
```

#### 4.3.3 递归识别 Shebang 检查

通过 `find` 和 `grep` 识别包含 `#!.*sh` shebang 的文件（无论是否有 `.sh` 后缀），并进行检查：

```bash
find . -type f -exec grep -q '^#!.*sh' {} \; -exec docker run --rm -it -v "$(pwd):/mnt" koalaman/shellcheck:stable {} +
```

**提示**：为避免新版本导致构建中断，建议将 `stable` 替换为具体版本（如 `v0.10.0`）。更多高级集成方案可参考 [shellcheck pre-commit 插件](https://github.com/koalaman/shellcheck-precommit)。


### 4.4 与 Linux 工具配合使用

基础镜像 `koalaman/shellcheck` 不含 Unix 用户空间工具（如 `ls`、`grep` 等）。如需集成 Linux 工具，可使用 [koalaman/shellcheck-alpine](https://hub.docker.com/r/koalaman/shellcheck-alpine/) 镜像，该镜像基于 Alpine Linux，包含完整用户空间工具集。


### 4.5 包含到自定义 Docker 镜像

可通过多阶段构建，将 `shellcheck` 二进制文件复制到自定义镜像中（如基于 Alpine 的镜像）：

```dockerfile
# 自定义镜像示例（基于 Alpine）
FROM docker.xuanyuan.run/alpine:latest
# 从 shellcheck 镜像复制二进制文件
COPY --from=koalaman/shellcheck:stable /bin/shellcheck /bin/

# 验证安装
RUN shellcheck --version
```


## 5. 版本标签说明

| 标签格式       | 说明                                  | 适用场景                     |
|----------------|---------------------------------------|------------------------------|
| `latest`       | 对应 ShellCheck 最新 Git 提交版本     | 尝鲜新功能，不保证稳定性     |
| `stable`       | 对应最新稳定发布版本                  | 本地开发或非关键 CI 流程     |
| `v<版本号>`    | 具体版本（如 `v0.10.0`）              | 关键 CI 流程，避免版本变更风险 |

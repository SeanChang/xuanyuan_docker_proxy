---
image: avdteam/action-molecule
description: "用于GitHub Actions的Molecule运行器，支持AVD代码验证，可执行Molecule命令并检查执行后的Git状态以跟踪意外文件变更，支持强制执行变更检查。"
source: https://xuanyuan.cloud/zh/r/avdteam/action-molecule
canonical: https://xuanyuan.cloud/zh/r/avdteam/action-molecule
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/avdteam/action-molecule" title="avdteam/action-molecule Docker 镜像中文简介、标签列表与拉取命令">avdteam/action-molecule 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# GitHub Action for Molecule

## 镜像概述和主要用途
该GitHub Action允许使用Ansible集合结构运行[Molecule](https://molecule.readthedocs.io/en/latest/)，用于AVD（Arista Validated Design）代码验证。此外，支持在Molecule执行后检查Git状态，以跟踪意外文件变更，且可强制执行变更检查并在检测到变更时生成失败结果。

## 核心功能和特性
- 支持Molecule命令执行，包括check、cleanup、converge等多种操作
- 提供Molecule运行选项配置，如调试模式、基础配置文件、环境变量文件等
- 支持指定场景、驱动程序或执行所有场景
- 可安装自定义Python依赖（通过pip文件）和Ansible Galaxy依赖
- 支持指定Ansible版本
- 执行后检查Git状态，跟踪意外文件变更
- 可强制执行Git状态检查，变更时返回失败

## 输入参数（Inputs）

| 参数名               | 描述                                                                 | 是否必填 | 默认值       |
|----------------------|----------------------------------------------------------------------|----------|--------------|
| molecule_parentdir   | molecule文件夹的相对路径                                             | 否       | -            |
| molecule_options     | Molecule选项，支持：<br>- --debug/--no-debug：启用/禁用调试模式<br>- -c/--base-config：基础配置文件路径<br>- -e/--env-file：环境变量文件（.env.yml）<br>- --version：显示版本<br>- --help：显示帮助 | 否       | -            |
| molecule_command     | Molecule命令，支持：check、cleanup、converge、create、dependency、destroy、idempotence、init、lint、list、login、matrix、prepare、side-effect、syntax、test、verify | 是       | 'test'       |
| molecule_args        | Molecule参数，支持：<br>- --scenario-name：指定场景<br>- --driver-name：指定驱动<br>- --all：所有场景<br>- --destroy=always：始终销毁实例 | 否       | -            |
| pip_file             | 从`${GITHUB_REPOSITORY}`开始的相对路径，用于安装运行Molecule前的Python依赖 | 否       | -            |
| ansible              | 要安装的Ansible包，支持pip语法指定版本                               | 否       | 'ansible'    |
| galaxy_file          | 从`${GITHUB_REPOSITORY}`开始的相对路径，用于安装Ansible Galaxy依赖   | 否       | ''           |
| check_git            | Molecule执行后检查Git状态，跟踪两次提交间的意外变更                   | 否       | -            |
| check_git_enforced   | 设为true时，退出码基于Git状态（有变更则失败）                         | 否       | -            |

## 使用场景和适用范围
适用于在GitHub Actions工作流中对AVD项目进行Molecule测试，确保Ansible角色/集合的质量和一致性，尤其适合需要自动化验证代码变更的CI/CD流程。

## 使用方法和配置说明

### GitHub Actions工作流配置示例
在仓库的`.github/workflows/`目录下创建`main.yml`（或自定义名称）：

```yaml
on: push

jobs:
  molecule:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Run molecule action
        uses: arista-netdevops-community/action-molecule-avd@v1.0
        with:
          molecule_parentdir: 'ansible_collections/arista/cvp'
          molecule_command: 'test'
          molecule_args: '--all'
          ansible: ansible>=2.10
          pip_file: 'requirements.txt'
          check_git: true
          check_git_enforced: false
```

### 本地测试
1. 创建环境变量文件（如`test.env`）：
```shell
# cat test.env
INPUT_PIP_FILE=requirements.txt
INPUT_MOLECULE_PARENTDIR=/root/ansible_collections/arista/cvp
INPUT_MOLECULE_COMMAND=test
INPUT_MOLECULE_ARGS=--all
```

2. 运行Docker容器：
```shell
docker run --rm -it \
    -v ${PWD}:/root/ \                              # 本地内容与容器共享
    -v /var/run/docker.sock:/var/run/docker.sock \  # Molecule需要的Docker进程
    --env-file dev.env \                            # 包含变量的文件
    avdteam/action-molecule:v1.0

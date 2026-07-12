---
image: fastsolve/desktop
description: "这是基于Ubuntu 16.04的FastSolve开发环境镜像，包含LXDE桌面、Octave、Python（含NumPy/SciPy/Pandas/Spyder）、Jupyter Notebook和Atom，可通过浏览器访问，支持Linux、Mac、Windows跨平台使用。"
source: https://xuanyuan.cloud/zh/r/fastsolve/desktop
canonical: https://xuanyuan.cloud/zh/r/fastsolve/desktop
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/fastsolve/desktop" title="fastsolve/desktop Docker 镜像中文简介、标签列表与拉取命令">fastsolve/desktop 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# FastSolve开发环境Docker镜像
该Docker镜像为FastSolve提供基于Ubuntu 16.04的开发环境，包含轻量级LXDE窗口管理器，预装Octave 4.0.2、Python 3.5.2（含NumPy、SciPy、Pandas和Spyder）、Jupyter Notebook及Atom编辑器。X窗口可在浏览器中全屏显示，支持64位Linux、Mac或Windows系统，确保用户在不同设备上使用一致的编程环境。

[![构建状态](https://travis-ci.org/fastsolve/docker-desktop.svg)](https://travis-ci.org/fastsolve/docker-desktop) [![](https://images.microbadger.com/badges/image/fastsolve/desktop.svg)](https://microbadger.com/images/fastsolve/desktop)

## 镜像概述
本镜像旨在为FastSolve用户和开发者提供统一、便捷的开发环境，无需在本地配置复杂的科学计算工具链。通过浏览器即可访问完整的桌面环境，支持跨平台运行，降低环境配置成本。

## 核心功能
- **预装工具**: 包含Octave（数值计算）、Python数据科学库（NumPy/SciPy/Pandas）、Spyder（Python IDE）、Jupyter Notebook（交互式分析）、Atom（代码编辑器）；
- **轻量级桌面**: LXDE窗口管理器，资源占用低，通过浏览器即可访问；
- **跨平台兼容**: 支持64位Linux、Mac、Windows系统；
- **可选MATLAB**: 开发者可通过参数安装MATLAB（需用户自行认证激活）；
- **离线运行**: 下载镜像后可无网络使用。

## 使用场景
- **FastSolve用户**: 在不同操作系统上使用统一的开发环境；
- **科学计算**: 利用Octave/Python进行数值分析、数据处理；
- **交互式教学**: 通过Jupyter Notebook开展编程或数据分析教学；
- **离线工作**: 在无网络环境下运行已下载的镜像完成任务。

## 配置说明
### 准备工作
1. **安装Python**: 
   - Linux/Mac通常已预装，可跳过；
   - Windows用户建议安装Miniconda（[下载地址](https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe)），安装时选择设为系统默认Python。
2. **安装Docker**: 下载Docker Community Edition（[地址](https://www.docker.com/community-edition#/download)），需管理员权限安装，安装后启动Docker。

**OS-specific注意事项**:
- **Windows**: 仅支持64位Win10 Pro及以上；需将用户加入`docker-users`组；共享C盘；调整镜像存储位置到私有目录；
- **Mac**: 解决Docker睡眠唤醒后的时钟问题（重启Docker或安装sync-docker-time）；调整代理设置避免重启；
- **Linux**: 安装后执行`sudo adduser $USER docker`，注销后重新登录。

### 运行镜像
#### 作为桌面环境运行
1. 下载脚本到工作目录：
   - Windows（PowerShell）:
     ```
     curl https://raw.githubusercontent.com/fastsolve/docker-desktop/master/fastsolve_desktop.py -outfile fastsolve_desktop.py
     ```
   - Linux/Mac（终端）:
     ```
     curl -s -O https://raw.githubusercontent.com/fastsolve/docker-desktop/master/fastsolve_desktop.py
     ```
2. 启动镜像：
   ```
   python fastsolve_desktop.py -p
   ```
   `-p`参数用于拉取最新镜像。开发者如需MATLAB：
   ```
   python fastsolve_desktop.py -p -m
   ```
   需通过Google账户认证下载，并用MathWorks账户激活（仅首次需要）。

#### 作为Jupyter Notebook服务器运行
替换脚本为`fastsolve_jupyter.py`：
- Windows:
  ```
  curl https://raw.githubusercontent.com/fastsolve/docker-desktop/master/fastsolve_jupyter.py -outfile fastsolve_jupyter.py
  python fastsolve_jupyter.py -p
  ```
- Linux/Mac:
  ```
  curl -s -O https://raw.githubusercontent.com/fastsolve/docker-desktop/master/fastsolve_jupyter.py
  python fastsolve_jupyter.py -p
  ```

#### 离线运行
下载镜像后，无需网络即可运行：
```
python fastsolve_desktop.py  # 桌面模式
# 或
python fastsolve_jupyter.py  # Jupyter模式
```

### 停止镜像
- 在启动脚本的终端按两次Ctrl-C；
- 或在Docker桌面左下角点击“logout”按钮；
- 或通过`docker stop <容器ID>`（用`docker ps -a`查看ID）。

### 全屏模式
推荐使用Chrome/Chromium浏览器：
- Windows/Linux: 菜单`View→Full Screen`，或按F11；
- Mac: 菜单`View→Enter Full Screen`，或按Ctrl+Cmd+f。

### 技巧与提示
1. **资源调整**: 在Docker设置中调整CPU核心数和内存（Mac/Windows：Settings→Advanced）；
2. **持久化目录**: `$HOME/.config`（配置）、`$HOME/.ssh`（映射主机SSH密钥）、`$HOME/shared`（映射主机工作目录）等目录内容会保留；
3. **SSH密钥**: 运行`ssh-add`添加密钥到ssh-agent，方便访问Git仓库；
4. **剪贴板同步**: 通过左侧工具栏的“Clipboard”框实现主机与容器间的复制粘贴；
5. **正确停止容器**: 不要仅关闭浏览器，需按上述停止方法操作。

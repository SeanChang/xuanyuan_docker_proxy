# 从零开始Docker部署OpenClaw：踩坑全记录+新手保姆级教程

![从零开始Docker部署OpenClaw：踩坑全记录+新手保姆级教程](https://img.xuanyuan.dev/docker/blog/docker-openclaw.png)

*分类: OpenClaw,AI,部署教程 | 标签: OpenClaw,AI,部署教程 | 发布时间: 2026-04-25 09:00:29*

> OpenClaw（江湖人称"龙虾"）绝对是其中的佼佼者。它不仅支持GPT-5.5、Claude Opus等几乎所有主流大模型，还能一键集成浏览器控制、文件操作、语音通话等强大功能。今天将完整的部署步骤和所有踩坑经验整理出来，新手照着做也能10分钟成功部署！

OpenClaw（江湖人称"龙虾"）绝对是其中的佼佼者。它不仅支持GPT-5.5、Claude Opus等几乎所有主流大模型，还能一键集成浏览器控制、文件操作、语音通话等强大功能。

今天我把完整的部署步骤和所有踩坑经验整理出来，新手照着做也能10分钟成功部署！

## 一、什么是OpenClaw？
OpenClaw是一个开源的AI网关和智能体运行平台，它就像一个"龙虾管家"，帮你统一管理所有大模型API，同时提供强大的工具调用能力。你可以用它来：
- 统一管理OpenAI、Anthropic、DeepSeek等多个大模型
- 让AI直接控制浏览器、操作文件、执行命令
- 构建自己的AI助手，集成到微信、Telegram等平台
- 实现复杂的自动化工作流

## 二、前置准备：Docker 环境一键搞定

部署的前提是拥有可用的 Docker 环境，不管是 Linux、Windows 还是 Mac，下面的方法都能快速搞定，尤其适合新手，避免踩环境配置的坑。

## 1. Linux 系统 Docker 一键安装（含国产系统适配）
Linux 系统（包括银河麒麟、欧拉、统信 UOS 等国产系统）直接用下面的脚本，一键安装 Docker、Docker Compose，还会自动配置轩辕镜像加速，省去手动配置的麻烦。[1]

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

该脚本支持多种架构（x86_64、ARM64 等）和众多 Linux 发行版，包括但不限于：
- Ubuntu / Debian / Kali / Deepin
- CentOS / RHEL / Rocky Linux / AlmaLinux
- 银河麒麟 (Kylin) / 统信 UOS / openEuler (欧拉) / OpenCloudOS / Anolis (龙蜥) 

## 2. Windows / Mac 用户
Windows 和 Mac 用户不用复杂的命令行操作，直接去 Docker 官网下载 Docker Desktop 即可，图形化界面操作简单，安装完成后启动 Docker 即可（启动后会在后台运行，桌面状态栏会有对应图标）。

**Docker Desktop 下载地址**：https://www.docker.com/get-started/

## 验证 Docker 环境
安装完成后，验证一下 Docker 是否正常运行，打开终端（Linux）或 PowerShell（Windows），输入以下命令：

```bash
docker version
```

如果能正常显示 Docker 的版本信息（Client 和 Server 都有版本号），说明环境已经准备就绪，可以开始部署了。


## 三、最新版OpenClaw部署步骤（新手直接复制）
经过多次踩坑，我总结出了**最稳妥、最简洁**的部署流程，新手直接复制粘贴命令即可。

> **推荐**：使用 OpenClaw 最新版本，与其他镜像不同，OpenClaw 更新较快，老版本问题较多。

### 1. 拉取最新版镜像
首先，我们拉取官方最新版的OpenClaw镜像：
```powershell
docker pull docker.xuanyuan.run/alpine/openclaw:latest
```

### 2. 清理旧配置（关键！）
这是**最重要的一步**，很多问题都是因为旧配置冲突导致的。
打开文件夹：`C:\Users\你的用户名`
找到并**删除** `.openclaw` 文件夹（如果存在的话）

### 3. 启动容器
使用以下命令启动OpenClaw容器：
####powershell 启动命令
```powershell
docker run -d --name openclaw -p 127.0.0.1:18789:18789 -v C:\Users\你的用户名\.openclaw:/home/node/.openclaw docker.xuanyuan.run/alpine/openclaw:latest openclaw gateway --port 18789 --allow-unconfigured
```

#### Linux 启动命令
```bash
docker run -d --name openclaw \
  -p 127.0.0.1:18789:18789 \
  -v ~/.openclaw:/home/node/.openclaw \
  docker.xuanyuan.run/alpine/openclaw:latest \
  openclaw gateway --port 18789 --allow-unconfigured
```

**参数说明：**
- `-d`：后台运行容器
- `--name openclaw`：给容器命名为openclaw
- `-p 127.0.0.1:18789:18789`：将容器的18789端口映射到本地的18789端口
- `-v`：将本地的`.openclaw`文件夹挂载到容器内，实现数据持久化
- `--allow-unconfigured`：允许在未配置API密钥的情况下启动网关

### 4. 验证服务状态
等待15秒左右，执行以下命令查看服务状态：
```powershell
docker logs -f openclaw
```

如果看到以下输出，说明服务已经成功启动：
```
[gateway] ready (5 plugins: acpx, browser, device-pair, phone-control, talk-voice; 9.3s)
[gateway] listening on ws://0.0.0.0:18789
```

看到这两行就可以按 `Ctrl+C` 退出日志查看了。

### 5. 获取官方仪表盘链接
执行以下命令获取带Token的官方仪表盘链接：
```powershell
docker exec -it openclaw openclaw dashboard --no-open
```

你会看到类似这样的输出：
```
Dashboard URL: http://127.0.0.1:18789/#token=a3feb6fd93afaefa072f8d47891eaa20a70ee3ad6d8e1d12
```

### 6. 浏览器访问验证
**忽略任何工具的报错信息**，直接在你的Chrome/Edge浏览器中复制粘贴上面的链接。

![OpenClaw的仪表盘界面](https://img.xuanyuan.dev/docker/blog/docker-openclaw-1.png)

如果一切顺利，你会看到OpenClaw的仪表盘界面，恭喜你部署成功了！

## 四、踩坑全记录（常见问题FAQ）
这是本文最有价值的部分，我把部署过程中遇到的所有问题都整理出来了，每个问题都有详细的解决方案。

### ❌ 问题1：端口映射错误
**错误现象：**
```
docker: Error response from daemon: ports are not available: exposing port TCP 187.0.0.1:18789 -> 127.0.0.1:0: listen tcp4 187.0.0.1:18789: can't bind on the specified endpoint
```

**原因分析：**
手滑把本地回环地址写成了`187.0.0.1`，正确的应该是`127.0.0.1`。

**解决方案：**
使用正确的端口映射格式：
```powershell
-p 127.0.0.1:18789:18789
```

### ❌ 问题2：Token不匹配错误
**错误现象：**
```
[ws] unauthorized conn=xxx remote=172.17.0.1 reason=token_mismatch
```

**原因分析：**
使用了旧的Token链接，或者手动修改了配置文件中的Token。

**解决方案：**
1. 停止并删除当前容器
2. 删除本地的`.openclaw`文件夹
3. 重新启动容器，让系统自动生成新的Token
4. 使用`docker exec -it openclaw openclaw dashboard --no-open`获取最新的链接

### ❌ 问题3：服务只监听容器内部回环地址
**错误现象：**
浏览器访问链接时出现`ERR_EMPTY_RESPONSE`错误，日志显示：
```
[gateway] listening on ws://127.0.0.1:18789, ws://[::1]:18789
```

**原因分析：**
系统默认生成的配置文件中，`gateway.bind`设置为了`loopback`，导致服务只监听容器内部的回环地址，Docker端口映射失效。

**解决方案：**
1. 停止当前容器
2. 打开本地的`.openclaw/openclaw.json`文件
3. 将`"bind": "loopback"`改为`"bind": "lan"`
4. 重新启动容器

### ❌ 问题4：配对流程问题（旧版本特有）
**错误现象：**
浏览器访问链接时提示`pairing required`，但日志中没有显示配对码。

**原因分析：**
旧版本（v2026.3.25及以下）的OpenClaw不会在普通日志中打印配对码，必须使用专门的命令查看。

**解决方案：**
1. 刷新浏览器页面，触发配对请求
2. 立即执行以下命令查看待处理的配对请求：
   ```powershell
   docker exec -it openclaw openclaw pairing list --channel webchat
   ```
3. 你会看到类似这样的输出：
   ```
   Pending pairing requests:
     - code: 123456, channel: webchat, remote: 172.17.0.1
   ```
4. 执行以下命令批准配对请求：
   ```powershell
   docker exec -it openclaw openclaw pairing approve --channel webchat 123456
   ```
5. 再次刷新浏览器页面

**最佳解决方案：**
直接升级到最新版（v2026.4.23及以上），最新版已经**默认禁用了本地模式下的配对流程**，不需要再进行繁琐的配对操作。

### ❌ 问题5：工具访问本地回环地址报错
**错误现象：**
使用某些工具访问`http://127.0.0.1:18789`时提示"URL拼写可能存在错误"。

**原因分析：**
这是工具访问本地回环地址的限制，不是真实问题。

**解决方案：**
忽略工具的报错信息，直接在真实的浏览器（Chrome/Edge/Firefox）中打开链接即可。

### ❌ 问题6：配置文件不兼容
**错误现象：**
启动容器时提示：
```
Invalid config at /home/node/.openclaw/openclaw.json:
- gateway: Unrecognized key: "pairing"
```

**原因分析：**
手动添加了当前版本不支持的配置项。

**解决方案：**
1. 停止当前容器
2. 删除本地的`.openclaw`文件夹
3. 重新启动容器，让系统自动生成兼容的配置文件

### ❌ 问题7：启动参数错误
**错误现象：**
启动容器时提示：
```
error: unknown option '--mode'
```

**原因分析：**
使用了当前版本不支持的启动参数。

**解决方案：**
使用官方推荐的最简启动命令：
```powershell
docker run -d --name openclaw -p 127.0.0.1:18789:18789 -v C:\Users\你的用户名\.openclaw:/home/node/.openclaw docker.xuanyuan.run/alpine/openclaw:latest openclaw gateway --port 18789 --allow-unconfigured
```

### ❌ 问题8：容器无法启动
**错误现象：**
执行`docker run`命令后，容器立即退出。

**原因分析：**
可能是端口被占用、权限不足或者配置文件损坏。

**解决方案：**
1. 检查18789和18791端口是否被占用：
   ```powershell
   netstat -ano | findstr :18789
   ```
2. 如果端口被占用，杀死占用端口的进程，或者修改映射端口
3. 删除本地的`.openclaw`文件夹，重新启动容器

## 五、总结
经过这次踩坑，我总结出了OpenClaw部署的**三大黄金法则**：
1. **永远使用最新版镜像**：最新版修复了绝大多数bug，特别是配对流程的问题
2. **部署前一定要清理旧配置**：90%的问题都是因为旧配置冲突导致的
3. **使用官方原生命令**：不要手动修改配置文件，除非你非常清楚自己在做什么

现在你已经成功部署了OpenClaw，接下来可以在仪表盘里添加你的大模型API密钥，开始体验这个强大的AI网关工具了。如果你在部署过程中遇到了其他问题，欢迎在评论区留言交流。

## 六、下一步
- 添加你的OpenAI/Anthropic API密钥
- 安装各种实用插件
- 集成到Open WebUI
- 构建你的第一个AI自动化工作流

希望这篇文章对你有帮助。


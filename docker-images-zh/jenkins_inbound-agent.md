---
image: jenkins/inbound-agent
description: "这是一个用于Jenkins代理的镜像，该镜像支持通过TCP或WebSocket协议建立入站连接至Jenkins控制器，旨在实现代理与控制器之间的稳定通信，确保Jenkins任务能够在代理节点上顺利执行，适用于需要灵活配置网络连接方式的Jenkins环境，为分布式构建和部署提供可靠的基础设施支持。"
source: https://xuanyuan.cloud/zh/r/jenkins/inbound-agent
canonical: https://xuanyuan.cloud/zh/r/jenkins/inbound-agent
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jenkins/inbound-agent" title="jenkins/inbound-agent Docker 镜像中文简介、标签列表与拉取命令">jenkins/inbound-agent 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Jenkins入站代理Docker镜像


## 警告
**注意！** 该镜像曾以 [jenkinsci/jnlp-slave]([]) 和 [jenkins/jnlp-slave]([]) 发布，目前这两个镜像已弃用，请使用 [jenkins/inbound-agent]([])。


## 概述
本镜像用于 Jenkins 代理，通过 TCP 或 WebSocket 与 Jenkins 控制器建立入站连接。代理功能基于 [Jenkins Remoting 库]([]) 实现，其版本取自基础 [Docker Agent 镜像]([])。关于代理的更多使用说明，参见 [《使用代理》]([]) 文档。


## 用容器镜像配置代理

### 在Jenkins上设置代理
1. 进入 Jenkins 控制台
2. 从主菜单选择 **Manage Jenkins**（管理 Jenkins）
3. 在 **System Configuration**（系统配置）中选择 **Nodes**（节点）  
   （操作界面如图所示）
4. 从侧边菜单选择 **New Node**（新建节点）
5. 填写节点（代理）名称并选择类型（例如：名称填 agent1，类型选 Permanent Agent（永久代理））
6. 填写远程根目录、标签、执行器数量等字段，**关键设置**：  
   - **启动方式选择“通过连接到控制器启动代理”**（如图所示）
7. 点击 **Save**（保存），agent1 会注册成功但暂时处于离线状态，点击进入该节点
8. 此时可查看代理密钥，将密钥作为容器参数传入，或设置为 `JENKINS_SECRET` 环境变量（如图所示）


### 运行容器
#### 基本命令
> **注意**  
> 需替换命令中的 `<secret>`（代理密钥）和 `<agent name>`（代理名称），可从上方“在Jenkins上设置代理”步骤获取。代理节点需能连接 Jenkins 控制器的代理端口（默认50000，非80/443/8080等服务器端口），端口可在 **Manage Jenkins > Security > Agent** 中设置。

##### Linux代理
```bash
docker run --init jenkins/inbound-agent -url [] <secret> <agent name>
```
*注：`--init` 参数用于正确处理子进程（避免僵尸进程），必须添加。*

##### Windows代理
```bash
docker run jenkins/inbound-agent:windowsservercore-ltsc2019 -Url [] -Secret <secret> -Name <agent name>
```


#### 指定工作目录
若需自定义代理工作目录，可添加 `-workDir` 参数：

##### Linux代理
```bash
docker run --init jenkins/inbound-agent -url [] -workDir=/home/jenkins/agent <secret> <agent name>
```

##### Windows代理
```bash
docker run jenkins/inbound-agent:windowsservercore-ltsc2019 -Url [] -WorkDir=C:/Jenkins/agent -Secret <secret> -Name <agent name>
```


## 可选环境变量
以下环境变量可调整代理运行参数：

### 推荐使用
- `JENKINS_JAVA_BIN`：指定Java可执行文件路径，替代PATH或JAVA_HOME中的默认Java  
- `JENKINS_JAVA_OPTS`：Remoting进程的Java参数，未设置时取自JAVA_OPTS（**Windows使用需注意下方“Windows Jenkins Java参数”说明**）  
- `JENKINS_AGENT_FILE`：Jenkins代理JAR文件路径，默认使用 `/usr/share/jenkins/agent.jar`  
- `REMOTING_OPTS`：传递给agent.jar的额外命令行参数（可通过 `-help` 查看所有参数）  


### 已弃用（建议改用 `REMOTING_OPTS`）
- `JENKINS_URL`：Jenkins服务器URL，可替代 `-url` 参数  
- `JENKINS_TUNNEL`：格式 `HOST:PORT`，通过代理主机端口连接控制器（适用于Jenkins在负载均衡器/反向代理后场景）  
- `JENKINS_SECRET`：代理密钥，未通过命令行参数设置时使用  
- `JENKINS_AGENT_NAME`：代理名称，需与Jenkins上设置的名称一致  
- `JENKINS_AGENT_WORKDIR`：工作目录，未通过 `-workDir` 参数设置时使用  
- `JENKINS_WEB_SOCKET`：设为 `true` 时通过WebSocket而非TCP连接  
- `JENKINS_DIRECT_CONNECTION`：格式 `HOST:PORT`，直接连接TCP代理端口，跳过HTTP(S)参数下载  
- `JENKINS_INSTANCE_IDENTITY`：Jenkins控制器的InstanceIdentity字节数组（base64编码），设置后跳过HTTP(S)连接信息获取  
- `JENKINS_PROTOCOLS`：指定尝试的Remoting协议（当设置 `JENKINS_INSTANCE_IDENTITY` 时生效）  


## Windows Jenkins Java参数说明
Windows环境下，`JENKINS_JAVA_OPTS` 环境变量或 `-JenkinsJavaOpts` 命令行参数的解析遵循 [Powershell命令解析规则]([])。若参数包含Powershell表达式特殊字符，需用引号包裹：  
- 示例1：`-XX:+PrintCommandLineFlags --show-version` 需改为 `" -XX:+PrintCommandLineFlags" --show-version`  
- 示例2：`-Dsome.property=some value --show-version` 需改为 `"-Dsome.property='some value'" --show-version`  


## 配置注意事项

### 支持的JNLP协议
自3.40-1版本起，本镜像仅支持 [JNLP4-connect协议]([])，已移除早期不支持的旧协议。因此，Jenkins 2.32之前的版本不再兼容。


### Amazon ECS使用说明
运行前需确保ECS容器代理已 [更新]([])，旧版本可能无法正确处理 `entryPoint` 参数。详见 [entryPoint定义]([])。

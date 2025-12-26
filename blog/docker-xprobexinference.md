# 基于 Docker 部署 xprobe/xinference：从环境准备到实战操作

![基于 Docker 部署 xprobe/xinference：从环境准备到实战操作](https://img.xuanyuan.dev/docker/blog/docker-xinference.png)

*分类: Docker,xinference | 标签: xinference,docker,部署教程 | 发布时间: 2025-10-10 03:17:48*

> 如果你想部署一个AI模型做推理（比如用Qwen-7B做对话、用ResNet做图片分类），不用手动解决模型依赖、CUDA配置、环境冲突这些麻烦事——Xinference已经把这些工作封装好，尤其是通过Docker镜像，能让你在几分钟内搭好推理环境。

## 关于Xinference：它是什么，能用来做什么？
xprobe/xinference（简称Xinference）是一款开源的**AI模型推理服务工具**，核心作用是帮你快速加载、运行来自ModelScope、Hugging Face等平台的各类AI模型（比如大语言模型LLM、图像识别模型、语音处理模型等），并提供稳定的推理服务接口。

简单说，如果你想部署一个AI模型做推理（比如用Qwen-7B做对话、用ResNet做图片分类），不用手动解决模型依赖、CUDA配置、环境冲突这些麻烦事——Xinference已经把这些工作封装好，尤其是通过Docker镜像，能让你在几分钟内搭好推理环境。它的核心价值主要有三点：
1. **简化部署**：统一模型加载逻辑，支持多平台模型源，不用针对每个模型单独配环境；
2. **性能优化**：默认依赖NVIDIA GPU加速，能充分利用硬件资源提升推理访问表现；
3. **灵活适配**：提供GPU和CPU两种镜像版本，有GPU用GPU版提速，没GPU也能靠CPU跑基础模型。

不管是开发者测试模型、小企业部署AI服务，还是大企业搭建多模型推理集群，Xinference都能适配场景需求。


## 准备工作：先搞定基础环境
在部署Xinference前，必须确保两件事：Docker环境已装好，GPU/CUDA环境符合要求（CPU版可跳过GPU检查）。

### 1. 安装Docker与Docker Compose（必做）
如果你的Linux服务器还没装Docker，直接用下面的一键脚本——它会自动安装Docker、Docker Compose，还会配置轩辕镜像访问支持源，避免拉取镜像慢的问题（国内用户强烈推荐）：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```
执行完脚本后，可通过`docker --version`和`docker compose --version`检查是否安装成功，能看到版本号就说明没问题。

### 2. 检查GPU与CUDA环境（GPU版必做，CPU版跳过）
Xinference的GPU版依赖NVIDIA GPU和CUDA，这是硬性要求，少一步都跑不起来，具体要求和检查方法如下：
- **要求**：主机CUDA版本≥12.4（若用`cu128`标签需≥12.8），NVIDIA驱动版本≥550，容器才能正常调用GPU；
- **检查方法**：在服务器终端执行`nvidia-smi`命令：
  - 如果命令报错（比如“command not found”），说明NVIDIA驱动没装，需要先去[NVIDIA官网](https://www.nvidia.com/)下载对应显卡的驱动；
  - 如果命令成功执行，看输出结果里的“CUDA Version”和“Driver Version”：
    - 比如输出“CUDA Version: 12.5”“Driver Version: 555.42.02”，符合`latest`标签要求；若要使用`latest-cu128`，需确保CUDA Version≥12.8；
    - 若CUDA版本或驱动低于要求，需要升级（可参考NVIDIA官方文档升级CUDA和驱动）。


## 第一步：了解Xinference的Docker镜像（含轩辕镜像同步说明）
Xinference的官方镜像默认存放在Docker Hub的`xprobe/xinference`仓库，而**轩辕镜像（国内加速平台）** 会实时同步该仓库的所有镜像，标签和内容完全一致，国内用户通过轩辕镜像拉取能避免跨境网络延迟，访问表现提升2-5倍。

### 镜像标签分类与适用场景
不管是Docker Hub还是轩辕镜像，支持的标签完全相同，按功能可分为以下几类，选对标签是部署的第一步：

| 镜像标签          | 核心特点                                  | 适用场景                          | 对应轩辕镜像拉取地址                          |
|-------------------|-------------------------------------------|-----------------------------------|-------------------------------------------|
| nightly-main      | 每天从GitHub主分支构建，含最新功能，稳定性一般 | 测试新特性、开发调试              | docker pull docker.xuanyuan.run/xprobe/xinference:nightly-main |
| nightly-main-cu128| nightly-main基础上预装CUDA 12.8           | 测试新功能且依赖高版本CUDA        | docker pull docker.xuanyuan.run/xprobe/xinference:nightly-main-cu128 |
| nightly-main-cpu  | 纯CPU版，无GPU依赖，体积小（3.11GB）      | 无GPU环境，测试轻量模型           | docker pull docker.xuanyuan.run/xprobe/xinference:nightly-main-cpu |
| latest            | 指向最新正式版，经过测试，稳定性高        | 初学者、通用GPU场景               | docker pull docker.xuanyuan.run/xprobe/xinference:latest |
| latest-cu128      | 最新正式版+CUDA 12.8，适合高版本CUDA需求  | 需高版本CUDA的生产环境            | docker pull docker.xuanyuan.run/xprobe/xinference:latest-cu128 |
| v<版本号>（如v0.14.0） | 固定正式版本，无自动更新风险            | 生产环境、需版本锁定的场景        | docker pull docker.xuanyuan.run/xprobe/xinference:v0.14.0 |

**新手推荐**：国内用户用轩辕镜像的`latest`（GPU版）或`nightly-main-cpu`（CPU版）；**生产环境推荐**：用轩辕镜像的`v<版本号>`（如v0.14.0），避免自动更新导致兼容性问题。


## 第二步：拉取Xinference镜像
根据你的网络环境（国内/国外）和硬件（GPU/CPU），选择对应的拉取方式。国内用户优先用轩辕镜像，国外用户可直接从Docker Hub拉取，两种方式的验证方法一致。

### 2.1 国内用户：轩辕镜像拉取方式

#### （1）GPU版镜像（有GPU优先选）
- **最新稳定版（新手首选）**：
  ```bash
  # 拉取轩辕镜像的latest标签（15.71 GB，linux/amd64）
  docker pull docker.xuanyuan.run/xprobe/xinference:latest
  ```
- **最新稳定版+CUDA 12.8（高版本CUDA需求）**：
  ```bash
  # 拉取轩辕镜像的latest-cu128标签（13.58 GB，linux/amd64）
  docker pull docker.xuanyuan.run/xprobe/xinference:latest-cu128
  ```
- **每日测试版（尝新功能）**：
  ```bash
  # 拉取轩辕镜像的nightly-main标签（15.71 GB，linux/amd64）
  docker pull docker.xuanyuan.run/xprobe/xinference:nightly-main
  ```
- **每日测试版+CUDA 12.8（尝新+高版本CUDA）**：
  ```bash
  # 拉取轩辕镜像的nightly-main-cu128标签（13.59 GB，linux/amd64）
  docker pull docker.xuanyuan.run/xprobe/xinference:nightly-main-cu128
  ```

#### （2）CPU版镜像（无GPU环境专用）
仅支持`nightly-main-cpu`标签，体积小（3.11 GB），拉取访问表现快：
```bash
# 拉取轩辕镜像的nightly-main-cpu标签（3.11 GB，linux/amd64）
docker pull docker.xuanyuan.run/xprobe/xinference:nightly-main-cpu
```

### 2.2 国外用户：Docker Hub拉取方式
直接拉取官方仓库镜像，命令如下：
- GPU版最新稳定版：`docker pull xprobe/xinference:latest`
- GPU版CUDA 12.8：`docker pull xprobe/xinference:latest-cu128`
- CPU版：`docker pull xprobe/xinference:nightly-main-cpu`

### 2.3 （可选）重命名镜像（简化后续命令）
轩辕镜像的地址较长（`docker.xuanyuan.run/xprobe/xinference`），后续启动容器时输入麻烦，可重命名为与Docker Hub一致的简洁名称（如`xprobe/xinference:latest`），示例如下（以轩辕的`latest`标签为例）：
```bash
# 重命名镜像（原地址→简化名称）
docker tag docker.xuanyuan.run/xprobe/xinference:latest xprobe/xinference:latest
# （可选）删除原轩辕镜像标签，避免占用命名空间
docker rmi docker.xuanyuan.run/xprobe/xinference:latest
```
重命名后，后续启动容器时直接用`xprobe/xinference:latest`即可，与Docker Hub拉取的镜像用法完全一致。

### 2.4 验证镜像拉取成功
无论用哪种方式拉取，执行以下命令确认镜像存在：
```bash
# 过滤Xinference相关镜像
docker images | grep -E "xprobe/xinference|docker.xuanyuan.run/xprobe/xinference"
```
若输出类似以下内容，说明拉取成功（以轩辕`latest`标签为例）：
```
docker.xuanyuan.run/xprobe/xinference   latest    678e4abc1234   2天前    15.71 GB
# 若重命名过，会显示：xprobe/xinference   latest    678e4abc1234   2天前    15.71 GB
```


## 第三步：部署Xinference（三种场景，按需选择）
以下部署方案同时适用于“轩辕镜像拉取”和“Docker Hub拉取”的镜像（若重命名过，直接用简化名称；未重命名则用轩辕完整地址），步骤详细到每一条命令，跟着做即可。

### 方案1：快速部署（测试用，适合新手）
这个方案适合临时测试Xinference功能，不用考虑持久化（容器删了模型也没了），命令简单，一步启动。

#### GPU版启动命令（以轩辕拉取的`latest`标签为例，未重命名）：
```bash
docker run -d --name xinference-test \
  -e XINFERENCE_MODEL_SRC=modelscope \  # 国内优先选ModelScope，下载快
  -p 9998:9997 \  # 主机9998端口→容器9997端口（Xinference默认端口）
  --gpus all \  # GPU版必须加，分配所有GPU资源
  docker.xuanyuan.run/xprobe/xinference:latest \  # 未重命名用轩辕地址；重命名后用xprobe/xinference:latest
  xinference-local -H 0.0.0.0 --log-level debug  # 绑定所有网卡，开启debug日志
```

#### CPU版启动命令（未重命名，用轩辕`nightly-main-cpu`标签）：
```bash
docker run -d --name xinference-test \
  -e XINFERENCE_MODEL_SRC=modelscope \
  -p 9998:9997 \
  docker.xuanyuan.run/xprobe/xinference:nightly-main-cpu \  # 未重命名用轩辕地址；重命名后用xprobe/xinference:nightly-main-cpu
  xinference-local -H 0.0.0.0 --log-level debug
```

#### 关键参数解释（新手必看）：
- `-d`：容器后台运行，不占用当前终端；
- `--name xinference-test`：给容器命名，后续停止/查看日志用这个名字；
- `-e XINFERENCE_MODEL_SRC=modelscope`：指定从ModelScope下载模型（国内网络比Hugging Face快）；
- `--gpus all`：GPU版核心参数，少了会报“找不到GPU”错误；
- `-H 0.0.0.0`：绑定所有网卡，否则只能在容器内部访问，主机连不上。


### 方案2：挂载目录部署（实际项目用，推荐）
快速部署的问题是“模型不持久”——容器删了，下载的模型也没了。这个方案通过挂载主机目录，把模型、配置、缓存存在主机上，容器重启或重建都不丢数据，适合实际项目。

#### 第一步：在主机创建挂载目录
先建3个核心目录，分别存Xinference主配置、模型缓存（避免重复下载）：
```bash
# 目录路径可自定义（如/home/xxx/xinference），这里以/data/xinference为例
mkdir -p /data/xinference/{home,cache/huggingface,cache/modelscope}
```
目录作用：
- `/data/xinference/home`：存Xinference配置和下载的模型；
- `/data/xinference/cache/huggingface`：Hugging Face模型缓存；
- `/data/xinference/cache/modelscope`：ModelScope模型缓存（国内用户常用）。

#### 第二步：启动容器（挂载目录，以轩辕GPU版为例）
```bash
docker run -d --name xinference-service \
  # 挂载主机目录到容器（确保路径和你创建的一致）
  -v /data/xinference/home:/root/.xinference \
  -v /data/xinference/cache/huggingface:/root/.cache/huggingface \
  -v /data/xinference/cache/modelscope:/root/.cache/modelscope \
  # 环境变量（指定主目录和模型源）
  -e XINFERENCE_HOME=/root/.xinference \
  -e XINFERENCE_MODEL_SRC=modelscope,huggingface \
  -e TZ=Asia/Shanghai \  # 同步上海时区，避免日志时间错乱
  # 端口映射
  -p 9998:9997 \
  # GPU资源（CPU版去掉这行）
  --gpus all \
  # 镜像地址（未重命名用轩辕地址；重命名后用xprobe/xinference:latest）
  docker.xuanyuan.run/xprobe/xinference:latest \
  # 启动命令
  xinference-local -H 0.0.0.0
```

#### 验证挂载是否生效：
启动后，去主机的`/data/xinference/home`目录下，会看到Xinference自动生成的配置文件；后续加载模型时，模型文件会存在这个目录里，就算删除容器，重新启动后仍能复用之前的模型。


### 方案3：docker-compose部署（企业级，适合高级工程师）
如果需要长期运行，且要和其他服务（如前端、数据库）配合，用docker-compose更方便——把所有配置写在`docker-compose.yml`里，一键启动/停止，还能设置自动重启，保障服务稳定性。

#### 第一步：创建docker-compose.yml文件
在`/data/xinference`目录下创建`docker-compose.yml`，以下是**轩辕GPU版（latest标签）** 配置：
```yaml
version: '3'
services:
  xinference:
    # 镜像地址（未重命名用轩辕地址；重命名后用xprobe/xinference:latest）
    image: docker.xuanyuan.run/xprobe/xinference:latest
    # 容器名称
    container_name: xinference-service
    # 端口映射
    ports:
      - "9998:9997"
    # 目录挂载（和主机创建的目录对应）
    volumes:
      - /data/xinference/home:/root/.xinference
      - /data/xinference/cache/huggingface:/root/.cache/huggingface
      - /data/xinference/cache/modelscope:/root/.cache/modelscope
    # 环境变量
    environment:
      - XINFERENCE_HOME=/root/.xinference
      - XINFERENCE_MODEL_SRC=modelscope,huggingface
      - TZ=Asia/Shanghai
    # GPU资源配置（CPU版删除这部分）
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all  # 用所有GPU，也可写1/2指定数量
              capabilities: [gpu]
    # 容器退出后自动重启（保障服务不宕机）
    restart: always
    # 启动命令
    command: xinference-local -H 0.0.0.0
```

#### CPU版docker-compose.yml（轩辕`nightly-main-cpu`标签）：
```yaml
version: '3'
services:
  xinference:
    image: docker.xuanyuan.run/xprobe/xinference:nightly-main-cpu  # 未重命名用轩辕地址
    container_name: xinference-service
    ports:
      - "9998:9997"
    volumes:
      - /data/xinference/home:/root/.xinference
      - /data/xinference/cache/huggingface:/root/.cache/huggingface
      - /data/xinference/cache/modelscope:/root/.cache/modelscope
    environment:
      - XINFERENCE_HOME=/root/.xinference
      - XINFERENCE_MODEL_SRC=modelscope,huggingface
      - TZ=Asia/Shanghai
    restart: always
    command: xinference-local -H 0.0.0.0
```

#### 第二步：启动服务
在`docker-compose.yml`所在目录执行：
```bash
# 后台启动服务（首次启动会拉取依赖，耐心等1-2分钟）
docker compose up -d
# 查看服务状态（STATUS为Up说明正常运行）
docker compose ps
```

#### 常用企业级操作：
- 停止服务：`docker compose down`
- 实时查看日志：`docker compose logs -f`
- 重启服务：`docker compose restart`


## 第四步：验证部署是否成功
不管用哪种拉取和部署方式，都要通过以下三步确认服务正常，避免后续用的时候发现问题。

### 1. 检查容器运行状态
执行命令查看容器是否在运行：
```bash
# 按容器名过滤（方案1用xinference-test，方案2/3用xinference-service）
docker ps | grep xinference-service
```
若`STATUS`列显示`Up X minutes`（如Up 5 minutes），说明容器正常运行；若显示`Exited`，执行`docker logs 容器名`（如`docker logs xinference-service`）看报错原因（常见：GPU未识别、端口被占用）。

### 2. 测试服务接口
用`curl`命令测试Xinference的健康检查接口，或在浏览器访问（需开放9998端口）：
```bash
# 替换“你的服务器IP”为实际IP（如http://192.168.1.100:9998/v1/health）
curl http://你的服务器IP:9998/v1/health
```
若返回`{"status":"healthy"}`，说明服务正常；若返回“Connection refused”，检查两点：
- **安全组**：云服务器需在控制台开放9998端口；
- **防火墙**：服务器本地防火墙开放端口（CentOS：`firewall-cmd --add-port=9998/tcp --permanent && firewall-cmd --reload`；Ubuntu：`ufw allow 9998/tcp`）。

### 3. 加载测试模型（可选，确认推理功能）
进入容器内部，加载一个轻量模型（如`qwen-1.8b-chat`），验证推理功能：
```bash
# 进入容器（容器名替换为你的，如xinference-service）
docker exec -it xinference-service /bin/bash
# 在容器内加载模型（qwen-1.8b-chat体积小，适合测试）
xinference model load --model-name qwen-1.8b-chat --model-format pytorch
# 加载成功后查看模型列表
xinference model list
```
若能看到`qwen-1.8b-chat`的模型信息，说明Xinference完全可用。


## 第五步：常见问题（含轩辕镜像专属问题）
### 5.1 容器启动失败，报错“no NVIDIA GPU found”
- 原因：容器没拿到GPU资源；
- 解决：
  1. 执行`nvidia-smi`确认主机GPU和驱动正常；
  2. 安装`nvidia-container-toolkit`：`sudo apt install nvidia-container-toolkit`，然后重启Docker：`sudo systemctl restart docker`；
  3. 启动命令确保加了`--gpus all`（方案1/2）或docker-compose有GPU配置（方案3）。

### 5.2 访问9998端口被拒绝
- 解决：开放服务器安全组和防火墙的9998端口（参考“第四步2”的操作）；若端口被占用，更换主机端口（如`-p 9999:9997`）。

### 5.3 模型下载慢或失败
- 解决：
  1. 确保`XINFERENCE_MODEL_SRC`包含`modelscope`（国内优先）；
  2. 手动下载模型到主机的`/data/xinference/cache/modelscope`目录，容器会自动识别。

### 5.4 容器内时区错乱
- 解决：启动时加`-e TZ=Asia/Shanghai`（方案2/3已包含，方案1可手动补充）。

### 5.5 轩辕镜像拉取慢或失败
- 原因：网络波动或节点问题；
- 解决：
  1. 检查服务器能否访问国内网络（如`ping baidu.com`）；
  2. 执行轩辕一键脚本配置全局加速：`bash <(wget -qO- https://xuanyuan.cloud/docker.sh)`，选择“2) 修改轩辕镜像专属访问支持地址”；
  3. 换一个轩辕镜像标签尝试（如先拉取体积小的`nightly-main-cpu`测试网络）。


## 结尾
到这里，Xinference的“轩辕镜像访问支持拉取+Docker部署”全流程就结束了。新手建议按“轩辕镜像拉取→快速部署→验证服务”的顺序操作，熟悉后再用“挂载目录部署”；企业级用户直接用“docker-compose部署”，配合轩辕镜像的稳定同步和加速，能大幅降低运维成本。

后续使用中，你可以通过Xinference的API对接自己的应用（如AI对话、图像生成），也可以加载更多模型（如GLM-4、Qwen-Image）。若遇到文档未覆盖的问题，可参考Xinference官方文档，或在GitHub仓库提issue，也可通过轩辕镜像官网获取技术支持。


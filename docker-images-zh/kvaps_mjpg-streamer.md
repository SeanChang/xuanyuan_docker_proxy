<!-- xuanyuan-docker-images-zh
image: kvaps/mjpg-streamer
source: https://xuanyuan.cloud/zh/r/kvaps/mjpg-streamer
canonical: https://xuanyuan.cloud/zh/r/kvaps/mjpg-streamer
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/kvaps/mjpg-streamer" title="kvaps/mjpg-streamer Docker 镜像中文简介、标签列表与拉取命令">kvaps/mjpg-streamer — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/kvaps/mjpg-streamer" title="kvaps/mjpg-streamer Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/kvaps/mjpg-streamer</a></p>

## MJPG-streamer Docker镜像文档

### 镜像概述
本镜像基于MJPG-streamer构建，旨在提供轻量级的网络摄像头流媒体解决方案。通过Docker容器化部署，可快速将USB摄像头等UVC（USB Video Class）设备的视频流通过HTTP协议进行实时传输，适用于各类需要远程访问摄像头画面的场景。

### 核心功能特性
- **UVC设备支持**：兼容主流USB摄像头等UVC标准视频设备
- **HTTP协议输出**：通过HTTP协议提供视频流访问，支持浏览器直接查看
- **视频参数配置**：可自定义视频分辨率（如320x240）、帧率（如10fps）等参数
- **访问控制**：支持通过用户名密码（如admin:admin）限制访问权限
- **容器化部署**：简化依赖管理，支持快速启停与服务持久化（通过restart: always配置）

### 适用场景
- 家庭/办公室远程监控系统搭建
- 嵌入式设备（如树莓派）摄像头视频传输
- 远程实验/教学场景中的实时画面分享
- 需要低延迟HTTP视频流的应用集成

### 使用方法与配置说明

#### 1. 基础运行命令（docker run）
通过以下命令快速启动容器，挂载摄像头设备并映射HTTP端口：

```bash
docker run \
    --device /dev/video0 \  # 挂载摄像头设备（默认/dev/video0，根据实际设备路径调整）
    --entrypoint mjpg_streamer \
    -p 8090:8090 \  # 映射容器8090端口到主机8090端口（HTTP访问端口）
    kvaps/mjpg-streamer \
    -i "/usr/lib64/input_uvc.so -y -d /dev/video0 -r 320x240 -f 10" \  # 输入插件配置：使用YUV格式，设备路径/dev/video0，分辨率320x240，帧率10fps
    -o "/usr/lib64/output_http.so -p 8090 -w /usr/share/mjpeg-streamer/www/ -c admin:admin"  # 输出插件配置：HTTP端口8090，网页目录，访问控制（用户名:密码）
```

#### 2. Docker Compose配置
通过`docker-compose.yml`实现服务持久化部署，支持自动重启：

```yaml
mjpg-streamer:
  restart: always  # 服务异常退出时自动重启
  image: kvaps/mjpg-streamer  # 使用的Docker镜像
  devices:
    - /dev/video0  # 挂载摄像头设备（根据实际设备路径调整）
  ports:
    - 8090:8090  # 端口映射（主机端口:容器端口）
  command: -i "/usr/lib64/input_uvc.so -y -d /dev/video0 -r 320x240 -f 10" -o "/usr/lib64/output_http.so -p 8090 -w /usr/share/mjpeg-streamer/www/ -c admin:admin"  # 启动命令（同docker run的参数）
```

#### 3. 关键参数说明
- **设备挂载**：`--device /dev/video0` 需根据实际摄像头设备路径调整（多摄像头可能为/dev/video1等）
- **视频参数**：
  - `-r <width>x<height>`：设置视频分辨率（如640x480、1280x720）
  - `-f <fps>`：设置视频帧率（如5、15、30，需设备支持）
  - `-y`：启用YUV格式传输（减少压缩延迟）
- **访问控制**：`-c <user>:<pass>` 配置HTTP访问的用户名密码（如`admin:123456`）
- **端口映射**：`-p <host_port>:8090` 可修改主机端口（如映射到80端口需root权限）

#### 4. 访问视频流
服务启动后，通过浏览器或HTTP客户端访问以下地址：
- 视频流地址：`http://<主机IP>:8090/?action=stream`
- 单帧图片：`http://<主机IP>:8090/?action=snapshot`
（访问时需输入配置的用户名密码，如默认admin:admin）

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/kvaps/mjpg-streamer" title="kvaps/mjpg-streamer Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/kvaps/mjpg-streamer</a></p>

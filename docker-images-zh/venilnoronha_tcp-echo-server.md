---
image: venilnoronha/tcp-echo-server
description: "这是一个用Golang编写的简单TCP回声服务器，接收客户端数据并添加预配置前缀后回显，适用于网络调试和TCP协议学习场景。"
source: https://xuanyuan.cloud/zh/r/venilnoronha/tcp-echo-server
canonical: https://xuanyuan.cloud/zh/r/venilnoronha/tcp-echo-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/venilnoronha/tcp-echo-server" title="venilnoronha/tcp-echo-server Docker 镜像中文简介、标签列表与拉取命令">venilnoronha/tcp-echo-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# TCP回声服务器

## 镜像概述
本镜像提供基于Golang实现的TCP回声服务器，遵循TCP协议工作。服务器监听客户端连接请求，接收数据后添加预配置前缀，再将处理结果返回给客户端。

## 核心功能
- 监听TCP端口的连接请求
- 接收客户端发送的原始数据
- 为数据添加自定义前缀
- 将处理后的内容回显给客户端

## 使用场景
- 测试TCP网络连接的连通性
- 调试客户端与服务器的TCP通信逻辑
- 学习TCP协议的基础交互流程
- 作为轻量级网络服务示例

## 配置说明
通过环境变量`PREFIX`设置回显数据的前缀（如未指定则默认无前缀）。

## 部署示例
### Docker Run命令
```bash
docker run -d -p 8080:8080 -e PREFIX="Response: " docker.xuanyuan.run/venilnoronha/tcp-echo-server:latest
```
参数说明：
- `-d`：后台运行容器
- `-p 8080:8080`：映射主机8080端口到容器服务端口
- `-e PREFIX="Response: "`：设置回显前缀为"Response: "

### 验证方式
使用telnet工具测试：
```bash
telnet localhost 8080
# 输入"Hello World"，将收到"Response: Hello World"
```

## 标签与文档
- 镜像标签：`latest`（对应Dockerfile见[GitHub仓库](https://github.com/venilnoronha/tcp-echo-server/blob/master/Dockerfile)）
- 完整文档：参考[GitHub仓库README.md](https://github.com/venilnoronha/tcp-echo-server/blob/master/README.md)

## 许可证
本项目采用BSD风格许可证，详情见[LICENSE文件](https://github.com/venilnoronha/tcp-echo-server/blob/master/LICENSE)。

---
image: docker/whalesay
description: "用于Docker演示教程的教学工具镜像，改编自Linux cowsay游戏"
source: https://xuanyuan.cloud/zh/r/docker/whalesay
canonical: https://xuanyuan.cloud/zh/r/docker/whalesay
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/docker/whalesay" title="docker/whalesay Docker 镜像中文简介、标签列表与拉取命令">docker/whalesay 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Whalesay 镜像文档

## 概述
Whalesay 是 Linux cowsay 游戏的改编版，原游戏由 Tony Monroe 于 1999 年编写。本镜像主要作为 Docker 演示教程的教学工具，对原始 cowsay 代码进行了针对性修改。

## 主要修改
- 将默认图案文件 default.cow 替换为 Docker 鲸鱼图案
- 新增 docker.cow 图案文件
- 修改 install.sh 脚本以禁用交互功能

## 使用方法
通过以下命令运行镜像，生成指定文本的鲸鱼说话图案：
```
$ docker run docker/whalesay cowsay boo
     _____
    < boo >
     -----
            \
             \
                \
                                            ##        .            
                                ## ## ##       ==            
                         ## ## ## ##      ===            
                 /""""""""""___/ ===        
        ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~   
                 \______ o          __/            
                    \    \        __/              
                        \____\______/   
```

## Dockerfile 说明
以下是镜像的 Dockerfile 内容，展示构建流程：
```dockerfile
FROM docker.xuanyuan.run/ubuntu:14.04

# 安装 cowsay 并移走默认图案文件，以便替换
RUN apt-get update && apt-get install -y cowsay --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& mv /usr/share/cowsay/cows/default.cow /usr/share/cowsay/cows/orig-default.cow

# 添加 cowsay 安装路径到环境变量
ENV PATH $PATH:/usr/games

# 复制自定义图案文件并设为默认
COPY docker.cow /usr/share/cowsay/cows/
RUN ln -sv /usr/share/cowsay/cows/docker.cow /usr/share/cowsay/cows/default.cow

CMD ["cowsay"]
```
*注：Dockerfile 通过软链接将 docker.cow 设为默认图案，并配置环境变量以确保 cowsay 命令可直接调用。*

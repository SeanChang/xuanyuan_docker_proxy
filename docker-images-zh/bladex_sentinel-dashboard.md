<!-- xuanyuan-docker-images-zh
image: bladex/sentinel-dashboard
source: https://xuanyuan.cloud/zh/r/bladex/sentinel-dashboard
canonical: https://xuanyuan.cloud/zh/r/bladex/sentinel-dashboard
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [bladex/sentinel-dashboard — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/bladex/sentinel-dashboard "bladex/sentinel-dashboard Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/bladex/sentinel-dashboard

# 使用 Docker 部署 Sentinel Dashboard


## 1. 下载镜像
执行以下命令拉取 Sentinel Dashboard 镜像：  
```bash
docker pull bladex/sentinel-dashboard
```


## 2. 启动容器
通过以下命令启动容器（参数说明：`--name sentinel` 指定容器名称为 `sentinel`，`-d` 后台运行，`-p 8858:8858` 映射容器 8858 端口到主机 8858 端口）：  
```bash
docker run --name sentinel -d -p 8858:8858 bladex/sentinel-dashboard
```


## 3. 登录 Web 控制台
容器启动后，按以下步骤访问控制台：  
- 访问地址：`[]  
- 账号密码：均为 `sentinel`  
- 登录成功后即可使用控制台功能。


## 4. 相关资源
- GitHub 仓库：`[]  
- 官方网站：`[]

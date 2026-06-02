<!-- xuanyuan-docker-images-zh
image: ydkn/cups
source: https://xuanyuan.cloud/zh/r/ydkn/cups
canonical: https://xuanyuan.cloud/zh/r/ydkn/cups
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [ydkn/cups — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/ydkn/cups "ydkn/cups Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/ydkn/cups

# CUPS Docker 镜像

[项目地址]([])


## 支持架构

- amd64  
- arm32v7  
- arm64v8  


## 使用方法

### 启动容器

执行以下命令启动容器：

```bash
docker run -d --restart always -p 631:631 -v $(pwd):/etc/cups ydkn/cups:latest
```


### 配置

1. **登录 Web 界面**  
通过 631 端口访问 CUPS Web 管理界面（例如：`[] CUPS。  

2. **默认登录凭据**  
用户名：`admin`，密码：`admin`。

3. **修改管理员密码**  
如需自定义管理员密码，启动容器时添加环境变量 `ADMIN_PASSWORD`，示例命令：  

```bash
docker run -d --restart always -p 631:631 -v $(pwd):/etc/cups -e ADMIN_PASSWORD=mySecretPassword ydkn/cups:latest
```

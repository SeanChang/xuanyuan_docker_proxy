# 绿联 NAS Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/lvlian

通过配置「轩辕镜像源」，可以让绿联 NAS 在拉取 Docker 镜像时大幅提升速度，解决「拉取慢」、「卡在下载」的问题。

## 目录

- [适用条件](#适用条件)
- [进入 Docker 设置界面](#进入-docker-设置界面)
- [打开镜像配置页面](#打开镜像配置页面)
- [填写轩辕镜像地址](#填写轩辕镜像地址)
- [保存配置](#保存配置)
- [拉取镜像测试](#拉取镜像测试)
- [可选支持的镜像源](#可选支持的镜像源高级用法)
- [联系技术支持](#技术说明可选了解)

## 适用条件

- **适用机型：** 绿联私有云全系列
- **适用系统版本：** UGOS Pro 及以上
- **支持镜像源：** docker.io、ghcr.io、gcr.io、k8s.gcr.io 等

## 进入 Docker 设置界面

1. 打开绿联 NAS 管理后台
2. 点击左侧导航栏的「镜像」
3. 点击右上角的齿轮图标 ⚙️ 或「设置」

## 打开镜像配置页面

在"镜像仓库"页面，找到已有的 DockerHub 项，点击右侧的「镜像源配置」按钮。

![绿联 NAS Docker 设置界面](https://img.xuanyuan.dev/docker/usage/lvlian1.jpg)

### 绿联 DX4600 专用配置

如果您使用的是绿联 DX4600 系列，请按照下图所示进行配置：

![绿联 DX4600 镜像配置界面](https://img.xuanyuan.dev/docker/usage/DX4600.png)

## 填写轩辕镜像地址

在弹出的镜像源配置页面中，将镜像源地址设置为你专属的"轩辕镜像地址"：

```
https://***.xuanyuan.run
```

**说明：** 请根据你的账号获取的实际地址填写，*** 是分配给你的用户前缀。

![绿联 NAS 镜像源配置页面](https://img.xuanyuan.dev/docker/usage/lvlian2.jpg)

### DX4600 填写专属域名

如果您使用的是绿联 DX4600 系列，请按照下图所示填写镜像源地址：

![绿联 DX4600 填写镜像源地址配置](https://img.xuanyuan.dev/docker/usage/DX4600-2.png)

## 保存配置

点击右下角的「确定」，保存镜像源设置。

## 拉取镜像测试

**重要**

配置保存后，建议拉取常用镜像（如 nginx）验证加速是否生效。

### 已知问题：镜像仓库无法搜索

绿联 NAS 的「镜像仓库」目前无法正常检索镜像。即使已正确配置轩辕镜像源，在镜像仓库中搜索 `nginx:latest` 也可能搜不到任何结果。这是绿联系统侧的已知限制，与轩辕镜像服务本身无关。

请改用「公网库」方式直接拉取镜像，操作路径如下：

1. 进入 **镜像管理** → **本地镜像** → **添加** → **公网库**
2. 在镜像地址栏填写专属域名加镜像名，例如 `***.xuanyuan.run/nginx`，点击 **确认** 开始拉取
3. 等待拉取完成；若配置正确，下载速度会明显加快

```
***.xuanyuan.run/nginx
```

请将 `***` 替换为你的专属域名前缀。

![绿联 NAS 通过公网库添加镜像：镜像管理 > 本地镜像 > 添加 > 公网库](https://img.xuanyuan.dev/docker/blog/lvlian1.jpg)

镜像管理 → 本地镜像 → 添加 → 公网库

![绿联 NAS 公网库填写镜像地址并确认](https://img.xuanyuan.dev/docker/blog/lvlian2.jpg)

输入 `***.xuanyuan.run/nginx`，点击确认

![绿联 NAS 公网库拉取镜像过程](https://img.xuanyuan.dev/docker/blog/lvlian3.jpg)

镜像拉取过程

## 可选支持的镜像源（高级用法）

如果你希望也访问 ghcr.io、gcr.io、k8s.gcr.io 的镜像，也可以在终端内使用 Podman 或 containerd 自定义镜像源（高级用法，需 SSH 访问 NAS）。

## 技术说明（可选了解）

轩辕镜像基于国内优化 + 多地缓存，支持：

- 极速拉取 docker.io/library/* 镜像
- 支持 IPv6 访问优化
- 不需要登录认证，自动识别用户

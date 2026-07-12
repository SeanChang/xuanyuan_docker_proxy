# 绿联 NAS Docker 镜像加速 - 轩辕镜像配置手册

通过配置"轩辕镜像加速器"，可以让绿联 NAS 在拉取 Docker 镜像时大幅提升速度，解决"拉取慢"、"卡在下载"的问题。

## 📋 适用条件

- **适用机型**：绿联私有云全系列
- **适用系统版本**：UGOS Pro 及以上
- **支持镜像源**：docker.io、ghcr.io、gcr.io、k8s.gcr.io 等

## 1. 进入 Docker 设置界面

1. 打开绿联 NAS 管理后台
2. 点击左侧导航栏的「镜像」
3. 点击右上角的齿轮图标 ⚙️ 或「设置」

## 2. 打开镜像加速配置页面

在"镜像仓库"页面，找到已有的 DockerHub 项，点击右侧的「加速器配置」按钮。

![绿联 NAS Docker 设置界面](https://imgs.xuanyuan.run/img/lvlian1.jpg)

*点击图片可查看大图*

## 3. 填写轩辕镜像加速地址

在弹出的加速器配置页面中，将加速器地址设置为你专属的"轩辕镜像加速地址"：

```
https://xxx.xuanyuan.run
```

**说明**：请根据你的账号获取的实际地址填写，xxx 是分配给你的用户前缀。

![绿联 NAS 加速器配置页面](https://imgs.xuanyuan.run/img/lvlian2.jpg)

*点击图片可查看大图*

## 4. 保存配置

点击右下角的「确定」，保存加速器设置。

## 5. 测试效果

回到镜像页面，搜索并拉取任意镜像，比如：

```
nginx:latest
```

如果配置正确，拉取速度会明显加快，几乎秒下完成。

## 📌 可选支持的镜像源（高级用法）

如果你希望也加速 ghcr.io、gcr.io、k8s.gcr.io 的镜像，也可以在终端内使用 Podman 或 containerd 自定义镜像源（高级用法，需 SSH 访问 NAS）。

## 🧑‍💻 技术说明（可选了解）

[轩辕镜像](https://xuanyuan.cloud/) 基于私有加速 CDN + 多地缓存，支持：

- 极速拉取 docker.io/library/* 镜像
- 支持 IPv6 访问优化
- 不需要登录认证，自动识别用户

## 获取专属加速地址

请前往 [轩辕镜像](https://xuanyuan.cloud/) 个人中心获取您的专属加速地址。

如需充值流量包，请访问 [充值页面](https://xuanyuan.cloud/recharge)。

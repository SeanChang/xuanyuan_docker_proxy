# OrbStack Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/orbstack

在 MacOS 系统上配置 OrbStack 使用轩辕镜像源，让所有 Docker 操作都享受优化访问体验

## 目录

- [获取专属域名](#获取专属域名)
- [配置 OrbStack 镜像](#配置-orbstack-镜像)
- [重启 OrbStack 服务](#重启-orbstack-服务)
- [验证配置](#验证配置)
- [开始使用](#开始使用)
- [配置说明](#配置说明)

## 获取专属域名

登录网站后，在左侧菜单栏的「专属域名」菜单中获取您的专属域名，格式为：`***.xuanyuan.run`

> **注意**：请将 ***.xuanyuan.run** 替换为您的专属域名。[登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Forbstack)网站后，点击左侧菜单栏的「专属域名」菜单即可获取。

## 配置 OrbStack 镜像

通过配置 `~/.orbstack/config/docker.json` 中的 registry-mirrors，我们能够实现使用 docker 的镜像功能。然而，在 macOS 上，相较于 docker 桌面版本，OrbStack 以其更低的资源占用显得更为出色。那么，如何在 OrbStack 中配置国内镜像源呢？实际上，这一过程相当简便。

### 图形界面操作方式（推荐）

1. 在菜单栏中点击 **OrbStack** 菜单，选择 **Settings...**（或使用快捷键 ⌘,）
2. 在设置窗口的左侧边栏中，点击 **Docker** 选项
3. 找到 **Advanced engine configuration** 部分
4. 在配置编辑器中添加或修改 `registry-mirrors` 配置
5. 点击 **edit the config file** 链接可以直接编辑配置文件

或者，您也可以直接创建并编辑 `~/.orbstack/config/docker.json` 文件：

```json
{
    "registry-mirrors": [
        "***.xuanyuan.run"
    ]
}
```

此配置文件将设置 OrbStack 的镜像源

> ⚠️ 请将 ***.xuanyuan.run** 替换为您的专属域名。[登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Forbstack)网站后，点击左侧菜单栏的「专属域名」菜单即可获取。

## 重启 OrbStack 服务

完成配置后，重启 OrbStack 服务：

> 💡 在 MacOS 上，您可以通过以下方式重启 OrbStack：

- **图形界面方式：**在菜单栏中点击 OrbStack 图标，选择 "Restart"
- **终端方式：**在终端中运行 `orb restart`
- **设置界面方式：**在 Settings 窗口中修改配置后，OrbStack 会自动提示重启

## 验证配置

验证配置是否生效：

```bash
docker info | grep -A 10 "Registry Mirrors"
```

如果配置成功，您应该能看到您的轩辕镜像地址

✅ 成功配置后，输出信息中 Registry Mirrors 部分应该包含您所配置的镜像地址：

```
Registry Mirrors:
  https://***.xuanyuan.run
```

## 开始使用

配置完成后，您可以直接使用标准的 Docker 命令拉取镜像：

**拉取镜像：**

```bash
docker pull mysql:latest
```

> ⚠️ **PS:** 不加 TAG 默认为 latest，建议指定具体的 TAG 版本进行下载。

## 配置说明

### 为什么选择 OrbStack？

相较于 Docker Desktop，OrbStack 具有更低的资源占用、更快的启动速度和更好的性能表现，特别适合 MacOS 用户使用。

### 配置优势

通过配置轩辕镜像源，您可以享受国内高速稳定的镜像下载体验，大幅提升开发效率。

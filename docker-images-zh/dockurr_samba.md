---
image: dockurr/samba
description: "Docker容器化的Samba，Windows SMB网络协议的实现"
source: https://xuanyuan.cloud/zh/r/dockurr/samba
canonical: https://xuanyuan.cloud/zh/r/dockurr/samba
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dockurr/samba" title="dockurr/samba Docker 镜像中文简介、标签列表与拉取命令">dockurr/samba 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Samba Docker容器

Docker容器化的[Samba](https://www.samba.org/)，Windows SMB网络协议的实现。

## 使用方法 🐳

### 通过Docker Compose：

```yaml
services:
  samba:
    image: docker.xuanyuan.run/dockurr/samba
    container_name: samba
    environment:
      NAME: "Data"
      USER: "samba"
      PASS: "secret"
    ports:
      - 445:445
    volumes:
      - ./samba:/storage
    restart: always
```

### 通过Docker CLI：

```bash
docker run -it --rm --name samba -p 445:445 -e "NAME=Data" -e "USER=samba" -e "PASS=secret" -v "${PWD:-.}/samba:/storage" docker.xuanyuan.run/dockurr/samba
```

## 配置 ⚙️

### 如何选择共享文件夹的位置？

要更改共享文件夹的位置，请在compose文件中包含以下绑定挂载：

```yaml
volumes:
  - ./samba:/storage
```

将示例路径`./samba`替换为所需的文件夹或命名卷。

### 如何修改共享文件夹的显示名称？

您可以通过添加以下环境变量来更改共享文件夹的显示名称：

```yaml
environment:
  NAME: "Data"
```

### 如何连接到共享文件夹？

要连接到共享文件夹，请在Windows资源管理器中输入：`\\192.168.0.2\Data`。

> [!NOTE]
> 将上面的示例IP地址替换为您主机的IP地址。

### 如何修改默认凭据？

您可以设置`USER`和`PASS`环境变量来修改默认凭据（默认用户为`samba`，密码为`secret`）。

```yaml
environment:
  USER: "samba"
  PASS: "secret"
```

### 如何修改权限？

您可以设置`UID`和`GID`环境变量来更改用户和组ID。

```yaml
environment:
  UID: "1002"
  GID: "1005"
```

要将共享标记为只读，请添加变量`RW: "false"`。

### 如何修改其他设置？

如果您需要更高级的功能，可以通过修改此仓库中的[smb.conf](https://github.com/dockur/samba/blob/master/smb.conf)文件完全覆盖默认配置，并将自定义配置绑定到容器，如下所示：

```yaml
volumes:
  - ./smb.conf:/etc/samba/smb.conf
```

### 如何配置多个用户？

如果要配置多个用户，可以将[users.conf](https://github.com/dockur/samba/blob/master/users.conf)文件绑定到容器，如下所示：

```yaml
volumes:
  - ./users.conf:/etc/samba/users.conf
```

该文件中的每一行包含一个用`:`分隔的属性列表，描述要创建的用户。

`username:UID:groupname:GID:password:homedir`

其中：
- `username` 用户的文本名称。
- `UID` 用户的数字ID。
- `groupname` 主用户组的文本名称。
- `GID` 主用户组的数字ID。
- `password` 用户的明文密码。密码不能包含`:`、`\n`或`\r`。
- `homedir` 可选字段，用于设置用户的主目录。

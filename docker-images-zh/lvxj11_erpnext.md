<!-- xuanyuan-docker-images-zh
image: lvxj11/erpnext
source: https://xuanyuan.cloud/zh/r/lvxj11/erpnext
canonical: https://xuanyuan.cloud/zh/r/lvxj11/erpnext
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [lvxj11/erpnext — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/lvxj11/erpnext "lvxj11/erpnext Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/lvxj11/erpnext

# ERPNext 开源ERP系统 Docker镜像介绍

ERPNext 是一款界面清爽、真正完全开源的ERP系统。本Docker镜像基于ERPNext官方版本构建，旨在提供更便捷的部署体验。

## 镜像特点

该镜像的特点包括：

1.  **集成化设计 (All in one)**：已内置 MySQL 数据库与 Redis，单镜像即可满足 ERPNext 运行的所有依赖。
2.  **预配置就绪**：已完成站点创建及 ERPNext 应用的安装，部署后可直接访问，无需额外的初始化或应用拉取步骤。
3.  **中文支持**：已集成中文汉化包（源地址：`[]  **常用模块预装**：包含 hrms、payments、print_designer 模块。
5.  **国内源优化**：已将 apt、pip、npm、yarn 的安装源替换为国内镜像，提升访问速度。

总而言之，该镜像实现了真正的“开箱即用”。

## 使用指南

### 基本步骤

1.  **拉取镜像**
2.  **运行容器**
3.  **访问系统**：通过浏览器访问 `[] 重要提示

在运行容器时，示例中的挂载卷**必须使用数据卷模式**，而非主机目录。使用主机目录挂载可能会覆盖容器内的文件和目录，导致应用因找不到必要文件而启动失败。若挂载的是新数据卷，容器内的文件会自动复制到卷中。

### 示例运行脚本

```bash
docker run -itd -p 80:80 \
  -v ERPNext_db:/var/lib/mysql \
  -v ERPNext_sites:/home/frappe/frappe-bench/sites \
  --name ERPNext lvxj11/erpnext:latest
```

## 其他说明

*   **默认账号密码**：
    *   账号：`administrator`
    *   密码：`admin`
*   **数据库信息**：已包含 MySQL 数据库，数据库 root 用户密码为 `Pass1234`。如需修改上述参数，请自行手动调整。
*   **即开即用**：镜像已拉取所有必要文件并安装中文本地化插件，运行后无需额外设置即可直接访问。
*   **适用场景**：建议用于测试、演示或临时使用。生产环境使用前，请务必自行充分测试。
*   **构建文件**：构建文件可参考：`[]   **数据卷说明**：示例中，`/var/lib/mysql` 是容器内 MySQL 数据库数据的存储目录，`/home/frappe/frappe-bench/sites` 是 Frappe 站点的存储目录。将这两个目录挂载到数据卷是为了实现数据持久化。
*   **升级建议**：完成数据持久化设置后，如需升级，删除现有容器及镜像，重新拉取最新镜像并运行即可，理论上无需手动恢复数据。

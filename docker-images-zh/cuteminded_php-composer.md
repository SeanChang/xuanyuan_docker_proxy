---
image: cuteminded/php-composer
description: "为在容器化环境中托管现代PHP应用程序提供稳健的起点。"
source: https://xuanyuan.cloud/zh/r/cuteminded/php-composer
canonical: https://xuanyuan.cloud/zh/r/cuteminded/php-composer
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cuteminded/php-composer" title="cuteminded/php-composer Docker 镜像中文简介、标签列表与拉取命令">cuteminded/php-composer 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ⚠️ 弃用通知**重要提示：** `wkhtmltopdf` 已被弃用且不再积极维护。因此，此版本的Docker镜像将不再接收更新。

# 可用标签

| 标签       | 描述                          |
|------------|-------------------------------|
| `latest`   | 包含Composer的PHP环境         |
| `node`     | 包含Composer和Node.js的PHP环境|
| `laravel`  | 基于latest的Laravel优化版本   |

# 可选环境变量

您可以使用以下可选环境变量配置容器行为：

| 变量名             | 默认值 | 描述                                   |
|--------------------|--------|----------------------------------------|
| `LARAVEL_CLEAR`    | `no`   | 设置为`yes`时，启动时运行Laravel清理命令 |
| `LARAVEL_SCHEDULE` | `no`   | 设置为`yes`时，每分钟运行Laravel调度器  |
| `VITE`             | `no`   | 设置为`yes`时，启动Vite开发服务器       |

---

# Vite设置

- **默认端口**：`5173`

## 故障排除：容器中Vite服务器无法工作？

如果Vite开发服务器无法从容器外部访问，请确保您的`vite.config.js`包含适当的外部访问和HMR（热模块替换）设置：

```js
export default {
  // 其他设置...
  server: {
    host: "0.0.0.0",
    port: 5173,
    strictPort: true,
    hmr: {
      host: "localhost",
    },
  },
  // 其他设置...
};

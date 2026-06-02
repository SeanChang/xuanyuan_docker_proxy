<!-- xuanyuan-docker-images-zh
image: decolua/9router
source: https://xuanyuan.cloud/zh/r/decolua/9router
canonical: https://xuanyuan.cloud/zh/r/decolua/9router
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/decolua/9router" title="decolua/9router Docker 镜像中文简介、标签列表与拉取命令">decolua/9router — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/decolua/9router" title="decolua/9router Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/decolua/9router</a></p>

# 9Router Docker 镜像（decolua/9router）

9Router 是一款 AI 路由网关，可将 Claude Code、Cursor、Copilot、Cline 等多种 AI 编程工具统一接入 40+ 家 AI 服务商与 100+ 大模型，便于在本地或内网集中管理 API 密钥、路由策略与用量。

## 快速运行

```bash
docker run -d \
  --name 9router \
  -p 20128:20128 \
  -v "$HOME/.9router:/app/data" \
  -e DATA_DIR=/app/data \
  decolua/9router
```

应用在容器内默认监听 **20128** 端口。

## 数据持久化

```bash
-v "$HOME/.9router:/app/data" \
-e DATA_DIR=/app/data
```

配置与数据库默认写入 `DATA_DIR` 下的 `db.json`（容器内路径示例：`/app/data/db.json`），绑定挂载后可在宿主机 `$HOME/.9router/db.json` 持久保存。

## 常用操作

```bash
# 查看日志
docker logs -f 9router

# 停止并删除
docker stop 9router && docker rm 9router
```

## 可选环境变量

可通过 `-e` 覆盖端口、监听地址与调试开关，例如：

```bash
-e PORT=20128 \
-e HOSTNAME=0.0.0.0 \
-e DEBUG=true
```

## 适用场景

- 多 IDE / AI 客户端共用一套模型路由与密钥管理
- 自建内网 AI 网关，降低直连公网 API 的复杂度
- 需要按提供商或模型切换、聚合调用的开发与团队环境

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/decolua/9router" title="decolua/9router Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/decolua/9router</a></p>

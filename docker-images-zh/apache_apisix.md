---
image: apache/apisix
description: "Apache APISIX是一款动态、实时、高性能的云原生API网关，提供负载均衡、动态上游、金丝雀发布、熔断、认证、可观测性等丰富流量管理功能，适用于处理传统南北向流量及服务间东西向流量。"
source: https://xuanyuan.cloud/zh/r/apache/apisix
canonical: https://xuanyuan.cloud/zh/r/apache/apisix
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/apisix" title="apache/apisix Docker 镜像中文简介、标签列表与拉取命令">apache/apisix — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/apache/apisix" title="apache/apisix Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/apache/apisix</a>

## Apache APISIX API网关是什么

Apache APISIX是一个动态、实时、高性能的API网关。

APISIX API网关提供丰富的流量管理功能，如负载均衡、动态上游、金丝雀发布、熔断、认证、可观测性等。

您可以使用APISIX API网关处理传统南北向流量，以及服务间的东西向流量。目前，APISIX已被 NASA、腾讯云、欧盟数字工厂、空客、空中云汇、爱奇艺等多个行业的企业所采用。

## 如何运行Apache APISIX

Apache APISIX支持单机模式，也支持使用etcd数据库作为配置中心。

### 如何以单机模式运行APISIX

在单机模式下，APISIX使用`apisix.yaml`作为配置中心，存储路由、上游、消费者等信息。APISIX启动后，会定期加载`apisix.yaml`文件以更新相应配置信息。

您可以通过以下命令启动一个单机模式的APISIX容器：

```shell
docker run -d --name apache-apisix \
  -p 9080:9080 \
  -e APISIX_STAND_ALONE=true \
  apache/apisix
```

向运行中的APISIX容器添加路由和插件配置：

```shell
docker exec -i apache-apisix sh -c 'cat > /usr/local/apisix/conf/apisix.yaml <<_EOC_
routes:
  -
    id: httpbin
    uri: /*
    upstream:
      nodes:
        "httpbin.org": 1
      type: roundrobin
    plugin_config_id: 1

plugin_configs:
  -
    id: 1
    plugins:
      response-rewrite:
        body: "Hello APISIX\n"
    desc: "response-rewrite"
#END
_EOC_'
```

测试示例：

```shell
curl http://127.0.0.1:9080/
```

```shell
Hello APISIX
```

如需更多配置示例，可参考[单机模式文档](https://apisix.apache.org/docs/apisix/stand-alone)。

### 如何使用etcd作为配置中心运行APISIX

#### 方案一

APISIX运行也支持使用etcd作为配置中心。启动APISIX容器前，需先通过以下命令启动etcd容器，并指定容器使用主机网络。确保所有所需端口（默认：`9080`、`9443`和`2379`）可用且未被其他系统进程占用。

1. 启动etcd。

```shell
docker run -d \
  --name etcd \
  --net host \
  -e ALLOW_NONE_AUTHENTICATION=yes \
  -e ETCD_ADVERTISE_CLIENT_URLS=http://127.0.0.1:2379 \
  bitnami/etcd:latest
```

2. 启动APISIX。

```shell
docker run -d \
  --name apache-apisix \
  --net host \
  apache/apisix
```

#### 方案二

启动APISIX容器前，需先创建Docker虚拟网络并启动etcd容器。

1. 创建网络并查看子网地址，然后启动etcd

```shell
docker network create apisix-network --driver bridge && \
docker network inspect -v apisix-network && \
docker run -d --name etcd \
  --network apisix-network \
  -p 2379:2379 \
  -p 2380:2380 \
  -e ALLOW_NONE_AUTHENTICATION=yes \
  -e ETCD_ADVERTISE_CLIENT_URLS=http://127.0.0.1:2379 \
  bitnami/etcd:latest
```

2. 查看上一步的返回结果，可看到`subnet`地址。在当前目录创建APISIX配置文件。需将`allow_admin`设置为步骤1中获取的`subnet`地址。

```shell
cat << EOF > $(pwd)/config.yaml
deployment:
  role: traditional
  role_traditional:
    config_provider: etcd
  admin:
    allow_admin:
      - 0.0.0.0/0  # 请设置为您获取到的子网地址。
                  # 若未设置，默认允许所有IP访问。
  etcd:
    host:
      - "http://etcd:2379"
    prefix: "/apisix"
    timeout: 30
EOF
```

3. 启动APISIX并引用上一步创建的文件。

```shell
 docker run -d --name apache-apisix \
  --network apisix-network \
  -p 9080:9080 \
  -p 9180:9180 \
  -v $(pwd)/config.yaml:/usr/local/apisix/conf/config.yaml \
  apache/apisix
```

#### 测试示例

通过在主机上运行以下命令检查APISIX是否正常运行。

```
curl "http://127.0.0.1:9180/apisix/admin/services/" \
-H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1'
```

响应表明apisix运行成功：

```json
{
  "total": 0,
  "list": []
}
```

如需修改APISIX默认配置，可通过以下命令进入APISIX容器并修改配置文件`./conf/config.yaml`，重新加载APISIX后生效。详情请参考`./conf/config-default.yaml`。

```
docker exec -it apache-apisix bash
```

更多信息可参考[APISIX官网](https://apisix.apache.org/)和[APISIX文档](https://apisix.apache.org/docs/apisix/getting-started)。使用中遇到问题可通过[slack和邮件列表](https://apisix.apache.org/docs/general/join/)寻求帮助。

## 在运行中的容器中重新加载APISIX

若修改了自定义配置，可通过以下命令重新加载APISIX（无停机）。

```
docker exec -it apache-apisix apisix reload
```

此命令将在容器中执行`apisix reload`。

## Kubernetes Ingress

部署过程中，除上述操作外，APISIX还衍生了[`apisix-ingress-controller`](https://github.com/apache/apisix-ingress-controller)，可在K8s环境中更便捷地部署使用。

## 许可证

基于Apache许可证2.0版本授权：[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

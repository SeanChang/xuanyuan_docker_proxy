---
image: openeuler/paddlepaddle
description: "基于openEuler构建的PaddlePaddle官方Docker镜像，支持深度学习模型开发、训练与推理，适用于AI研究和应用开发，提供amd64/arm64多架构支持且无用户速率限制。"
source: https://xuanyuan.cloud/zh/r/openeuler/paddlepaddle
canonical: https://xuanyuan.cloud/zh/r/openeuler/paddlepaddle
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/paddlepaddle" title="openeuler/paddlepaddle Docker 镜像中文简介、标签列表与拉取命令">openeuler/paddlepaddle 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PaddlePaddle | openEuler Docker镜像

## 镜像概述

本镜像为基于[openEuler](https://repo.openeuler.org/)构建的PaddlePaddle官方Docker镜像，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护。PaddlePaddle作为中国首个自主研发的深度学习平台，自2016年起正式开源，适用于各类深度学习任务的开发与部署。本仓库可免费使用且无用户速率限制。

## 核心功能与特性

- **多架构支持**：同时支持amd64和arm64架构
- **稳定可靠**：基于openEuler稳定版本构建，确保运行环境一致性
- **开箱即用**：内置PaddlePaddle深度学习框架，无需额外配置
- **开源免费**：遵循开源协议，无使用限制和速率限制

## 支持的标签及对应Dockerfile链接

每个`paddlepaddle`镜像标签由PaddlePaddle版本和基础镜像版本组成，具体信息如下：

| 标签 | 当前版本 | 支持架构 |
|------|----------|----------|
|[3.2.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/paddlepaddle/3.2.0/24.03-lts-sp2/Dockerfile) | openEuler 24.03-LTS-SP2上的PaddlePaddle 3.2.0 | amd64, arm64 |
|[3.0.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/paddlepaddle/3.0.0/24.03-lts-sp1/Dockerfile)| openEuler 24.03-LTS-SP1上的PaddlePaddle 3.0.0 | amd64, arm64 |

## 使用方法

根据需求选择相应的`{Tag}`进行操作。

### 拉取镜像

```bash
docker pull docker.xuanyuan.run/openeuler/paddlepaddle:{Tag}
```

### 交互式shell运行

可通过交互式shell启动容器使用PaddlePaddle：

```bash
docker run -it --rm docker.xuanyuan.run/openeuler/paddlepaddle:{Tag} bash
```

### MNIST示例：PaddlePaddle基础使用

以下示例演示如何使用PaddlePaddle构建、训练、评估、保存和加载基于LeNet的神经网络，用于MNIST手写数字识别任务。

#### 完整示例代码

```python
import paddle
import numpy as np
from docker.xuanyuan.run/paddle.vision.transforms import Normalize

# 1) 加载并转换MNIST数据集
transform = Normalize(mean=[127.5], std=[127.5], data_format="CHW")
train_dataset = paddle.vision.datasets.MNIST(mode="train", transform=transform)
test_dataset = paddle.vision.datasets.MNIST(mode="test", transform=transform)

# 2) 定义模型（LeNet）
lenet = paddle.vision.models.LeNet(num_classes=10)
model = paddle.Model(lenet)

# 3) 配置训练过程
model.prepare(
    paddle.optimizer.Adam(parameters=model.parameters()),
    paddle.nn.CrossEntropyLoss(),
    paddle.metric.Accuracy(),
)

# 4) 训练模型
model.fit(train_dataset, epochs=5, batch_size=64, verbose=1)

# 5) 评估模型
model.evaluate(test_dataset, batch_size=64, verbose=1)

# 6) 保存训练好的模型
model.save("./output/mnist")

# 7) 加载训练好的模型
model.load("output/mnist")

# 8) 对单张测试图片进行推理
img, label = test_dataset[0]
img_batch = np.expand_dims(img.astype("float32"), axis=0)
out = model.predict_batch(img_batch)[0]
pred_label = out.argmax()
print("真实标签: {}, 预测标签: {}".format(label[0], pred_label))
```

#### 预期输出

```
step 938/938 [==============================] - loss: 0.1575 - acc: 0.9275 - 31ms/step                            
Epoch 2/5
step 938/938 [==============================] - loss: 0.0990 - acc: 0.9740 - 32ms/step                            
Epoch 3/5
step 938/938 [==============================] - loss: 0.0196 - acc: 0.9792 - 32ms/step                           
Epoch 4/5
step 938/938 [==============================] - loss: 0.0052 - acc: 0.9804 - 31ms/step                           
Epoch 5/5
step 938/938 [==============================] - loss: 0.0253 - acc: 0.9831 - 32ms/step                               
Eval begin...
step 157/157 [==============================] - loss: 3.7890e-04 - acc: 0.9839 - 13ms/step                           
Eval samples: 10000
真实标签: 7, 预测标签: 7
```

## 问题反馈

如有任何问题或需使用特定功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)仓库提交issue或Pull Request。获取帮助可联系[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)或[openEuler社区](https://gitee.com/openeuler/community)。

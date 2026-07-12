---
image: ciag/odm
description: "用于处理马赛克图片的Docker镜像，通过配置Amazon S3访问密钥、存储桶和ID，将S3存储桶中/data/$ID目录的输入图片处理后，生成的马赛克结果输出至S3的/result/$ID目录。"
source: https://xuanyuan.cloud/zh/r/ciag/odm
canonical: https://xuanyuan.cloud/zh/r/ciag/odm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ciag/odm" title="ciag/odm Docker 镜像中文简介、标签列表与拉取命令">ciag/odm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ciag/odm Docker镜像文档

## 镜像概述

ciag/odm是一个用于处理马赛克图片的Docker镜像，主要依赖Amazon S3存储服务进行输入图片的读取和处理结果的存储。通过配置必要的环境变量，该镜像可自动完成马赛克图片的处理流程，适用于需要自动化处理图片生成马赛克的场景。

## 核心功能与特性

- **S3集成**：通过Amazon IAM密钥访问S3存储桶，实现输入输出的云端存储
- **任务隔离**：通过ID参数区分不同的马赛克处理任务，确保输入输出文件路径隔离
- **自动化处理**：配置完成后，镜像自动从指定S3路径读取图片并处理，处理结果自动写入S3指定路径

## 使用场景

- 需要批量处理马赛克图片且依赖云存储的场景
- 自动化图片处理流程中，需将输入输出文件存储在Amazon S3的应用
- 对图片处理任务进行隔离管理的需求场景

## 环境变量配置

| 变量名        | 描述                          |
|-------------|-----------------------------|
| ACCESS_KEY  | Amazon IAM访问密钥，用于认证S3访问权限    |
| SECRET_KEY  | Amazon IAM密钥密码，与ACCESS_KEY配合使用 |
| BUCKET      | Amazon S3存储桶名称              |
| ID          | 马赛克处理任务的唯一标识ID          |

### 路径说明
- 输入图片需放置在S3存储桶的`/data/$ID`目录下（其中`$ID`为环境变量ID的值）
- 处理完成后的马赛克结果将输出至S3存储桶的`/result/$ID`目录

## 使用方法

### Docker Run命令示例

```bash
docker run --privileged \
  -e ACCESS_KEY="your_aws_access_key" \
  -e SECRET_KEY="your_aws_secret_key" \
  -e BUCKET="your_s3_bucket_name" \
  -e ID="your_mosaic_task_id" \
  docker.xuanyuan.run/ciag/odm
```

### 使用说明
1. 替换上述命令中的环境变量值：
   - `your_aws_access_key`：替换为实际的Amazon IAM访问密钥
   - `your_aws_secret_key`：替换为实际的Amazon IAM密钥密码
   - `your_s3_bucket_name`：替换为实际的S3存储桶名称
   - `your_mosaic_task_id`：替换为当前马赛克处理任务的唯一ID
2. 确保S3存储桶中已在`/data/$ID`目录下存放待处理的图片
3. 运行命令后，镜像将自动处理图片，完成后结果会出现在S3存储桶的`/result/$ID`目录下

---
image: minio/mc
description: "Minio Client（简称mc）是一款为UNIX系统中常用命令如ls（列出文件）、cat（查看文件内容）、cp（复制文件）、mirror（数据镜像）、diff（比较文件差异）等提供现代化替代方案的客户端工具，它在保留传统命令核心操作逻辑的基础上，融入了更适配现代云存储与对象存储场景的功能特性，为用户提供高效、直观且符合当下技术环境的文件管理与操作体验。"
source: https://xuanyuan.cloud/zh/r/minio/mc
canonical: https://xuanyuan.cloud/zh/r/minio/mc
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [minio/mc — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/minio/mc)

含镜像标签、拉取命令、部署文档与相关推荐。

[minio/mc Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/minio/mc)

# MinIO客户端快速入门指南


MinIO Client（简称`mc`）是UNIX命令（如`ls`、`cat`、`cp`等）的现代替代工具，支持本地文件系统和兼容Amazon S3的云存储服务（AWS Signature v2和v4）。


## 核心命令列表
```
alias       设置、移除和列出配置文件中的别名
ls          列出桶和对象
mb          创建桶
rb          删除桶
cp          复制对象
mirror      将对象同步到远程站点
cat         显示对象内容
head        显示对象的前n行内容
pipe        将标准输入流传输到对象
share       生成对象的临时访问URL
find        搜索对象
sql         对对象运行SQL查询
stat        显示对象元数据
mv          移动对象
tree        以树形结构列出桶和对象
du          递归汇总磁盘使用情况
retention   设置对象的保留策略
legalhold   为对象设置法律保留
diff        列出两个桶之间对象名称、大小和日期的差异
rm          删除对象
encrypt     管理桶加密配置
event       管理对象通知
watch       监听对象通知事件
undo        撤销PUT/DELETE操作
policy      管理桶和对象的匿名访问权限
tag         管理桶和对象的标签
ilm         管理桶生命周期
version     管理桶版本控制
replicate   配置服务端桶复制
admin       管理MinIO服务器
update      将mc更新到最新版本
```


## 安装与部署

### Docker容器安装
#### 稳定版
```bash
docker pull minio/mc
docker run minio/mc ls play  # 默认连接MinIO play测试环境
```

#### 边缘版（开发中版本）
```bash
docker pull minio/mc:edge
docker run minio/mc:edge ls play
```

**注意**：上述示例默认连接MinIO [play测试环境](#测试配置)。若要连接其他S3兼容服务，需先进入容器交互模式：
```bash
docker run -it --entrypoint=/bin/sh minio/mc
```
再执行[`mc config`命令](#添加云存储服务)配置连接。

#### GitLab CI中使用
在GitLab CI中使用Docker容器时，需将entrypoint设为空字符串：
```yaml
deploy:
  image:
    name: minio/mc
    entrypoint: ['']  # 覆盖镜像默认entrypoint
  stage: deploy
  before_script:
    - mc alias set minio $MINIO_HOST $MINIO_ACCESS_KEY $MINIO_SECRET_KEY  # 配置服务别名
  script:
    - mc cp <源文件> <目标路径>  # 执行文件复制等操作
```


### macOS安装（Homebrew）
通过Homebrew安装：
```bash
brew install minio/stable/mc
mc --help  # 验证安装
```


### GNU/Linux安装（二进制下载）
| 平台       | 架构        | 下载链接 |
|------------|-------------|----------|
| GNU/Linux  | 64位Intel   | [] |
| GNU/Linux  | 64位PPC     | [] |

以64位Intel为例：
```bash
wget [] +x mc  # 添加执行权限
./mc --help  # 验证安装
```


### Windows安装（二进制下载）
| 平台         | 架构        | 下载链接 |
|--------------|-------------|----------|
| Microsoft Windows | 64位Intel | [] |

下载后直接运行：
```bash
mc.exe --help  # 验证安装
```


### 源码安装（适用于开发者）
需先配置Golang环境（最低版本go1.13）：
```bash
GO111MODULE=on go get github.com/minio/mc
```


## 添加云存储服务
若仅使用本地文件系统，可跳过此步骤。如需连接S3兼容服务，通过`mc alias set`命令配置，信息存储在`~/.mc/config.json`中。

**命令格式**：
```bash
mc alias set <别名> <S3服务地址> <访问密钥> <密钥> --api <签名版本> --path <桶路径模式>
```
- `<别名>`：服务的简短标识（自定义）。
- `--api`：可选，签名版本（默认S3v4）。
- `--path`：可选，桶路径模式（`on`/`off`，默认`auto`自动检测）。


### 示例：连接MinIO服务
假设MinIO服务器地址为`[] alias set minio [] BKIKJAA5BMMU2RHO6IBB V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12
```


### 示例：连接Amazon S3服务
需先获取AWS访问密钥（参考[AWS凭证指南]([])）：
```bash
mc alias set s3 [] BKIKJAA5BMMU2RHO6IBB V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12
```

**注意**：IAM用户需配置权限策略（示例，限制访问指定桶）：
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowBucketStat",
            "Effect": "Allow",
            "Action": ["s3:HeadBucket"],
            "Resource": "*"
        },
        {
            "Sid": "AllowThisBucketOnly",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::<your-restricted-bucket>/*",
                "arn:aws:s3:::<your-restricted-bucket>"
            ]
        }
    ]
}
```


### 示例：连接Google Cloud Storage
获取访问密钥后（参考[Google凭证指南]([])）：
```bash
mc alias set gcs [] BKIKJAA5BMMU2RHO6IBB V8f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12
```


## 测试配置
`mc`默认预配置了MinIO play测试环境（别名`play`），可直接测试基本功能。


### 列出桶
```bash
mc ls play  # 列出play环境中的所有桶
# 输出示例：
# [2016-03-22 19:47:48 PDT]     0B my-bucketname/
# [2016-03-22 22:01:07 PDT]     0B mytestbucket/
```


### 创建桶
用`mb`命令创建桶：
```bash
mc mb play/mybucket  # 在play环境创建mybucket桶
# 输出：Bucket created successfully `play/mybucket`.
```


### 复制对象
用`cp`命令复制本地文件到桶：
```bash
mc cp myobject.txt play/mybucket  # 将本地myobject.txt复制到play/mybucket
# 输出示例：myobject.txt:    14 B / 14 B  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  100.00 % 41 B/s 0
```


## 日常使用技巧

### Shell别名替换
可将`mc`命令别名设置为常用Unix命令，直接替换原生工具：
```bash
alias ls='mc ls'       # 用mc ls替换系统ls
alias cp='mc cp'       # 用mc cp替换系统cp
alias cat='mc cat'     # 用mc cat替换系统cat
alias mkdir='mc mb'    # 用mc mb替换系统mkdir
alias find='mc find'   # 用mc find替换系统find
```


### Shell自动补全
`mc`内置bash、zsh、fish的自动补全功能，安装方法：
```bash
mc --autocompletion  # 安装补全配置
```
重启Shell后，输入`mc `并按Tab键即可自动补全命令：
```bash
mc <TAB>  # 按Tab键显示可选命令
# 输出示例：admin    config   diff     find     ls       mirror   policy   session  sql      update   watch...
```


## 深入了解
- [MinIO客户端完整指南]([])
- [MinIO快速入门指南]([])
- [MinIO文档官网]([])


## 参与贡献
请参考MinIO [贡献者指南]([])。


## 许可协议
`mc`的使用受GNU AGPLv3许可协议约束，详见[LICENSE]([])文件。

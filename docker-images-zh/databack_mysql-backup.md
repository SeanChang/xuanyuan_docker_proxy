---
image: databack/mysql-backup
description: "用于将MySQL数据库备份到任何位置的工具，支持定时备份、恢复操作及旧备份清理。"
source: https://xuanyuan.cloud/zh/r/databack/mysql-backup
canonical: https://xuanyuan.cloud/zh/r/databack/mysql-backup
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/databack/mysql-backup" title="databack/mysql-backup Docker 镜像中文简介、标签列表与拉取命令">databack/mysql-backup — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/databack/mysql-backup" title="databack/mysql-backup Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/databack/mysql-backup</a>

# mysql-backup

将MySQL数据库备份到任何位置！

详情请参见[官方主页和文档](https://github.com/databacker/mysql-backup)

## 概述

mysql-backup是一种简单的MySQL数据库备份、恢复及管理工具。

其主要特性包括：
* 支持备份（dump）与恢复（restore）操作
* 可将备份存储至本地文件系统或SMB服务器
* 支持指定数据库用户及密码
* 可连接至同一系统中运行的任何容器
* 支持配置备份执行频率
* 支持设置首次备份开始时间（具体时间或相对于容器启动时间）
* 支持清理超过指定时间或数量的旧备份

贡献者列表请参见[CONTRIBUTORS.md](https://github.com/databacker/mysql-backup/tree/master/CONTRIBUTORS.md)。

## 版本

当前为最新版本，基于2023年底完成的Golang代码库完全重构，对应1.0.0版本发布。

## 支持

支持可通过databack Slack频道获取；注册[此处](https://join.slack.com/t/databack/shared_invite/zt-1cnbo2zfl-0dQS895icOUQy31RAruf7w)。我们接受此处的问题报告及Slack上的一般支持问题。

如需商业支持，请通过上述Slack联系我们。

## 运行`mysql-backup`

mysql-backup提供独立二进制文件和容器镜像两种形式。

## 备份

运行备份时，需以容器或二进制形式启动mysql-backup并指定正确参数。

例如：
```bash
docker run -d --restart=always -e DB_DUMP_FREQUENCY=60 -e DB_DUMP_BEGIN=2330 -e DB_DUMP_TARGET=/local/file/path -e DB_SERVER=my-db-address -v /local/file/path:/db databack/mysql-backup dump

# 或

mysql-backup dump --frequency=60 --begin=2330 --target=/local/file/path --server=my-db-address

# 或通过unix域套接字连接本地mysqld（当前用户）

mysql-backup dump --frequency=60 --begin=2330 --target=/local/file/path --server=/run/mysqld/mysqld.sock
```

或使用配置文件：`mysql-backup --config-file=/path/to/config/file.yaml`，配置文件内容如下：
```yaml
server: my-db-address
dump:
  frequency: 60
  begin: 2330
  target: /local/file/path
```

上述配置将从`my-db-address`容器访问的数据库中，每60分钟执行一次备份，首次备份从当天23:30开始。

指定用户密码的示例：
```bash
docker run -d --restart=always -e DB_USER=user123 -e DB_PASS=pass123 -e DB_DUMP_FREQUENCY=60 -e DB_DUMP_BEGIN=2330 -e DB_DUMP_TARGET=/db -e DB_SERVER=my-db-address -v /local/file/path:/db databack/mysql-backup dump

# 或

mysql-backup dump --user=user123 --pass=pass123 --frequency=60 --begin=2330 --target=/local/file/path --server=my-db-address --port=3306
```

备份详细说明参见[backup](https://github.com/databacker/mysql-backup/tree/master/docs/backup.md)，所有配置选项参见[configuration](https://github.com/databacker/mysql-backup/tree/master/docs/configuration.md)。

## 恢复

执行恢复操作时，流程相反，需使用`restore`命令并指定恢复目标。仍需连接数据库，但需替换为恢复相关参数。

### 基础恢复

恢复现有数据库时，需设置以下环境变量（建议使用`--env-file=`避免敏感信息泄露到shell历史）：
* `DB_SERVER`：数据库连接地址（主机名或unix域套接字路径，以斜杠开头），必填。
* `DB_PORT`：数据库端口，可选，默认3306。
* `DB_USER`：数据库用户名。
* `DB_PASS`：数据库密码。
* `DB_NAMES`：需恢复的数据库名称，空格分隔，`SINGLE_DATABASE=true`时必填。
* `SINGLE_DATABASE`：若设为`true`，`DB_NAMES`必填且只能包含一个数据库名，此时MySQL命令将添加`--database=$DB_NAMES`参数，无需`USE <database>;`语句，适用于从`SINGLE_DATABASE=true`备份的文件恢复。
* `DB_RESTORE_TARGET`：恢复文件路径（压缩备份文件），支持绝对路径（需挂载卷）、SMB或S3 URL。
* `DB_DUMP_DEBUG`：设为`true`时，恢复过程将输出详细日志。
* 使用S3驱动时，需定义`AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`和`AWS_DEFAULT_REGION`。

恢复示例：
1. 从本地文件恢复：
```bash
docker run -e DB_SERVER=gotodb.example.com -e DB_USER=user123 -e DB_PASS=pass123 -e DB_RESTORE_TARGET=/backup/db_backup_201509271627.gz -v /local/path:/backup databack/mysql-backup restore
```
2. 使用SSL从本地文件恢复：
```bash
docker run -e DB_SERVER=gotodb.example.com -e DB_USER=user123 -e DB_PASS=pass123 -e DB_RESTORE_TARGET=/backup/db_backup_201509271627.gz -e RESTORE_OPTS="--ssl-cert /certs/client-cert.pem --ssl-key /certs/client-key.pem" -v /local/path:/backup -v /local/certs:/certs databack/mysql-backup restore
```
3. 从SMB文件恢复：
```bash
docker run -e DB_SERVER=gotodb.example.com -e DB_USER=user123 -e DB_PASS=pass123 -e DB_RESTORE_TARGET=smb://smbserver/share1/backup/db_backup_201509271627.gz databack/mysql-backup restore
```
4. 从S3文件恢复：
```bash
docker run -e DB_SERVER=gotodb.example.com -e AWS_ACCESS_KEY_ID=awskeyid -e AWS_SECRET_ACCESS_KEY=secret -e AWS_REGION=eu-central-1 -e DB_USER=user123 -e DB_PASS=pass123 -e DB_RESTORE_TARGET=s3://bucket/path/db_backup_201509271627.gz databack/mysql-backup restore
```

### 恢复特定数据库

多库备份文件可选择恢复部分数据库，或重命名恢复单个数据库（需备份和恢复时均设置`SINGLE_DATABASE=true`）。

示例：
1. 多库备份恢复部分数据库：
   * 备份：
```bash
docker run -e DB_SERVER=gotodb.example.com -e DB_USER=user123 -e DB_PASS=pass123 -v /local/path:/backup databack/mysql-backup dump
```
   * 恢复：
```bash
docker run -e DB_SERVER=gotodb.example.com -e DB_USER=user123 -e DB_PASS=pass123 -e DB_RESTORE_TARGET=/backup/db_backup_201509271627.gz -e DB_NAMES="database1 database3" -v /local/path:/backup databack/mysql-backup restore
```
2. 重命名恢复单个数据库：
   * 备份：
```bash
docker run -e DB_SERVER=gotodb.example.com -e DB_USER=user123 -e DB_PASS=pass123 -e SINGLE_DATABASE=true -e DB_NAMES=database1 -v /local/path:/backup databack/mysql-backup dump
```
   * 恢复：
```bash
docker run -e DB_SERVER=gotodb.example.com -e DB_USER=user123 -e DB_PASS=pass123 -e DB_RESTORE_TARGET=/backup/db_backup_201509271627.gz -e SINGLE_DATABASE=true -e DB_NAMES=newdatabase1 -v /local/path:/backup databack/mysql-backup restore
```

恢复详细说明参见[restore](https://github.com/databacker/mysql-backup/tree/master/docs/restore.md)，所有配置选项参见[configuration](https://github.com/databacker/mysql-backup/tree/master/docs/configuration.md)。

## 许可证

MIT许可证。版权所有Avi Deitcher https://github.com/deitch

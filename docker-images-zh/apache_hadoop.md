<!-- xuanyuan-docker-images-zh
image: apache/hadoop
source: https://xuanyuan.cloud/zh/r/apache/hadoop
canonical: https://xuanyuan.cloud/zh/r/apache/hadoop
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [apache/hadoop — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/apache/hadoop "apache/hadoop Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/apache/hadoop

## Apache Hadoop  

Apache Hadoop 是一个软件框架，支持通过简单编程模型在计算机集群上分布式处理大型数据集。它设计之初就支持从单台服务器扩展到数千台机器，每台机器均提供本地计算和存储能力。与依赖硬件实现高可用不同，Hadoop 框架本身在应用层设计了故障检测和处理机制，因此即便集群中部分机器可能发生故障，仍能提供高可用服务。  


## 快速开始  

通过拉取相关 Docker 镜像并指定必要配置，即可搭建 Hadoop 集群。  


### 构建最新 hadoop-3 镜像示例  

#### 创建基础 docker-compose.yaml 文件  
文件内容如下：  
```yaml
version: "2"
services:
   namenode:
      image: apache/hadoop:3
      hostname: namenode
      command: ["hdfs", "namenode"]
      ports:
        - 9870:9870
      env_file:
        - ./config
      environment:
          ENSURE_NAMENODE_DIR: "/tmp/hadoop-root/dfs/name"
   datanode:
      image: apache/hadoop:3
      command: ["hdfs", "datanode"]
      env_file:
        - ./config      
   resourcemanager:
      image: apache/hadoop:3
      hostname: resourcemanager
      command: ["yarn", "resourcemanager"]
      ports:
         - 8088:8088
      env_file:
        - ./config
      volumes:
        - ./test.sh:/opt/test.sh
   nodemanager:
      image: apache/hadoop:3
      command: ["yarn", "nodemanager"]
      env_file:
        - ./config
```  
如需构建其他版本（如 Apache Hadoop 3.3.5），修改 `image: apache/hadoop:3` 为对应版本即可，例如 `image: apache/hadoop:3.3.5`。  


#### 创建 config 配置文件  
文件内容如下，可按类似格式添加或替换配置项：  
```
CORE-SITE.XML_fs.default.name=hdfs://namenode
CORE-SITE.XML_fs.defaultFS=hdfs://namenode
HDFS-SITE.XML_dfs.namenode.rpc-address=namenode:8020
HDFS-SITE.XML_dfs.replication=1
MAPRED-SITE.XML_mapreduce.framework.name=yarn
MAPRED-SITE.XML_yarn.app.mapreduce.am.env=HADOOP_MAPRED_HOME=$HADOOP_HOME
MAPRED-SITE.XML_mapreduce.map.env=HADOOP_MAPRED_HOME=$HADOOP_HOME
MAPRED-SITE.XML_mapreduce.reduce.env=HADOOP_MAPRED_HOME=$HADOOP_HOME
YARN-SITE.XML_yarn.resourcemanager.hostname=resourcemanager
YARN-SITE.XML_yarn.nodemanager.pmem-check-enabled=false
YARN-SITE.XML_yarn.nodemanager.delete.debug-delay-sec=600
YARN-SITE.XML_yarn.nodemanager.vmem-check-enabled=false
YARN-SITE.XML_yarn.nodemanager.aux-services=mapreduce_shuffle
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.maximum-applications=10000
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.maximum-am-resource-percent=0.1
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.resource-calculator=org.apache.hadoop.yarn.util.resource.DefaultResourceCalculator
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.root.queues=default
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.root.default.capacity=100
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.root.default.user-limit-factor=1
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.root.default.maximum-capacity=100
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.root.default.state=RUNNING
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.root.default.acl_submit_applications=*
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.root.default.acl_administer_queue=*
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.node-locality-delay=40
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.queue-mappings=
CAPACITY-SCHEDULER.XML_yarn.scheduler.capacity.queue-mappings-override.enable=false
```  


### 检查当前目录（可选）  
执行 `ls -l` 命令，应能看到上述创建的两个文件：  
```
docker-3 % ls -l
-rw-r--r--  1 hadoop  apache  2547 Jun 23 15:53 config
-rw-r--r--  1 hadoop  apache  1533 Jun 23 16:07 docker-compose.yaml
```  


### 运行 docker 容器  
通过 docker-compose 启动集群：  
```bash
docker-compose up -d
```  
预期输出如下：  
```
docker-3 % docker-compose up -d    
Creating network "docker-3_default" with the default driver
Creating docker-3_namenode_1        ... done
Creating docker-3_datanode_1        ... done
Creating docker-3_nodemanager_1     ... done
Creating docker-3_resourcemanager_1 ... done
```  


### 访问集群  

#### 登录节点  
通过指定容器名称登录任意节点，例如登录 namenode：  
```bash
docker exec -it docker-3_namenode_1 /bin/bash
```  

#### 运行示例任务（Pi 任务）  
执行以下命令运行 Pi 计算任务：  
```bash
yarn jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.5.jar pi 10 15
```  
类似地，可运行其他 Hadoop 相关命令。  


### 访问 UI 界面  
- Namenode UI：访问 `[]  
- ResourceManager UI：访问 `[]  


### 关闭集群  
执行以下命令停止并移除集群容器：  
```bash
docker-compose down
```  


### 注意事项  
上述示例适用于 Hadoop-3.x 版本。若需搭建 Hadoop-2.x 集群，需使用不同的配置和 docker-compose 文件，可参考：[]  


### Docker 源代码  
Hadoop Docker 镜像基于特定分支构建：  
- Hadoop-3.x 分支：[]  
- Hadoop-2.x 分支：[]  


### 联系我们  
可通过 Hadoop 邮件列表联系开发者：[]  


### 延伸阅读  
更多信息请访问 Hadoop 官网：[]

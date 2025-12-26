# Docker 部署微服务项目保姆级教程

![Docker 部署微服务项目保姆级教程](https://img.xuanyuan.dev/docker/blog/docker-mico.png)

*分类: Docker,Microservices | 标签: microservices,docker,部署教程 | 发布时间: 2025-10-20 05:08:47*

> 这是一篇专门写给编程新手的微服务部署全流程教程，不用纠结复杂概念，不用怕踩网络或环境坑。我们从Docker环境一键搭建开始，用轩辕镜像解决国内拉取镜像慢的问题，避开OpenJDK弃用的雷区，全程手把手带你完成「本地调试→服务器部署」，哪怕是2核4G的低配服务器，也能顺利跑通包含MySQL、Redis、Nacos和4个电商场景业务服务的微服务项目。

## 简介
这是一篇专门写给编程新手的微服务部署全流程教程，不用纠结复杂概念，不用怕踩网络或环境坑。我们从Docker环境一键搭建开始，用轩辕镜像解决国内拉取镜像慢的问题，避开OpenJDK弃用的雷区，全程手把手带你完成「本地调试→服务器部署」，哪怕是2核4G的低配服务器，也能顺利跑通包含MySQL、Redis、Nacos和4个电商场景业务服务的微服务项目。

## 前置准备：Docker及Docker Compose环境搭建
刚接触微服务部署的同学，千万别上来就怼服务器——先把本地Docker环境搞定，后续操作会少走90%的坑。而且这一步超级简单，用脚本一键就能完成。

### 为什么选Docker部署微服务？
传统部署微服务太折磨人了：要手动装MySQL、Redis这些依赖，版本不对还会冲突；本地跑的好好的，一上服务器就报错；启动服务要敲一堆命令，忘了顺序还得重来。而Docker能一次性解决这些问题：
- 环境一致：把应用和依赖打包成「镜像」，就像带配置的安装包，本地、服务器跑起来完全一样；
- 隔离安全：每个服务跑在独立容器里，不会互相干扰，也不用担心影响主机环境；
- 操作简单：用Docker Compose写个配置文件，一行命令就能启动所有服务；
- 迭代方便：更新版本只需拉新镜像，出问题回滚也快；
- 资源够省：容器启动秒级响应，2核4G服务器跑一套微服务完全够用。

### 一键安装Docker及Docker Compose
不管你用的是Linux、Mac还是Windows（需开启WSL2），复制下面的命令到终端，回车就能自动安装，还会配置好轩辕镜像访问支持，不用手动调配置：
```bash
# 直接复制到终端执行，Linux/Mac/WSL2通用
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```
安装完成后，一定要验证一下环境是否可用，输入两个命令：
```bash
docker --version  # 能看到版本号（比如Docker version 27.0.3）就对了
docker compose --version  # 输出类似Docker Compose version v2.27.0即可
```
如果是Windows或Mac用户，想更直观地管理容器，也可以装Docker Desktop（官网直接搜就能下载），安装后会自动关联本地Docker环境，图形化界面能看到容器启动状态，新手友好度拉满。

### Maven安装说明（本地/服务器双方案）
打包微服务需要Maven环境，这里提供「容器免安装」和「手动安装」两种方案，新手优先选容器方案（无需配置环境变量，直接可用）。

#### 方案1：Docker容器方案（推荐新手，免安装）
无需手动安装Maven，直接使用官方Maven镜像运行打包命令，容器退出后不残留环境，命令如下（后续打包会直接用此方式）：
```bash
# 格式：docker run -v 本地项目路径:/app -w /app maven:版本 打包命令
docker run -v $(pwd):/app -w /app maven:3.8.1-jdk-8-slim mvn clean package -DskipTests
```

#### 方案2：手动安装（本地/服务器通用）
若需本地长期使用Maven，可手动安装，步骤如下：
1.  **下载Maven**：访问[Maven官网](https://maven.apache.org/download.cgi)，下载对应系统的压缩包（如Linux选apache-maven-3.8.8-bin.tar.gz）；
2.  **解压安装**：
    - Linux/Mac：终端执行`tar -zxvf apache-maven-3.8.8-bin.tar.gz -C /usr/local/`；
    - Windows：右键解压到指定目录（如D:\apache-maven-3.8.8）；
3.  **配置环境变量**：
    - Linux/Mac：编辑`/etc/profile`，添加`export MAVEN_HOME=/usr/local/apache-maven-3.8.8`和`export PATH=$MAVEN_HOME/bin:$PATH`，执行`source /etc/profile`生效；
    - Windows：右键「此电脑」→属性→高级系统设置→环境变量，新增MAVEN_HOME变量（值为解压路径），在Path中添加`%MAVEN_HOME%\bin`；
4.  **验证安装**：终端执行`mvn -v`，能看到Maven版本信息即成功。


## 核心概念：不用死记，理解就行
刚接触Docker的同学，不用纠结复杂术语，记住两个核心东西，后续操作就顺了：
- 镜像：相当于「带环境的安装包」，包含了应用运行需要的所有东西（如JDK、MySQL程序），我们从镜像仓库拉取后就能用；
- 容器：镜像运行起来后的实例，就像装好了软件的虚拟机，能启动、停止、删除，删除后数据不会残留（除非配置了持久化）。

这里有个关键提醒：很多教程里用的OpenJDK镜像已经被弃用了，继续用会出兼容性问题！给大家整理了5个官方推荐的替代镜像，新手优先选Amazon Corretto，体积小、适配性强，每个镜像都能在轩辕镜像平台查到详细用法（**Amazon Corretto是构建业务服务的基础镜像，属于环境依赖范畴，并非业务服务本身**）：
- Amazon Corretto（推荐）：AWS官方维护，兼容所有Java项目，https://xuanyuan.cloud/r/library/amazoncorretto
- Eclipse Temurin：Eclipse基金会维护，轻量适合容器环境，https://xuanyuan.cloud/r/library/eclipse-temurin
- IBM Semeru Runtimes：IBM出品，内存占用低，适合微服务，https://xuanyuan.cloud/r/library/ibm-semeru-runtimes
- IBMJava：基于OpenJ9 JVM，启动快，https://xuanyuan.cloud/r/library/ibmjava
- SapMachine：SAP维护，企业级稳定性，https://xuanyuan.cloud/r/library/sapmachine

而Docker Compose，你可以把它理解成「容器管家」——不用一个个启动MySQL、Redis、业务服务，写个配置文件，告诉它要启动哪些容器、容器之间的关系，它就能按顺序一键启动，还能统一管理。


## 部署流程概览
整个部署分两大步，逻辑超清晰：
1.  本地部署：先在自己电脑上把所有服务调通，确认没问题再上服务器，风险低、调试方便；
2.  服务器部署：把本地调好的代码和配置同步到服务器，一键启动，完成线上部署。

每一步都有明确的目标，跟着做就行，不用自己瞎琢磨顺序。


## 第一阶段：本地部署（8步搞定，新手也能一次过）
本地部署的核心是「把所有服务跑起来，验证功能正常」，我们以**电商基础场景**为例（包含用户、商品、订单核心服务），一步步操作：

### 1. 梳理服务部署表格：先把要部署的东西列清楚
部署前先列个清单，避免漏服务或搞混启动顺序。我们把服务分成「环境依赖」和「业务服务」两类——必须先启动环境依赖，再启动业务服务，不然会报“连接不上数据库”之类的错。表格中所有信息均与后续配置文件、命令严格对应，新手可直接复用。

| 服务名称         | 英文名                  | 端口号       | 版本/镜像说明                          | 服务类别   | 核心作用                          | 轩辕镜像详情页                          |
|------------------|-------------------------|--------------|---------------------------------------|------------|-----------------------------------|---------------------------------------|
| 数据库           | mysql                   | 3306         | mysql:8                               | 环境依赖   | 存储用户、商品、订单数据          | https://xuanyuan.cloud/r/library/mysql |
| 缓存服务         | redis                   | 6379         | redis:6                               | 环境依赖   | 缓存热点数据（如商品详情）        | https://xuanyuan.cloud/r/library/redis |
| 消息队列         | rabbitmq                | 5672（通信）/15672（管理） | rabbitmq:3.12.6-management        | 环境依赖   | 异步处理订单（如创建订单后发通知）| https://xuanyuan.cloud/r/library/rabbitmq |
| 注册中心         | nacos                   | 8848         | nacos/nacos-server:v2.2.0-slim        | 环境依赖   | 服务注册与发现（管理业务服务）    | https://xuanyuan.cloud/r/nacos/nacos-server |
| 网关服务         | mall-gateway            | 8080         | 基于Amazon Corretto:8-alpine构建      | 业务服务   | 统一入口，路由请求到对应服务      | https://xuanyuan.cloud/r/library/amazoncorretto |
| 用户中心服务     | mall-user-service       | 8081         | 基于Amazon Corretto:8-alpine构建      | 业务服务   | 处理用户注册、登录、信息管理      | https://xuanyuan.cloud/r/library/amazoncorretto |
| 商品管理服务     | mall-product-service    | 8082         | 基于Amazon Corretto:8-alpine构建      | 业务服务   | 处理商品新增、查询、库存管理      | https://xuanyuan.cloud/r/library/amazoncorretto |
| 订单服务         | mall-order-service      | 8083         | 基于Amazon Corretto:8-alpine构建      | 业务服务   | 处理订单创建、支付状态同步        | https://xuanyuan.cloud/r/library/amazoncorretto |


### 2. Docker环境下打包：不用本地装Maven，容器内搞定
微服务项目用Maven子父模块管理，不用一个个打包，用Docker容器就能一键打包所有服务，还不会污染本地环境。

先确认你的项目是子父模块结构（父模块`mall-parent`包含`mall-gateway`、`mall-user-service`等4个业务子模块），然后给pom.xml加好配置：
- 父模块（mall-parent）pom.xml：引入spring-boot-maven-plugin，注意别加configuration和repackage，统一管理插件版本：
  ```xml
  <build>
      <pluginManagement>
          <plugins>
              <plugin>
                  <groupId>org.springframework.boot</groupId>
                  <artifactId>spring-boot-maven-plugin</artifactId>
                  <version>2.7.10</version> <!-- 与Spring Boot版本对应 -->
              </plugin>
          </plugins>
      </pluginManagement>
  </build>
  ```
- 业务子模块（如mall-user-service）pom.xml：加repackage配置，让依赖自动打入jar包，每个业务子模块都需添加：
  ```xml
  <build>
      <plugins>
          <plugin>
              <groupId>org.springframework.boot</groupId>
              <artifactId>spring-boot-maven-plugin</artifactId>
              <executions>
                  <execution>
                      <id>repackage</id>
                      <goals>
                          <goal>repackage</goal>
                      </goals>
                  </execution>
              </executions>
          </plugin>
      </plugins>
  </build>
  ```

配置好后，打开终端进入项目根目录（mall-parent），执行下面的命令（用Maven容器打包，不用本地装Maven）：
```bash
# Windows用户把$(pwd)改成自己的项目路径，比如/c/Users/xxx/mall-parent
docker run -v $(pwd):/app -w /app maven:3.8.1-jdk-8-slim mvn clean package -DskipTests
```
打包成功后，每个业务子模块的target目录里会出现xxx.jar文件（比如mall-user-service-0.0.1-SNAPSHOT.jar），这就是我们要部署的应用包。


### 3. 编写Dockerfile：给每个业务服务做「安装包」
Dockerfile是构建镜像的说明书，告诉Docker怎么用Amazon Corretto基础镜像打包我们的业务服务。新手不用自己写，复制下面的模板，改改jar包名称和端口就行。

我们选「复制jar包版」（本地已经打好包，效率高），以「用户中心服务」为例，在`mall-user-service`目录下新建Dockerfile，内容如下（**所有业务服务的Dockerfile结构一致，仅需修改jar包名称和端口**）：
```dockerfile
# 基础镜像：用轩辕加速的Amazon Corretto（OpenJDK替代方案，环境依赖）
FROM xxx.xuanyuan.run/library/amazoncorretto:8-alpine

# 指定容器内的工作目录，后续命令都在此目录执行
WORKDIR /app

# 把本地target目录的jar包复制到容器的工作目录（jar包名称要和自己的一致）
ADD target/mall-user-service-0.0.1-SNAPSHOT.jar .

# 暴露服务端口（必须和服务配置的端口一致，用户中心服务是8081）
EXPOSE 8081

# 启动命令：指定生产环境配置文件（prod配置需提前编写，后续步骤会讲）
ENTRYPOINT ["java","-jar","/app/mall-user-service-0.0.1-SNAPSHOT.jar","--spring.profiles.active=prod"]
```

按同样的方式，给另外3个业务服务编写Dockerfile：
- 网关服务（mall-gateway）：修改jar包为`mall-gateway-0.0.1-SNAPSHOT.jar`，端口为8080；
- 商品管理服务（mall-product-service）：jar包为`mall-product-service-0.0.1-SNAPSHOT.jar`，端口8082；
- 订单服务（mall-order-service）：jar包为`mall-order-service-0.0.1-SNAPSHOT.jar`，端口8083。

写完后可以在IDEA里调试：右键Dockerfile→Build Image，输入镜像名称（比如mall-user-service），构建成功后启动容器，查看日志如果能看到Spring的图标，说明Dockerfile没问题。


### 4. 编写环境依赖配置：一键启动MySQL、Redis等服务
环境依赖（MySQL、Redis、RabbitMQ、Nacos）要单独配置，避免和业务服务一起启动时顺序混乱。在项目根目录（mall-parent）新建`docker-compose.env.yml`文件，内容如下（所有镜像都用轩辕访问支持地址，国内拉取超快，配置与服务表格严格对应）：
```yaml
version: '3'
services:
  # MySQL服务（对应表格中"数据库"服务）
  mysql:
    image: xxx.xuanyuan.run/library/mysql:8  # 轩辕加速镜像，拉取访问表现快
    container_name: mall-mysql  # 容器名称，与服务名对应，好记
    environment:
      MYSQL_ROOT_PASSWORD: 123456  # 数据库密码，建议后续修改为复杂密码
      MYSQL_DATABASE: mall_db  # 自动创建业务数据库，无需手动建库
    ports:
      - "3306:3306"  # 端口映射：本地3306 ↔ 容器3306（与表格端口一致）
    volumes:
      - ./.mysql-data:/var/lib/mysql  # 数据持久化：容器删除后数据不丢失
      - ./mysql-init:/docker-entrypoint-initdb.d  # 初始化脚本目录：启动时自动执行SQL
    restart: always  # 容器崩溃后自动重启，提高稳定性
    networks:
      - mall-network  # 加入自定义网络，确保与其他环境依赖互通

  # Redis服务（对应表格中"缓存服务"）
  redis:
    image: xxx.xuanyuan.run/library/redis:6  # 轩辕加速镜像
    container_name: mall-redis  # 与表格服务名对应
    ports:
      - "6379:6379"  # 端口映射（与表格一致）
    volumes:
      - ./.redis-data:/data  # 持久化缓存数据
    command: redis-server --appendonly yes  # 开启AOF持久化，防止缓存丢失
    networks:
      - mall-network

  # RabbitMQ服务（对应表格中"消息队列"）
  rabbitmq:
    image: xxx.xuanyuan.run/library/rabbitmq:3.12.6-management  # 带管理面板的镜像
    container_name: mall-rabbitmq  # 与表格服务名对应
    environment:
      RABBITMQ_DEFAULT_USER: guest  # 默认账号（测试用，生产环境需修改）
      RABBITMQ_DEFAULT_PASS: guest  # 默认密码
    ports:
      - "5672:5672"  # 消息通信端口（与表格一致）
      - "15672:15672"  # 管理面板端口（与表格一致）
    volumes:
      - ./.rabbitmq-data:/var/lib/rabbitmq  # 持久化消息数据
    networks:
      - mall-network

  # Nacos服务（对应表格中"注册中心"）
  nacos:
    image: xxx.xuanyuan.run/library/nacos/nacos-server:v2.2.0-slim  # 支持arm64架构，避免启动失败
    container_name: mall-nacos  # 与表格服务名对应
    ports:
      - "8848:8848"  # 端口映射（与表格一致）
    volumes:
      - ./.nacos-data:/home/nacos/data  # 持久化服务注册信息
      - ./.nacos-log:/home/nacos/logs  # 日志持久化，方便排查问题
    environment:
      - MODE=standalone  # 单节点模式：适合测试和小型生产环境
      - PREFER_HOST_MODE=hostname  # 支持主机名访问
      - TZ=Asia/Shanghai  # 时区配置：避免日志时间错乱
    networks:
      - mall-network

# 自定义网络：所有环境依赖在同一网络，确保互相访问无阻碍
networks:
  mall-network:
```

**关键准备步骤**：在项目根目录新建`mysql-init`文件夹，里面放`init.sql`初始化脚本（创建业务表，以用户表为例），启动MySQL时会自动执行，无需手动建表：
```sql
-- 切换到业务数据库
USE mall_db;

-- 创建用户表（用户中心服务用）
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '加密密码',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 可继续添加商品表、订单表...
```

配置好后，执行下面的命令启动环境依赖：
```bash
docker compose -f docker-compose.env.yml up
```
启动后逐一验证（确保与表格中服务一致）：
- MySQL：用Navicat连接`localhost:3306`，账号root，密码123456，能看到`mall_db`数据库和`user`表就对了；
- Redis：用Redis客户端连接`localhost:6379`，执行`set test 123`能成功，说明正常；
- RabbitMQ：浏览器打开`localhost:15672`，账号密码都是guest，能登录管理面板就行；
- Nacos：浏览器打开`localhost:8848/nacos`，账号密码都是nacos，能进入控制台就没问题。


### 5. 编写业务服务配置：关联环境依赖，一键启动
环境依赖能正常运行后，编写业务服务的配置文件`docker-compose.service.yml`（放在项目根目录），配置与服务表格、环境依赖配置严格对应，确保服务间能正常通信：
```yaml
version: '3'
services:
  # 网关服务（对应表格中"网关服务"，先启动网关，作为统一入口）
  mall-gateway:
    container_name: mall-gateway  # 与表格服务名一致
    build:
      context: ./mall-gateway  # 网关服务的根目录（含Dockerfile）
      dockerfile: Dockerfile
    ports:
      - "8080:8080"  # 端口映射（与表格一致）
    networks:
      - mall-network  # 与环境依赖用同一网络，确保能访问MySQL等服务
    depends_on:
      - nacos  # 网关依赖注册中心，确保Nacos先启动

  # 用户中心服务（对应表格中"用户中心服务"）
  mall-user-service:
    container_name: mall-user-service  # 与表格一致
    build:
      context: ./mall-user-service
      dockerfile: Dockerfile
    ports:
      - "8081:8081"  # 与表格端口一致
    networks:
      - mall-network
    depends_on:
      - mall-gateway  # 依赖网关
      - mysql  # 依赖数据库
      - redis  # 依赖缓存
      - nacos  # 依赖注册中心

  # 商品管理服务（对应表格中"商品管理服务"）
  mall-product-service:
    container_name: mall-product-service  # 与表格一致
    build:
      context: ./mall-product-service
      dockerfile: Dockerfile
    ports:
      - "8082:8082"  # 与表格端口一致
    networks:
      - mall-network
    depends_on:
      - mall-gateway
      - mysql
      - redis
      - nacos

  # 订单服务（对应表格中"订单服务"）
  mall-order-service:
    container_name: mall-order-service  # 与表格一致
    build:
      context: ./mall-order-service
      dockerfile: Dockerfile
    ports:
      - "8083:8083"  # 与表格端口一致
    networks:
      - mall-network
    depends_on:
      - mall-gateway
      - mysql
      - redis
      - rabbitmq  # 订单服务依赖消息队列
      - nacos

# 与环境依赖共用同一网络，确保业务服务能访问所有环境依赖
networks:
  mall-network:
```

这里的`depends_on`只是控制启动顺序，不会等服务完全就绪，所以一定要先确认环境依赖已经正常运行，再启动业务服务。


### 6. 调整程序配置：解决容器内访问问题
这是新手最容易踩的坑——本地用`localhost`能访问MySQL，容器里就不行了！因为容器内的`localhost`指向容器本身，不是你的电脑，要把配置里的`localhost`改成**环境依赖的服务名**（比如MySQL的服务名是`mysql`，与`docker-compose.env.yml`中的服务名一致）。

给每个业务服务新建`src/main/resources/application-prod.yml`（生产环境配置），配置与服务表格、环境依赖配置严格对应：

#### （1）用户中心服务（mall-user-service）配置
```yaml
spring:
  profiles: prod  # 指定为生产环境配置
  # 数据库配置（localhost改成mysql，与环境依赖服务名一致）
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://mysql:3306/mall_db?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: root
    password: 123456  # 与MySQL的密码一致
  # Redis配置（localhost改成redis，与环境依赖服务名一致）
  redis:
    host: redis
    port: 6379  # 与表格中Redis端口一致
    timeout: 5000  # 连接超时时间
  # Nacos注册中心配置（localhost改成nacos，与环境依赖服务名一致）
  cloud:
    nacos:
      discovery:
        server-addr: nacos:8848  # 与表格中Nacos端口一致
        service: mall-user-service  # 服务名，与表格一致
  application:
    name: mall-user-service  # 应用名，与服务名一致

server:
  port: 8081  # 服务端口，与表格一致
```

#### （2）商品管理服务（mall-product-service）配置
仅需修改服务名和端口，其他与用户服务一致：
```yaml
spring:
  profiles: prod
  datasource:
    url: jdbc:mysql://mysql:3306/mall_db?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: root
    password: 123456
  redis:
    host: redis
    port: 6379
  cloud:
    nacos:
      discovery:
        server-addr: nacos:8848
        service: mall-product-service  # 与表格服务名一致
  application:
    name: mall-product-service

server:
  port: 8082  # 与表格一致
```

#### （3）订单服务（mall-order-service）配置
新增RabbitMQ配置（依赖消息队列），其他与上述服务一致：
```yaml
spring:
  profiles: prod
  datasource:
    url: jdbc:mysql://mysql:3306/mall_db?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: root
    password: 123456
  redis:
    host: redis
    port: 6379
  # RabbitMQ配置（localhost改成rabbitmq，与环境依赖服务名一致）
  rabbitmq:
    host: rabbitmq
    port: 5672  # 与表格中RabbitMQ通信端口一致
    username: guest
    password: guest
  cloud:
    nacos:
      discovery:
        server-addr: nacos:8848
        service: mall-order-service  # 与表格服务名一致
  application:
    name: mall-order-service

server:
  port: 8083  # 与表格一致
```

#### （4）网关服务（mall-gateway）配置
核心是路由配置，将请求转发到对应业务服务：
```yaml
spring:
  profiles: prod
  cloud:
    # Nacos注册中心配置
    nacos:
      discovery:
        server-addr: nacos:8848  # 与环境依赖服务名一致
    # 网关路由配置（与业务服务名对应）
    gateway:
      routes:
        # 路由到用户中心服务
        - id: mall-user-service
          uri: lb://mall-user-service  # 负载均衡指向用户服务
          predicates:
            - Path=/api/user/**  # 匹配/api/user开头的请求
          filters:
            - StripPrefix=1  # 去掉/api前缀后转发
        # 路由到商品管理服务
        - id: mall-product-service
          uri: lb://mall-product-service
          predicates:
            - Path=/api/product/**
          filters:
            - StripPrefix=1
        # 路由到订单服务
        - id: mall-order-service
          uri: lb://mall-order-service
          predicates:
            - Path=/api/order/**
          filters:
            - StripPrefix=1
  application:
    name: mall-gateway  # 与表格服务名一致

server:
  port: 8080  # 与表格一致

# 开启网关Swagger文档支持（方便接口测试）
knife4j:
  gateway:
    enabled: true
    strategy: discover
    discover:
      enabled: true
      version: swagger2
```

**硬编码修复提醒**：如果代码里有硬编码的`localhost`（比如直接写`factory.setHost("localhost")`连接RabbitMQ），一定要改成从配置文件读取，示例：
```java
@Slf4j
@Component
public class InitRabbitMqConfig {
    // 从配置文件读取RabbitMQ地址，默认值localhost（适配本地开发）
    @Value("${spring.rabbitmq.host:localhost}")
    private String rabbitmqHost;

    @PostConstruct
    public void initExchangeAndQueue() {
        try {
            ConnectionFactory factory = new ConnectionFactory();
            factory.setHost(rabbitmqHost);  // 用配置的地址，不是硬编码
            Connection connection = factory.newConnection();
            Channel channel = connection.createChannel();
            // 后续创建交换机、队列逻辑不变...
            log.info("RabbitMQ交换机和队列初始化成功");
        } catch (Exception e) {
            log.error("RabbitMQ初始化失败", e);
        }
    }
}
```

改完配置后，重新执行Maven打包命令，更新jar包：
```bash
docker run -v $(pwd):/app -w /app maven:3.8.1-jdk-8-slim mvn clean package -DskipTests
```


### 7. 本地启动业务服务并验证
确保环境依赖已经启动（后台运行的话不用管），执行下面的命令启动业务服务：
```bash
docker compose -f docker-compose.service.yml up
```
启动后，打开浏览器访问`localhost:8080/doc.html`（网关的Swagger文档地址），能看到用户、商品、订单三大类接口，说明启动成功了。

接下来测试核心业务流程（模拟用户下单）：
1.  **用户注册**：调用`/api/user/register`接口，传入`username: testuser`、`password: 123456`，返回成功；
2.  **用户登录**：调用`/api/user/login`接口，传入注册的账号密码，获取登录令牌（token）；
3.  **新增商品**：在请求头添加token，调用`/api/product/add`接口，传入商品名称、价格、库存，返回成功；
4.  **创建订单**：请求头带token，调用`/api/order/create`接口，传入商品ID和数量，返回订单号；
5.  **查询订单**：调用`/api/order/get`接口，传入订单号，能查到订单详情。

所有接口都能正常调用，说明本地部署没问题了！


## 第二阶段：服务器部署（7步搞定，和本地操作几乎一样）
本地调试通后，服务器部署就简单了，核心是把本地的代码、配置同步过去，一键启动。

### 1. 准备服务器：2核4G就够了
选一台Linux服务器（推荐CentOS 7.9或Ubuntu 20.04），配置不用太高，**2核4G完全够用**（后续会验证资源占用）。

先做两个关键准备工作：
-  **开放端口**：在云厂商控制台的「安全组」里，开放以下端口（与服务表格一致）：8080-8083（业务服务）、3306（MySQL）、6379（Redis）、8848（Nacos）、15672（RabbitMQ），允许外部访问；
-  **远程连接**：用Xshell或FinalShell连接服务器，使用root账号登录（权限足够，操作方便）。


### 2. 服务器安装Docker环境：和本地一样一键搞定
登录服务器后，执行和本地相同的安装命令，一键安装Docker和Docker Compose，自动配置轩辕镜像访问支持：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```
安装完成后，执行以下命令验证，确保环境可用：
```bash
docker --version  # 输出Docker版本（如Docker version 27.0.3）
docker compose --version  # 输出Compose版本（如Docker Compose version v2.27.0）
systemctl enable docker  # 设置Docker开机自启，避免服务器重启后服务中断
systemctl status docker  # 查看Docker运行状态，显示"active (running)"即为正常
```


### 3. 同步本地文件到服务器：新手用IDEA远程部署最省心
把本地调好的项目文件同步到服务器，推荐用IDEA的「远程部署」功能——自动同步本地修改，不用手动传文件，新手也能轻松操作：

#### 步骤1：配置SFTP连接
1.  打开IDEA，顶部菜单栏点击「Tools」→「Deployment」→「Configuration」；
2.  点击左侧「+」号，选择「SFTP」，输入配置名称（比如“电商服务器”），点击「OK」；
3.  **填写服务器基础信息**：
    - 「Host」：输入服务器公网IP（如120.XX.XX.XX）；
    - 「Port」：默认22（SSH端口，未修改过无需改动）；
    - 「Username」：root（或自己的服务器账号，需有目录读写权限）；
    - 「Password」：输入服务器登录密码；
    点击下方「Test Connection」，弹出“Successfully connected”说明连接成功。

#### 步骤2：配置路径映射（关键！避免文件放错位置）
1.  切换到「Mappings」标签页；
2.  「Local path」：选择本地项目根目录（如`D:\code\mall-parent`，Windows路径）或`/Users/xxx/code/mall-parent`（Mac/Linux路径）；
3.  「Deployment path」：输入服务器上的项目存放路径（如`/code/mall-parent`，建议放在/code目录下，权限充足）；
4.  「Web path」：留空即可（非Web项目无需配置）；
5.  勾选右上角「Automatic upload (always)」：本地修改文件后自动同步到服务器，避免手动重复上传。

#### 步骤3：首次同步本地文件
右键点击本地项目根目录（`mall-parent`）→「Deployment」→「Upload to 电商服务器」，IDEA会自动将所有文件同步到服务器的`/code/mall-parent`目录。  
同步完成后，在服务器终端执行命令验证：
```bash
ls /code/mall-parent  # 能看到docker-compose.env.yml、各服务目录即为同步成功
```

### 4. 服务器打包获取jar包：复用容器方案，不用装Maven
和本地打包逻辑完全一致，服务器无需手动安装Maven，直接用Docker容器打包，避免环境配置麻烦：
1.  登录服务器后，先进入项目根目录：
    ```bash
    cd /code/mall-parent
    ```
2.  执行容器打包命令（和本地命令完全相同）：
    ```bash
    docker run -v $(pwd):/app -w /app maven:3.8.1-jdk-8-slim mvn clean package -DskipTests
    ```
    打包过程会拉取Maven依赖（首次可能稍慢，后续会缓存），耐心等待至出现「BUILD SUCCESS」。
3.  验证打包结果：
    ```bash
    # 查看用户服务的target目录是否有jar包
    ls /code/mall-parent/mall-user-service/target
    ```
    能看到`mall-user-service-0.0.1-SNAPSHOT.jar`即打包成功，其他业务服务同理。

### 5. 启动环境依赖服务：后台运行，稳定不中断
服务器部署需让服务在后台运行（关闭终端不停止），执行以下命令启动环境依赖：
```bash
cd /code/mall-parent
# 加-d参数实现后台启动
docker compose -f docker-compose.env.yml up -d
```
启动后执行「状态核查三连」，确保所有环境依赖正常运行：
1.  查看容器运行状态：
    ```bash
    docker ps  # 能看到mall-mysql、mall-redis、mall-rabbitmq、mall-nacos均为"Up"状态
    ```
2.  若某容器未启动，查看日志排查问题：
    ```bash
    docker logs -f 容器名  # 如docker logs -f mall-nacos，查看报错信息
    ```
3.  验证Nacos注册中心：
    浏览器访问`http://服务器公网IP:8848/nacos`，登录后进入「服务管理→服务列表」，此时暂无业务服务注册（正常，后续启动业务服务后会自动注册）。

### 6. 启动业务服务并验证：公网访问测试
环境依赖确认正常后，启动业务服务，同样用后台启动模式：
```bash
cd /code/mall-parent
docker compose -f docker-compose.service.yml up -d
```

#### 关键验证步骤（公网访问）
1.  **服务注册验证**：
    刷新Nacos控制台的「服务列表」，能看到`mall-gateway`、`mall-user-service`等4个业务服务，状态为「健康」，说明服务注册成功。
2.  **接口功能验证**：
    浏览器打开`http://服务器公网IP:8080/doc.html`（网关Swagger地址），重复本地的核心业务流程测试：
    - 调用`/api/user/register`注册用户；
    - 调用`/api/user/login`获取token；
    - 调用`/api/product/add`新增商品；
    - 调用`/api/order/create`创建订单；
    所有接口返回「成功」状态，说明服务器部署完全可用！

#### 常见失败排查
- 接口无法访问：先检查服务器安全组是否开放8080端口，再执行`docker logs -f mall-gateway`查看网关日志；
- 服务注册失败：检查Nacos地址配置是否为`nacos:8848`，执行`docker network ls`确认业务服务和环境依赖在同一`mall-network`网络。

### 7. 新手必备运维操作：服务器环境特供版
服务器部署后需要基础运维能力，整理6个高频命令，新手直接复制使用：
1.  **查看服务资源占用**（确认2核4G是否够用）：
    ```bash
    docker stats  # 实时显示CPU、内存占用，总内存占用约2.5-3G，完全够用
    ```
2.  **设置服务开机自启**（服务器重启后自动恢复服务）：
    ```bash
    # 给环境依赖和业务服务的容器添加开机自启
    docker update --restart=always mall-mysql mall-redis mall-rabbitmq mall-nacos
    docker update --restart=always mall-gateway mall-user-service mall-product-service mall-order-service
    ```
3.  **重启单个服务**（如用户服务故障）：
    ```bash
    docker restart mall-user-service
    ```
4.  **查看服务日志**（排查接口报错）：
    ```bash
    # 查看订单服务最新100行日志，实时刷新
    docker logs -f --tail 100 mall-order-service
    ```
5.  **批量停止所有服务**（如服务器维护）：
    ```bash
    docker compose -f docker-compose.service.yml down
    docker compose -f docker-compose.env.yml down
    ```
6.  **清理无用镜像**（释放服务器磁盘空间）：
    ```bash
    # 删除所有未使用的镜像（谨慎操作，确保无用后执行）
    docker image prune -a -f
    ```


## 结尾：部署完成！这些坑新手一定要记牢
至此，2核4G服务器上的电商微服务集群已经部署完成——从Docker环境搭建到公网接口可用，全程没有复杂配置，核心就是「本地调通再上服务器，配置保持一致」。最后再划3个避坑重点，帮你少走弯路：
1.  **环境依赖≠业务服务**：Amazon Corretto是基础镜像（环境依赖），用来打包网关、用户服务等业务服务，千万别混淆；
2.  **容器内访问用“服务名”**：localhost只在本地生效，容器内必须用`mysql`、`redis`等服务名访问依赖，这是新手最常踩的坑；
3.  **服务器先开安全组**：所有端口（8080-8083、3306等）必须在云厂商控制台开放，否则公网根本访问不到。

如果在操作中遇到具体问题，比如容器启动失败、接口调用报错，欢迎在评论区留言，我会逐一回复解决。觉得这篇教程有用的话，点赞收藏再走，后续还会更新「微服务日志收集」「服务监控搭建」等进阶内容，助力新手从小白变运维高手！

**版权声明**：本文为原创保姆级教程，禁止未经授权的商用转载，欢迎个人学习转发，转载请注明出处。


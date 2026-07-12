---
image: fabric8/java-alpine-openjdk8-jre
description: "基于Alpine的Fabric8 Java基础镜像，提供OpenJDK 8 JRE环境，集成Agent Bond（含Jolokia和Prometheus jmx_exporter）及run-java.sh启动脚本，用于容器化Java应用的部署、监控与JVM参数自动配置。"
source: https://xuanyuan.cloud/zh/r/fabric8/java-alpine-openjdk8-jre
canonical: https://xuanyuan.cloud/zh/r/fabric8/java-alpine-openjdk8-jre
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/fabric8/java-alpine-openjdk8-jre" title="fabric8/java-alpine-openjdk8-jre Docker 镜像中文简介、标签列表与拉取命令">fabric8/java-alpine-openjdk8-jre 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Fabric8 Java基础镜像 OpenJDK 8 (JRE)

该镜像基于Alpine构建，提供OpenJDK 8 (JRE)运行环境。主要包含以下组件：

* [Agent Bond](https://github.com/fabric8io/agent-bond)代理，集成[Jolokia](http://www.jolokia.org)和Prometheus [jmx_exporter](https://github.com/prometheus/jmx_exporter)。代理安装路径为`/opt/agent-bond/agent-bond.jar`，配置选项见下文。
* 用于启动Java应用的启动脚本[`/deployments/run-java.sh`](#启动脚本-run-javash)。

### Agent Bond

若需为应用启用Jolokia，应将此镜像作为基础镜像（通过`FROM`指令），并在启动脚本中使用`agent-bond-opts`的输出结果，将其包含到Java启动选项中。

例如，可在启动Java应用的脚本中添加以下片段：

```bash
# ...
export JAVA_OPTIONS="$JAVA_OPTIONS $(agent-bond-opts)"
# .... 启动应用时使用JAVA_OPTIONS，如Tomcat的启动方式
```

默认使用以下版本及配置：

* [Jolokia](http://www.jolokia.org)：版本**1.6.2**，端口**8778**
* [jmx_exporter](https://github.com/prometheus/jmx_exporter)：版本**0.3.1**，端口**9779**

可通过设置环境变量调整`agent-bond-opts`的行为：

### Agent-Bond选项

可通过以下环境变量配置Agent Bond：

* **AB_OFF**：若设置，禁用Agent Bond（输出空值）。默认启用。
* **AB_ENABLED**：启用的子代理列表，以逗号分隔。允许值为`jolokia`和`jmx_exporter`。默认两者均启用。

#### Jolokia配置

* **AB_JOLOKIA_CONFIG**：若设置，使用指定文件（含路径）作为Jolokia JVM代理属性（详见Jolokia [参考手册](http://www.jolokia.org/reference/html/agents.html#agents-jvm)）。默认值为`/opt/jolokia/jolokia.properties`。
* **AB_JOLOKIA_HOST**：绑定的主机地址（默认：`0.0.0.0`）
* **AB_JOLOKIA_PORT**：使用的端口（默认：`8778`）
* **AB_JOLOKIA_USER**：认证用户名。默认关闭认证。
* **AB_JOLOKIA_HTTPS**：启用HTTPS安全通信。若`AB_JOLOKIA_OPTS`中未配置`serverCert`，默认生成自签名服务器证书。
* **AB_JOLOKIA_PASSWORD**：认证密码。默认关闭认证。
* **AB_JOLOKIA_ID**：使用的代理ID（默认：`$HOSTNAME`，即容器ID）
* **AB_JOLOKIA_OPTS**：附加选项，格式为"key=value,key=value,..."

特定环境集成选项：

* **AB_JOLOKIA_AUTH_OPENSHIFT**：启用OpenShift TLS通信的客户端认证。值可为客户端证书中必须包含的相对可分辨名称。启用此参数会自动将Jolokia切换到HTTPS模式，默认CA证书路径为`/var/run/secrets/kubernetes.io/serviceaccount/ca.crt`。

#### jmx_exporter配置

* **AB_JMX_EXPORTER_OPTS**：`jmx_exporter`的配置，格式为`<port>:<配置文件路径>`
* **AB_JMX_EXPORTER_PORT**：JMX Exporter使用的端口。默认：`9779`
* **AB_JMX_EXPORTER_CONFIG**：`jmx_exporter`的配置文件路径。默认：`/opt/agent-bond/jmx_exporter_config.json`

### 启动脚本 run-java.sh

该镜像的默认命令为[/deployments/run-java.sh](https://github.com/fabric8io/run-java-sh)。其用途是启动Java应用，支持以fat-jars（包含所有依赖）或主类（从目录中的所有jar构建类路径）方式运行。

对于这些镜像，变量**JAVA_APP_DIR**的默认值为`/deployments`。

### run-java.sh

此通用启动脚本针对容器内运行Java应用优化，调用方式如下：

```bash
./run-java.sh <子命令> <选项>
```

`run-java.sh`支持两个子命令：

* `options`：输出JVM选项，可用于自定义Java应用启动（如Maven或Tomcat）。会考虑容器约束并包含脚本使用的所有配置逻辑。
* `run`：启动Java应用（如下所述）。这也是默认命令，可省略。

### 运行Java应用

当未指定子命令（或使用默认子命令`run`）时，脚本默认启动Java应用。

启动过程主要通过环境变量配置：

* **JAVA_APP_DIR**：应用所在目录。应用中的所有路径均相对于此目录。默认与启动脚本所在目录相同。
* **JAVA_LIB_DIR**：存放Java jar文件及可选`classpath`文件的目录。`classpath`文件可为单行冒号分隔的类路径，或每行列出一个jar文件。若未设置，**JAVA_LIB_DIR**与**JAVA_APP_DIR**相同。
* **JAVA_OPTIONS**：调用`java`时添加的选项。
* **JAVA_MAJOR_VERSION**：版本号≥7。若设置，仅使用适合该版本的选项。设为7时会移除Java 8以上特有的选项；≥10时不计算显式内存限制（Java 10+支持容器限制）。若省略，通过`JAVA_VERSION`变量、`release`文件或解析`java -version`输出猜测。
* **JAVA_MAX_MEM_RATIO**：当`JAVA_OPTIONS`中未指定`-Xmx`时使用。基于容器内存限制计算默认最大堆内存。若容器无内存限制则无效；若有内存限制，`-Xmx`设为容器可用内存的指定比例。默认值：容器可用内存<300M时为`25`，否则为`50`（即使用50%可用内存）。设为0可禁用此机制。
* **JAVA_INIT_MEM_RATIO**：当`JAVA_OPTIONS`中未指定`-Xms`时使用。基于容器内存限制计算默认初始堆内存。若容器无内存限制则无效。默认未设置。
* **JAVA_MAX_CORE**：手动限制可用核心数，用于计算GC线程数等默认值。设为0时不基于核心数进行JVM调优。
* **JAVA_DIAGNOSTICS**：设置后输出诊断信息到标准输出。
* **JAVA_MAIN_CLASS**：作为`java`参数的主类。设置此变量时，`$JAVA_APP_DIR`中的所有jar及`$JAVA_LIB_DIR`均添加到类路径。
* **JAVA_APP_JAR**：带合适清单的jar文件，可通过`java -jar`启动（若未设置`$JAVA_MAIN_CLASS`）。无论如何，此jar均添加到类路径。
* **JAVA_APP_NAME**：进程名称。
* **JAVA_CLASSPATH**：使用的类路径。若未设置，脚本检查`${JAVA_APP_DIR}/classpath`文件，其内容直接作为类路径；若文件不存在，添加`classes:${JAVA_APP_DIR}/*`（即目录中所有jar）。
* **JAVA_DEBUG**：设置后启用远程调试。
* **JAVA_DEBUG_SUSPEND**：设置后启用远程调试的挂起模式。
* **JAVA_DEBUG_PORT**：远程调试端口。默认：5005。
* **HTTP_PROXY**：代理服务器URL，转换为`http.proxyHost`和`http.proxyPort`系统属性。
* **HTTPS_PROXY**：代理服务器URL，转换为`https.proxyHost`和`https.proxyPort`系统属性。
* **no_proxy**/**NO_PROXY**：直接访问的主机列表，转换为`http.nonProxyHosts`系统属性。

若未设置`$JAVA_APP_JAR`和`$JAVA_MAIN_CLASS`，脚本检查`$JAVA_APP_DIR`中的单个JAR文件作为`$JAVA_APP_JAR`；若未找到或找到多个，抛出错误。

类路径构建规则：

* 若设置`$JAVA_CLASSPATH`，直接使用。
* 首先添加当前目录（"."）。
* 若当前目录与`$JAVA_APP_DIR`不同，添加`$JAVA_APP_DIR`。
* 若设置`$JAVA_MAIN_CLASS`：
  - 若设置`$JAVA_APP_JAR`，添加该jar。
  - 若`$JAVA_APP_DIR/classpath`文件存在，其内容追加到类路径（可为单行冒号分隔或多行，每行是相对于`$JAVA_LIB_DIR`的jar路径）。
  - 若文件不存在，添加`${JAVA_APP_DIR}/*`（按字母顺序添加目录中所有jar）。

这些变量也可在`run-env.sh` shell配置文件中设置，启动脚本会加载该文件。该文件可位于启动脚本目录或`${JAVA_APP_DIR}`，后者中的环境变量覆盖前者。

脚本还会检查`run-java-options`命令，若存在，其输出添加到`$JAVA_OPTIONS`。

脚本暴露描述容器限制的环境变量，供应用使用：

* **CONTAINER_CORE_LIMIT**：计算的核心限制，详见https://www.kernel.org/doc/Documentation/scheduler/sched-bwc.txt
* **CONTAINER_MAX_MEMORY**：容器的内存限制

脚本的所有参数直接传递给Java应用。

示例：

```bash
# 直接设置应用目录
export JAVA_APP_DIR=/deployments
# 基于容器约束设置-Xmx
export JAVA_MAX_MEM_RATIO=40
# 启动JAVA_APP_DIR中的jar并传递参数
./run-java.sh --user maxmorlock --password secret
```

### 选项

该脚本还可用于计算通用的Java应用启动最佳实践选项。例如，在容器中运行Maven时，应考虑容器内存约束。

子命令`options`可输出选项到标准输出，便于供其他Java应用使用。

未指定额外参数时，使用默认值（可通过上述环境变量调整）。

可通过额外参数选择特定选项集：

* `--debug`：若`JAVA_DEBUG`设置，输出Java调试选项
* `--memory`：基于环境变量的内存设置
* `--proxy`：解析代理环境变量
* `--cpu`：核心数受限时的调优
* `--gc`：GC调优参数
* `--jit`：JIT选项
* `--diagnostics`：若`JAVA_DIAGNOSTICS`设置，输出诊断选项
* `--java-default`：等同于`--memory --jit --diagnostic --cpu --gc`

示例：

```bash
# 在容器中运行Maven时使用适当的内存设置
export MAVEN_OPTS="$(run-java.sh options --memory)"
mvn clean install
```

### 版本信息

* 基础镜像：**Alpine 3.11**
* Java：**OpenJDK 8 1.8.0**（Java Runtime Environment (JRE)）
* Agent-Bond：**1.2.0**（Jolokia 1.6.2，jmx_exporter 0.3.1）

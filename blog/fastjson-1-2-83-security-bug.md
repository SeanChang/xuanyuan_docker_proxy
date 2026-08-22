# 【漏洞预警】Fastjson 远程代码执行

![【漏洞预警】Fastjson 远程代码执行](https://assets.xuanyuan.me/docker/blog/docker-security-advisory.png)

*分类: 安全公告 | 标签: Fastjson,Java,RCE,安全公告,漏洞预警 | 发布时间: 2026-07-23 11:23:09*

> Fastjson 1.2.83 及以下版本在特定类加载器环境下存在远程代码执行风险。影响 1.2.68 至 1.2.83，建议升级至 2.x 或开启 SafeMode，并限制服务出网。

**发布日期：** 2026 年 7 月 21 日  
**风险等级：** 严重（Critical）  
**影响组件：** Fastjson（Java JSON 序列化 / 反序列化库）

---

## 一、漏洞概述

Fastjson 是广泛使用的 Java 组件库，用于实现 Java 对象与 JSON 字符串之间的序列化与反序列化，在 Spring Boot、微服务及各类 Java 业务系统中极为常见。

**Fastjson 1.2.83 及以下版本存在远程代码执行（RCE）漏洞。** 在 JDK8 `URLClassLoader`、Spring Boot `LaunchedURLClassLoader`、自定义远程类加载器等环境下，攻击者可构造恶意 payload，触发 **远程类加载**，从而实现 **任意代码执行**。

> **重要说明：** 漏洞利用依赖特定类加载器与可达的反序列化入口。使用 Fastjson 处理不可信外部 JSON 输入的服务风险最高，请优先排查对外暴露的 API、消息消费、文件解析等场景。

---

## 二、漏洞状态

**统计截止：** 2026 年 7 月 20 日 23:15:00（UTC+8）

| 项目 | 状态 |
|------|------|
| 漏洞细节 | 已公开 |
| PoC | 已公开 |
| 在野利用 | 暂未发现 |

---

## 三、影响范围

| 组件 | 受影响版本 |
|------|------------|
| Fastjson | **1.2.68 ≤ 版本 ≤ 1.2.83** |

**典型受影响场景：**

- 使用 Fastjson 1.2.x 解析不可信用户输入、HTTP 请求体或消息队列内容的 Java 应用
- 基于 Spring Boot / Spring Cloud，且依赖 Fastjson 进行 JSON 处理的服务
- 类路径中存在可被远程加载利用的类加载器环境（如 JDK8 `URLClassLoader`、Spring Boot `LaunchedURLClassLoader` 等）

---

## 四、修复建议

请尽快采取以下任一方案完成修复或加固：

### 1. 升级至 Fastjson 2.x（推荐）

将项目依赖中的 Fastjson 升级至 **2.x** 安全版本，并充分回归测试 JSON 序列化 / 反序列化相关业务逻辑。

**Maven 示例：**

```xml
<dependency>
    <groupId>com.alibaba.fastjson2</groupId>
    <artifactId>fastjson2</artifactId>
    <version><!-- 请使用当前最新稳定版 --></version>
</dependency>
```

### 2. 开启 SafeMode

若短期内无法升级，可先开启 Fastjson SafeMode，关闭危险的 autoType 相关能力。

**代码方式：**

```java
ParserConfig.getGlobalInstance().setSafeMode(true);
```

**JVM 启动参数：**

```bash
-Dfastjson.parser.safeMode=true
```

> 开启 SafeMode 后，请验证依赖 autoType 的业务功能是否仍可正常工作；若有兼容问题，应优先完成版本升级并调整相关代码。

---

## 五、临时缓解措施

在无法立即完成升级或开启 SafeMode 前，建议采取以下措施降低风险：

1. **限制出网**  
   通过防火墙 / 安全组限制应用运行环境对外发起网络请求，阻断远程类加载所需的外联通道。

2. **收敛 JSON 入口**  
   对不可信外部输入增加校验与白名单，避免将用户可控数据直接交给 Fastjson 反序列化。

3. **加强监控与审计**  
   关注异常出站连接、可疑类加载行为及应用异常崩溃日志，发现异常及时隔离处置。

---

## 六、参考链接

- 相关讨论：<https://x.com/k_firsov/status/2078872293745570032>
- 技术分析：<https://mp.weixin.qq.com/s/cfz3mrZdnobLEjQ9f6UWjA>

---

**轩辕镜像安全团队**  
2026 年 7 月 21 日

---


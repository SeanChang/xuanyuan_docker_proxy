# 容器镜像漏洞周报（11.08–11.15）：4 条已在野利用，7 个镜像至今没有补丁

![容器镜像漏洞周报（11.08–11.15）：4 条已在野利用，7 个镜像至今没有补丁](https://imgs.xuanyuan.cloud/docker/blog/cover-weekly-2026-11-15.webp)

*分类: Docker部署教程 | 标签: 漏洞周报,容器安全,CVE,安全公告,PostgreSQL,OpenEMR,Node.js,Apache,Kubernetes | 发布时间: 2026-11-15 14:15:35*

> 2026-11-08 至 11-15 这一周，与容器镜像相关的高危漏洞共 34 组、22 条 Critical。PostgreSQL 一次修 52 个，OpenEMR 两批加起来近九十个编号，Node.js、Apache HTTP Server、Airflow、Grafana、Traefik、n8n 同周发版；GPUStack、OpenSSH+musl、FreeSWITCH、IBM Aspera Faspex 四条新进 CISA KEV，补丁期限 11 月 12 日已过。Keycloak、BusyBox、SurveyKing、Flowise 等 7 个镜像至今没有补丁。另有四个镜像的 latest 仍停在受影响版本：bitnami/postgresql、library/mongo、grafana-oss、linuxserver/openssh-server。

**发布日期：** 2026 年 11 月 15 日  
**覆盖周期：** 2026-11-08 09:00 至 2026-11-15 13:00（Asia/Shanghai）  
**风险等级：** 严重（Critical）至 高危（High）  
**涉及镜像：** `library/postgres`、`openemr/openemr`、`library/httpd`、`library/node`、`apache/airflow`、`gpustack/gpustack`、`safarov/freeswitch`、`keycloak/keycloak` 等 30 余个  
**本周规模：** 34 组漏洞，22 条 Critical（含厂商自评等级）  
**收录口径：** 只收与 Docker / OCI 镜像直接相关的 High / Critical，或厂商标注的同等及以上级别（例如 Apache 的 important / critical）。桌面软件、网络设备、固件不进这份清单。

---

## 这周补丁发得有点密集

一周里 34 组漏洞，听着吓人，但大部分是同一批集中发版带来的。PostgreSQL 一次修了 52 个，OpenEMR 前后两批加起来近九十个编号，Node.js、Apache HTTP Server、Airflow、Grafana、Traefik、n8n、NocoDB 都在这一周推了安全版本。

如果这周只能动两个镜像，先动 OpenEMR 和 PostgreSQL。OpenEMR 里那几条路径穿越是未认证或低权限就能打穿的，打完直接落文件执行命令；PostgreSQL 那批要求你先有数据库账号，但一个库里通常挂着几十个应用，随便哪条业务线的只读账号漏出来，攻击者就能在数据库进程所属的系统用户下执行任意代码。

另外四条要单独拎出来：GPUStack、OpenSSH（musl）、FreeSWITCH、IBM Aspera Faspex 在 11 月 9 日进了 CISA KEV，都属于已确认被人利用过；Node.js 的 Brotli 问题补丁期限是 11 月 10 日，也已经过了。KEV 的期限只对美国政府机构有强制力，但它的意思很直白——这不是理论上能打，是已经有人打了。

从这一周开始，漏洞预警改成每周一篇汇总。单个漏洞的完整复现细节不再单独成文，新增、修复和变化都写在这里。

---

## 四条已经被人打过

| 漏洞 | 产品 | 分数 | 打进需要什么条件 | 修到哪一版 |
|------|------|------|------------------|------------|
| [CVE-2026-102895](https://nvd.nist.gov/vuln/detail/CVE-2026-102895) | GPUStack | 9.8 | 无需账号。伪造 `X-GPUStack-Real-IP: 127.0.0.1` 就被当成本机管理员 | ≥ 2.2.0，建议直接 2.3.1 |
| [CVE-2026-123158](https://nvd.nist.gov/vuln/detail/CVE-2026-123158) | OpenSSH（musl、未启 PAM，典型是 Alpine） | 8.1 | 远程。256 到 1024 字节的任意密码就能通过认证 | OpenSSH ≥ 10.6p2，或 Alpine ≥ 3.24.4，改完重启 sshd |
| [CVE-2026-116779](https://nvd.nist.gov/vuln/detail/CVE-2026-116779) | FreeSWITCH | 9.8 | 能向它发一条 SIP MESSAGE | ≥ 1.11.3 |
| [CVE-2026-123218](https://nvd.nist.gov/vuln/detail/CVE-2026-123218) | IBM Aspera Faspex | 9.8 | 需要一个已认证账号 | 5.0.19 PL1（`faspex-core` 镜像哈希 `1ce4b13`） |

**OpenSSH 那条最容易误判。** 中招条件是 Linux + musl + 未启用 PAM，Alpine 基础镜像正好三条都占。没跑 sshd 的容器不受影响，所以纯静态业务的 Alpine 镜像不用慌；但只要镜像里起了 sshd，就必须换。Alpine 3.21.10 / 3.22.8 / 3.23.8 / 3.24.4 都带了修复。

**FreeSWITCH 那条的门槛比想象中低。** 入站 SIP MESSAGE 的 To 用户名会按 `+` 拆开，左半边被当成 chat proto，选到 `api` 就进了 `switch_api_execute()`。也就是说，只要对端能被接受，一条 SIP 消息就能执行 FreeSWITCH API，包括系统命令。

**GPUStack 这条是老账新账一起算。** 9.8 那条 11 月 5 日就报过了，这周才进 KEV。它同一周发的 2.3.1 还有一批新问题：9.1 的 `trust_remote_code` 会在评估模型时加载仓库里的 Python 并执行，9.0 的资源更新接口能替换 `owner_principal_id` 改所有权，还有一条 8.8 —— Kubernetes API 代理只检查组织是否拥有这个集群，不检查组织内角色，普通成员会被当成集群管理员。还在跑 2.3.0 的，两批都得补。

---

## 集中发版的五家

### PostgreSQL：一次 52 个，14 分支到此为止

18.7 / 17.12 / 16.16 / 15.20 / 14.25，High 38 条、Medium 12 条、Low 2 条，没有 Critical。多数 High 是 8.8，向量基本一致：已认证用户、或者能建对象的用户，可以在数据库进程所属的系统用户下执行任意代码。

翻一下那 38 条的标题就知道为什么值得连夜升：`ALTER ... SET DATA TYPE` 后的类型混淆、`tsvector_delete()` 堆溢出、plperl 和 pltcl 的释放后使用、`pg_restore` 对非 plain 归档缺少校验、逻辑复制能往订阅端系统目录写。这些东西凑在一起，等于给了一个数据库账号就等于给了宿主机。

两个附带信息：`library/postgres` 的 `latest` 已经对齐 18.7，主版本 tag（`18` / `17` / `16` / `15` / `14`）也都指向对应修复版；`bitnami/postgresql` 至今没跟上，精确 tag 全是 404。另外 14.25 是 PostgreSQL 14 的最后一个版本，14 分支到这里就结束支持了，还在 14 上的该安排迁移。

### OpenEMR：两批，别以为升一次就完事

第一批是 8.3.0 / 8.4.0，Critical 4 条、High 24 条。最狠的两条都是 9.9：一条是 fax/sms 的 `disposeDocument` 不校验 `file_path`，能读到 `sqlconf.php`（数据库口令就在这个文件里）再写任意文件，直接 RCE；另一条在 Fee Sheet 的 `sellDrug`，把 warehouse 的 POST 字段拼进 `ORDER BY`，时间盲注。还有一条 9.8 是 OneTimeAuth 忽略了一次性使用和速率限制，患者门户的 PIN 可以重放或爆破。

第二批是 8.5.0，官方 Critical 6 条、High 32 条，和第一批不是同一批编号。9.6 那条的路径是前台职员链式提升，最后能读整库、拿到患者身份、甚至塞进一份「已批准」的伪造病历。

结论很简单：升到 8.5.0 一次覆盖两批。11 月 9 日那批按建议升到 8.4.0 的，这周还得再升一次。

### Node.js：7 个 High，全在网络栈

22.23.5 / 24.22.3 / 26.13.1，7 条官方 High。最实用的两条是 8.2 和 8.1：HTTP/2 会话拆除时 `Http2Stream` 没有 detach，`~Http2Session()` 断言失败，未认证发个请求就能把进程打崩（CVE-2026-123863，只影响 24.x 和 26.x）；HTTPS 的 `TLSWrap::DoWrite()` 遇到零长度写直接 `ClearOut()`，可重入 `llhttp_execute()` 造成释放后使用和堆越界读（CVE-2026-123864）。

还有一条容易被忽略：TLS 1.2 重协商时客户端能单方面改 servername，把已有客户端证书认证带到策略更严的主机上（CVE-2026-123872，8.1）。做双向 TLS 的服务要重点看这条。

别停在 22.23.4 / 24.22.1 / 26.12.1，那是上一批 Brotli 的修复点，挡不住这批。

### Apache HTTP Server 2.4.71：mod_http2 那条官方自己标 critical

CVE-2026-119618 在 `mod_http2` 的 `assign_headers()` 里同步处理不当，能造成堆损坏，进而 RCE，影响 2.4.55 到 2.4.70。NVD 一开始没给分数，后来 CISA ADP 补了个 8.1，官方口径始终是 critical。另一条 CVE-2026-106023 是 `mod_md` 空指针解引用，子进程崩，影响 2.4.30 到 2.4.70。

`library/httpd` 的 `latest` 已经对齐 2.4.71。注意 Hub 上 2.4.70 还在，写死 tag 的 compose 文件不会自己动。

### Airflow 3.4.0：第一条最不像「漏洞」

四条 important。CVE-2026-68982 是 CeleryExecutor 执行 deadline-alert 回调时没校验工作负载的认证 token —— 任何能往 Celery broker 写消息的人，都能在每台 worker 上执行任意代码，不需要 Airflow 账号。如果 broker 的访问控制本来就不严，这条等价于远程代码执行。

另外三条：调度器会完整反序列化任务写入的 XCom（Dag 作者就能控制进调度器进程的数据）；Task SDK 的 SecretCache 用未转义的 `_` 拼接团队名和 secret id，多团队且开了缓存时能读到另一团队的 Variable 或 Connection；Connections API 没屏蔽 apprise provider 的 `config` 字段，有连接读取权限的人能拿到明文。

3.3.2 仍然受影响。

---

## 网关、注册中心和运行时

### runc：只有做 checkpoint/restore 才中

CVE-2026-119101，顾问给 7.9。恶意镜像可以在 rootfs 的符号链接目标里塞入 `]:`，让以宿主 root 运行的 `runc restore` 把配置里从没写过的宿主机路径以读写方式 bind 进恢复后的容器。这个问题从 runc 1.1.0 起就存在。

两个前提要说清楚：rootless runc 不受影响；只做 checkpoint、不做 restore 也不受影响。占住其中一条，可以按正常节奏排期；一条都不占的，赶紧升。

修到 1.3.7 / 1.4.4 / 1.5.3，1.6 预发布线是 1.6.0-rc.2。官方没有对应的镜像仓库，得从发行版包或引擎自带的 runc 升。同根因的还有 crun 的 CVE-2026-115520，根因在 CRIU 一侧，CRIU 4.3.1 也修了。截至 11 月 15 日 NVD 还没收录这条，但顾问和修复版本都已经公开。

### Traefik v3.7.18 / v2.11.62

三条 High。7.0 那条是 ForwardAuth 的 NTLM 认证能被 `Proxy-Authorization` 绕过，是对上一个补丁的不完整修复；8.7 那条更省事——Compress 中间件给每个在途响应固定约 18 MiB 的 zstd 编码器状态，未认证就能把内存吃光；还有一条 7.0 是 ingress-nginx 风格的客户端证书认证（`auth-tls-secret`）能被绕过，只影响 v3.7.15 到 v3.7.17。

v3.0 到 v3.6 已经停止支持，没有补丁，只能靠升级。另外 Hub 上的 `traefik/traefik` 是非官方镜像，tag 基本是 `experimental-*`，请用 `library/traefik`。

### Apache APISIX 3.20.0

两条 High。7.8 那条出在 jwe-decrypt：当 `strict: false` 且 `forward_header` 与 token 头不一致时，未认证客户端能向下游提交被当成「网关已解密明文」的身份头。7.0 那条是路由级认证绕过：同一个 upstream 上如果还有一条不认证的路由，未认证客户端能打到本应由认证插件保护的上游路径。

官方没有裸 `3.20.0` 标签，要用 `3.20.0-ubuntu`、`3.20.0-debian` 或 `3.20.0-redhat`。

### Kong Gateway Enterprise：9 条 High

最高 8.7。Admin API 的 RBAC 能被委派管理员通过百分号编码的角色名提权；LLM 用量计数处有 SQL 注入；几个缓存插件在键的设计上漏了维度——proxy-cache 的键不含请求主机名，graphql-proxy-cache 的键不含调用者身份，request-callout 漏了客户端没发的 callout 头，还有一条是把带 `Authorization` 的请求所缓存的响应给了别的调用者。

CNA 只把 Enterprise 和部分 AI Gateway 列为受影响产品，开源 Kong 不在名单里。按所在分支升到 3.16.0.2 / 3.15.0.7 / 3.14.0.17 / 3.13.0.12 / 3.10.0.20。

### MongoDB：Critical 那条只打副本集

Critical 那条（9.0）是副本集新主节点 catch-up 过程中的预认证释放后使用，独立 mongod 不受影响。另外 6 条 High 里，最省事的是「无凭据网络方可耗尽副本集节点内存」（7.5）——不需要任何账号，把节点内存打光就行。

修到 9.0.7 / 8.3.16 / 8.0.37 / 7.0.48。`mongodb/mongodb-community-server` 已经推了 9.0.8，可以直接用；但 `library/mongo` 在 11 月 11 日核的时候，浮动标签还停在 10 月 27 日的清单上。

### Grafana：三条 7.1，都跟权限边界有关

几个互相独立的实例如果共用同一个 `[rendering] renderer_token`，一个实例签发的 image renderer 密钥会被其他实例接受（13.0 起 `renderAuthJWT` 默认开启）。文件夹的 Editor 能通过 folders resource API 把文件夹挪到自己名下，从而变成 Admin —— 这条只有 12.4.15 的发行说明写了修复。Viewer 和 Editor 能通过 repository files API 绕过 Git Sync 资源的文件夹权限，这条在 13.x 修。

13 线升到 13.3.1 / 13.2.6 / 13.1.10 / 13.0.13，12 线升到 12.4.15。别把 `grafana/grafana-oss` 当成已修镜像，它的 `latest` 还停在 6 月的 13.0.2。

---

## 七个镜像，这周等不到补丁

这些到 11 月 15 日 13:00 仍然没有官方修复版本。能做的只有收缩暴露面、轮换凭据、加监控。

**Keycloak（CVE-2026-120984，9.1）** —— 有 manage-clients 权限的已认证用户，可以在创建或导入启用了 authorization services 的 client 时导入带 inline JavaScript 的 policy，随后在授权请求时于服务端执行，还可能突破 realm 边界。26.8.2 和 `latest` 是同一个 digest，不能当成已修。

**BusyBox（4 条，7.5 到 7.6）** —— wget 走 FTP 续传时，用服务器返回的 `SIZE` 减去续传偏移且不校验，长度可能变成负数，随后当 `fread()` 长度写进堆缓冲；TFTP 客户端请求了小 blksize、服务器不确认而回退 512 时没有重新分配缓冲；httpd 处理子目录的 `I:` 索引页规则时，过长的索引页名会栈溢出（前提是攻击者能写该子目录的 `httpd.conf`）；udhcpc6 把恶意 DHCPv6 服务器给的选项拷进栈缓冲时没校验长度。官方 1.38.0 就带着这些逻辑。

**SurveyKing（7.5 / 7.1）** —— 匿名问卷视图会泄露 lookup 配置（含密码），未提交答案时又跳过 lookup 密码校验；往 MyBatis 的 LIKE 条件里注入 `%` 就能匹配全部答卷，再用 `loadProject` 加 `answerId` 读出含隐藏字段的完整答卷。另一条是联动问卷不校验 `linkSurveyId` 是否属于调用者自己的项目。Hub 最新就是受影响的 v1.13.2，上游 issue #92 还开着。

**Flowise（8.5）** —— 有 chatflows 或 agentflows 编辑权限的用户，在允许名单包里要求子路径模块（比如 `axios/dist/node/axios.cjs`），就能拿到未被包裹的 HTTP 客户端，跳过 `checkDenyList`，去打回环、内网和云元数据。最新正式版还是 3.1.4。

**Dinky（7.3）** —— `sql-gateway` 的 `connectAddress` 处理不当，SSRF，影响至 1.2.5。

**LimeSurvey 的 SQL 注入（7.1）** —— 7.8.0 在问卷档案导入和 SPSS 答卷导出流程里，把持久化的列名当 SQL 表达式执行。官方只说受影响版本是 7.8.0，同时写明尚无补丁，所以别把已经推出的 7.9.x 当成修好了。同产品另一条存储型 XSS（7.4）是真修了，7.9.0+261029 起。

**SiYuan（3 条，7.4 到 7.7）** —— 官方顾问在 Affected 一节写的是「未能确定补丁版本」，NVD 描述写的是 3.8.9 之前。两边不一致，我不替官方下结论：`latest` 的 v3.8.10 不能算官方确认修复。

顺手提一句 DataEase：它有补丁（2.x 升 2.10.28，3.x 升 3.2.0），但漏洞利用已经公开，而且官方 OCI 镜像在阿里云 `registry.cn-qingdao.aliyuncs.com/dataease/dataease`，Docker Hub 上没有官方同名仓库。

---

## 你拉下来的 latest，可能还是旧的那份

这周有一条漏洞本身就是讲这件事的。FrankenPHP 的 CVE-2026-128027 拿了个 9.8，内容不是代码缺陷，而是它的 Docker 镜像在 1.1.11 之前只在基础镜像出新 tag 时才重建 —— Alpine、PHP、Go 在「同一个 tag 名」下推送的安全修复，进不到已经有镜像里。项目方自己把它当漏洞发了。

这不是 FrankenPHP 一家的毛病。本地镜像不会因为上游重推同一个 tag 就自动更新，`docker compose up` 也不会替你重新拉。

这周核到四个具体的：

- `bitnami/postgresql` 的 `latest` 停在 2026-11-11 07:33，18.7 / 17.12 / 16.16 / 15.20 / 14.25 精确 tag 全部 404。
- `library/mongo` 的浮动标签在 11 月 11 日核的时候还停在 10 月 27 日，没有 9.0.7 这一级的补丁 tag。
- `grafana/grafana-oss` 的 `latest` 停在 6 月 2 日的 13.0.2，没有 13.3.1 的修复 tag。
- `linuxserver/openssh-server` 的 `latest` 是 `version-10.3_p1-r2`，低于 10.6p2，挡不住上面那条 KEV。

还有两个跟 tag 写法有关的坑：`apache/apisix` 没有裸 `3.20.0`，只有带发行版后缀的；`bitnami/apisix` 在 Hub 上已经是空的，转成商业制品了，照着旧文档拉会直接失败。

---

## 怎么确认自己是哪一份

先拉明确版本，别用 `latest`：

```bash
docker pull docker.xuanyuan.run/library/postgres:18.7
```

再看本地这份是哪天构建的、对应哪个 digest：

```bash
docker image inspect docker.xuanyuan.run/library/postgres:18.7 --format '{{.Created}} {{index .RepoDigests 0}}'
```

Compose 起服务前记得先 `docker compose pull`，别只 `up -d`。Kubernetes 里把 `imagePullPolicy` 设成 `Always`，或者干脆把镜像钉到 digest——版本号会骗人，digest 不会。

---

## 本周涉及镜像与最低安全版本

| 镜像 | 本周涉及 | 最低安全版本 |
|------|----------|--------------|
| `library/postgres` — [轩辕镜像](https://xuanyuan.cloud/r/library/postgres) | 52 条，High×38 | 18.7 / 17.12 / 16.16 / 15.20 / 14.25 |
| `bitnami/postgresql` — [轩辕镜像](https://xuanyuan.cloud/r/bitnami/postgresql) | 同上，未跟进修复 | 暂时改用 `library/postgres` |
| `openemr/openemr` — [轩辕镜像](https://xuanyuan.cloud/r/openemr/openemr) | 两批，Critical×10 | 8.5.0 |
| `library/httpd` — [轩辕镜像](https://xuanyuan.cloud/r/library/httpd) | mod_http2 堆损坏、mod_md 崩溃 | 2.4.71 |
| `library/node` — [轩辕镜像](https://xuanyuan.cloud/r/library/node) | 11 月批次 High×7 | 22.23.5 / 24.22.3 / 26.13.1 |
| `apache/airflow` — [轩辕镜像](https://xuanyuan.cloud/r/apache/airflow) | important×4 | 3.4.0 |
| `library/golang` — [轩辕镜像](https://xuanyuan.cloud/r/library/golang) | 构建期代码执行等 12 项 | 1.27.4 / 1.26.11 |
| `library/mongo` — [轩辕镜像](https://xuanyuan.cloud/r/library/mongo) | 副本集 UAF 9.0 等 7 条 | 9.0.7 / 8.3.16 / 8.0.37 / 7.0.48 |
| `mongodb/mongodb-community-server` — [轩辕镜像](https://xuanyuan.cloud/r/mongodb/mongodb-community-server) | 同上 | 9.0.8-ubuntu2204 |
| `gpustack/gpustack` — [轩辕镜像](https://xuanyuan.cloud/r/gpustack/gpustack) | 9.8 进 KEV，另加 2.3.1 批次 | 2.3.1 |
| `safarov/freeswitch` — [轩辕镜像](https://xuanyuan.cloud/r/safarov/freeswitch) | 9.8 进 KEV | 1.11.3 |
| `library/alpine` — [轩辕镜像](https://xuanyuan.cloud/r/library/alpine) | OpenSSH 密码认证绕过 | 3.24.4（或 3.23.8 / 3.22.8 / 3.21.10） |
| `linuxserver/openssh-server` — [轩辕镜像](https://xuanyuan.cloud/r/linuxserver/openssh-server) | 同上，镜像仍在 10.3 | 尚未跟进，暂换基础镜像 |
| `keycloak/keycloak` — [轩辕镜像](https://xuanyuan.cloud/r/keycloak/keycloak) | Critical 9.1 | 暂无 |
| `kong/kong-gateway` — [轩辕镜像](https://xuanyuan.cloud/r/kong/kong-gateway) | High×9，仅企业版 | 3.16.0.2 等，按分支选 |
| `grafana/grafana` — [轩辕镜像](https://xuanyuan.cloud/r/grafana/grafana) | High×3 | 13.3.1；12 线 12.4.15 |
| `grafana/grafana-enterprise` — [轩辕镜像](https://xuanyuan.cloud/r/grafana/grafana-enterprise) | 同上 | 同上 |
| `grafana/grafana-oss` — [轩辕镜像](https://xuanyuan.cloud/r/grafana/grafana-oss) | 同上，镜像停在 13.0.2 | 改用 `grafana/grafana` |
| `library/traefik` — [轩辕镜像](https://xuanyuan.cloud/r/library/traefik) | High×3 | v3.7.18 / v2.11.62 |
| `apache/apisix` — [轩辕镜像](https://xuanyuan.cloud/r/apache/apisix) | High×2 | 3.20.0-ubuntu |
| `library/busybox` — [轩辕镜像](https://xuanyuan.cloud/r/library/busybox) | High×4 | 暂无 |
| `n8nio/n8n` — [轩辕镜像](https://xuanyuan.cloud/r/n8nio/n8n) | 角色接管 1 条 + High×2 | 2.47.6 / 2.48.3 / 3.2.2 |
| `nocodb/nocodb` — [轩辕镜像](https://xuanyuan.cloud/r/nocodb/nocodb) | High×12 | 2026.09.0 |
| `dunglas/frankenphp` — [轩辕镜像](https://xuanyuan.cloud/r/dunglas/frankenphp) | Critical 9.8 + High×2 | 1.13.5 |
| `directus/directus` — [轩辕镜像](https://xuanyuan.cloud/r/directus/directus) | WebSocket 公开模式越权 | 12.1.0 |
| `jellyfin/jellyfin` — [轩辕镜像](https://xuanyuan.cloud/r/jellyfin/jellyfin) | 资料库路径穿越 | 12.0 |
| `linuxserver/jellyfin` — [轩辕镜像](https://xuanyuan.cloud/r/linuxserver/jellyfin) | 同上 | 12.4 |
| `vikunja/vikunja` — [轩辕镜像](https://xuanyuan.cloud/r/vikunja/vikunja) | High×3 | 2.7.1 |
| `langflowai/langflow` — [轩辕镜像](https://xuanyuan.cloud/r/langflowai/langflow) | 本地文件隔离绕过 | 1.12.3 起，建议 ≥ 1.12.10 |
| `owasp/modsecurity-crs` — [轩辕镜像](https://xuanyuan.cloud/r/owasp/modsecurity-crs) | XML 属性绕过约 159 条规则 | 4.28.0 |
| `martialblog/limesurvey` — [轩辕镜像](https://xuanyuan.cloud/r/martialblog/limesurvey) | XSS 已修；SQL 注入无补丁 | 7.9.1-261102，SQL 注入除外 |
| `surveyking/surveyking` — [轩辕镜像](https://xuanyuan.cloud/r/surveyking/surveyking) | High×2 | 暂无 |
| `flowiseai/flowise` — [轩辕镜像](https://xuanyuan.cloud/r/flowiseai/flowise) | SSRF 沙箱绕过 | 暂无 |
| `b3log/siyuan` — [轩辕镜像](https://xuanyuan.cloud/r/b3log/siyuan) | High×3 | 官方未确认 |
| `teableio/teable` — [轩辕镜像](https://xuanyuan.cloud/r/teableio/teable) | 附件自选 Content-Type 存储 XSS | release.2026-10-12T12-45-53Z.3331 |
| `magiccoders/nginxpulse` — [轩辕镜像](https://xuanyuan.cloud/r/magiccoders/nginxpulse) | 未认证 SQL 注入 9.8 | 1.6.26 |
| `dinkydocker/dinky-standalone-server` — [轩辕镜像](https://xuanyuan.cloud/r/dinkydocker/dinky-standalone-server) | SSRF | 暂无 |

---

## 参考链接

- PostgreSQL 安全更新：[18.7 / 17.12 / 16.16 / 15.20 / 14.25](https://www.postgresql.org/about/news/postgresql-187-1712-1616-1520-1425-and-19-rc-2-released-3442/)
- OpenEMR 8.5.0 发行说明：[v8_5_0](https://github.com/openemr/openemr/releases/tag/v8_5_0)
- Node.js 2026 年 11 月 11 日安全发布：[官方通告](https://nodejs.org/en/blog/vulnerability/november-2026-security-releases)
- Apache HTTP Server 漏洞表：[vulnerabilities_24](https://httpd.apache.org/security/vulnerabilities_24.html)
- Apache Airflow 3.4.0：[发行说明](https://github.com/apache/airflow/releases/tag/3.4.0)
- runc 顾问：[GHSA-g2c3-j8g3-7gpw](https://github.com/opencontainers/runc/security/advisories/GHSA-g2c3-j8g3-7gpw)
- Traefik v3.7.18：[Release](https://github.com/traefik/traefik/releases/tag/v3.7.18)
- GPUStack v2.3.1：[Release](https://github.com/gpustack/gpustack/releases/tag/v2.3.1)
- CISA 已知被利用漏洞目录：[KEV Catalog](https://www.cisa.gov/known-exploited-vulnerabilities-catalog)
- 本周完整巡检记录：`report-2026-11-08` 至 `report-2026-11-15` 共 30 份正式档

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/container-security-weekly-2026-11-15-security-advisory)

---

**轩辕镜像安全团队**
2026 年 11 月 15 日



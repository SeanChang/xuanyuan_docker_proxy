# OpenClaw 3.23：术后修复完成——Qwen DashScope 全球端点支持、Auth 凭证系统大修及40+稳定性修复

![OpenClaw 3.23：术后修复完成——Qwen DashScope 全球端点支持、Auth 凭证系统大修及40+稳定性修复](https://openclaw.ai/blog/openclaw-logo-text.png)

*分类: OpenClaw,AI,部署教程 | 标签: OpenClaw,AI,部署教程,飞书,钉钉,QQ | 发布时间: 2026-03-25 06:09:15*

> 3.22版本曾推翻旧架构、重建底层基座：12项不兼容更新（Breaking Changes）、全新插件注册中心、30个安全补丁，这既是OpenClaw历史上规模最大的版本发布，也是问题暴露最多的一次。

3.22版本曾推翻旧架构、重建底层基座：12项不兼容更新（Breaking Changes）、全新插件注册中心、30个安全补丁，这既是OpenClaw历史上规模最大的版本发布，也是问题暴露最多的一次。

而3.23的任务十分明确：确保这个“刚下手术台”的系统平稳恢复。本次仅包含3项不兼容更新，且均为前瞻性优化；40余项修复，绝大部分用于解决3.22版本遗留的各类问题。两个版本间隔仅一天——因为有些故障根本等不起。

## 不兼容更新（Breaking Changes）：仅3项，无功能删除

本次的3项不兼容更新，没有一项是删除你当前正在使用的功能，全部为体验和兼容性优化。

### Qwen 接入 DashScope 标准端点，支持全球API Key

Qwen供应商现已新增DashScope标准（按量计费）端点，支持中国及全球区域的API Key，与原有Coding Plan端点并行可用。同时，供应商组已重命名为「Qwen (Alibaba Cloud Model Studio)」。

这一更新的核心价值的在于：此前Qwen集成仅支持Coding Plan密钥——这只是阿里云产品线的一个子集。如果你在国内使用标准计费的DashScope API Key，或是需要用到全球Key，现在无需再编写各种绕路配置，开箱即用即可。

### Control UI 界面整合优化

本次对Control UI界面进行了全面整合：合并按钮基元（btn--icon、btn--ghost、btn--xs）；将Knot主题调整为黑红配色，对比度达到WCAG 2.1 AA级标准（网页内容无障碍指南）；为配置页各模块（Diagnostics、CLI、Secrets、ACP、MCP）添加专属图标；将圆角滑块改为离散档位；全局新增aria-labels标签，进一步完善无障碍支持。

温馨提示：若你的自定义CSS依赖旧版按钮类名或Knot主题变量，请检查并调整相关覆写配置。

### CSP 脚本哈希优化

index.html中的内联<script>代码块，如今会计算SHA-256哈希值，并写入CSP script-src指令。内联脚本默认仍处于阻止状态，仅通过哈希校验的引导代码可正常放行。

注意：若你此前曾向Control UI中注入自定义内联脚本，现在会被拦截，需为该脚本添加对应哈希值方可正常使用。

## Auth 凭证系统大修：8项核心修复，解决3.22重灾区问题

本次更新将8项修复集中于Auth认证及凭证系统——这是3.22版本故障最集中、问题最严重的模块。修复过程本身也印证了一个教训：在运行中的系统底层重建基础设施，极易引发各类连锁问题。

**核心修复1：网关auth-profile实时写入异常**
此前，网关（gateway）的auth-profile实时写入功能，会将刚保存的凭证偷偷还原为内存中的旧值——比如你粘贴新的OpenAI token并保存后，会眼睁睁看着它自动变回过期的旧token。Configure流程、Onboard流程、粘贴token流程均受此影响，且根因一致，目前该问题已彻底修复。

**核心修复2：Operator scope保留异常**
设备auth旁路路径曾静默丢弃operator scope，导致operator会话失败，或在需要read权限的页面直接白屏。现在系统会忽略缓存的低权限token，若确实缺少read scope，会显示明确的回退提示，避免无意义白屏。

**核心修复3：CLI渠道认证优化**
单渠道配置现在可自动选择唯一可用的登录渠道；对Channel ID进行原型链及控制字符注入加固；按需渠道安装可干净回退至基于catalog的安装方式，避免安装失败。

**核心修复4：ClawHub macOS认证（3项关联修复）**
ClawHub登录token现已支持从macOS Application Support路径读取，同时兼容XDG config路径作为备用；网关的skill浏览功能会使用已登录的auth状态，不再偷偷回退至未认证模式；将browse-all请求切换为search方式，避免触发未认证状态下的429限流。

**核心修复5：OAuth代理支持完善**
通过env配置的HTTP/HTTPS proxy dispatcher，现在会在token交换和preflight请求前完成初始化，使得需要代理的环境也能正常完成MiniMax和OpenAI Codex的登录流程。此前，代理环境下Codex OAuth token过期后，用户会被直接锁定在外，无法正常登录。

**核心修复6：斜杠命令授权异常**
当渠道allowFrom解析命中未解析的SecretRef账户时，授权功能不再崩溃或丢弃整个有效白名单，仅对受影响的模型推理路径执行fail closed（关闭失败路径），不影响其他功能正常使用。

## 浏览器稳定性：别急着宣告胜利，先等浏览器真正就绪

本次针对浏览器稳定性的2项修复，核心思路一致：在浏览器未真正就绪前，不急于判定其状态，避免因短暂延迟误判为故障。

**macOS Chrome连接修复**
通过MCP附加到已有Chrome会话时，系统曾将初始握手直接判定为“就绪”，但此时浏览器标签页实际尚未可用。这导致macOS上频繁出现用户配置文件超时、授权确认反复弹出的问题。修复后，系统会等待attach完成后，确认标签页真正可用再继续执行后续流程。

**无头Linux CDP修复**
在性能较慢的无头Linux环境中，CDP检测时若出现短暂的可达性失败，系统会立即触发浏览器完整重启，导致二次启动/打开浏览器的回归问题。修复后，短暂可达性失败时会复用已运行的回环浏览器，不再急于执行重启检测流程。

这两个bug的共性的在于：系统对状态变化的判定过于急躁，将短暂的响应延迟误判为失败，进而触发高代价的恢复流程，反而导致问题加剧。

## 插件生态：ClawHub迁移收尾，解决遗留问题

3.22版本已将插件生态迁移至ClawHub，3.23版本则重点完成迁移收尾工作，解决各类遗留兼容问题：

- 打包的运行时sidecar回归：WhatsApp light-runtime-api.js、Matrix runtime-api.js等插件运行时入口文件，此前从npm包中遗漏，导致全局安装时直接报文件缺失，现已修复。

- ClawHub安装兼容性优化：插件API兼容性检查 now 基于安装时的活跃运行时版本；此前导致≥2026.3.22版本ClawHub包安装卡住的陈旧1.2.0常量，已替换为回归覆盖，安装流程恢复正常。

- 恢复ClawHub格式卸载支持：openclaw plugins uninstall clawhub:<package> 命令恢复正常使用，即便记录的安装已锁定版本号。

- LanceDB首次使用自动引导：memory-lancedb插件现在会在bundled npm install未安装LanceDB时自动引导，plugins.slots.memory="memory-lancedb"在全局安装后可正常工作。

- 陈旧配置不再致命：未知的plugins.allow ID now 视为警告而非致命错误，plugins install、doctor --fix、status命令在插件本地缺失时仍可正常运行，无需因配置问题阻断操作。

- Doctor清理优化：openclaw doctor --fix命令会清除插件卸载后残留的plugins.allow和plugins.entries引用，且不再将whatsapp等内置渠道ID追加到plugins.allow中。

- Matrix和LINE运行时修复：解决Jiti下重复的runtime-api导出导致Matrix打包安装启动崩溃的问题；LINE在star export前预导出重叠的运行时符号，避免出现TypeError: Cannot redefine property错误。

## Agent 可靠性提升：6项修复，让行为更可预测

通过6项针对性修复，优化Agent运行逻辑，减少异常行为，提升可靠性：

- web_search provider优化：Agent轮次 now 使用活跃运行时的web_search provider，而非陈旧的默认选择——你配置的特定搜索供应商，现在能真正生效。

- Failover分类优化：仅当generic api_error包含瞬态失败信号时，才视为可重试；MiniMax风格的后端故障仍会触发模型降级，但计费、认证、格式错误不再触发重试，避免无效重试浪费资源。

- 子代理超时精度优化：超时的worker等待在发送完成事件前，会重新检查最新运行时快照，避免将已完成的worker错误报告为超时。

- Anthropic thinking blocks优化：转录图片脱敏过程中，保留assistant thinking和redacted-thinking block的顺序，防止后续轮次触发Anthropic的unmodified-thinking校验。

- Replay恢复优化：对畸形的assistant转录内容，在会话历史脱敏前进行规范化处理，避免遗留或损坏的轮次导致Pi replay和子代理恢复路径崩溃。

- Skill配置注入优化：内嵌的skill配置和环境变量使用活跃的已解析运行时快照，skills.entries.<skill>.apiKey SecretRef在内嵌启动时可正确解析，不再出现配置失效问题。

## Gateway 加固：4项修复，提升运行可靠性

针对网关（Gateway）的4项修复，重点解决探测误判、稳定性不足等问题，进一步加固运行安全：

- 探测精度优化：成功的gateway握手，不再因后续RPC加载缓慢而被误报为“不可达”；慢设备现在会正确报告“可达但RPC失败”，避免出现假阴性的“死亡网关”提示。

- Supervision稳定性优化：解决launchd和systemd下的锁冲突导致的crash-loop问题；重复进程会在重试等待中保持运行，不再在健康网关仍持有锁时退出并报错。

- Auth强制校验：canvas路由 now 要求强制认证，agent session reset操作要求admin scope权限；匿名的canvas访问和非admin权限的reset请求，均会执行fail closed，提升安全防护。

- OpenRouter定价优化：openrouter/auto的定价刷新不再在引导阶段出现无限递归，auto路由可正常填充缓存定价和usage.cost，避免定价异常。

## 频道修复：多渠道异常问题解决

**Telegram（3项修复）**：主线程元数据缺失时，DM topic的线程上下文可正确填充；同聊天的入站消息防抖顺序得以保留，避免过时的忙碌会话导致后续消息卡住；新增asDocument作为forceDocument的用户侧别名，支持图片和GIF按文档形式发送。

**Discord**：权限不足时，原生斜杠命令会返回明确的未授权回复，不再穿透到Discord自带的误导性通用完成提示，提升用户体验。

**Plivo 语音**：对replay key进行稳定化处理，解决webhook重试和重放保护在有效后续投递上产生的冲突，避免语音服务异常。

此外，外部渠道目录 now 可覆盖出厂的fallback元数据，且在渠道安装时尊重覆写的npm包规格，自定义目录不再在channel ID匹配时回退到内置包，提升自定义灵活性。

## 其他修复：细节优化，完善体验

- Mistral：将打包的max-token默认值下调至安全的输出预算；openclaw doctor --fix命令可修复带有context-sized output limit的旧持久化配置，避免出现确定性的422拒绝错误。

- CLI cron：openclaw cron add|edit --at ... --tz <iana> 命令 now 可正确处理无偏移量的一次性日期时间的本地时间，包括夏令时边界场景。

- 配置警告优化：同base的修正版本（如2026.3.23-2）写入的配置，被2026.3.23版本读取时，不再弹出误导性的“更新版OpenClaw”警告。

- Exec trust：shell-multiplexer wrapper二进制文件在策略检查中得以保留，不影响已批准命令的重建，BusyBox/ToyBox的白名单和审计流程保持一致。

- 安全/exec审批：shell-wrapper白名单匹配拒绝单引号的$0/$n token，禁止换行分隔的exec，但仍支持exec -- carrier形式，兼顾安全与兼容性。

- 缓存诊断：cache-trace JSONL输出中的凭证字段已脱敏，同时保留非敏感诊断字段和图片脱敏元数据，兼顾诊断需求与数据安全。

- 飞书文档：渠道配置示例中，将botName改为name，与严格的account schema保持对齐，避免配置报错。

- 发布打包：打包的插件和Control UI资源会保留在发布的npm安装包中，发布检查会在出厂资源缺失时及时报错，避免安装后功能缺失。

## 贡献者致谢

本次3.23版本的修复工作，由16位贡献者共同完成。特别感谢@vincentkoc，一人提交了14项修复，覆盖浏览器、Gateway、Agent、插件、安全及发布基础设施等多个模块——这种全方位的贡献，是大版本发布后项目能够快速稳住的关键。

同时感谢以下贡献者（按提交修复数量排序）：@BunsDev（4项修复）、@scoootscooob、@openperf、@futhgar、@07akioni、@Drickon、@osolmaz、@bakhtiersizhaev、@Lukavyi、@ayushozha、@RolfHegr、@drobison00、@haroldfabla2-hue、@jzakirov 和 @sallyom。

## 升级建议

- Qwen用户：请检查你的供应商配置；若此前为使用标准DashScope Key编写过绕路配置，现在可直接切换至原生端点，无需再额外配置。

- Mistral用户：请运行openclaw doctor --fix命令，修复带有context-sized output limit的旧配置，避免出现422拒绝错误。

- 自定义CSS用户：Knot主题配色和按钮类名已更新，请检查并调整你的CSS覆写配置。

- Control UI脚本注入用户：内联脚本现在需要添加CSP SHA-256哈希值，否则会被拦截，需及时处理。

---

如果说3.22版本是“打开胸腔、更换发动机”的激进升级，那么3.23版本就是“细致缝合、稳固恢复”的务实修复。

40余项修复、8个Auth核心补丁、2个浏览器回归问题解决、插件生态在ClawHub迁移后彻底跑通——这不是一个光鲜亮丽的版本，但正是它，将3.22版本的架构野心，落地成了能真正在生产环境稳定运行的可用系统。

这只“龙虾”（OpenClaw）恢复状况良好，每一处“缝合”都已稳固。
> （注：文档部分内容可能由 AI 生成）


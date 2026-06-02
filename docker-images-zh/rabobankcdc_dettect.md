<!-- xuanyuan-docker-images-zh
image: rabobankcdc/dettect
source: https://xuanyuan.cloud/zh/r/rabobankcdc/dettect
canonical: https://xuanyuan.cloud/zh/r/rabobankcdc/dettect
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/rabobankcdc/dettect" title="rabobankcdc/dettect Docker 镜像中文简介、标签列表与拉取命令">rabobankcdc/dettect — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/rabobankcdc/dettect" title="rabobankcdc/dettect Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/rabobankcdc/dettect</a></p>

# DeTT&CT 镜像文档

## 镜像概述和主要用途
DeTT&CT（Detect Tactics, Techniques & Combat Threats）旨在协助蓝队利用MITRE ATT&CK框架，通过评估数据源质量、可见性覆盖、检测覆盖和威胁行为，提升组织抵御攻击的能力。该框架包含Python CLI工具（DeTT&CT CLI）、YAML管理文件、[DeTT&CT Editor](https://rabobank-cdc.github.io/dettect-editor)（用于创建和编辑YAML文件）及[评分表](https://github.com/rabobank-cdc/DeTTECT/raw/master/scoring_table.xlsx)（针对检测、数据源和可见性），适用于ATT&CK的企业、ICS和移动域。

## 核心功能和特性
### 主要功能
DeTT&CT为企业、ICS和移动ATT&CK域提供以下功能：
- **数据源管理与评分**：管理并评分数据源质量<sup>*</sup>，支持评估数据可靠性。
- **可见性洞察**：分析端点等目标的可见性覆盖情况。
- **检测覆盖映射**：映射组织当前的检测能力覆盖范围。
- **威胁行为映射**：关联并展示威胁行为与ATT&CK技术的对应关系。
- **对比分析**：比较可见性、检测覆盖和威胁行为，发现检测与可见性的改进空间，辅助蓝队工作优先级排序。
- **统计分析**：按平台获取各数据源覆盖技术数量的统计数据。

### 可视化支持
通过MITRE [ATT&CK™ Navigator](https://mitre-attack.github.io/attack-navigator/#comment_underline=false)生成彩色可视化结果。建议使用指定URL以避免图层文件元数据显示黄色下划线：[https://mitre-attack.github.io/attack-navigator/#comment_underline=false](https://mitre-attack.github.io/attack-navigator/#comment_underline=false)。

<sup>*</sup><small>ATT&CK尚未为移动域实现数据源，未来ATT&CK更新后将整合至DeTT&CT。</small>

## 使用场景和适用范围
- **蓝队安全能力评估**：评估现有数据源质量、可见性和检测能力，定位薄弱环节。
- **检测能力提升**：通过对比检测覆盖与威胁行为，优先改进高风险领域的检测措施。
- **威胁情报分析**：映射威胁行为，理解攻击者战术技术，增强针对性防御。
- **ICS与移动安全管理**：针对工业控制系统（ICS）和移动设备的ATT&CK域，提供专用评估能力。

## 框架组成与工具
### 核心组件
- **DeTT&CT CLI**：Python命令行工具，用于执行评估、生成报告和可视化图层。
- **YAML管理文件**：存储数据源、检测规则、威胁行为等配置信息。
- **DeTT&CT Editor**：网页编辑器，用于创建和编辑YAML文件，简化配置管理。
- **评分表**：Excel表格，用于量化评估数据源、检测和可见性的质量。

### 第三方工具：Dettectinator
Dettectinator是用于SOC自动化的Python库/命令行工具，可通过插件从SIEM或EDR读取检测规则，自动创建/更新DeTT&CT YAML文件，便于在ATT&CK Navigator中可视化检测覆盖。更多信息见[GitHub](https://github.com/siriussecurity/dettectinator/)。

## 作者和贡献
### 开发与维护
该项目由[Marcus Bakker](https://github.com/marcusbakker)（Twitter: [@Bakk3rM](https://twitter.com/Bakk3rM)）和[Ruben Bouman](https://github.com/rubinatorz)（Twitter: [@rubinatorz](https://twitter.com/rubinatorz/)）开发维护。欢迎通过GitHub Issue提问或贡献代码/建议。

### 赞助商
- **Rabobank**：支持核心功能开发。
- **Cyber Security Sharing & Analytics (CSSA)**：资助ATT&CK ICS域支持。
- **荷兰国家警察**：资助ATT&CK移动域支持。

### 灵感来源
功能受以下工作启发：
- Roberto Rodriguez关于数据源质量和ATT&CK技术评分的研究。
- [MITRE ATT&CK Mapping项目](https://github.com/siriussecurity/mitre-attack-mapping)。

## 许可证
[GPL-3.0](https://github.com/rabobank-cdc/DeTTECT/blob/master/LICENSE)（GNU General Public License v3.0）

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/rabobankcdc/dettect" title="rabobankcdc/dettect Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/rabobankcdc/dettect</a></p>

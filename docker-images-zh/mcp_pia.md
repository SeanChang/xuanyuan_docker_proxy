<!-- xuanyuan-docker-images-zh
image: mcp/pia
source: https://xuanyuan.cloud/zh/r/mcp/pia
canonical: https://xuanyuan.cloud/zh/r/mcp/pia
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/mcp/pia" title="mcp/pia Docker 镜像中文简介、标签列表与拉取命令">mcp/pia — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/mcp/pia" title="mcp/pia Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mcp/pia</a></p>

# Program Integrity Alliance MCP服务器

一个MCP服务器，用于帮助美国政府开放数据集实现AI友好化。

[什么是MCP服务器？](https://www.anthropic.com/news/model-context-protocol)

## MCP信息
| 属性 | 详情 |
|-|-|
**Docker镜像** | [mcp/pia](https://hub.docker.com/repository/docker/mcp/pia)
**作者** | [Program-Integrity-Alliance](https://github.com/Program-Integrity-Alliance)
**代码仓库** | https://github.com/Program-Integrity-Alliance/pia-mcp-local

## 镜像构建信息
| 属性 | 详情 |
|-|-|
**Dockerfile** | https://github.com/Program-Integrity-Alliance/pia-mcp-local/blob/main/Dockerfile
**Docker镜像构建者** | Docker Inc.
**Docker Scout健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/pia)
**验证签名** | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/pia --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub`
**许可证** | MIT License

## 可用工具 (11个)
| 本服务器提供的工具 | 简短描述 |
|-|-|
`fetch` | 使用唯一标识符从PIA数据库检索特定文档的完整内容。
`pia_search_content` | 搜索Program Integrity Alliance (PIA)数据库以获取文档内容和推荐。
`pia_search_content_congress` | 搜索PIA数据库以获取Congress.gov文档内容和推荐。
`pia_search_content_crs` | 搜索PIA数据库以获取CRS文档内容和推荐。
`pia_search_content_doj` | 搜索PIA数据库以获取司法部文档内容和推荐。
`pia_search_content_facets` | 获取PIA数据库内容搜索的可用分面（筛选值）。
`pia_search_content_gao` | 搜索PIA数据库以获取GAO文档内容和推荐。
`pia_search_content_oig` | 搜索PIA数据库以获取OIG文档内容和推荐。
`pia_search_titles` | 仅搜索PIA数据库中的文档标题。
`pia_search_titles_facets` | 获取PIA数据库标题搜索的可用分面（筛选值）。
`search` | 搜索PIA数据库并返回潜在相关的搜索结果列表，包括标题、片段和引用URL。

---
## 工具详情

#### 工具：**`fetch`**
使用唯一标识符从PIA数据库检索特定文档的完整内容。此端点是OpenAI MCP规范中支持ChatGPT连接器的端点之一。

| 参数 | 类型 | 描述 |
|-|-|-|
`id` | `string` | 要检索的文档的唯一标识符

---
#### 工具：**`pia_search_content`**
搜索Program Integrity Alliance (PIA)数据库以获取文档内容和推荐。返回包含完整引用信息和可点击链接的综合结果，以便正确归因。每个结果都包含带有数据源归因的相应引用。主要数据源包括：司法部（198k+文档）、Congress.gov（29k+文档）、Oversight.gov（22k+文档）、CRS（22k+文档）、GAO（10k+文档）。支持带有布尔逻辑、运算符和分组的复杂OData筛选。

| 参数 | 类型 | 描述 |
|-|-|-|
`query` | `string` | 搜索查询文本
`filter` | `string` *可选* | 支持复杂布尔逻辑的可选OData筛选表达式。

**可用字段：**
• SourceDocumentDataSource：发布文档的数据源/机构。主要来源（>1k文档）：'Department of Justice'、'Congress.gov'、'Oversight.gov'、'CRS'、'GAO'、'Federal Register'
• SourceDocumentDataSet：文档所属的数据集或集合。值：'press-releases'、'reports'、'bills-and-laws'、'federal-reports'、'executive orders'、'state-and-local-reports'、'federal reports'
• SourceDocumentOrg：与文档关联的组织。有许多值，使用pia_search_content_facets工具查看可用选项
• SourceDocumentTitle：文档标题 - 使用contains、eq进行文本匹配
• SourceDocumentPublishDate：发布日期 - ISO 8601格式YYYY-MM-DD（例如，'2023-01-01'）。使用ge/le进行范围查询
• RecStatus：推荐状态
• RecPriorityFlag：推荐的优先级标志
• IsIntegrityRelated：内容是否与完整性相关
• SourceDocumentIsRecDoc：文档是否包含推荐。值：'No'、'Yes'
• RecFraudRiskManagementThemePIA：欺诈风险管理主题分类
• RecMatterForCongressPIA：事项是否需要国会关注
• RecRecommendation：推荐文本 - 使用contains、eq进行文本匹配
• RecAgencyComments：机构对推荐的评论 - 使用contains、eq进行文本匹配

**运算符：**
• 文本：contains、eq、ne、startswith、endswith
• 精确匹配：eq（等于）、ne（不等于）、in（在列表中）
• 日期：ge（大于等于）、le（小于等于）、eq（等于）
• 逻辑：and、or、not、括号分组

**示例：**
• "SourceDocumentDataSource eq 'GAO'"
• "SourceDocumentDataSource eq 'GAO' and RecStatus ne 'Closed'"
• "IsIntegrityRelated eq 'True' and RecPriorityFlag eq 'Yes'"
• "(SourceDocumentDataSource eq 'GAO' or SourceDocumentDataSource eq 'OIG') and RecStatus eq 'Open'"
• "SourceDocumentPublishDate ge '2020-01-01' and SourceDocumentPublishDate le '2024-12-31'"

**提示：** 使用pia_search_content_facets工具获取最新可用值。

`include_facets` | `boolean` *可选* | 在结果中包含分面
`limit` | `integer` *可选* | 最大结果限制
`page` | `integer` *可选* | 页码（默认：1）
`page_size` | `integer` *可选* | 每页结果数（默认：10）
`search_mode` | `string` *可选* | 搜索模式（默认：content）

---
#### 工具：**`pia_search_content_congress`**
搜索Program Integrity Alliance (PIA)数据库以获取Congress.gov文档内容和推荐。此工具自动筛选结果，仅包含来自Congress.gov的文档。返回包含完整引用信息和可点击链接的综合结果，以便正确归因。每个结果都包含带有数据源归因的相应引用。支持带有布尔逻辑、运算符和分组的复杂OData筛选。

| 参数 | 类型 | 描述 |
|-|-|-|
`query` | `string` | 搜索查询文本
`filter` | `string` *可选* | 支持复杂布尔逻辑的可选OData筛选表达式。

**可用字段：**
• 注意：此工具的SourceDocumentDataSource自动设置为'Congress.gov'。主要来源（>1k文档）：'Department of Justice'、'Congress.gov'、'Oversight.gov'、'CRS'、'GAO'、'Federal Register'
• SourceDocumentDataSet：文档所属的数据集或集合。值：'press-releases'、'reports'、'bills-and-laws'、'federal-reports'、'executive orders'、'state-and-local-reports'、'federal reports'
• SourceDocumentOrg：与文档关联的组织。有许多值，使用pia_search_content_facets工具查看可用选项
• SourceDocumentTitle：文档标题 - 使用contains、eq进行文本匹配
• SourceDocumentPublishDate：发布日期 - ISO 8601格式YYYY-MM-DD（例如，'2023-01-01'）。使用ge/le进行范围查询
• RecStatus：推荐状态
• RecPriorityFlag：推荐的优先级标志
• IsIntegrityRelated：内容是否与完整性相关
• SourceDocumentIsRecDoc：文档是否包含推荐。值：'No'、'Yes'
• RecFraudRiskManagementThemePIA：欺诈风险管理主题分类
• RecMatterForCongressPIA：事项是否需要国会关注
• RecRecommendation：推荐文本 - 使用contains、eq进行文本匹配
• RecAgencyComments：机构对推荐的评论 - 使用contains、eq进行文本匹配

**运算符：**
• 文本：contains、eq、ne、startswith、endswith
• 精确匹配：eq（等于）、ne（不等于）、in（在列表中）
• 日期：ge（大于等于）、le（小于等于）、eq（等于）
• 逻辑：and、or、not、括号分组

**示例：**
• "RecStatus eq 'Open'"
• "RecStatus ne 'Closed' and RecPriorityFlag eq 'Yes'"
• "IsIntegrityRelated eq 'True' and RecPriorityFlag eq 'Yes'"
• "(RecStatus eq 'Open' and RecPriorityFlag eq 'Yes')"
• "SourceDocumentPublishDate ge '2020-01-01' and SourceDocumentPublishDate le '2024-12-31'"

**提示：** 使用pia_search_content_facets工具获取最新可用值。
`include_facets` | `boolean` *可选* | 在结果中包含分面
`limit` | `integer` *可选* | 最大结果限制
`page` | `integer` *可选* | 页码（默认：1）
`page_size` | `integer` *可选* | 每页结果数（默认：10）
`search_mode` | `string` *可选* | 搜索模式（默认：content）

---
#### 工具：**`pia_search_content_crs`**
搜索Program Integrity Alliance (PIA)数据库以获取CRS文档内容和推荐。此工具自动筛选结果，仅包含来自国会研究服务处（CRS）的文档。返回包含完整引用信息和可点击链接的综合结果，以便正确归因。每个结果都包含带有数据源归因的相应引用。支持带有布尔逻辑、运算符和分组的复杂OData筛选。

| 参数 | 类型 | 描述 |
|-|-|-|
`query` | `string` | 搜索查询文本
`filter` | `string` *可选* | 支持复杂布尔逻辑的可选OData筛选表达式。

**可用字段：**
• 注意：此工具的SourceDocumentDataSource自动设置为'CRS'。主要来源（>1k文档）：'Department of Justice'、'Congress.gov'、'Oversight.gov'、'CRS'、'GAO'、'Federal Register'
• SourceDocumentDataSet：文档所属的数据集或集合。值：'press-releases'、'reports'、'bills-and-laws'、'federal-reports'、'executive orders'、'state-and-local-reports'、'federal reports'
• SourceDocumentOrg：与文档关联的组织。有许多值，使用pia_search_content_facets工具查看可用选项
• SourceDocumentTitle：文档标题 - 使用contains、eq进行文本匹配
• SourceDocumentPublishDate：发布日期 - ISO 8601格式YYYY-MM-DD（例如，'2023-01-01'）。使用ge/le进行范围查询
• RecStatus：推荐状态
• RecPriorityFlag：推荐的优先级标志
• IsIntegrityRelated：内容是否与完整性相关
• SourceDocumentIsRecDoc：文档是否包含推荐。值：'No'、'Yes'
• RecFraudRiskManagementThemePIA：欺诈风险管理主题分类
• RecMatterForCongressPIA：事项是否需要国会关注
• RecRecommendation：推荐文本 - 使用contains、eq进行文本匹配
• RecAgencyComments：机构对推荐的评论 - 使用contains、eq进行文本匹配

**运算符：**
• 文本：contains、eq、ne、startswith、endswith
• 精确匹配：eq（等于）、ne（不等于）、in（在列表中）
• 日期：ge（大于等于）、le（小于等于）、eq（等于）
• 逻辑：and、or、not、括号分组

**示例：**
• "RecStatus eq 'Open'"
• "RecStatus ne 'Closed' and RecPriorityFlag eq 'Yes'"
• "IsIntegrityRelated eq 'True' and RecPriorityFlag eq 'Yes'"
• "(RecStatus eq 'Open' and RecPriorityFlag eq 'Yes')"
• "SourceDocumentPublishDate ge '2020-01-01' and SourceDocumentPublishDate le '2024-12-31'"

**提示：** 使用pia_search_content_facets工具获取最新可用值。
`include_facets` | `boolean` *可选* | 在结果中包含分面
`limit` | `integer` *可选* | 最大结果限制
`page` | `integer` *可选* | 页码（默认：1）
`page_size` | `integer` *可选* | 每页结果数（默认：10）
`search_mode` | `string` *可选* | 搜索模式（默认：content）

---
#### 工具：**`pia_search_content_doj`**
搜索Program Integrity Alliance (PIA)数据库以获取司法部文档内容和推荐。此工具自动筛选结果，仅包含来自司法部的文档。返回包含完整引用信息和可点击链接的综合结果，以便正确归因。每个结果都包含带有数据源归因的相应引用。支持带有布尔逻辑、运算符和分组的复杂OData筛选。

| 参数 | 类型 | 描述 |
|-|-|-|
`query` | `string` | 搜索查询文本
`filter` | `string` *可选* | 支持复杂布尔逻辑的可选OData筛选表达式。

**可用字段：**
• 注意：此工具的SourceDocumentDataSource自动设置为'Department of Justice'。主要来源（>1k文档）：'Department of Justice'、'Congress.gov'、'Oversight.gov'、'CRS'、'GAO'、'Federal Register'
• SourceDocumentDataSet：文档所属的数据集或集合。值：'press-releases'、'reports'、'bills-and-laws'、'federal-reports'、'executive orders'、'state-and-local-reports'、'federal reports'
• SourceDocumentOrg：与文档关联的组织。有许多值，使用pia_search_content_facets工具查看可用选项
• SourceDocumentTitle：文档标题 - 使用contains、eq进行文本匹配
• SourceDocumentPublishDate：发布日期 - ISO 8601格式YYYY-MM-DD（例如，'2023-01-01'）。使用ge/le进行范围查询
• RecStatus：推荐状态
• RecPriorityFlag：推荐的优先级标志
• IsIntegrityRelated：内容是否与完整性相关
• SourceDocumentIsRecDoc：文档是否包含推荐。值：'No'、'Yes'
• RecFraudRiskManagementThemePIA：欺诈风险管理主题分类
• RecMatterForCongressPIA：事项是否需要国会关注
• RecRecommendation：推荐文本 - 使用contains、eq进行文本匹配
• RecAgencyComments：机构对推荐的评论 - 使用contains、eq进行文本匹配

**运算符：**
• 文本：contains、eq、ne、startswith、endswith
• 精确匹配：eq（等于）、ne（不等于）、in（在列表中）
• 日期：ge（大于等于，le（小于等于）、eq（等于）
• 逻辑：and、or、not、括号分组

**示例：**
• "RecStatus eq 'Open'"
• "RecStatus ne 'Closed' and RecPriorityFlag eq 'Yes'"
• "IsIntegrityRelated eq 'True' and RecPriorityFlag eq 'Yes'"
• "(RecStatus eq 'Open' and RecPriorityFlag eq 'Yes')"
• "SourceDocumentPublishDate ge '2020-01-01' and SourceDocumentPublishDate le '2024-12-31'"

**提示：** 使用pia_search_content_facets工具获取最新可用值。
`include_facets` | `boolean` *可选* | 在结果中包含分面
`limit` | `integer` *可选* | 最大结果限制
`page` | `integer` *可选* | 页码（默认：1）
`page_size` | `integer` *可选* | 每页结果数（默认：10）
`search_mode` | `string` *可选* | 搜索模式（默认：content）

---
#### 工具：**`pia_search_content_facets`**
获取PIA数据库内容搜索的可用分面（筛选值）。这有助于在执行内容搜索前了解可用的筛选值。主要数据源包括：司法部（198k+文档）、Congress.gov（29k+文档）、Oversight.gov（22k+文档）、CRS（22k+文档）、GAO（10k+文档）。

| 参数 | 类型 | 描述 |
|-|-|-|
`filter` | `string` *可选* | 支持复杂布尔逻辑的可选OData筛选表达式。

**可用字段：**
• SourceDocumentDataSource：发布文档的数据源/机构。主要来源（>1k文档）：'Department of Justice'、'Congress.gov'、'Oversight.gov'、'CRS'、'GAO'、'Federal Register'
• SourceDocumentDataSet：文档所属的数据集或集合。值：'press-releases'、'reports'、'bills-and-laws'、'federal-reports'、'executive orders'、'state-and-local-reports'、'federal reports'
• SourceDocumentOrg：与文档关联的组织。有许多值，使用pia_search_content_facets工具查看可用选项

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/mcp/pia" title="mcp/pia Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/mcp/pia</a></p>

---
image: azul/zulu-openjdk-alpine
description: "zulu-openjdk-alpine镜像是Alpine原生的Azul Zulu OpenJDK构建版本，使用内置musl libc功能，无需在Alpine发行版上添加glibc，可免费无限使用并由Azul提供商业支持。"
source: https://xuanyuan.cloud/zh/r/azul/zulu-openjdk-alpine
canonical: https://xuanyuan.cloud/zh/r/azul/zulu-openjdk-alpine
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/azul/zulu-openjdk-alpine" title="azul/zulu-openjdk-alpine Docker 镜像中文简介、标签列表与拉取命令">azul/zulu-openjdk-alpine 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Azul Zulu Alpine Docker镜像文档

## 镜像概述和主要用途

`zulu-openjdk-alpine`镜像包含Alpine原生的Azul Zulu OpenJDK构建版本，该版本使用Alpine内置的musl libc功能，不在Alpine发行版基础上额外添加glibc。

Azul Zulu OpenJDK构建版本可免费无限使用，并作为Azul Platform Core套件的一部分由[Azul][1]提供商业支持。更多信息请查看[Azul Platform Core][2]，技术文档可访问[docs.azul.com/core][3]。

根据基础系统的不同，Azul Zulu Docker镜像可在以下仓库获取：

- [Ubuntu: azul/zulu-openjdk][4]
- [Alpine: azul/zulu-openjdk-alpine][5]
- [CentOS: azul/zulu-openjdk-centos][6]
- [Debian: azul/zulu-openjdk-debian][7]
- [Distroless: azul/zulu-openjdk-distroless][8]

## 核心功能和特性

- **Alpine原生支持**：专为Alpine Linux优化，无需额外依赖glibc
- **musl libc集成**：使用Alpine内置的musl libc，减少镜像体积
- **免费使用**：无限制免费使用权限
- **商业支持**：由Azul提供专业商业支持服务
- **多版本覆盖**：提供从JDK 6到JDK 25的多个版本支持

## 标签和Dockerfile链接

### 最新标签

- [`25.0.0-25.28`, `25-latest` (*25-latest/Dockerfile*)][38]
- [`22.0.2-22.32`, `22-latest` (*22-latest/Dockerfile*)][62]
- [`21.0.8-21.44`, `21-latest` (*21-latest/Dockerfile*)][72]
- [`17.0.16-17.60`, `17-latest` (*17-latest/Dockerfile*)][133]
- [`11.0.28-11.82`, `11-latest` (*11-latest/Dockerfile*)][269]
- [`8u462-8.88`, `8-latest` (*8-latest/Dockerfile*)][359]

### 历史标签

OpenJDK先前更新版本的Azul Zulu Alpine Docker镜像标签（最新的4个标签）如下：

#### JRE Headless版本
- [25-jre-headless-latest][11], [25.0.0-25.28-jre-headless][41]
- [24-jre-headless-latest][12], [24.0.0-24.28-jre-headless][45], [24.0.1-24.30-jre-headless][47], [24.0.2-24.32-jre-headless][49]
- [23-jre-headless-latest][13], [23.0.0-23.28-jre-headless][55], [23.0.1-23.30-jre-headless][57], [23.0.2-23.32-jre-headless][61]
- [22-jre-headless-latest][14], [22.0.0-22.28-jre-headless][63], [22.0.1-22.30-jre-headless][67], [22.0.2-22.32-jre-headless][71]
- [21-jre-headless-latest][15], [21.0.0-21.28.85-jre-headless][73], [21.0.1-21.30-jre-headless][77], [21.0.1-21.30.15-jre-headless][79]
- [20-jre-headless-latest][16], [20.0.0-20.28.85-jre-headless][106], [20.0.1-20.30.11-jre-headless][108], [20.0.2-20.32.11-jre-headless][112]
- [19-jre-headless-latest][17], [19.0.0-19.28.81-jre-headless][114], [19.0.1-19.30.11-jre-headless][118], [19.0.2-19.32.13-jre-headless][122]
- [18-jre-headless-latest][18], [18.0.1-18.30.11-jre-headless][124], [18.0.2.1-18.32.13-jre-headless][128], [18.0.2-18.32.11-jre-headless][130]
- [17-jre-headless-latest][19], [17.0.0-17.28.13-jre-headless][134], [17.0.1-17.30.15-jre-headless][139], [17.0.2-17.32.13-jre-headless][142]
- [15-jre-headless-latest][20], [15.0.7-15.40.19-jre-headless][212], [15.0.8-15.42.15-jre-headless][216], [15.0.9-15.44.13-jre-headless][218]
- [13-jre-headless-latest][21], [13.0.3-13.31.11-jre-headless][229], [13.0.4-13.33.25-jre-headless][234], [13.0.5-13.35.17-jre-headless][237]
- [11-jre-headless-latest][22], [11.0.5-11.35-jre-headless][276], [11.0.6-11.37-jre-headless][281], [11.0.7-11.39.15-jre-headless][284]
- [8-jre-headless-latest][23], [8u232-8.42.0.23-jre-headless][376], [8u242-8.44.0.11-jre-headless][379], [8u252-8.46.0.19-jre-headless][381]

#### JRE版本
- [25-jre-latest][24], [25.0.0-25.28-jre][39]
- [24-jre-latest][25], [24.0.0-24.28-jre][44], [24.0.1-24.30-jre][46], [24.0.2-24.32-jre][50]
- [23-jre-latest][26], [23.0.0-23.28-jre][53], [23.0.1-23.30-jre][58], [23.0.2-23.32-jre][60]
- [22-jre-latest][27], [22.0.0-22.28-jre][65], [22.0.1-22.30-jre][66], [22.0.2-22.32-jre][70]
- [21-jre-latest][28], [21.0.0-21.28.85-jre][75], [21.0.1-21.30-jre][76], [21.0.1-21.30.15-jre][81]
- [20-jre-latest][29], [20.0.0-20.28.85-jre][105], [20.0.1-20.30.11-jre][109], [20.0.2-20.32.11-jre][111]
- [19-jre-latest][30], [19.0.0-19.28.81-jre][116], [19.0.1-19.30.11-jre][117], [19.0.2-19.32.13-jre][120]
- [18-jre-latest][31], [18.0.1-18.30.11-jre][126], [18.0.2.1-18.32.13-jre][127], [18.0.2-18.32.11-jre][131]
- [17-jre-latest][32], [17.0.0-17.28.13-jre][136], [17.0.1-17.30.15-jre][137], [17.0.2-17.32.13-jre][141]
- [16-jre-latest][33], [16.0.0-16.28.11-jre][196], [16.0.1-16.30.15-jre][197], [16.0.2-16.32.15-jre][200]
- [15-jre-latest][34], [15.0.0-15.27.17-jre][202], [15.0.7-15.40.19-jre][211], [15.0.8-15.42.15-jre][215]
- [13-jre-latest][35], [13.0.3-13.31.11-jre][231], [13.0.4-13.33.25-jre][233], [13.0.5-13.35.17-jre][236]
- [11-jre-latest][36], [11.0.3-11.31-jre][272], [11.0.4-11.33-jre][275], [11.0.5-11.35-jre][277]
- [8-jre-latest][37], [8u212-8.38.0.13-jre][369], [8u222-8.40.0.25-jre][370], [8u232-8.42.0.21-jre][373]

#### JDK完整版本
- [25-latest][38], [25.0.0-25.28][40]
- [24-latest][42], [24.0.0-24.28][43], [24.0.1-24.30][48], [24.0.2-24.32][51]
- [23-latest][52], [23.0.0-23.28][54], [23.0.1-23.30][56], [23.0.2-23.32][59]
- [22-latest][62], [22.0.0-22.28][64], [22.0.1-22.30][68], [22.0.2-22.32][69]
- [21-latest][72], [21.0.0-21.28.85][74], [21.0.1-21.30][78], [21.0.1-21.30.15][80]
- [20-latest][103], [20.0.0-20.28.85][104], [20.0.1-20.30.11][107], [20.0.2-20.32.11][110]
- [19-latest][113], [19.0.0-19.28.81][115], [19.0.1-19.30.11][119], [19.0.2-19.32.13][121]
- [18-latest][123], [18.0.1-18.30.11][125], [18.0.2.1-18.32.13][129], [18.0.2-18.32.11][132]
- [17-latest][133], [17.0.0-17.28.13][135], [17.0.1-17.30.15][138], [17.0.2-17.32.13][140]
- [16-latest][194], [16.0.0-16.28.11][195], [16.0.1-16.30.15][198], [16.0.2-16.32.15][199]
- [15-latest][201], [15.0.0-15.27.17][203], [15.0.1-15.28.13][204], [15.0.1-15.28.51][205]
- [14-latest][223], [14.0.1-14.28.21][224], [14.0.2-14.29.23][225]
- [13-latest][226], [13.0.1-13.28][227], [13.0.2-13.29][228], [13.0.3-13.31.11][230]
- [12-latest][265], [12.0.0-12.1][266], [12.0.1-12.2][267], [12.0.2-12.3][268]
- [11-latest][269], [11.0.1-11.2][270], [11.0.2-11.29][271], [11.0.3-11.31][273]
- [8-latest][359], [8u131-8.21.0.1][360], [8u144-8.23.0.3][361], [8u152-8.25.0.1][362]
- [7-latest][457], [7u141-7.18.0.3][458], [7u154-7.20.0.3][459], [7u161-7.21.0.3][460]
- [6-latest][480], [6u93-6.16.0.1][481], [6u97-6.17.0.1][482], [6u99-6.18.0.3][483]

> **注意**：部分历史标签可能使用glibc，早于迁移到musl libc的版本。

## 使用场景和适用范围

- 基于Alpine Linux的轻量级Java应用部署
- 需要最小化Docker镜像体积的场景
- 对原生musl libc支持有要求的环境
- 需要商业支持的企业级Java应用
- 多版本Java应用的容器化部署

## 使用方法和配置说明

### 基本使用示例

获取并运行最新版本的Azul Zulu OpenJDK 17

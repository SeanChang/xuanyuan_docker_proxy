<!-- xuanyuan-docker-images-zh
image: hyperledger/fabric-ca
source: https://xuanyuan.cloud/zh/r/hyperledger/fabric-ca
canonical: https://xuanyuan.cloud/zh/r/hyperledger/fabric-ca
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [hyperledger/fabric-ca — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/hyperledger/fabric-ca "hyperledger/fabric-ca Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/hyperledger/fabric-ca

# Fabric CA

Fabric CA 是 Hyperledger Fabric 区块链平台的证书颁发机构（Certificate Authority）组件。它在 Fabric 网络中扮演着核心角色，负责管理网络中所有实体（如用户、节点、排序服务等）的身份证书。简单来说，Fabric CA 就是 Fabric 网络的“身份证管理中心”，确保网络中的身份真实、可信，并基于这些身份进行权限控制。

## 主要功能

Fabric CA 的核心功能围绕数字证书的生命周期管理展开：

1.  **证书签发**：为网络中的用户、节点（Peer、Orderer）等实体签发符合 X.509 标准的数字证书。这些证书包含了实体的公钥和身份信息，并由 CA 的私钥进行签名，以保证其真实性和完整性。
2.  **证书验证**：提供验证已签发证书有效性的机制，确保实体身份的合法性。
3.  **证书吊销**：当证书过期、私钥泄露或实体权限被撤销时，Fabric CA 可以将证书列入吊销列表（CRL），使其失效。

除了上述核心功能，Fabric CA 还支持：

*   **身份管理**：管理用户身份的整个生命周期，包括注册、 enrollment（获取证书）、属性管理等。
*   **多 CA 层次结构**：支持根 CA（Root CA）和中间 CA（Intermediate CA）的部署模式，以满足复杂网络的安全需求和组织架构。中间 CA 可以由根 CA 授权签发证书，形成信任链。
*   **属性管理**：允许在证书中嵌入自定义属性，这些属性可用于 Fabric 网络中的访问控制策略（ACL）。
*   **安全存储**：提供对密钥和证书的安全存储机制。

## 关键配置与使用考量

要有效部署和使用 Fabric CA，需要关注以下几点：

*   **CA 类型选择**：根据网络架构选择部署根 CA、中间 CA，或两者结合。
*   **证书模板与策略**：定义证书的有效期、密钥算法（如 RSA、ECC）、密钥长度、扩展字段等模板和签发策略。
*   **用户注册与 Enrollment**：
    *   **注册（Register）**：管理员通常需要先在 CA 中注册一个实体，获取一个 enrollment ID 和密码（或注册码）。
    *   **Enrollment**：实体使用注册时获得的 ID 和密码向 CA 发起 enrollment 请求，CA 验证通过后颁发证书（通常包含实体的签名证书和私钥）。
*   **客户端工具**：Fabric 提供了 `fabric-ca-client` 命令行工具，用于与 Fabric CA 服务器进行交互，执行注册、enrollment、证书更新、吊销等操作。
*   **集成与 API**：Fabric CA 提供 REST API，方便与外部系统（如身份管理系统、应用程序）集成。
*   **高可用性与备份**：对于生产环境，需要考虑 CA 服务的高可用性部署以及数据（尤其是根 CA 私钥）的备份与恢复策略。私钥的安全保管至关重要。
*   **数据库配置**：Fabric CA 需要数据库来存储用户信息、证书元数据、CRL 等。支持 SQLite、PostgreSQL、MySQL 等数据库。

通过合理配置和管理 Fabric CA，可以为 Hyperledger Fabric 区块链网络提供坚实的身份基础设施，确保网络通信和交易的安全性与可追溯性。

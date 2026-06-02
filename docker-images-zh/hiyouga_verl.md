---
image: hiyouga/verl
description: "VolcEngine/verl 是火山引擎推出的强化学习框架，旨在提供高效、易用的强化学习开发与训练工具，支持多种经典及前沿算法，具备高性能计算与灵活扩展能力，助力开发者快速构建、训练和部署强化学习模型；hiyouga/EasyR1 则是一款轻量级强化学习工具库，专注于简化强化学习流程，通过直观的接口设计、丰富的示例代码及详尽文档，降低入门门槛，适合初学者快速上手及科研人员进行快速原型开发，为强化学习学习与应用提供便捷支持。"
source: https://xuanyuan.cloud/zh/r/hiyouga/verl
canonical: https://xuanyuan.cloud/zh/r/hiyouga/verl
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [hiyouga/verl — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/hiyouga/verl)

含镜像标签、拉取命令、部署文档与相关推荐。

[hiyouga/verl Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/hiyouga/verl)

## 项目一：VERL（火山引擎强化学习平台）  


### 核心功能  
VERL 是火山引擎开发的强化学习（RL）平台，主打高性能和易用性，核心特点包括：  
- **算法覆盖广**：支持 PPO、SAC、DQN 等经典 RL 算法，也兼容 Transformer-based 等前沿算法，满足不同场景需求。  
- **分布式训练加速**：内置分布式训练框架，可利用多机多卡资源提升训练效率，适合处理大规模状态空间任务。  
- **低门槛使用**：API 设计简洁，封装了数据处理、模型训练、评估等流程，新手也能快速上手。  
- **生态集成**：可对接火山引擎的云服务器、存储等工具，方便工业级应用部署。  


### 适用场景  
- 学术研究：快速复现 RL 算法，验证新模型效果。  
- 工业开发：机器人控制、推荐系统优化、自动驾驶决策等工业级 RL 应用开发。  


### 快速上手  
#### 安装  
```bash  
# 从源码安装（推荐）  
git clone []  
cd verl && pip install -e .  
```  

#### 简单示例（训练 PPO 模型）  
```python  
from verl.algorithms import PPO  
from verl.environments import GymEnv  

# 初始化环境和算法  
env = GymEnv("CartPole-v1")  
agent = PPO(env.observation_space, env.action_space, lr=3e-4)  

# 训练 100 个回合  
for episode in range(100):  
    obs = env.reset()  
    total_reward = 0  
    while True:  
        action = agent.select_action(obs)  
        next_obs, reward, done, _ = env.step(action)  
        agent.store_transition(obs, action, reward, next_obs, done)  
        total_reward += reward  
        if done:  
            agent.update()  # 每回合更新策略  
            print(f"Episode {episode}, Reward: {total_reward}")  
            break  
        obs = next_obs  
```  


## 项目二：EasyR1（R1 任务轻量化实现）  


### 核心功能  
EasyR1 是针对 **R1 任务**（一种检索增强生成任务，结合检索和生成的混合 NLP 任务）的轻量级实现，特点如下：  
- **模型兼容性强**：支持 LLaMA、Qwen、ChatGLM 等主流开源大语言模型（LLM），无需修改模型结构即可适配。  
- **低资源部署**：优化了推理流程，可在单卡 GPU 或甚至 CPU 上运行，适合个人开发者和小团队。  
- **全流程示例**：提供从数据预处理（检索库构建）、模型微调（可选）到推理生成的完整代码示例，开箱即用。  
- **可扩展性高**：代码结构清晰，支持自定义检索器（如 FAISS、BM25）和生成策略。  


### 适用场景  
- 学习实践：想了解检索增强生成（RAG）流程的开发者，可通过 EasyR1 快速掌握核心逻辑。  
- 小规模应用：开发轻量级 RAG 工具（如本地知识库问答、文档辅助写作）。  


### 快速上手  
#### 安装  
```bash  
# 克隆仓库并安装依赖  
git clone []  
cd EasyR1 && pip install -r requirements.txt  
```  

#### 简单示例（运行 R1 推理）  
```python  
from easyr1 import R1Pipeline  

# 初始化 R1 流程（指定模型和检索库）  
pipeline = R1Pipeline(  
    model_name_or_path="lmsys/vicuna-7b-v1.5",  # 选用 Vicuna-7B 模型  
    retriever_type="faiss",  # 使用 FAISS 检索器  
    corpus_path="data/sample_corpus.txt"  # 检索库文本文件  
)  

# 输入问题，获取 R1 生成结果  
question = "强化学习和监督学习的核心区别是什么？"  
response = pipeline.generate(question, top_k=3)  # 检索 top 3 相关文本  
print(f"Answer: {response}")  
```  


### 总结  
VERL 聚焦强化学习全流程开发，适合需要高性能训练和工业级部署的场景；EasyR1 则专注于 R1 任务的轻量化落地，适合学习和小规模 RAG 应用。两者均提供开源代码和详细示例，降低了对应领域的上手门槛。

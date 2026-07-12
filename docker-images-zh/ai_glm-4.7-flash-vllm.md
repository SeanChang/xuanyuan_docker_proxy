---
image: ai/glm-4.7-flash-vllm
description: "GLM-4.7-Flash是顶级的30B-A3B混合专家模型，平衡了强大性能与高效部署，为轻量级部署提供兼顾性能与效率的新选择。"
source: https://xuanyuan.cloud/zh/r/ai/glm-4.7-flash-vllm
canonical: https://xuanyuan.cloud/zh/r/ai/glm-4.7-flash-vllm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ai/glm-4.7-flash-vllm" title="ai/glm-4.7-flash-vllm Docker 镜像中文简介、标签列表与拉取命令">ai/glm-4.7-flash-vllm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# GLM-4.7-Flash 镜像文档

## 概述

GLM-4.7-Flash是一个30B-A3B混合专家（MoE）模型。作为30B级别中性能最强的模型，它为轻量级部署提供了兼顾性能与效率的新选择。

## 基准测试性能

| 基准测试           | GLM-4.7-Flash | Qwen3-30B-A3B-Thinking-2507 | GPT-OSS-20B |
|--------------------|---------------|-----------------------------|-------------|
| AIME 25            | 91.6          | 85.0                        | 91.7        |
| GPQA               | 75.2          | 73.4                        | 71.5        |
| LCB v6             | 64.0          | 66.0                        | 61.0        |
| HLE                | 14.4          | 9.8                         | 10.9        |
| SWE-bench Verified | 59.2          | 22.0                        | 34.0        |
| τ²-Bench           | 79.5          | 49.0                        | 47.7        |
| BrowseComp         | 42.8          | 2.29                        | 28.3        |

## 评估参数

### 默认设置（大多数任务）

* temperature: `1.0`
* top-p: `0.95`
* 最大新 tokens: `131072`

对于多轮智能体任务（τ²-Bench和Terminal Bench 2），请开启[Preserved Thinking模式](https://docs.z.ai/guides/capabilities/thinking-mode)。

### Terminal Bench、SWE Bench Verified

* temperature: `0.7`
* top-p: `1.0`
* 最大新 tokens: `16384`

### τ²-Bench

* temperature: `0`
* 最大新 tokens: `16384`

在τ²-Bench评估中，我们在零售和电信用户交互中添加了额外提示，以避免用户错误结束交互导致的失败模式。对于航空领域，我们应用了[Claude Opus 4.5](https://assets.anthropic.com/m/64823ba7485345a7/Claude-Opus-4-5-System-Card.pdf)发布报告中提出的领域修复方案。

## 引用

如果您在研究中发现本工作有用，请考虑引用以下论文：

```bibtex
@misc{5team2025glm45agenticreasoningcoding,
      title={GLM-4.5: Agentic, Reasoning, and Coding (ARC) Foundation Models}, 
      author={GLM Team and Aohan Zeng and Xin Lv and Qinkai Zheng and Zhenyu Hou and Bin Chen and Chengxing Xie and Cunxiang Wang and Da Yin and Hao Zeng and Jiajie Zhang and Kedong Wang and Lucen Zhong and Mingdao Liu and Rui Lu and Shulin Cao and Xiaohan Zhang and Xuancheng Huang and Yao Wei and Yean Cheng and Yifan An and Yilin Niu and Yuanhao Wen and Yushi Bai and Zhengxiao Du and Zihan Wang and Zilin Zhu and Bohan Zhang and Bosi Wen and Bowen Wu and Bowen Xu and Can Huang and Casey Zhao and Changpeng Cai and Chao Yu and Chen Li and Chendi Ge and Chenghua Huang and Chenhui Zhang and Chenxi Xu and Chenzheng Zhu and Chuang Li and Congfeng Yin and Daoyan Lin and Dayong Yang and Dazhi Jiang and Ding Ai and Erle Zhu and Fei Wang and Gengzheng Pan and Guo Wang and Hailong Sun and Haitao Li and Haiyang Li and Haiyi Hu and Hanyu Zhang and Hao Peng and Hao Tai and Haoke Zhang and Haoran Wang and Haoyu Yang and He Liu and He Zhao and Hongwei Liu and Hongxi Yan and Huan Liu and Huilong Chen and Ji Li and Jiajing Zhao and Jiamin Ren and Jian Jiao and Jiani Zhao and Jianyang Yan and Jiaqi Wang and Jiayi Gui and Jiayue Zhao and Jie Liu and Jijie Li and Jing Li and Jing Lu and Jingsen Wang and Jingwei Yuan and Jingxuan Li and Jingzhao Du and Jinhua Du and Jinxin Liu and Junkai Zhi and Junli Gao and Ke Wang and Lekang Yang and Liang Xu and Lin Fan and Lindong Wu and Lintao Ding and Lu Wang and Man Zhang and Minghao Li and Minghuan Xu and Mingming Zhao and Mingshu Zhai and Pengfan Du and Qian Dong and Shangde Lei and Shangqing Tu and Shangtong Yang and Shaoyou Lu and Shijie Li and Shuang Li and Shuang-Li and Shuxun Yang and Sibo Yi and Tianshu Yu and Wei Tian and Weihan Wang and Wenbo Yu and Weng Lam Tam and Wenjie Liang and Wentao Liu and Xiao Wang and Xiaohan Jia and Xiaotao Gu and Xiaoying Ling and Xin Wang and Xing Fan and Xingru Pan and Xinyuan Zhang and Xinze Zhang and Xiuqing Fu and Xunkai Zhang and Yabo Xu and Yandong Wu and Yida Lu and Yidong Wang and Yilin Zhou and Yiming Pan and Ying Zhang and Yingli Wang and Yingru Li and Yinpei Su and Yipeng Geng and Yitong Zhu and Yongkun Yang and Yuhang Li and Yuhao Wu and Yujiang Li and Yunan Liu and Yunqing Wang and Yuntao Li and Yuxuan Zhang and Zezhen Liu and Zhen Yang and Zhengda Zhou and Zhongpei Qiao and Zhuoer Feng and Zhuorui Liu and Zichen Zhang and Zihan Wang and Zijun Yao and Zikang Wang and Ziqiang Liu and Ziwei Chai and Zixuan Li and Zuodong Zhao and Wenguang Chen and Jidong Zhai and Bin Xu and Minlie Huang and Hongning Wang and Juanzi Li and Yuxiao Dong and Jie Tang},
      year={2025},
      eprint={2508.06471},
      archivePrefix={arXiv},
      primaryClass={cs.CL},
      url={https://arxiv.org/abs/2508.06471}, 
}

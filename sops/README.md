# SOPs — 可执行操作手册

> docs/ 讲方法论的"为什么"，sops/ 讲落到日常会话的"怎么做"。每一篇都是从真实长链项目中跑出来的步骤清单 + 反向清单。

## 与 docs/ 的分工

| 维度 | docs/ | sops/ |
|------|-------|-------|
| 体裁 | 叙事 / 理论 | 步骤 / 检查表 |
| 读者动作 | 理解架构 | 复制粘贴执行 |
| 失败惩罚 | 误解概念 | 立刻出 bug |
| 更新频率 | 慢 | 跟着实战频繁修订 |

读 docs/ 像看白皮书；读 sops/ 像翻应急包。

## 阅读顺序（按使用频率从高到低）

| 编号 | 主题 | 何时翻它 |
|------|------|----------|
| [01](01-context-and-plan-rules.md) | Context 与 Plan 八条铁律 | 每次新会话开场 |
| [02](02-five-phase-lifecycle.md) | 单模块开发五段式 lifecycle | 写一个具体模块时 |
| [03](03-new-session-onboarding.md) | 打开新会话的决策树（A/B/C） | 启会话第一条消息之前 |
| [04](04-multi-agent-collaboration.md) | 双 Agent A/B 协作模式 | 中大型项目需要持续多 turn |
| [05](05-modular-localization.md) | 多板块项目局部接入 | 项目大到要按板块切独立会话 |
| [06](06-no-test-framework-self-test.md) | 无测试框架时的 .mjs 自测 | 项目没装 jest/vitest 但要测纯数学公式 |
| [07](07-project-archive-five-piece.md) | 项目档案五件套（接续体系） | 项目进入中长线（10+ 次会话） |
| [08](08-experience-repo-and-writeback.md) | 经验沉淀仓与回送四件套 | 并行多个项目，经验要跨项目流动 |
| [09](09-hook-guards.md) | Hook 守卫：规范的机器强制 | 规范写进文档后仍反复被违反 |

## 怎么用

需求理解与方案选择使用 [12 信息四象限与优先复用](12-shared-understanding-and-reuse.md)，先补齐必要信息并检查现有实现和开源候选。

新增流程可按任务读取 [10 变更审查与发布](10-review-and-release.md) 与 [11 从研究资料到工作流](11-research-to-workflow.md)。前者覆盖验证、风险和恢复，后者记录外部方法的采用依据与试用结果。

- **全新机器 / 全新 AI**：直接把 [../BOOTSTRAP.md](../BOOTSTRAP.md) 发给 AI，让它自己走
- **新项目从 day 1**：先读 [03](03-new-session-onboarding.md) + [01](01-context-and-plan-rules.md)，按 A 场景启动
- **已有项目继续做**：读 [03](03-new-session-onboarding.md) 选 B 场景，依据需要翻 [02](02-five-phase-lifecycle.md)
- **项目做大了**：接续文档从单 HANDOFF 升级为 [07 五件套](07-project-archive-five-piece.md)
- **多项目并行**：建经验仓，按 [08](08-experience-repo-and-writeback.md) 回送
- **规范反复被违反**：翻 [09](09-hook-guards.md)，把复发 2 次以上的规范机器化成 advisory hook
- **小修小补**：选 [03](03-new-session-onboarding.md) 的 C 场景就够，其它跳过
- **AI 约束查询**：所有 SOP 末尾都有「不要做什么」节，集中版见 [../AI-CONSTRAINTS.md](../AI-CONSTRAINTS.md)

## 风格约定

每篇 SOP 都按下面骨架写，便于检索：

```
# 标题

适用场景 / 何时不适用 / 版本

## 总览（一两张图或表）

## 步骤 / 阶段 / 各文件 / 各角色（视主题）

## 容易忘的细节

## 不要做什么（反向清单）

## 修订记录
```

`不要做什么` 段不是装饰，是反复踩坑后冷凝下来的护栏。新会话开始前扫一眼比扫整篇正文更高 ROI。

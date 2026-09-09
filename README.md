# vibe-coding-workflow

> 一套面向个人开发者的 AI-native 工程化协作方法论 —— 多 Agent 角色化分工 + 长链记忆持久化 + Plan-Act-Observe 闭环验证。

## 这是什么

本仓库记录了一套围绕 Claude Code 构建的**个人级 Agentic Workflow** 方法论与可复用模板。它不是一个工具或代码库，而是一套已经在多个生产级项目中验证过的 "AI 接续型工程" 协作范式。

**核心目标**：让独立开发者在并行推进多个异构项目时，AI 不只是写代码片段的助手，而是承担架构决策、跨会话接续、跨项目调度的真实数字劳动力。

## 解决的核心痛点

| 痛点 | 本方案 |
|------|--------|
| **会话间上下文断裂** —— 每次新对话从零开始 | HANDOFF.md + MEMORY.md 跨会话记忆持久化 |
| **多技术栈认知漂移** —— Web/游戏/Python 频繁切换 | 角色化 Sub-Agent 分工，主对话只做决策 |
| **片段级响应不够** —— 需要架构级协同思考 | Plan-Act-Observe 闭环 + 多 Agent 评审 |
| **规范靠自觉遵守** —— 写进文档还是反复被违反 | advisory hook 机器强制，动作发生时自动提醒 |

## 功能特性

- **一键自举**：把 [BOOTSTRAP.md](BOOTSTRAP.md) 发给全新电脑上的 AI，它自己生成全部记忆文档并按流程走
- **三层架构**：编排层（Supervisor）+ 执行层（Sub-Agent）+ 持久化记忆层
- **跨会话接续**：轻量 HANDOFF.md 起步，中长线升级为项目档案五件套（30+ 轮接续不失真）
- **跨项目经验流动**：独立经验仓 + 回送四件套闸门（磁盘/索引/体检/自描述），沉淀不腐烂
- **自我迭代系统**：六步闭环让 Agent 从反思中持续改善自身行为
- **机器强制闸门（hook 守卫）**：advisory hook 把高频规范从"文档约定"升级为动作发生时自动提醒，对治"对策记了 ≠ 对策被执行"
- **11 类 AI 协作约束**：从真实踩坑中冷凝出的工程止损线
- **完整 SOP 体系**：从开新会话到收尾沉淀的标准化操作流程
- **零依赖起步**：核心是纯 Markdown，零安装零运行时；可选启用 hooks/ 守卫脚本（Windows PowerShell）

## 技术栈

- **语言**：Markdown 为主 + 4 个可选的 PowerShell 守卫脚本（hooks/，Windows）
- **工具**：git（唯一技术依赖）
- **运行时**：核心内容无需运行时（指导性 SOP 与模板）；hook 为可选增强，需 Windows PowerShell

## 快速开始

### 零配置路径（推荐）：让 AI 自己装好这套工作流

把 [BOOTSTRAP.md](BOOTSTRAP.md) 作为第一条消息发给 Claude Code（任何机器、包括全新电脑），它会自检环境 → 访谈你一轮 → 自己生成 MEMORY.md / CLAUDE.md / 项目档案，然后按本仓库的流程走。你不需要记住任何规则。

### 完全不懂技术？先读小白教程

如果你刚接触 AI 辅助编程、或对命令行/git 不熟，先读 [TUTORIAL.md](TUTORIAL.md)，它把每一步拆到"跟着做就行"的颗粒度。

下面是手动路径：

### 第一步：了解架构（5 分钟）

阅读 [docs/01-架构总览.md](docs/01-架构总览.md)，理解三层架构和多 Agent 角色分工。

### 第二步：复制模板到你的项目（2 分钟）

从 `templates/` 目录复制以下文件到你的项目根目录：

```bash
# 复制项目级行为约定
cp templates/CLAUDE.md <你的项目根目录>/CLAUDE.md

# 复制跨会话接续骨架
cp templates/HANDOFF.md <你的项目根目录>/HANDOFF.md

# 复制用户级记忆索引（放到 Claude Code 全局目录）
cp templates/MEMORY.md ~/.claude/MEMORY.md
```

然后按占位符说明裁剪 CLAUDE.md，填入你的项目信息。

### 第三步：开第一个会话（1 分钟）

按 [sops/03-new-session-onboarding.md](sops/03-new-session-onboarding.md) 的 A/B/C 决策树选择场景，发送对应的第一条消息。

## 项目结构

```
vibe-coding-workflow/
├── BOOTSTRAP.md               # 给 AI 读的自举协议（全新电脑一份文件起步）
├── TUTORIAL.md                # 面向小白的零基础上手教程
├── AI-CONSTRAINTS.md          # 11 类 AI 协作约束总集（最核心文件）
├── README.md                  # 本文件
├── LICENSE                    # MIT 许可证
├── docs/                      # 方法论文档（讲"为什么"）
│   ├── 01-架构总览.md         #   三层架构设计
│   ├── 02-长链记忆体系.md     #   MEMORY + 项目档案 + 经验仓 三层记忆
│   ├── 03-工作流闭环.md       #   Plan-Act-Observe 循环
│   ├── 04-工具与具身化.md     #   工具链与 Sub-Agent
│   ├── 05-实践案例.md         #   3 个真实落地案例
│   └── 06-自我迭代机制.md     #   跨会话 Recursive Self-Improvement
├── sops/                      # 可执行 SOP（讲"怎么做"）
│   ├── README.md              #   SOP 索引与使用指南
│   ├── 01-context-and-plan-rules.md
│   ├── 02-five-phase-lifecycle.md
│   ├── 03-new-session-onboarding.md
│   ├── 04-multi-agent-collaboration.md
│   ├── 05-modular-localization.md
│   ├── 06-no-test-framework-self-test.md
│   ├── 07-project-archive-five-piece.md
│   ├── 08-experience-repo-and-writeback.md
│   └── 09-hook-guards.md      #   hook 守卫：规范的机器强制
├── hooks/                     # 可选的 advisory 守卫脚本（Windows PowerShell）
│   ├── warn-commit-emoji.ps1  #   commit message 含 emoji 时提醒
│   ├── warn-git-add-all.ps1   #   git add . / -A 时提醒（防 stage 他人 WIP）
│   ├── warn-ps1-no-bom.ps1    #   含中文 .ps1 缺 UTF-8 BOM 时提醒
│   └── remind-reflect.ps1     #   会话收尾轻提醒反思沉淀
├── templates/                 # 可复用模板
│   ├── CLAUDE.md              #   项目级行为约定模板
│   ├── HANDOFF.md             #   跨会话接续骨架模板
│   └── MEMORY.md              #   用户级记忆索引模板
├── examples/                  # 脱敏示例
│   ├── handoff-godot-sample.md
│   └── memory-sample.md
└── self-iteration/            # 自我迭代系统（六步闭环）
    ├── README.md
    ├── protocol.md            #   Agent 应遵循的指令集
    ├── reflection-log.md      #   任务反思日志
    ├── patterns.md            #   提炼出的模式
    └── pending-updates.md     #   待批准的更新提案
```

## 文档索引

### 方法论（docs/）—— 讲"为什么这么设计"

| 文档 | 主题 |
|------|------|
| [01 - 架构总览](docs/01-架构总览.md) | 三层架构：编排 / 执行 / 持久化记忆 |
| [02 - 长链记忆体系](docs/02-长链记忆体系.md) | 三层记忆：MEMORY + 项目档案 + 经验仓 |
| [03 - 工作流闭环](docs/03-工作流闭环.md) | Plan-Act-Observe 循环 |
| [04 - 工具与具身化](docs/04-工具与具身化.md) | 工具链与 Sub-Agent 角色 |
| [05 - 实践案例](docs/05-实践案例.md) | net-blog / Godot / TripStar 三个落地案例 |
| [06 - 自我迭代机制](docs/06-自我迭代机制.md) | 跨会话 Recursive Self-Improvement 雏形 |

### 可执行 SOP（sops/）—— 讲"怎么落到日常会话"

| 编号 | 主题 | 何时翻它 |
|------|------|----------|
| [01](sops/01-context-and-plan-rules.md) | Context 与 Plan 八条铁律 | 每次新会话开场 |
| [02](sops/02-five-phase-lifecycle.md) | 单模块开发五段式 lifecycle | 写一个具体模块时 |
| [03](sops/03-new-session-onboarding.md) | 打开新会话的决策树（A/B/C） | 启会话第一条消息之前 |
| [04](sops/04-multi-agent-collaboration.md) | 双 Agent A/B 协作模式 | 中大型项目需要持续多 turn |
| [05](sops/05-modular-localization.md) | 多板块项目局部接入 | 项目大到要按板块切独立会话 |
| [06](sops/06-no-test-framework-self-test.md) | 无测试框架时的 .mjs 自测 | 项目没装 jest/vitest 但要测纯函数 |
| [07](sops/07-project-archive-five-piece.md) | 项目档案五件套（接续体系） | 项目进入中长线（10+ 次会话） |
| [08](sops/08-experience-repo-and-writeback.md) | 经验沉淀仓与回送四件套 | 并行多项目，经验要跨项目流动 |
| [09](sops/09-hook-guards.md) | Hook 守卫：规范的机器强制 | 规范写进文档后仍反复被违反时 |

### AI 协作约束（顶层）—— 讲"哪些事 AI 不能做、为什么"

[AI-CONSTRAINTS.md](AI-CONSTRAINTS.md) 是 11 类约束的总集：

| 编号 | 主题 | 一句话 |
|------|------|--------|
| 1 | Context 与对话生命周期 | context 是稀缺资源，省着用 |
| 2 | 决策边界 | 不可逆/对外可见/预算变化前停下来 |
| 3 | 报告诚信 | 没 `file@line` 的结论 = 想象 |
| 4 | 文件修改边界 | 哪些文件只用户改 |
| 5 | 可逆性 | 没说就不要 `--force` |
| 6 | 文本一致性 | 改数值/枚举/路径要 grep 全文 |
| 7 | 验证/测试守则 | 不只跑 `tsc --noEmit`，要全套 build |
| 8 | 沟通与文风 | 不主动加 emoji |
| 9 | 沉淀与提醒义务 | 可迁移经验必须主动提醒沉淀 |
| 10 | INVARIANT 注释体系 | 钉死关键 trade-off 防 LLM 误删 |
| 11 | Secret / 凭据守则 | PAT/API key/DB 密码永不让用户贴进对话 |

## 已落地项目

| 项目 | 状态 | 验证的核心点 | 详细案例 |
|------|------|-------------|----------|
| net-blog | LIVE @ [hlhaya.cn](https://hlhaya.cn) | 个人产品几乎从 0 到 1 全流程 AI 主导 | [案例详情](docs/05-实践案例.md#案例-1net-blog个人博客系统) |
| app note Godot 重构版 | 持续迭代 | HANDOFF.md 长链接续机制，30+ 轮跨会话接续 | [案例详情](docs/05-实践案例.md#案例-2app-note-godot-重构版) |
| TripStar 本地化 | 已部署 | 开源项目深度补丁 + LLM 调用层韧性 | [案例详情](docs/05-实践案例.md#案例-3tripstar-本地化深度改造) |

## 使用说明

### 复用模板

| 模板 | 用途 | 使用方式 |
|------|------|----------|
| [CLAUDE.md](templates/CLAUDE.md) | 项目级行为约定 | 复制到项目根目录，按占位符裁剪 |
| [HANDOFF.md](templates/HANDOFF.md) | 跨会话接续骨架 | 复制到项目根目录，每次会话结束前更新 |
| [MEMORY.md](templates/MEMORY.md) | 用户级记忆索引 | 复制到 `~/.claude/MEMORY.md`，长期积累 |

### 脱敏示例

- [HANDOFF 接续示例](examples/handoff-godot-sample.md) —— 看实际项目中 HANDOFF.md 怎么写
- [MEMORY 索引示例](examples/memory-sample.md) —— 看实际项目中 MEMORY.md 怎么组织

### 自我迭代系统

[self-iteration/](self-iteration/) 目录包含一套可运行的自我迭代系统，让 Agent 从反思中持续改善自身行为。详见 [self-iteration/README.md](self-iteration/README.md)。

### 机器强制闸门（hook 守卫）

[hooks/](hooks/) 目录提供 4 个 advisory 守卫脚本，把高频规范从"文档约定"升级为 Claude Code 动作发生时的自动提醒（可选启用，仅 Windows PowerShell）。安装与配置见 [sops/09-hook-guards.md](sops/09-hook-guards.md)。

## 阅读路径

**最快上手**：把 [BOOTSTRAP.md](BOOTSTRAP.md) 直接发给你的 AI，剩下的它来做

**零基础**：从 [TUTORIAL.md](TUTORIAL.md) 开始，一步步跟着做

**第一次接触**：README.md（本文件） → [docs/01-架构总览.md](docs/01-架构总览.md) → [sops/03-new-session-onboarding.md](sops/03-new-session-onboarding.md)

**开始使用**：复制 [templates/](templates/) → 按 [sops/03](sops/03-new-session-onboarding.md) 的 A/B/C 场景开第一个会话

**深入理解**：按需阅读 [docs/](docs/) 和 [sops/](sops/) 中的文档

**查阅约束**：遇到边界问题查 [AI-CONSTRAINTS.md](AI-CONSTRAINTS.md)

## 常见问题

**Q: 这和 GitHub Copilot / Cursor 有什么区别？**

Copilot / Cursor 是代码补全工具，每次对话独立。本工作流解决的是跨会话记忆接续、多 Agent 协作、架构级决策闭环的问题。两者可以并行使用。

**Q: 必须用 Claude Code 吗？**

本方法论围绕 Claude Code 设计（利用其 Sub-Agent、plan mode、compact 等原生能力），但核心思想（HANDOFF 接续、MEMORY 持久化、约束体系）可以适配其他 Agent 工具。

**Q: 手里的项目已经写了一半，还能接入吗？**

可以。按 [sops/05-多板块项目局部接入](sops/05-modular-localization.md) 操作，不需要推倒重来。

**Q: self-iteration 系统安全吗？**

安全。第 5 步（Apply 到 CLAUDE.md / MEMORY.md）必须人类批准，Agent 不能跳过。详见 [self-iteration/README.md](self-iteration/README.md) 的安全护栏。

**Q: 必须装 hooks 吗？**

不必须。核心工作流纯 Markdown 零依赖。当你发现某条规范"写进文档还是反复被违反"时，再按 [sops/09](sops/09-hook-guards.md) 把它机器化。

## 贡献指南

这是一个个人方法论仓库，欢迎参考和使用。如果你有改进建议：

1. Fork 本仓库
2. 创建你的特性分支
3. 提交 Pull Request 并说明改进理由

由于这是方法论文档而非代码项目，请确保任何修改都有明确的实践依据。

## 许可证

[MIT License](LICENSE) - Copyright (c) 2026 Harly

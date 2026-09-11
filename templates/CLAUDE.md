# CLAUDE.md

> 项目级行为约定。每次会话 Claude Code 都会自动加载本文件。
> 把项目独有的约定、口味、踩过的坑写在这里，可以避免反复给 Agent 解释同样的事。
>
> **本文件是"开箱可用 + 占位符"混合版**：通用约束已经预填，项目特定部分用 `<...>` 标记。复制后按项目情况裁剪即可。
>
> 跨项目约束的完整版见 [../AI-CONSTRAINTS.md](../AI-CONSTRAINTS.md)。

## 项目定位

<一两句话：这是什么项目、谁在用、当前阶段。例：个人博客系统，自己日常发文+做小游戏 epic 验证，当前 phase F-15>

## 技术栈

- 语言/框架：<例：Next.js 14 + TypeScript>
- 包管理器：<例：npm>
- 数据库：<例：Postgres + Prisma>
- 测试框架：<无 / jest / vitest / 自建 .mjs（见 sops/06）>
- 部署目标：<例：自管 VPS + Nginx + PM2>

## 强约束（违反会破坏项目）

通用（建议保留）：

- used 控制 90% 以内，过了立刻 `/clear` 重开
- 一次只改一个小点，30 分钟内收尾，超时 `/clear`
- 改数值 / 枚举 / 路径必须 grep 全文同步 UI 文案 / dashboard / 文档
- 改 core 模块对外接口必须全仓同步所有调用方
- commit 前 `git diff --cached` 扫一眼，禁止带入 `.env` / secret / 二进制大文件
- 跨板块新增 import / 改 DB schema 必须先聊架构再动手

项目特定（自己填）：

- <例：所有数据库迁移必须可回滚>
- <例：禁止在客户端日志中输出 token>
- <例：UI 文案必须走 i18n，不允许硬编码>
- <例：游戏数值改动后必须更新 数值表.xlsx 并 commit>

## 偏好（不会破坏项目，但希望遵循）

通用（建议保留）：

- 优先编辑现有文件，不要无理由新增
- 注释保持极简，命名能说明的事不写注释
- 默认不加 emoji（包括 UI 文案 / 代码 / commit msg）
- UI / 前端改动后启动 dev server 实测再报告完成
- plan mode 选项默认 `recommend`，detail 明写"不推荐"才避开
- 注释只在 WHY 非显然时写（隐藏约束 / 微妙不变量 / 绕过特定 bug）

项目特定：

- <例：API route 错误统一走 `lib/error.ts` 的 `ApiError`>
- <例：颜色用 `tokens.color.*` 不要硬编码 hex>

## 不要做的事

破坏性 / 不可逆（建议保留）：

- 不主动 `git push --force` / `git reset --hard` / `rm -rf`
- 不跳过 git hooks（`--no-verify` / `--no-gpg-sign`）
- 不让 Agent 自己改 spec / AGENT.md / CLAUDE.md（这些只由用户改）
- 不在生产 DB 上跑 Agent 直接生成的命令（给模板让用户跑）

信任 / 报告（建议保留）：

- 不信 Agent 的"全面 OK / 项目评分上升"，自己跑 build / test 验
- 不要 Agent 给项目"全面分析报告"（compact 后是潜行记忆）
- 没 `file@line` 引用的结论 = 想象

工程边界（建议保留）：

- 不主动 refactor 未要求的代码
- 不为不会发生的边缘场景加 error handling / fallback
- 不在没确认的情况下升级主版本依赖
- 不添加 backwards-compatibility shim 除非用户明确要

凭据 / Secret（建议保留）：

- 不让用户把 PAT / API key / DB 密码贴进对话
- 给命令模板 + 配置文件路径，让用户自己改

项目特定：

- <例：不要把删除的代码留在仓库里以注释形式存在>
- <例：不要主动给 PWA manifest 加新字段>

## 关键命令

```bash
# 开发
<dev 命令，例：npm run dev>

# 构建（含 lint，不只是 tsc --noEmit）
<build 命令，例：npm run build>

# 测试
<test 命令，例：npm test / node scripts/test-*.mjs>

# 部署
<deploy 命令，例：./scripts/deploy.sh>
```

## 重要文件锚点

- `<path>` —— <作用，为什么重要>
- `<path>` —— <作用>
- `<path>` —— <作用>

## 历史决策（避免反复讨论）

> 已经讨论过的事不要重新讨论，浪费 context。需要重新讨论时由用户主动开启。

- <YYYY-MM-DD> 选择 X 而非 Y，因为 ...
- <YYYY-MM-DD> 数据持久化用 X，因为 ...
- <YYYY-MM-DD> 不引入 Y 框架，因为 ...

## INVARIANT 锚点（可选，详见 AI-CONSTRAINTS §10）

如果项目积累到 30+ commit 且出现"看起来 dead code 但删了会崩"的代码 → 建立 INVARIANT 体系。

- 锚点格式：`// INVARIANT-N：<规则> + <删了会咋样>。详见 docs/code-map.md §7`
- 集中索引：项目内 `code-map.md §7` 列所有锚点
- 当前项目锚点数：<N>（无则填 0）

## 协作模式

- **接续型工程**：每次会话结束前更新 HANDOFF.md（模板见 [HANDOFF.md](HANDOFF.md)）
- **关键合并节点**：建议触发多 Agent 评审（如 ultrareview）
- **重大架构决策**：列出选项，等待人类二选一
- **沉淀义务**：出现可迁移经验 → 工作收尾时**主动提醒**用户"要不要写进 MEMORY.md / CLAUDE.md?"（详见 [../sops/02 §5 learning](../sops/02-five-phase-lifecycle.md#5️⃣-learning结会话前必做)）

## 测试 / 验证守则

- `tsc --noEmit` 不够，必须完整跑 `npm run build`（含 lint pass）
- 纯数学公式 / helper 必须有测试（jest / vitest / `.mjs` 自测，见 [../sops/06](../sops/06-no-test-framework-self-test.md)）
- UI 改动必须启动 dev server 实测 golden path + 边缘 case + console 无报错
- 无法实测的项 → **显式声明**而不是宣布"完成"

## 项目特定的"已知陷阱"

> 这一段是踩坑笔记的项目内简版。一行一坑，链接到详细档案。

- <例：next-auth 在 server component 里读 session 要用 `getServerSession`，client 用 `useSession`，错了类型不会报但行为不一致>
- <例：Prisma migration 时如果有 long-running query 会卡死，先 `SELECT pg_terminate_backend(pid)` 清掉>

## 修订记录

- <YYYY-MM-DD> 创建。复制自 vibe-coding-workflow templates/CLAUDE.md，按本项目情况裁剪。

## 首次打开统一流程

首次打开 Codex 或 Claude 时，遵循 D:\AAA PROJECT\real-vibecoding-harries\操作手册\首次打开统一流程.md；该稳定入口当前指向 操作手册\打开Codex与Claude-首次统一流程-v2.md（v2.0）。

# 02 — 单模块开发的五段式 lifecycle

> 在已有项目里写一个 spec 模块时，把散落各处的动作正名为 5 个**显式 gate**：planning → building → checking → finishing → learning。**每个 gate 没过不准进下一段**。

## 五段式总览

```
planning  →  building  →  checking  →  finishing  →  learning
   ↑           ↑             ↑            ↑             ↑
plan mode    一次一模块    测试+自审    更新 HANDOFF  反馈进
对齐需求     30 分钟内     不信全面OK   写决策记录    MEMORY/CLAUDE
```

灵感来源：开源项目 Trellis 的五段式 lifecycle，针对 Markdown 长链接续做了调整。

## 一句话口诀

```
没 plan 不准 build
没 check 不准 finish
没 finish 不准 learn
没 learn 不准 /clear
```

---

## 1️⃣ Planning（开干前必做）

**做法**：`shift+tab` 进 plan mode → Agent 提问澄清 → 对齐实现细节 → `clear and implement`。

**这一步要确认 4 件事**：

- [ ] 模块的 acceptance criteria 已经从 spec 抄进对话（"什么算 done"）
- [ ] 边界确认（不动哪些文件 / 不改哪些既有行为）
- [ ] 关键决策点用户已拍板（不要 Agent 自作主张）
- [ ] 改动范围估算（行数 + 文件数，过大就再切一刀）

**不能跳过的理由**：没 plan 直接开干 = 全面实现的死路，30 分钟以上开始劣化（见 [01 §3](01-context-and-plan-rules.md#3-一次只改一个小点30-分钟以上效果开始劣化)）。

**通过条件**：用户说"开干 / go / 实现吧" —— 明确进入下一 gate。

---

## 2️⃣ Building（一次一模块，30 分钟内收尾）

**做法**：plan 通过后选 `recommend` → Agent 改代码 → 用户随时可叫停。

**这一步守 3 条**：

- [ ] **一次只做一个模块** —— 不接"顺手把 X、Y、Z 都改了"
- [ ] **30 分钟内收尾** —— 超时立刻 `/clear` 重开
- [ ] **used 控制 90% 以内** —— 逼近就停手 + `/clear`

**不能跳过的理由**：超时 = 失忆写的垃圾代码；一次多模块 = context 爆裂 + 互相串味。

**通过条件**：本模块代码写完 + Agent 自检 OK。

---

## 3️⃣ Checking（没过不准 finishing）

**做法**：跑最小测试（`npm test` / `npm run build` / 手动调一遍 UI）→ 必要时让 Agent 做局部自审。

**这一步确认**：

- [ ] 模块 acceptance criteria 全部满足（一项一项对照 spec 勾）
- [ ] 没破坏既有功能（跑相邻模块的回归测试或手动调一下）
- [ ] 没引入 lint / type 错误（`npm run build` 全套，不是只 `tsc --noEmit`）
- [ ] **不信** Agent 的"全面 OK / 一切正常"报告 —— 自己跑一遍

**不能跳过的理由**：跳过 checking 就 commit = "差不多了"心态，半年后回看会发现 bug 是这一刻种下的。

**通过条件**：测试全过 + 自己手动验过 acceptance criteria。

---

## 4️⃣ Finishing（没过不准 learning，没过不准 `/clear`）

**做法**：更新接续文档 + 留决策记录 + commit。

**这一步做 4 件事**：

- [ ] 更新接续文档，把"当前状态 / 下一步行动"按当下**改写**（不是往下堆）：
  - 轻量项目：项目根 `HANDOFF.md`（模板见 [templates/HANDOFF.md](../templates/HANDOFF.md)）
  - 中长线项目：档案目录的 `状态档案.md`（五件套见 [07](07-project-archive-five-piece.md)）
- [ ] 五件套项目：写一篇 `日志/YYYY-MM-DD-标题.md`，并**双写**覆盖根目录 `最新日志.md`
- [ ] 影响后续工程的决策记下来（带日期 + 理由 + "用户拍板"字样）
- [ ] 项目仓 commit + push（如有 git；`git add` 显式列文件，不用 `git add .`）

**不能跳过的理由**：跳过 finishing = 下次会话的 Agent 不知道当前在哪；半年后回看不知道这次为什么这么改。

**通过条件**：4 件事都做完。

---

## 5️⃣ Learning（结会话前必做）⭐

**做法**：Agent 在工作收尾时检查"本次有没有可迁移经验"，并按触发模型处理：

| 情况 | Agent 的动作 |
|------|-------------|
| 本次项目档案有写入、且用户建了经验仓 | **直接执行回送 + 告知**（四件套见 [08](08-experience-repo-and-writeback.md)），不再问"要不要" |
| 出现跨项目可迁移的新经验 | **主动开口**："这次的 X 经验要不要沉淀进 MEMORY.md / CLAUDE.md？" → 用户拍板 yes/no |
| 没有可沉淀的东西 | 明说"本次无新经验"，不静默跳过 |

**沉淀去向**：

- [ ] 跨项目通用的稳定规则 → `~/.claude/CLAUDE.md` 或 `MEMORY.md`
- [ ] 本项目独有的强约束 → 项目根 `CLAUDE.md` / `AGENT.md`
- [ ] 可复用模式（能搬去下个项目的） → 档案的 `vibe库资料.md`
- [ ] 单事件大坑 → 接续文档的"已知陷阱 / 小尾巴"段（一行一坑）
- [ ] 有经验仓的 → 回送四件套：磁盘 + 索引 + 体检 + 自描述（[08](08-experience-repo-and-writeback.md)）

**不能跳过的理由**：

- 跳过 = 经验只留在本次会话上下文里，下次会话压缩之后就丢了
- "每次都问"的结局是问烦了 → 静默跳过 → 漏沉淀；所以例行回送改为直接做 + 告知，**新经验**才需要拍板
- 让 Agent 反向把规则写进自己的指令集，正是 [docs/06 自我迭代机制](../docs/06-自我迭代机制.md) 的入口

**通过条件**：三种情况之一明确发生——回送已执行并告知 / 用户对沉淀提议拍了板 / Agent 明示本次无新经验。**唯一不合格的是静默**。

---

## 容易忘的细节

1. **plan mode 选项默认 `recommend`** —— 其它选项 detail 里明写"不推荐 / 大块复写"才避开
2. **30 分钟硬指标** —— 不是"差不多 30 分钟"，是 30 分钟过线就停
3. **不信 Agent 自己跑的全面 OK 报告** —— 自己跑一遍 build/test
4. **接续文档是 onboarding 的 source of truth** —— "当前状态 / 下一步行动"段不维护，下次接续就要花时间猜
5. **learning gate 由 Agent 主动执行/开口，不要等用户问**

## 不要做什么

- 跳过 planning 直接开干（30 分钟后效果开始劣化，回头还是要重做）
- 一个 thread 跨多个 gate 不 `/clear`（building 完不 clear 接 checking → context 串味）
- checking 时信 Agent 的"全面 OK" —— 自己跑一遍 build / 测试
- finishing 时只 commit 不更新接续文档（半年后不知道为什么这么改）
- learning 时静默跳过（回送直接做 + 告知；新经验主动问；没东西就明说）
- 把五段挤进一个会话（每段 30 分钟内，中间该 `/clear` 就 `/clear`）

## 修订记录

- 2026-06-10：finishing 升级为"接续文档双轨"（HANDOFF 轻量 / 五件套中长线）+ 日志双写；learning 改为"例行回送直接做+告知、新经验才拍板"的触发模型，对齐 [07](07-project-archive-five-piece.md)/[08](08-experience-repo-and-writeback.md)。
- 2026-05-16：每段补"通过条件"与"不能跳过的理由"，把散落动作（plan mode / 自审 / HANDOFF 维护 / 经验沉淀）正名为显式 gate。

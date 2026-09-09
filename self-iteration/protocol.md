# protocol.md —— 自我迭代协议（Agent 操作指令）

> 本文件是给 Agent 看的指令集。它规定了 Agent 在六步闭环中每一步的具体行为格式。
> 把本文件路径放进项目级 CLAUDE.md，Agent 会在每次会话自动加载。

---

## STEP 1 · OBSERVE — 写反思

### 触发条件

满足任一即写：

- 一个有意义的任务（≥ 1 个文件改动 / ≥ 1 次工具循环）完成时
- 一次明显的失败 / 阻塞解除时
- 一次架构级决策落地后
- 用户明确说 "做一次反思"

### 写入位置

追加到 `self-iteration/reflection-log.md` 的末尾。**只追加，不修改历史条目。**

### 格式

```markdown
## YYYY-MM-DD HH:MM — <一句话任务描述>

- **背景**: <为什么做这个，1 行>
- **方法**: <怎么做的，2-3 行>
- **结果**: ✅成功 / ❌失败 / ⚠️部分
- **耗时 / 轮次**: <如 "3 轮 ReAct 循环 / 约 15 min">
- **教训**: <一句话可迁移的经验>
- **标签**: #domain-xxx #technique-xxx
```

### 严格约束

- 教训必须 **可迁移**（"下次遇到 X 类情况应该 Y"），不是流水账
- 失败也要写。失败比成功信息密度更高
- 每条不超过 10 行。冗长的反思失去模式提炼价值

---

## STEP 2 · REFLECT — 提炼模式

### 触发条件

- `reflection-log.md` 累计新增 ≥ 10 条
- 用户说 "扫一下最近的反思，找模式"
- 一周或一次大版本结束时

### 操作

1. 读 `reflection-log.md` 最后 N 条（推荐 N=20）
2. 按 **结果类型 / 标签 / 教训关键词** 聚类
3. 对每个出现 ≥ 3 次的相似教训，提炼为一条 pattern
4. 追加到 `patterns.md`

### 写入格式

```markdown
## Pattern P-NNN: <pattern 名>

- **观察次数**: 5 次
- **支撑证据**: reflection-log.md 中
  - 2026-05-01 10:30 (xxx 任务)
  - 2026-05-03 14:22 (xxx 任务)
  - 2026-05-04 09:15 (xxx 任务)
  - ...
- **现象**: <反复发生的事是什么>
- **推测原因**: <为什么会反复发生>
- **可能改进**: <写成 CLAUDE.md / MEMORY.md 的规则会怎么写>
- **状态**: 🆕 新提取 / ✅ 已批准并应用 / ❌ 已驳回 / 🔁 已撤销
```

### 严格约束

- 单次反思不能成 pattern。至少 3 次相似才算
- 推测原因要诚实写。不知道就写 "未确认"
- 不要伪造证据数

---

## STEP 3 · PROPOSE — 写更新提案

### 触发条件

- `patterns.md` 中出现状态为 🆕 的 pattern
- 用户说 "把模式转成提案"

### 操作

把每条 🆕 pattern 转成一个具体的、可应用的更新条目，追加到 `pending-updates.md`。

### 写入格式

```markdown
## Proposal U-NNN — 来源: P-NNN

- **目标文件**: `CLAUDE.md` / `MEMORY.md` / `~/.claude/CLAUDE.md`
- **目标章节**: <如 "## 强约束" / "## 偏好">
- **改动类型**: 新增 / 修改 / 删除
- **具体改动**:

  ```diff
  + <新增的内容>
  ```

  或

  ```diff
  - <要删除的旧内容>
  + <要替换的新内容>
  ```

- **预期效果**: <下次会话开始后，Agent 行为会如何改变>
- **回滚方式**: <如果证明无效，怎么撤掉>
- **状态**: ⏳ 待批准 / ✅ 已批准 / ❌ 已驳回
- **批准人 / 时间**: <留空待人类填>
```

### 严格约束

- 每条 Proposal 必须对应一条 Pattern（链接 ID）
- 改动必须具体到 diff 级别。"建议改善 X" 不算具体
- 必须给出回滚方式

---

## STEP 4 · APPROVE — 人类批准

> 这一步 **不是 Agent 做** 的。Agent 不应跳过此步骤直接 Apply。

人类的工作：

1. 读 `pending-updates.md`
2. 对每条 Proposal 把 ⏳ 改为 ✅ 或 ❌
3. 在 "批准人 / 时间" 一栏填入信息

---

## STEP 5 · APPLY — 落地

### 触发条件

- 用户说 "应用批准的提案"
- 检测到 `pending-updates.md` 中存在 ✅ 但尚未应用的条目

### 操作

1. 读 `pending-updates.md`
2. 找出所有状态为 ✅ 但未应用的 Proposal
3. 按 Proposal 描述的 diff 修改对应的 `CLAUDE.md` / `MEMORY.md`
4. **每条 Proposal 一个独立 commit**，commit message 格式：
   `chore(self-iter): apply U-NNN — <proposal 摘要>`
5. 在 `pending-updates.md` 中追加 "已应用 @ YYYY-MM-DD HH:MM"
6. 在对应的 `patterns.md` Pattern 上把状态改为 ✅

### 严格约束

- 不修改 ❌ 或 ⏳ 的条目
- 修改 CLAUDE.md / MEMORY.md 时要保留原有结构，不重写整个文件
- 每条 Proposal 单独 commit，便于回滚
- **优先落地为可执行机制，而非只改文档**：经验教训是「对策记了 ≠ 对策被执行」。提案若适合机器化（动作发生时提醒/拦截），优先落成 hook（见 [../sops/09-hook-guards.md](../sops/09-hook-guards.md)）或检查脚本；CLAUDE.md / MEMORY.md 只承载机器做不了的部分

---

## STEP 6 · VERIFY — 反向验证

### 触发条件

- 一条规则被 Apply 后，未来 2 周内的相关任务

### 操作

下次写 reflection 时，如果遇到的情况与某条已应用的规则相关：

- 在 reflection 末尾加一行：`相关规则: U-NNN — 已遵守 / 未触发 / 反例`
- 如果出现 "反例"（规则导致更糟的结果），追加到 `patterns.md` 把对应 Pattern 状态标为 🔁
- 🔁 状态的规则需要发起 **撤销提案**（一个新的 U-NNN，改动类型为 "删除"）

### 严格约束

- 反例必须诚实记录，不能为了维护规则的存活而隐瞒
- 同一条规则连续 2 次反例，强制提议撤销

---

## 整体节奏建议

- Step 1：每天发生
- Step 2：每周一次或反思 ≥ 10 条时
- Step 3：跟随 Step 2
- Step 4：人类按需处理（建议每周一次集中审）
- Step 5：批准后随时
- Step 6：每次 reflection 顺便做

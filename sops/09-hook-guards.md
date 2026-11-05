# SOP 09 — Hook 守卫：把高频规范从文档约定增加操作时提醒

**适用场景**：工作流跑了一段时间后，发现某些规范**写进了 CLAUDE.md 还是反复被违反**，想让它们在动作发生的那一刻被机器自动提醒，而不是指望 Agent 每次自觉去读。

**何时不适用**：项目刚起步、规范还没稳定时。先让规范在文档里沉淀，**同一条规范复发 2 次以上**再考虑机器化。

**版本**：v1（2026-09-09，从真实经验仓脱敏同步）

---

## 0. 为什么需要这一层（核心动机）

一条被反复验证的 meta 教训：**"对策记了 ≠ 对策被执行"**。

真实案例：自测自欺的对策写得清清楚楚，下一批照样原样复发；"commit message 不加 emoji"被人工纠正了两次；"含中文的 .ps1 必须带 UTF-8 BOM"连续踩坑三次。共同病根不是"缺规范"，而是**规范只活在文档里，靠人/Agent 每次自觉去读去守，必然漏**。

规范成熟度三档：

```
口头约定  →  文档约定（CLAUDE.md / MEMORY.md，本仓大部分内容在这里）  →  自动提醒（本 SOP）
```

自动提醒补上操作时检查这一环：Claude Code 在动作发生时（PreToolUse / PostToolUse / Stop）自动调用脚本检查，不靠自觉。

本仓的 hook 全部属于 **advisory（警告/提醒，不阻断）**，不能保证规则执行。先用提醒跑一段时间观察误报率，将来再决定要不要升级成硬拦截。

---

## 1. 当前 hook 清单（4 个，全部 advisory 不阻断）

| 脚本 | 事件 | matcher | 触发条件 | 作用 |
|---|---|---|---|---|
| `warn-commit-emoji.ps1` | PreToolUse | `Bash` | 命令含 `git commit` 且 message 含 emoji | 提醒 commit message 纯文字约定 |
| `warn-git-add-all.ps1` | PreToolUse | `Bash` | 命令含 `git add .` / `-A` / `--all` | 提醒共享会话会带上他人 WIP，先 diff 再显式 add |
| `warn-ps1-no-bom.ps1` | PostToolUse | `Write\|Edit` | 刚写的 `.ps1` 含中文但无 UTF-8 BOM | 提醒 PS5.1 会按 GBK 解码致乱码，补 BOM |
| `remind-reflect.ps1` | Stop | （无） | 会话收尾，节流至多每 3 小时一次 | 轻提醒"有无可沉淀经验 → 追加 self-iteration/reflection-log.md" |

**全部铁律**：任何异常都 `exit 0` 静默；advisory 永不阻断动作；中文消息显式按 UTF-8 读写（见 §4）。

---

## 2. 安装（唯一对外触碰点：`~/.claude/settings.json`）

> hook 是行为层，settings.json 只是激活指针，随时可删可回滚，不碰任何项目文件。

在 `~/.claude/settings.json` 顶层加一个 `hooks` 键（与 `permissions` 等同级）。command 用单字符串形式（最通用），`-File` 指向本仓库脚本的**绝对路径**（路径含空格时必须双引号）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"D:\\path\\to\\vibe-coding-workflow\\hooks\\warn-commit-emoji.ps1\"" },
          { "type": "command", "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"D:\\path\\to\\vibe-coding-workflow\\hooks\\warn-git-add-all.ps1\"" }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          { "type": "command", "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"D:\\path\\to\\vibe-coding-workflow\\hooks\\warn-ps1-no-bom.ps1\"" }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"D:\\path\\to\\vibe-coding-workflow\\hooks\\remind-reflect.ps1\"" }
        ]
      }
    ]
  }
}
```

把 `D:\\path\\to\\vibe-coding-workflow` 换成本仓库在你机器上的实际路径。改完 settings.json 后**重启 / 重载 Claude Code 会话**使 hook 生效。

---

## 3. 关闭 / 升级

- **临时全关**：settings.json 顶层加 `"disableAllHooks": true`，或删掉整个 `hooks` 块。
- **关单个**：从对应事件数组里删掉那条 command。
- **觉得 Stop 提醒烦**：直接删 `Stop` 块，反思改回纯手动（对 AI 说"反思一下"）；也可改脚本里的 `$throttleHours` 调稀疏。
- **升级成硬拦截**（advisory → 阻断）：把输出里的 `permissionDecision` 从 `"allow"` 改成 `"deny"` 并补 `permissionDecisionReason`，或让脚本 `exit 2`（stderr 作为拦截理由回灌给 Agent）。**升级前必须先跑一段时间观察误报率**；这是改变工作流的动作，应走自我迭代提案 + 人审（见 [../self-iteration/protocol.md](../self-iteration/protocol.md)），不要随手改。

---

## 4. 容易忘的细节（编码三坑，Windows 必读）

- **stdin 必须显式按 UTF-8 读**：`[Console]::In` 用的是控制台输入编码，中文 Windows 上多半是 GBK，会把 Claude Code 喂进来的 UTF-8 JSON（commit message 常含中文/emoji）读乱，正则就匹配不到。脚本统一用 `StreamReader(OpenStandardInput, UTF8)`。
- **stdout 同理显式按 UTF-8 写**：否则中文提醒回灌给 Agent 时乱码。脚本统一用 `OpenStandardOutput` 写 UTF-8 字节。
- **脚本自身含中文 → 文件必须存成 UTF-8 带 BOM**：Windows PowerShell 5.1 对无 BOM 的 .ps1 按 GBK 解码，中文注释/字符串会乱、引号会被吃、直接解析失败。很多编辑器（和 AI 的写文件工具）默认无 BOM，写完要重存。本目录脚本已带 BOM。

---

## 5. 测试（改脚本后回归）

PowerShell 5.1 不支持 `<` 输入重定向，用 Bash 喂 stdin：

```bash
cd hooks/
# 造一个含 emoji 的 commit JSON（UTF-8 无 BOM）存成 test.json 后：
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "warn-commit-emoji.ps1" < test.json
```

期望：该触发的输出一行 `{"hookSpecificOutput":...}` JSON；不该触发的无输出（静默 `exit 0`）。
造测试 JSON 时注意：PowerShell 管道 `|` 喂不到子进程的真 stdin，必须写文件 + Bash 重定向。

---

## 6. 与其它文档的关系

- hook 机器化的规范，源头是各条踩坑经验与 [../AI-CONSTRAINTS.md](../AI-CONSTRAINTS.md) 的约束体系——hook 是这些规范的**执行层**，不是新规范。
- 新增 / 升级 hook 的提案，走 [../self-iteration/](../self-iteration/) 的六步闭环（反思 → 模式 → 提案 → **人审** → 落地 → 验证）。
- 自我迭代的 Apply 步骤有一条配套原则：**提案优先落地成 hook / 检查脚本这类可执行机制，而不是只改文档**——直接对治"对策记了 ≠ 对策被执行"。

---

## 不要做什么

- ❌ 规范第一次被违反就急着上 hook（先文档化，复发 2 次再机器化，否则误报和规则 churn 会淹没收益）
- ❌ 一上来就上硬拦截（deny / exit 2）。advisory 跑稳、误报率摸清之前，阻断只会制造阻塞
- ❌ 让 hook 抛错或非零退出。任何异常都必须 `exit 0` 静默——守卫自己先崩了比没有守卫更糟
- ❌ 在 hook 里做重活（网络请求、大文件扫描、写数据库）。hook 在每次工具调用上同步执行，慢 hook = 全程拖速
- ❌ 绕过自我迭代提案流程随手改 hook 行为。hook 改变的是每一次会话的行为边界，必须留人审闸门

---

## 修订记录

- 2026-09-09：创建 v1。从真实经验仓同步：把"对策记了 ≠ 对策被执行"的短板用 advisory hook 补上。首批 4 个：commit-emoji / git-add-all / ps1-no-bom / remind-reflect，全部不阻断。

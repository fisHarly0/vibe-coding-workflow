# self-iteration —— 跨会话自我迭代系统

> 让 Agent 改善 "下一次会话的自己" 的可运行原型。
> 设计原理见 [docs/06-自我迭代机制.md](../docs/06-自我迭代机制.md)。

## 文件清单

| 文件 | 角色 | 谁写 | 谁读 |
|------|------|------|------|
| `protocol.md` | Agent 应遵循的指令集 | 人类（一次性） | Agent（每次会话） |
| `reflection-log.md` | 任务反思日志（append-only） | Agent | Agent + 人类 |
| `patterns.md` | 提炼出的模式 | Agent | Agent + 人类 |
| `pending-updates.md` | 待批准的更新提案 | Agent | 人类（必须审核） |

## 完整闭环（六步）

```
任务结束
   │
   ├─[1]→ Agent 追加 reflection-log.md
   │
   ├─[2]→ Agent 周期性扫描日志 → 写 patterns.md
   │
   ├─[3]→ Agent 把模式转成提案 → 写 pending-updates.md
   │
   ├─[4]→ 人类逐条 ✅/❌ 标记 pending-updates.md
   │
   ├─[5]→ 批准的条目合入 CLAUDE.md / MEMORY.md
   │
   └─[6]→ 下次会话生效，新一轮反思验证规则
            │
            └─→ 回到 [1]
```

## 启动顺序

不要一上来就开全部六步。建议：

1. 先只跑第 1 步，攒 20+ 条反思
2. 然后手动触发 2-3，检查 Agent 提炼模式的质量
3. 满意后再让闭环跑通到 5
4. 第一次 Apply 严格审核，宁少勿滥

## 调用入口

在主对话里直接说：

- "**做一次反思**" → 触发第 1 步
- "**扫一下最近的反思，找模式**" → 触发第 2 步
- "**把模式转成提案**" → 触发第 3 步
- "**应用批准的提案**" → 触发第 5 步

或者把这些行为写进 `CLAUDE.md`，让 Agent 在合适时机自主触发。

## 安全护栏

- **第 5 步必须人类批准**。Agent 不能跳过批准直接改 CLAUDE.md / MEMORY.md。
- **每次 Apply 都要 git commit**，留下完整变更链。
- **patterns.md / pending-updates.md 的所有条目要带证据**（链接到 reflection-log 的具体条目）。
- **支持回滚**：如果某条规则在 Verify 阶段被证明无效，必须能干净地从 CLAUDE.md / MEMORY.md 中移除。

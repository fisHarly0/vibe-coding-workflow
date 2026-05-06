# MEMORY.md（脱敏示例）

> 真实 MEMORY 索引片段，已脱敏。展示 [templates/MEMORY.md](../templates/MEMORY.md) 在长期使用中的形态。

## 用户档案

- [角色与技术背景](user_role.md) — 独立开发者，关注 AI 工程化与个人项目长期维护
- [偏好邮箱](user_email_preference.md) — 主邮箱用于注册类，gmail 仅作为绑定备份
- [回复风格偏好](user_reply_style.md) — 简洁直接，不需要总结上文，重要选项请列出对比

## 协作约定

- [代码语言偏好](feedback_language_choice.md) — 个人项目优先 Plain JS，TypeScript 仅在团队场景使用
- [架构选择倾向](feedback_architecture.md) — 偏好少依赖、可迁移、可读性 > 性能（除非真有瓶颈）
- [测试策略](feedback_testing.md) — 关键路径必须有集成测试，UI 层手动验证可接受

## 项目档案

- [活跃项目清单](project_active_projects.md) — 三个并行项目的入口与状态
- [net-blog](project_net_blog.md) — LIVE @ hlhaya.cn，正在做存档归档
- [闲置农场 Godot 版](project_idle_farm.md) — 主开发分支在 D 盘，接续读 HANDOFF.md
- [TripStar 本地化](project_tripstar.md) — 本地部署完成，LLM 重试补丁在 .venv 里

## 外部参考

- [文档与笔记位置](reference_docs.md) — 长文档在 Notion，临时笔记在桌面
- [常用资源](reference_resources.md) — 字体、图标、配色等资源的固定来源

---

## 关于本索引的注释（脱敏说明）

下面这部分是本展示文件特有的，不是真实 MEMORY.md 的一部分，用于解释设计决策：

1. **每条目一行**：违反这一条的代价是 MEMORY.md 超过 200 行被截断，丢失尾部记忆
2. **指向独立文件**：详细内容拆出去是为了 Agent 能按需加载，不让所有记忆每次都进上下文
3. **类型前缀（user/feedback/project/reference）**：来自记忆系统的语义分类，用于决定 Agent 在什么场景该读哪条
4. **没有日期戳**：MEMORY 是 "当前快照"，不是日志。过时就更新或删除

更详细的设计原理见 [docs/02-长链记忆体系.md](../docs/02-长链记忆体系.md)。

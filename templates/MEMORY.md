# MEMORY.md

> 用户级长期记忆索引。本文件**只是索引**，每条目对应一个独立 .md 文件存放详细内容。
> Agent 在每次对话中自动加载本文件，按需读取具体记忆。

<!--
保持本文件简洁。每条目一行，控制在 150 字符以内：
- [Title](file.md) — one-line hook

避免：
- 把详细内容直接写在这里（拆到独立文件）
- 重复或过期条目（发现就更新或删除）
- 超过 200 行（会被截断）
-->

## 用户档案

- [角色与背景](user_role.md) — 独立开发者，关注 AI 工程化落地
- [偏好邮箱](user_email_preference.md) — 主邮箱与备用邮箱
- [工作风格](user_style.md) — 偏好简洁回复、关键节点确认

## 反馈与协作约定

- [代码风格偏好](feedback_code_style.md) — 注释极简、不要无理由抽象
- [回复风格偏好](feedback_reply_style.md) — 不要冗长总结
- [架构选择倾向](feedback_architecture.md) — 偏好少依赖、可迁移

## 项目档案

- [活跃项目清单](project_active_projects.md) — 当前并行的所有项目入口
- [项目 A 状态](project_a.md) — &lt;一句话当前状态&gt;
- [项目 B 状态](project_b.md) — &lt;一句话当前状态&gt;

## 外部参考

- [文档位置](reference_docs.md) — 项目外的资料分别在哪
- [常用资源](reference_resources.md) — 收藏夹级别的链接清单

<!--
什么不该写在这里：
- 代码模式、目录结构、文件路径（读项目就能得到）
- 最近的 commit、谁改了什么（git log 是权威）
- 临时的会话内任务进度（用 HANDOFF.md）
- 已经在 CLAUDE.md 里的内容
-->

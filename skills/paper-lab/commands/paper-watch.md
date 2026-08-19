---
description: arXiv 主题订阅与追新 digest
argument-hint: <主题关键词，如 "speculative decoding">
---

# /paper-watch：arXiv 追新

输入：`$ARGUMENTS`（主题关键词）。

## 1. 登记/更新订阅

用 `arxiv` MCP `watch_topic` 保存主题（同主题重复执行为更新，不会重复登记）。

## 2. 生成 digest

用 `check_alerts` 获取新论文，逐篇读 `get_abstract`，产出 `topics/<主题slug>/watch-digest-YYYYMMDD.md`：

- 新论文清单：| 标题 | 作者 | 日期 | 摘要一句 | 值得深读？ |
- 筛选标准：与方法主线相关 / 声称的增量是否可信 / 与 AGENTS.md `research_fields` 的契合度
- **推荐精读**：0-3 篇，各给一句理由；值得落库的直接下载登记 registry（状态`待读`）

## 3. 定时运行（可选，仅在用户明确要求时配置）

用户要求周期追新时，用宿主环境的定时任务能力（如 ZCode 的 CronCreate）创建定时任务（如每周一 09:00），prompt 写明：进入论文工作台目录执行 /paper-watch <主题> 流程并汇总。**不要未经要求自行创建定时任务。**

## 4. 汇报

本期新论文数量 / 推荐清单 / 已落库条目 / 下次 digest 建议。

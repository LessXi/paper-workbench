---
description: 多源检索论文 → 初筛打分 → 下载落库 → 登记台账
argument-hint: <关键词/研究问题/arXiv ID/整理inbox>
---

# /paper-find：检索与落库

输入：`$ARGUMENTS`。先读 AGENTS.md 的目录与登记约定，再执行以下流程。

## 1. 意图识别

- 研究问题/关键词 → 走检索流程
- arXiv ID（如 1706.03762）→ 直接定位下载
- "整理inbox" → 跳到第 4 步捡拾 `inbox/` 中的 PDF

## 2. 多源检索

- `paper-search` MCP 的 `search_papers`：广度检索（Semantic Scholar/OpenAlex/Crossref 等），按引用量辅助判断影响力
- `arxiv` MCP 的 `search_papers`：arXiv 深度检索（可限定分类如 cs.LG、eess.SP）
- 读工作区 AGENTS.md 的 `research_fields`，同一问题按各方向换用不同社区的检索词（如 AI 方向 "on-device inference"、系统方向 "model compression embedded"）
- **无 MCP 环境兜底**（如未装 MCP 的 agent）：用宿主的网页检索/抓取能力直接查 arxiv.org、Semantic Scholar；下载用 `curl -L -o paper.pdf "https://arxiv.org/pdf/<id>"`
- 必要时用 WebSearch 补充（Papers with Code、会议最佳论文）

## 3. 初筛打分

汇总为一张表：| 标题 | 作者/机构 | 年份 | 来源 | 被引 | 摘要要点（一句） | 推荐 |，分三档：

- **必读**（核心相关/高影响力）⭐ / **备读**（有参考价值）/ **跳过**（说明理由）

呈现给用户确认要下载哪些；用户不在交互细节时默认只下载"必读"档。

## 4. 下载落库

对每篇确认的论文：

1. 下载 PDF：优先 `arxiv` MCP `download_paper`（arXiv 论文，同时得到 HTML→MD）；其次 `paper-search` 的 `download_with_fallback`；无 MCP 时 `curl -L` 直拉；均失败（订阅墙）→ 告知用户用浏览器下载后放入 `inbox/`，或征得同意后用宿主的浏览器自动化能力（如 browser-use 技能）半自动获取
2. 建目录 `library/YYYY-短slug/`，PDF 存为 `paper.pdf`
3. 在 `registry.md` 表格首行登记：目录、标题、来源/ID、年份、领域、状态`待读`、评分、摘要一句话

## 5. 汇报

输出：本次检索总数 / 各档数量 / 落库清单（路径）/ 未获取的论文与原因 / 建议下一步（`/paper-read` 首选哪篇）。

---
description: 解析论文并三遍精读，产出结构化笔记并同步 Obsidian
argument-hint: <library目录名 | 论文关键词 | arXiv ID>
---

# /paper-read：三遍精读

输入：`$ARGUMENTS`。定位论文：先在 `registry.md` 模糊匹配，再列 `library/` 目录；未落库则提示先 `/paper-find`。方法论与领域侧重以 AGENTS.md 为准。

## 1. 解析（若 paper.md 不存在）

```bash
.zcode/tools/.venv/Scripts/python .zcode/tools/parse_paper.py "library/<目录>/paper.pdf"
```

- 首次运行会下载模型（数百 MB），耐心等待，勿中断换方案
- MinerU 失败或超时 → `--engine fast` 兜底生成 `paper.fast.md`
- arXiv 论文可配合 `arxiv` MCP：`get_paper_latex_section` 直接读作者源码中的公式/表格，比 PDF 解析更可靠；`get_abstract` 补元数据

## 2. 三遍读法

**第一遍·概览**：读标题/摘要/所有图表标题/结论 → 一句话总结 + 是否值得继续（不值得则记简版笔记，更新台账为跳过）。

**第二遍·精读**（按 paper.md 逐节）：

- 动机与问题定义：解决什么问题，为什么现有方案不行
- 方法：每个核心公式逐符号推导，标注张量维度；关键设计选择及理由
- 实验：每张表/图回答"证明了什么假设"；消融实验逐项解读
- 图表理解：把 `images/` 中的关键图在回复中引用本地路径（vision hook 会生成描述辅助你），复杂架构图必须看图核对文字理解

**第三遍·批判**：隐含假设 / 实验漏洞 / 可复性（开源？数据可得？算力需求？CPU 能否复现？）/ 与用户研究方向（AGENTS.md `research_fields`）的关联 / 开放问题。

## 3. 产出精读笔记（文件名 = 论文标题.md）

按 `.zcode/templates/精读笔记模板.md` 写 `library/<目录>/<论文标题>.md`。要求：

- 公式用 LaTeX 块，标注维度
- 关键图表链接 `images/` 相对路径
- "与我研究的关联"必须具体，不写空话

## 4. 引用与沉淀

1. BibTeX 追加到 `refs.bib`（arXiv 论文用 `arxiv` MCP `export_citations`）
2. 笔记已在 vault 内（工作区即 Obsidian 仓库），直接补 wikilink：[[论文标题]] 关联相关论文、[[概念名]] 关联 `概念卡/`（新概念建议建卡）。Obsidian 正在运行时可用 obsidian-cli 做搜索与反链查询
3. `registry.md` 更新：状态`已读`、评分、摘要一句话

## 5. 汇报

给用户：一句话总结 / 三个关键发现（方法层面）/ 主要局限 / 建议下一步（`/paper-cite` 扩展阅读？`/paper-reproduce`？写入哪个概念卡？）。

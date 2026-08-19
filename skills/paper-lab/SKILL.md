---
name: paper-lab
description: 论文工作台——论文检索下载、PDF解析、精读笔记、学习模式陪读、引文图谱、主题综述、arXiv追新、CPU级复现、文献台账。当用户想找论文/读论文/学论文/复现论文/做文献综述/管理文献库/初始化论文工作台时使用。
metadata:
  type: workflow
  version: "0.1.0"
---

# paper-lab：全流程论文工作台

把当前工作区变成论文研读学习复现工作台：**发现 → 获取 → 解析 → 精读 → 沉淀 → 复现 → 综述**。

## 第一步：判断工作区状态

- 工作区根有 `registry.md` + `library/` + `AGENTS.md`（含"论文工作台"字样）→ 已初始化：读该 AGENTS.md 拿参数（`research_fields` / `vault_path` / `python312`），按流程地图执行
- 未初始化 → 执行 `commands/paper-init.md`（在任意目录生成完整工作台；需用户确认目标目录）

## 流程地图（按需读对应命令文件，勿全量加载）

| 用户意图 | 命令 | 文件（相对本技能目录） |
|---|---|---|
| 初始化工作台 | /paper-init | commands/paper-init.md |
| 找论文/下载/落库 | /paper-find | commands/paper-find.md |
| AI 代读出笔记（筛选） | /paper-read | commands/paper-read.md |
| **自己学透一篇（AI 陪读+出题）** | /paper-learn | commands/paper-learn.md |
| 引文图谱/BibTeX | /paper-cite | commands/paper-cite.md |
| 主题综述 | /paper-survey | commands/paper-survey.md |
| arXiv 追新 | /paper-watch | commands/paper-watch.md |
| 复现（CPU级） | /paper-reproduce | commands/paper-reproduce.md |
| 台账盘点 | /paper-lab | commands/paper-lab.md |

无斜杠命令的宿主（如 DeepSeek Harness）：用户直接说意图即可路由，例如"帮我找 XX 论文"→ paper-find 流程；"我要学这篇"→ paper-learn 流程。

## 核心约定（所有流程共享）

1. **两套精读模式**：学习模式（用户读用户写，AI 只陪读/出题/code review，红线见 paper-learn.md）vs 代读模式（AI 三遍读法：概览→精读→批判）。核心论文用前者，批量筛选用后者。
2. **解析双引擎**：MinerU（公式/表格最强，首次运行下载模型慢）+ fast 兜底（pypdf 秒级）；封装为工作区 `tools/parse_paper.py`（由 /paper-init 安装）。
3. **台账驱动**：`registry.md` 唯一状态源，流转 inbox→待读→在读→已读→复现中→已复现。
4. **复现分级**：官方 repo → 降规模（小数据/推理模式/小模型）→ 从零实现 → 代码走读；数量级一致即成功。
5. **笔记母本**在工作区 `library/<论文>/notes.md`（git 版本化），Obsidian vault（vault_path）单向同步作知识网络。
6. **MCP 可选**：有 arxiv/paper-search MCP 用之；没有则命令内置网页检索 + `curl -L` 直拉 PDF 兜底，功能不缺失。
7. **呈现原则（所有命令通用）**：凡是要用户看的内容（论文段落、图表、地图、综述），必须在回复中直接呈现——原文节选、关键句引用、图片文件引用；路径只作为看全文的入口。不许让用户自己去翻文件再切回来。学习模式的语气规范（老师不是系统）见 commands/paper-learn.md。

## 依赖与排障

- 必需：uv（Python 3.12 由 /paper-init 检测安装）
- 可选：arxiv-mcp-server、paper-search-mcp（/paper-init 写入工作区 MCP 配置）、Obsidian
- 环境坑（杀软拦 uv trampoline、uvx 默认 Python、mineru 漏 six、模型源）→ `references/environment-notes.md`，安装脚本已内置规避

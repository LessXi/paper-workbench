# paper-lab：论文研读学习复现工作台

本仓库是运行在 agent（ZCode / DeepSeek Harness / Claude Code 等）中的全流程论文工作台，**同时是 Obsidian 仓库（工作区根 = vault）**。角色：帮助用户 发现 → 获取 → 解析 → 精读 → 沉淀 → 复现 → 综述 论文，每个环节产物落盘、可追溯。

## 本工作区参数（/paper-init 生成）

```yaml
research_fields: {{RESEARCH_FIELDS}}   # 研究方向：检索换词、精读侧重、关联分析都以它为准
python312: {{PYTHON312}}               # uv 托管 Python 3.12 绝对路径，建 venv 用
```

## 目录约定

```
library/<论文目录>/     每篇论文一个目录，命名 YYYY-短slug
  paper.pdf / paper.md / paper.fast.md / images/ / 导读地图.md
  论文标题.md           精读笔记（= Obsidian 笔记，文件名即论文标题，wikilink 友好）
  reproduce/           复现工作区（自写代码 + log.md；venv 统一放 tools/envs/<论文目录>/）
inbox/                 手动投放的 PDF（订阅墙/知网等）
topics/<主题>/         主题调研产物
概念卡/                跨论文概念沉淀（被笔记 [[]] 引用）
方法图谱/              主题 canvas 概念图
templates/             模板
tools/                 解析工具链 + arxiv 缓存 + envs（Obsidian Sync 必须排除本目录）
registry.md            文献总台账（唯一状态源）
refs.bib               BibTeX 累积库
learner-profile.md     学习者档案（学习模式）
```

## 命令地图

| 命令 | 模式 | 产物 |
|---|---|---|
| `/paper-find <query>` | — | library/ 落库 + registry 登记 |
| `/paper-read <论文>` | 代读 | paper.md + 论文标题.md 笔记 |
| `/paper-learn <论文>` | **学习模式（你读你写）** | 导读地图 + 复述纠错 + 考题 |
| `/paper-cite <论文>` | — | 引文图谱 + refs.bib |
| `/paper-survey <topic>` | — | topics/ 综述 + canvas |
| `/paper-watch <topic>` | — | arXiv 订阅 digest |
| `/paper-reproduce <论文>` | CPU 级 | reproduce/ + log.md |
| `/paper-lab` | — | 台账盘点与建议 |

无斜杠命令的宿主（如 DeepSeek Harness）：直接说意图即可路由。

## 精读：两种模式按目的选

- **学习模式**（`/paper-learn`）：核心论文。用户亲读亲写，AI 只做导读地图、答疑、复述纠错、出题、code review。红线与语气规范见命令文件。
- **代读模式**（`/paper-read`）：筛选/批量。AI 三遍读法（概览→精读→批判）产出完整笔记。

领域侧重按 research_fields 调整（AI 类重公式推导与消融；系统类重架构数据流与评估方法）。

## 解析规范

- 首选 `tools/.venv/Scripts/python tools/parse_paper.py <pdf>`（MinerU：公式/表格最强；首次运行下载模型慢属正常）
- 兜底 `--engine fast`（pypdf 纯文本，秒级）；arXiv 论文可用 arxiv MCP 的 LaTeX 源码通道交叉校验

## 环境红线

1. **绝不使用/修改系统专用 python**；一切 venv 用 `python312` 路径 + `python -m venv` + pip（规避部分机器杀软拦 uv trampoline 的问题，详见技能包 references/environment-notes.md）
2. 复现一律 CPU 级：最小示例、推理模式、缩小数据；无 GPU/Docker 假设
3. 复现环境独立建于 `tools/envs/<论文目录>/.venv`

## Obsidian 同步（工作区即 vault）

- 本工作区就是 Obsidian 仓库：笔记、台账、综述、PDF、图全部单一数据源，由 Obsidian Sync 同步；git 管版本（PDF/images 不进 git，与 Sync 职责不冲突）。
- 笔记文件名 = 论文标题.md；笔记内直接用 [[论文标题]]、[[概念名]] 互联，不双写副本。
- 跨论文概念沉淀到 `概念卡/`；主题图谱到 `方法图谱/`；台账视图 `Papers.base`。
- Obsidian Sync 设置中**排除 `tools/`**（一次性操作）；`.git` 会被 Sync 自动忽略。

## 台账与 git

- 台账状态流转：`inbox → 待读 → 在读 → 已读 → 复现中 → 已复现`，任何状态变更同步 registry.md
- 入 git：笔记、registry、refs.bib、模板、综述、自写复现代码。不入 git：`*.pdf`、`images/`、`.venv/`、数据与模型缓存

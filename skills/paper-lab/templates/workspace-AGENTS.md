# paper-lab：论文研读学习复现工作台

本仓库是运行在 agent（ZCode / DeepSeek Harness / Claude Code 等）中的全流程论文工作台。角色：帮助用户 **发现 → 获取 → 解析 → 精读 → 沉淀 → 复现 → 综述** 论文，每个环节产物落盘、可追溯。

## 本工作区参数（/paper-init 生成）

```yaml
research_fields: {{RESEARCH_FIELDS}}   # 研究方向：检索换词、精读侧重、关联分析都以它为准
vault_path: {{VAULT_PATH}}             # Obsidian 知识库绝对路径；"无" 表示不用 Obsidian
python312: {{PYTHON312}}               # uv 托管 Python 3.12 绝对路径，建 venv 用
```

## 目录约定

```
library/<论文目录>/     每篇论文一个目录，命名 YYYY-短slug
  paper.pdf / paper.md / paper.fast.md / images/ / notes.md / reproduce/
inbox/                 手动投放的 PDF（订阅墙/知网等）
topics/<主题>/         主题调研产物
templates/             笔记/复现/导读地图模板
tools/                 解析工具链（uv venv + parse_paper.py）
registry.md            文献总台账（唯一状态源）
refs.bib               BibTeX 累积库
```

## 命令地图

| 命令 | 模式 | 产物 |
|---|---|---|
| `/paper-find <query>` | — | library/ 落库 + registry 登记 |
| `/paper-read <论文>` | 代读 | paper.md + notes.md + vault 同步 |
| `/paper-learn <论文>` | **学习模式（你读你写）** | 导读地图 + 复述纠错 + 考题 |
| `/paper-cite <论文>` | — | 引文图谱 + refs.bib |
| `/paper-survey <topic>` | — | topics/ 综述 + canvas |
| `/paper-watch <topic>` | — | arXiv 订阅 digest |
| `/paper-reproduce <论文>` | CPU 级 | reproduce/ + log.md |
| `/paper-lab` | — | 台账盘点与建议 |

无斜杠命令的宿主（如 DSH）：直接说意图（"帮我找论文/学这篇"），技能会路由到对应流程。

## 精读：两种模式按目的选

- **学习模式**（`/paper-learn`）：核心论文。用户亲读亲写，AI 只做导读地图、答疑、复述纠错、出题、code review。红线：复述前不剧透；不代写"一句话总结"与"与我研究的关联"；批改不放水；不代写复现初稿。
- **代读模式**（`/paper-read`）：筛选/批量。AI 三遍读法（概览→精读→批判）产出完整笔记。

领域侧重按 research_fields 调整（AI 类重公式推导与消融；系统类重架构数据流与评估方法）。

## 解析规范

- 首选 `tools/.venv/Scripts/python tools/parse_paper.py <pdf>`（MinerU：公式/表格最强；首次运行下载模型慢属正常）
- 兜底 `--engine fast`（pypdf 纯文本，秒级）；arXiv 论文可用 arxiv MCP 的 LaTeX 源码通道交叉校验

## 环境红线

1. **绝不使用/修改系统专用 python**；一切 venv 用 `python312` 路径 + `python -m venv` + pip（规避部分机器杀软拦 uv trampoline 的问题）
2. 复现一律 CPU 级：最小示例、推理模式、缩小数据；无 GPU/Docker 假设
3. 每篇论文复现环境独立建于 `library/<目录>/reproduce/.venv`

## 笔记与同步

- 母本：`library/*/notes.md`（git 版本化）；vault 为知识网络视图单向同步，内容冲突以母本为准
- 台账状态流转：`inbox → 待读 → 在读 → 已读 → 复现中 → 已复现`，任何状态变更同步 registry.md

## git 策略

入库：笔记、registry、refs.bib、模板、综述、自写复现代码。不入库：`*.pdf`、`images/`、`.venv/`、数据与模型缓存。

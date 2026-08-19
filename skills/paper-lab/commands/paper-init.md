---
description: 一键把当前（或指定）目录初始化为论文工作台：数据层（Obsidian 可同步）+ 框架层（.zcode 点目录，Obsidian 不碰）
argument-hint: [目标目录，默认当前目录] [--lite 轻量环境] [--no-vault 不启用 Obsidian]
---

# /paper-init：初始化 / 恢复论文工作台

分层原则：**数据走同步（Obsidian Sync），框架走 GitHub（本技能包仓库）**。工作区里只放论文相关数据；框架在工作区的唯一落点是 `.zcode/` 点目录（Obsidian 不碰点开头目录，天然隔离；斜杠命令装在用户级，不进工作区，避免遮蔽/漂移）。

## 0. 模式判断（先做）

目标目录已有 `registry.md` 且 `library/` 里有论文目录 → **恢复模式**（工作区数据已由 Obsidian Sync 带到本机）：

1. 跳过第 2/4/5 步的数据脚手架（AGENTS.md、registry、概念卡均已同步，只读不改）
2. 只重建框架层：执行第 3 步（Python 3.12 检测）与第 6 步（.zcode/tools 环境）与第 7 步（MCP 配置）
3. git 接续（若本机无 `.git`）：`git init`；若用户提供私有远端 URL：`git remote add origin <url> && git fetch && git reset --mixed origin/main`（采纳远端历史，不动工作区文件）
4. 校验：对照 registry.md 逐条检查 library/ 目录与笔记在不在、PDF 是否已同步完（Obsidian Sync 大文件后到，缺 PDF 属正常，等同步即可）；汇报缺口
5. Obsidian：提示「打开文件夹作为仓库」（若本机尚未注册）

否则 → 初始化模式，走以下流程。

## 1. 确认目标（初始化模式）

- 目录默认当前目录；非空时列出已有内容并**征得确认**才继续（只新增不覆盖同名文件，遇同名先问）
- 参数：`--lite` 装轻量解析环境（秒级，仅 fast 引擎）；默认 `--full`（含 MinerU，模型首次解析时下载）

## 2. 建骨架（数据层，明面目录）

```
mkdir: inbox/ library/ topics/ 概念卡/ 方法图谱/
```

## 3. 检测 Python 3.12（uv）

```bash
uv python find 3.12 || uv python install 3.12 && uv python find 3.12
```

- 记下绝对路径（写进 AGENTS.md）。无 uv → 提示安装 uv 后重跑，或用本机任何 ≥3.10 的 python 路径代替
- 红线：不使用系统专用 python（如固件工具链）

## 4. 写薄 AGENTS.md

按 `templates/workspace-AGENTS.md` 渲染（只含：一句话定位、参数区、数据目录、机器环境事实、同步与版本策略）。占位符向用户询问给默认值：

- `{{RESEARCH_FIELDS}}` 研究方向（默认：AI/ML）
- `{{PYTHON312}}` 上一步解释器绝对路径

流程规则不写进 AGENTS——它们在本技能包命令里，单一来源。

## 5. 写数据层文件

- **registry.md**（templates/registry-template.md）
- **refs.bib**（注释头）、**.gitignore**（PDF/images/缓存不入库）
- Obsidian 相关（默认开启）：根目录 `概念卡/_模板.md`、`方法图谱/`、`Papers.base`、`HOME.md`（均从 templates/ 复制）

## 6. 框架层与解析环境（.zcode/tools）

```bash
bash <技能包>/scripts/setup_env.sh --full|--lite --dir <工作区>     # POSIX/Git Bash
# 或 powershell -File <技能包>/scripts/setup_env.ps1 -Mode full|lite -Dir <工作区>
```

脚本自建 `.zcode/tools/`（venv + parse_paper.py + pyproject.toml，arxiv-cache 与 envs 预留于此）并自验 import；失败按 `references/environment-notes.md` 排障（常见：杀软拦 uv trampoline → 脚本已默认标准 venv + pip）。

## 7. MCP 配置（.zcode/config.json，按宿主环境）

- **ZCode**：写 `<工作区>/.zcode/config.json`：

```json
{ "mcp": { "servers": {
  "arxiv": { "command": "uvx", "args": ["--python", "3.12", "arxiv-mcp-server", "--storage-path", "<工作区>/.zcode/tools/arxiv-cache"] },
  "paper-search": { "command": "uvx", "args": ["--python", "3.12", "paper-search-mcp"] }
} } }
```

- **Claude Code**：写 `<工作区>/.mcp.json`（同样的 servers，键名用 `mcpServers`）
- **DSH / 无 MCP 宿主**：跳过；各命令已内置网页检索与 curl 直拉兜底

## 8. Obsidian（默认开启）

1. 注册：装有 Obsidian 官方 CLI 用 CLI；否则提示用户「打开文件夹作为仓库」选择本工作区（一次性）
2. 用 Obsidian Sync 的提醒：明面数据自动全同步；`.zcode/` 与 `.git` 点开头目录 Obsidian 不碰（若同步列表意外出现它们，手动排除即可）

`--no-vault` 跳过本步（不影响其他流程）。

## 9. git 与收尾

1. `git init`（若尚未）+ 初始提交
2. 汇报：数据层清单 / `.zcode` 框架层就绪情况 / MCP 落盘 / Obsidian 注册状态 / 下一步（`/paper-find <你的第一个主题>`）

---
description: 一键把当前（或指定）目录初始化为论文工作台：目录树+AGENTS+台账+解析工具链+MCP配置+可选Obsidian库
argument-hint: [目标目录，默认当前目录] [--lite 轻量环境] [--no-vault 不建Obsidian库]
---

# /paper-init：初始化论文工作台

把知识装配进一个空工作区。资产源 = 本技能包目录（`templates/`、`scripts/`）。

## 1. 确认目标

- 目录默认当前目录；非空时列出已有内容并**征得确认**才继续（只新增不覆盖同名文件，遇同名先问）
- 参数：`--lite` 装轻量解析环境（秒级，仅 fast 引擎）；默认 `--full`（含 MinerU，模型首次解析时下载）

## 2. 建骨架

```
mkdir: inbox/ library/ topics/ templates/ tools/ docs/
```

复制技能包资产：

- `scripts/parse_paper.py`、`scripts/pyproject.toml` → `tools/`
- `templates/精读笔记模板.md`、`templates/reproduce-log-template.md`、`templates/导读地图模板.md`、`templates/概念卡模板.md`、`templates/Papers.base`、`templates/HOME.md` → `templates/`

## 3. 检测 Python 3.12（uv）

```bash
uv python find 3.12 || uv python install 3.12 && uv python find 3.12
```

- 记下绝对路径（写进 AGENTS.md）。无 uv → 提示安装 uv 后重跑，或用本机任何 ≥3.10 的 python 路径代替
- 红线：不使用系统专用 python（如固件工具链）

## 4. 写工作区文件

1. **AGENTS.md**：按 `templates/workspace-AGENTS.md` 渲染，替换占位符（占位符含义向用户询问，给默认值）：
   - `{{RESEARCH_FIELDS}}` 研究方向（默认：AI/ML）
   - `{{PYTHON312}}` 上一步得到的解释器绝对路径
2. **registry.md**（模板：表头 + 状态流转说明）
3. **refs.bib**（注释头）、**.gitignore**（PDF/images/.venv/缓存不入库）

## 5. 解析环境

```bash
bash <技能包>/scripts/setup_env.sh --full|--lite --dir <工作区>     # POSIX/Git Bash
# 或 powershell -File <技能包>/scripts/setup_env.ps1 -Mode full|lite -Dir <工作区>
```

脚本自验（import 检查）；失败时按 `references/environment-notes.md` 排障（常见：杀软拦 uv trampoline → 脚本已默认走标准 venv + pip）。

## 6. MCP 配置（按宿主环境写）

- **ZCode**：写 `<工作区>/.zcode/config.json`：

```json
{ "mcp": { "servers": {
  "arxiv": { "command": "uvx", "args": ["--python", "3.12", "arxiv-mcp-server", "--storage-path", "<工作区>/library/.arxiv-cache"] },
  "paper-search": { "command": "uvx", "args": ["--python", "3.12", "paper-search-mcp"] }
} } }
```

- **Claude Code**：写 `<工作区>/.mcp.json`（同样的 servers，键名用 `mcpServers`）
- **DSH / 无 MCP 宿主**：跳过；各命令已内置网页检索与 curl 直拉兜底

## 7. Obsidian 仓库（工作区即 vault，默认开启）

1. 根目录长出：`概念卡/_模板.md`（从 templates/ 复制改名）、`方法图谱/`、`Papers.base`、`HOME.md`（templates/ 复制）
2. 注册：装有 Obsidian 官方 CLI 时用 CLI 注册本工作区目录；否则提示用户在 Obsidian 中「打开文件夹作为仓库」选择本工作区（一次性）
3. 用户使用 Obsidian Sync 时提醒：设置 → 同步 → **排除文件夹勾选 `tools/`**（venv/模型缓存/复现环境都在其中）；`.git` 会被自动忽略
4. `--no-vault` 跳过本步（不影响其他流程，仅失去 Obsidian 图形界面与同步）

## 8. git 与收尾

1. `git init`（若尚未）+ 初始提交
2. 汇报：创建清单 / 环境模式与验证结果 / MCP 落盘位置 / Obsidian 仓库就绪（工作区根，如用 Sync 记得排除 tools/）/ 下一步建议（`/paper-find <你的第一个主题>`）

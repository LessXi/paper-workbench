# paper-workbench

把你的 agent（ZCode / DeepSeek Harness / Claude Code）变成**全流程论文研读学习复现工作台**：

```
发现 ─ 获取 ─ 解析 ─ 精读 ─ 沉淀 ─ 复现 ─ 综述
find   read   parse  learn  vault  repro  survey
```

特色是**学习模式**（/paper-learn）：AI 不代读——只做导读地图、答疑、复述纠错、闭卷出题、code review，公式和代码过你自己的脑子。

## 安装

**方式一：插件市场（推荐，零终端）**——ZCode/Claude Code：设置 → 插件管理 → Discover → **+** 从 GitHub 添加 `https://github.com/LessXi/paper-workbench` → 安装。装完重开会话。

**方式二：DSH 一条命令（bundle）**——DeepSeek Harness 用户：

```sh
dsh plugin --profile web add github:LessXi/paper-workbench   # 在 DSH 源码目录跑 pnpm dsh …，可加 #<commit> 锁定
```

装完获得 `paper` 工具（status 查工作台状态 / parse 解析 PDF）；工作流技能由 `/paper-init` 自动落到工作区 `.agents/skills/`。

**方式三：一条 bootstrap 命令（其他 terminal 用户）**

```bash
curl -LsSf https://raw.githubusercontent.com/LessXi/paper-workbench/main/bootstrap.sh | bash
# Windows: powershell -ExecutionPolicy Bypass -c "irm https://raw.githubusercontent.com/LessXi/paper-workbench/main/bootstrap.ps1 | iex"
```

（备选：`git clone` 本仓库后跑 `install.sh` / `install.ps1`）

## 两步跑通

```text
1. 插件装好，重开会话，在任意目录说 /paper-init   ← 生成你的工作台（只问一个问题：解析环境 lite 还是 full）
2. /paper-find <你的主题>                        ← 检索落库，开始研读
```

解析环境两档：**lite** 秒级装完（纯文本抽取，够筛选）；**full** 公式还原 LaTeX、表格成表、抽全部图表（精读必备），首次多等十来分钟。lite 随时可升级 full（一条 pip 命令，parse_paper.py 会在需要时提示你）。

## 九个命令

| 命令 | 用途 |
|---|---|
| `/paper-init [目录] [--lite]` | 初始化工作台（--lite 秒级轻量环境） |
| `/paper-find <query>` | 多源检索 → 必读/备读/跳过分档 → 落库登记 |
| `/paper-read <论文>` | AI 代读：MinerU 解析 + 三遍读法 + 结构化笔记 |
| `/paper-learn <论文>` | 学习模式：你读你写，AI 陪读/出题/review |
| `/paper-cite <论文>` | 前向/后向引文图谱 + BibTeX |
| `/paper-survey <topic>` | 方法族谱 + 对比矩阵 + 演化时间线 + canvas |
| `/paper-watch <topic>` | arXiv 订阅追新 digest |
| `/paper-reproduce <论文>` | CPU 级复现：官方repo→降规模→从零实现→数值对照 |
| `/paper-lab` | 台账盘点、卡点诊断、下一步建议 |

## 依赖

- **必需**：[uv](https://docs.astral.sh/uv/)（Python 3.12 自动管理）
- **增强**：arxiv-mcp-server + paper-search-mcp（/paper-init 自动写入工作区 MCP 配置；无 MCP 环境自动降级为网页检索 + curl 直拉）；Obsidian（工作区本身就是 vault——明面全是论文数据，Obsidian Sync 直接全同步；框架收在 `.zcode/` 点目录，Obsidian 不碰，无需手动排除）
- 解析：MinerU（公式/表格/中文最强，CPU 可跑）+ pypdf 快速兜底

多机环境坑（杀软拦 uv trampoline、uvx 默认 Python、mineru 漏 six 等）已沉淀在 [skills/paper-lab/references/environment-notes.md](skills/paper-lab/references/environment-notes.md)，安装脚本内置规避。

## 结构

```
skills/paper-lab/            自包含技能包（SKILL.md + 9 命令 + 模板 + 脚本 + 踩坑档案）
.claude-plugin/              插件清单（ZCode / Claude Code 市场兼容）
install.sh / install.ps1     一键双环境安装
```

## License

MIT

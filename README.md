# paper-workbench

把你的 agent（ZCode / DeepSeek Harness / Claude Code）变成**全流程论文研读学习复现工作台**：

```
发现 ─ 获取 ─ 解析 ─ 精读 ─ 沉淀 ─ 复现 ─ 综述
find   read   parse  learn  vault  repro  survey
```

特色是**学习模式**（/paper-learn）：AI 不代读——只做导读地图、答疑、复述纠错、闭卷出题、code review，公式和代码过你自己的脑子。

## 一键安装（双环境）

```bash
git clone <本仓库> && cd paper-workbench
bash install.sh          # Windows 用: powershell -ExecutionPolicy Bypass -File install.ps1
```

安装器自动检测并装配：

| 环境 | 落点 | 入口 |
|---|---|---|
| ZCode | `~/.zcode/commands/`（9 个斜杠命令）+ `~/.agents/skills/paper-lab/` | `/paper-init` |
| DeepSeek Harness | `~/.dsh/skills/paper-lab/`（skill 形态） | 对话说"初始化论文工作台" |
| Claude Code | 同 ZCode 路径（`.claude` 生态兼容） | `/paper-init` |

也可通过 ZCode/Claude 插件市场添加本仓库（`.claude-plugin/` 双清单）。

## 三步跑通

```text
1. /paper-init            ← 在任意空目录生成工作台（目录树+AGENTS+台账+解析环境+MCP+可选Obsidian库）
2. /paper-find <你的主题>   ← 多源检索 → 分档初筛 → 下载落库
3. /paper-learn <论文>     ← 学习模式：导读地图 → 你读你复述 → AI 纠错出题 → 你写复现 AI review
```

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
- **增强**：arxiv-mcp-server + paper-search-mcp（/paper-init 自动写入工作区 MCP 配置；无 MCP 环境自动降级为网页检索 + curl 直拉）；Obsidian（笔记知识网络，可选）
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

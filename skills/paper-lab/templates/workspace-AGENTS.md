# paper-lab：论文数据仓库

本目录是**数据层**：论文、笔记、概念卡、台账。流程规则（精读方法论、复现规范、命令地图）由 **paper-workbench 技能包**提供（命令在用户级，模板与解析工具在本工作区 `.zcode/` 下——Obsidian 不碰点开头目录，框架与数据天然隔离）。

## 本工作区参数（/paper-init 生成）

```yaml
research_fields: {{RESEARCH_FIELDS}}   # 研究方向：检索换词、精读侧重、关联分析都以它为准
python312: {{PYTHON312}}               # uv 托管 Python 3.12 绝对路径，建 venv 用
解析环境: .zcode/tools/.venv           # Python 3.12 + mineru（标准 venv + pip）
复现环境: .zcode/tools/envs/<论文目录>/.venv
```

## 数据目录

```
library/<论文目录>/   YYYY-短slug：paper.pdf / paper.md / images/ / 论文标题.md（精读笔记，文件名即标题，wikilink 友好）/ 导读地图.md / reproduce/
概念卡/ 方法图谱/ topics/ inbox/ registry.md refs.bib learner-profile.md HOME.md Papers.base
```

## 机器环境事实（红线）

1. **绝不使用/修改系统专用 python**；建 venv 一律 `<python312> -m venv <路径>` + 纯 pip（部分机器杀软拦 uv trampoline，详见技能包 references/environment-notes.md）
2. 无 GPU/Docker 假设；复现 CPU 级（最小示例、推理模式、缩小数据）
3. 首次 MinerU 解析下载模型（数百 MB，modelscope 源）属正常

## 同步与版本

- Obsidian Sync 同步全部明面数据；`.zcode/`、`.git` 点开头自动不被同步
- git 入库：笔记、registry、refs.bib、综述、自写复现代码；不入库：PDF、images/、.venv、缓存

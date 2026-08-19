# paper-lab 工作台（Obsidian 仓库）

本目录既是 agent 论文工作台，也是 Obsidian 仓库——所有数据一份数据一份真相，由 Obsidian Sync 跨设备同步。

## 地图

- **library/<论文>/**：每篇论文一个目录。`论文标题.md` 是精读笔记（wikilink 直接用 [[论文标题]]），`导读地图.md` 是学习模式备课笔记，`paper.md` 是解析后的全文，`paper.pdf` 原文，`images/` 图表
- **概念卡/**：跨论文概念沉淀，被笔记的 [[]] 引用
- **方法图谱/**：主题 survey 生成的 canvas 概念图
- **registry.md**：文献总台账（状态流水）
- **Papers.base**：文献台账数据库视图（全部/待读/已读卡片墙）
- **topics/**：主题综述；**inbox/**：待落库 PDF；**refs.bib**：引用库
- **learner-profile.md**：学习者档案（学习模式用）

## 同步设置（一次性）

设置 → 同步：**排除文件夹勾选 `tools/`**（解析 venv、模型缓存、复现环境都在里面，禁止上同步）。`.git` 会被自动忽略。

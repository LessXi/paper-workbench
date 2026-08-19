# Changelog

## 0.2.0（2026-08-19）

- **DSH 双形态**：仓库根新增 cordis bundle，`dsh plugin --profile web add github:LessXi/paper-workbench` 一条命令安装；注册 `paper` 工具（status 工作台状态 / parse 解析 PDF），构建产物 lib/ 随仓库提交
- **流程简化**：初次使用两步（插件市场装 → /paper-init 只问 lite/full 一问）；uv 缺失自动安装；parse_paper.py 在 lite 环境给一条命令升级指引
- **数据/框架分层**：工作区明面全是论文数据（Obsidian Sync 单通道，含版本历史，不设 git）；框架落点 `.zcode/` 点目录（Obsidian 不碰），恢复模式重建；技能包亦落工作区 `.agents/skills/`
- **bootstrap 单命令**（terminal 备选）：uv 检测安装 + 框架安装 + 指引
- **教学法协议**（学习模式）：真实老师人格（立场+范例+三条硬规则）、隐形学情推断（不设摸底表单）、提问可及性分层、提示阶梯、双语对照材料对话内呈现、图片内嵌渲染
- 修复实测反馈：开场禁备课汇报/复述规矩、转场指代自含、引用标注来源防混排

## 0.1.0（2026-08-19）

- 首版：9 命令全流程（init/find/read/learn/cite/survey/watch/reproduce/lab）、双引擎解析（MinerU/fast）、模板与多机环境踩坑档案、install.sh 双环境安装（ZCode + DSH skill 形态）

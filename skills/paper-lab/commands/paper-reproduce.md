---
description: CPU 级论文复现：找官方仓库 → 独立 uv 环境 → 跑最小示例 → 对照论文数值
argument-hint: <library目录名 | 论文关键词> [复现目标，如 "Table 1" 或 "Fig.3 现象"]
---

# /paper-reproduce：CPU 级复现

输入：`$ARGUMENTS`。定位论文（registry/library），确认复现目标（默认：论文主表的核心指标；用户指定了图表则以指定为准）。规范见 AGENTS.md「复现规范」。

## 1. 找实现

1. 官方 repo：论文中声明的 URL → `gh search repos` / WebSearch（Papers with Code）交叉确认
2. 找到 → 用 github 技能克隆到 `library/<目录>/reproduce/repo/`
3. 无官方实现或实现年久失修 → **从零实现核心算法**（常常更干净：numpy/torch 按论文伪代码与公式重写，只实现复现目标所需部分）
4. 读取 README / 环境声明 / issues（已知坑）

## 2. 环境（严格独立）

按工作区 AGENTS.md「建环境配方」（部分机器杀软拦 uv trampoline，标准 venv + pip 最稳）：

```bash
mkdir -p .zcode/tools/envs/<目录>
"<AGENTS.md 中 python312 绝对路径>" -m venv .zcode/tools/envs/<目录>/.venv   # 版本按 repo 声明换；未记录时 uv python find 3.12 查
.zcode/tools/envs/<目录>/.venv/Scripts/python.exe -m pip install -r library/<目录>/reproduce/repo/requirements.txt
```

- 装依赖报错 → context7 查该库文档找正确版本组合；仍不行 → 降级/升级逐一试并记录
- **红线：绝不使用系统 python；绝不装进解析环境 .zcode/tools/.venv（复现环境一律在 .zcode/tools/envs/<目录>/）**

## 3. CPU 适配跑通

本机无 GPU/Docker，策略优先级：

1. 原生 CPU 可跑 → 直接跑
2. 需要 GPU → 缩小规模：小数据集 / 减少层数与维度 / 推理模式（用预训练权重而非训练）/ 官方提供的 demo/notebook
3. 必须 GPU/Docker 且无法降级 → 停止，降级为「代码走读」：输出代码架构分析 + 与论文方法逐点对照，记入 log.md 并在 registry 标注「复现不可行(需GPU)」

## 4. 对照与归因

- 建 `reproduce/results.md`：| 指标 | 论文值 | 复现值 | 设置差异 | 差异可接受？ |
- 差异归因：数据规模缩小 / 精度(fp32 vs fp16) / 随机种子 / 迭代轮数 / 硬件差异
- 数量级一致即视为复现成功（CPU 级目标是理解与验证，不是刷指标）

## 5. 落盘

1. `reproduce/log.md`：按 `.zcode/templates/reproduce-log-template.md` 全程记录
2. 自写代码入 git（repo/ 克隆目录与 .venv/ 数据不入，见 .gitignore）
3. `registry.md`：状态`已复现`（或`复现不可行`），复现列写一句结果

## 6. 汇报

复现目标达成情况 / 与论文数值对照表 / 差异归因 / 关键收获（对方法理解的修正）/ 踩坑记录。

#!/usr/bin/env bash
# paper-workbench 一键安装：检测 ZCode 与 DeepSeek Harness 并安装
# 用法: bash install.sh [--force]
#   --force  未检测到目标环境时也装到通用位置（~/.agents + ~/.zcode）
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
SKILL_SRC="$SRC/skills/paper-lab"
FORCE=0
[[ "${1:-}" == "--force" ]] && FORCE=1

install_skill_dir() {  # $1=目标技能目录
  mkdir -p "$1"
  rm -rf "$1/paper-lab"
  cp -r "$SKILL_SRC" "$1/paper-lab"
  echo "[install] 技能 → $1/paper-lab"
}

echo "== paper-workbench 安装 =="

# ---- ZCode ----
if [[ -d "$HOME/.zcode" || $FORCE -eq 1 ]]; then
  install_skill_dir "$HOME/.agents/skills"
  mkdir -p "$HOME/.zcode/commands"
  rm -f "$HOME/.zcode/commands/paper-"*.md
  cp "$SKILL_SRC/commands/"paper-*.md "$HOME/.zcode/commands/"
  echo "[install] ZCode 斜杠命令 → ~/.zcode/commands/（9 个 /paper-*）"
fi

# ---- DeepSeek Harness ----
if [[ -d "$HOME/.dsh" || $FORCE -eq 1 ]]; then
  install_skill_dir "$HOME/.dsh/skills"
  echo "[install] DSH 技能 → ~/.dsh/skills/paper-lab"
fi

cat <<'EOF'

== 安装完成，各环境用法 ==
ZCode / Claude Code：任意目录对话中说 /paper-init（或"初始化论文工作台"）
DeepSeek Harness：  对话中说"用 paper-lab 技能初始化论文工作台"
之后：/paper-find <主题> 开始检索落库；/paper-learn <论文> 进入学习模式
卸载：删除 ~/.agents/skills/paper-lab、~/.zcode/commands/paper-*.md、~/.dsh/skills/paper-lab
EOF

#!/usr/bin/env bash
# paper-workbench 一条命令安装（terminal 用户 / DSH 用户备选路线；ZCode 用户可直接用插件市场）
set -euo pipefail

command -v uv >/dev/null 2>&1 || {
  echo "[boot] 未检测到 uv，自动安装 ..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
}
command -v git >/dev/null 2>&1 || { echo "[boot] 缺少 git，请先安装 git"; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
git clone --depth 1 https://github.com/LessXi/paper-workbench "$TMP/paper-workbench"
bash "$TMP/paper-workbench/install.sh" "$@"

cat <<'EOF'

[boot] 完成。下一步：重开 ZCode 会话，在任意目录说 /paper-init 生成你的论文工作台
EOF

#!/usr/bin/env bash
# paper-workbench 解析工具链安装：在工作区 tools/ 下建独立 venv
# 用法: bash setup_env.sh [--full|--lite] [--dir <工作区>]
#   --full  默认。mineru[pipeline]（公式/表格级解析，模型首次运行时下载）
#   --lite  秒级安装，仅 fast 引擎（pypdf 纯文本抽取）
set -euo pipefail

MODE=full
DIR="$(pwd)"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --lite) MODE=lite ;;
    --full) MODE=full ;;
    --dir)  DIR="$2"; shift ;;
    *) echo "未知参数 $1"; exit 2 ;;
  esac
  shift
done

TOOLS="$DIR/tools"
VENV="$TOOLS/.venv"
SRC="$(cd "$(dirname "$0")" && pwd)"

command -v uv >/dev/null 2>&1 || { echo "[setup] 缺少 uv，请先安装：https://docs.astral.sh/uv/"; exit 1; }

# 解析 uv 托管的 Python 3.12（没有则自动安装）
PY="$(uv python find 3.12 2>/dev/null || { echo "[setup] 安装 Python 3.12 ..."; uv python install 3.12 >/dev/null; uv python find 3.12; })"
echo "[setup] Python 3.12: $PY"

mkdir -p "$TOOLS"
# 标准库 venv + pip：规避部分机器杀软拦截 uv trampoline exe 的问题（见 references/environment-notes.md）
"$PY" -m venv "$VENV"

if [[ -x "$VENV/Scripts/python.exe" ]]; then VPIP="$VENV/Scripts/python.exe"; else VPIP="$VENV/bin/python"; fi

# 国内网络优先 modelscope 拉模型
export MINERU_MODEL_SOURCE="${MINERU_MODEL_SOURCE:-modelscope}"

if [[ "$MODE" == "lite" ]]; then
  PKGS=("pypdf>=4.0" "numpy>=1.26")
else
  PKGS=("mineru[pipeline]>=2.0" "pypdf>=4.0" "numpy>=1.26" "six>=1.16")  # six：mineru 漏声明
fi

"$VPIP" -m pip install --quiet --upgrade pip
"$VPIP" -m pip install --progress-bar off "${PKGS[@]}"

"$VPIP" -c "
import importlib.util as u, sys
missing = [m for m in ('pypdf', 'numpy') if u.find_spec(m) is None]
if sys.argv[1] == 'full' and u.find_spec('mineru') is None:
    missing.append('mineru')
print('[setup] 环境自验 ' + ('通过' if not missing else '缺失: ' + ', '.join(missing)))
sys.exit(1 if missing else 0)
" "$MODE"

cp -f "$SRC/parse_paper.py" "$TOOLS/parse_paper.py"
[[ -f "$SRC/pyproject.toml" ]] && cp -f "$SRC/pyproject.toml" "$TOOLS/pyproject.toml"
echo "[setup] 完成 ($MODE)：$VPIP"

# paper-workbench 解析工具链安装（PowerShell 版）
# 用法: powershell -File setup_env.ps1 [-Mode full|lite] [-Dir <工作区>]
param(
  [ValidateSet("full", "lite")][string]$Mode = "full",
  [string]$Dir = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
$Tools = Join-Path $Dir "tools"
$Venv  = Join-Path $Tools ".venv"
$Src   = $PSScriptRoot

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
  Write-Host "[setup] 缺少 uv，请先安装：https://docs.astral.sh/uv/" ; exit 1
}

# uv 托管 Python 3.12（没有则安装）
$Py = uv python find 3.12 2>$null
if (-not $Py -or $LASTEXITCODE -ne 0) {
  Write-Host "[setup] 安装 Python 3.12 ..."
  uv python install 3.12 | Out-Null
  $Py = uv python find 3.12
}
Write-Host "[setup] Python 3.12: $Py"

New-Item -ItemType Directory -Force -Path $Tools | Out-Null
# 标准库 venv + pip：规避杀软拦 uv trampoline（见 references/environment-notes.md）
& $Py -m venv $Venv
$Vpip = Join-Path $Venv "Scripts\python.exe"

$env:MINERU_MODEL_SOURCE = if ($env:MINERU_MODEL_SOURCE) { $env:MINERU_MODEL_SOURCE } else { "modelscope" }

if ($Mode -eq "lite") { $pkgs = @("pypdf>=4.0", "numpy>=1.26") }
else { $pkgs = @("mineru[pipeline]>=2.0", "pypdf>=4.0", "numpy>=1.26", "six>=1.16") }  # six：mineru 漏声明

& $Vpip -m pip install --quiet --upgrade pip
& $Vpip -m pip install --progress-bar off @pkgs

foreach ($m in @("pypdf", "numpy", "mineru")) {
  $found = & $Vpip -c "import importlib.util as u; print('Y' if u.find_spec('$m') else 'N')"
  Write-Host "[setup] $(if ($found -eq 'Y') {'OK'} else {'--'}) $m"
}

Copy-Item -Force (Join-Path $Src "parse_paper.py") (Join-Path $Tools "parse_paper.py")
if (Test-Path (Join-Path $Src "pyproject.toml")) {
  Copy-Item -Force (Join-Path $Src "pyproject.toml") (Join-Path $Tools "pyproject.toml")
}
Write-Host "[setup] 完成 ($Mode)：$Vpip"

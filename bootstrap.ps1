# paper-workbench 一条命令安装（terminal 用户 / DSH 用户备选路线；ZCode 用户可直接用插件市场）
# 用法: powershell -ExecutionPolicy Bypass -File bootstrap.ps1
$ErrorActionPreference = "Stop"

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
  Write-Host "[boot] 未检测到 uv，自动安装 ..."
  powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
  $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Write-Host "[boot] 缺少 git，请先安装 git"; exit 1 }

$Tmp = Join-Path $env:TEMP "paper-workbench-boot"
if (Test-Path $Tmp) { Remove-Item -Recurse -Force $Tmp }
New-Item -ItemType Directory -Force -Path $Tmp | Out-Null
git clone --depth 1 https://github.com/LessXi/paper-workbench (Join-Path $Tmp "paper-workbench")
powershell -ExecutionPolicy Bypass -File (Join-Path $Tmp "paper-workbench\install.ps1")

Write-Host "`n[boot] 完成。下一步：重开 ZCode 会话，在任意目录说 /paper-init 生成你的论文工作台"

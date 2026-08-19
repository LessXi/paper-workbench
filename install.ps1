# paper-workbench 一键安装（PowerShell）：检测 ZCode 与 DeepSeek Harness
# 用法: powershell -ExecutionPolicy Bypass -File install.ps1 [-Force]
param([switch]$Force)

$ErrorActionPreference = "Stop"
$Src = $PSScriptRoot
$SkillSrc = Join-Path $Src "skills\paper-lab"

function Install-SkillDir([string]$Target) {
  New-Item -ItemType Directory -Force -Path $Target | Out-Null
  if (Test-Path "$Target\paper-lab") { Remove-Item -Recurse -Force "$Target\paper-lab" }
  Copy-Item -Recurse $SkillSrc "$Target\paper-lab"
  Write-Host "[install] 技能 → $Target\paper-lab"
}

Write-Host "== paper-workbench 安装 =="

if ((Test-Path "$HOME\.zcode") -or $Force) {
  Install-SkillDir "$HOME\.agents\skills"
  New-Item -ItemType Directory -Force -Path "$HOME\.zcode\commands" | Out-Null
  Get-ChildItem "$HOME\.zcode\commands\paper-*.md" -ErrorAction SilentlyContinue | Remove-Item -Force
  Copy-Item "$SkillSrc\commands\paper-*.md" "$HOME\.zcode\commands\"
  Write-Host "[install] ZCode 斜杠命令 → ~/.zcode/commands/（9 个 /paper-*）"
}

if ((Test-Path "$HOME\.dsh") -or $Force) {
  Install-SkillDir "$HOME\.dsh\skills"
  Write-Host "[install] DSH 技能 → ~/.dsh/skills/paper-lab"
}

Write-Host @"

== 安装完成，各环境用法 ==
ZCode / Claude Code：任意目录对话中说 /paper-init（或"初始化论文工作台"）
DeepSeek Harness：  对话中说"用 paper-lab 技能初始化论文工作台"
之后：/paper-find <主题> 开始检索落库；/paper-learn <论文> 进入学习模式
卸载：删除 ~\.agents\skills\paper-lab、~\.zcode\commands\paper-*.md、~\.dsh\skills\paper-lab
"@

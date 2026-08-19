# 环境踩坑档案（多机验证积累）

安装/排障前先扫这里。`setup_env` 脚本已内置规避 1-3。

## 1. 杀软拦 uv trampoline（Windows 企业机常见）

`uv venv` / `uv pip install` 报 `Failed to update Windows PE resources: ...uv-trampoline-*.exe 拒绝访问 (os error -2147024891)`。

根因：杀软/DLP 钩住 trampoline exe 的 PE 资源修改；换 TEMP 位置、`--link-mode=copy` 均无效。

规避：**标准库 venv + 纯 pip**——`<uv托管python> -m venv .venv && .venv/Scripts/python.exe -m pip install ...`（pip 的 distlib 脚本机制不受影响）。`uvx` 运行 MCP/工具正常（env 落 C 盘缓存）。

## 2. uvx 默认抓错系统 Python

机器上有专用工具链 python（如嵌入式 SDK 自带 3.8）时，`uvx <server>` 会用它解析依赖然后失败（`does not satisfy Python>=3.10`）。

规避：uvx 显式 `--python 3.12`。MCP 配置里已带。

## 3. mineru 3.4.5 漏声明 six

`mineru[pipeline]` 的 pytorchocr 模块 import six 但依赖里没有，首跑解析报 `No module named 'six'`。

规避：安装时显式加 `six>=1.16`（setup 脚本已带）。

## 4. MinerU 模型下载慢/失败

首次解析需下载模型（数百 MB~1GB+）。国内网络设 `MINERU_MODEL_SOURCE=modelscope`（脚本默认已设）；模型缓存于 `~/.cache/modelscope`。下载中断可重跑，续传。

## 5. MinerU 3.x CLI 参数与 2.x 不同

无 `-d/--device`；默认 backend 是 `hybrid-engine`（会拉大 VLM 模型）。CPU 场景必须显式 `-b pipeline`。`parse_paper.py` 已按 3.x 适配（双参数组兜底）。

## 6. Windows 临时目录跨盘

TEMP 在 C: 而仓库在 D: 时，跨盘 hardlink 警告无害；如遇安装异常可 `export UV_LINK_MODE=copy` 或把 TEMP 指到同盘。

## 7. obsidian vault 注册

装有 Obsidian 官方 CLI 时可命令行注册；否则在 Obsidian 里「打开文件夹作为仓库」一次即可（vault 本质是 markdown 目录，文件写入随时生效）。

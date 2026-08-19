#!/usr/bin/env python
"""paper-lab 论文解析封装。

用法（必须用本目录 venv 的 Python 运行）:
    tools/.venv/Scripts/python tools/parse_paper.py <pdf路径>
    tools/.venv/Scripts/python tools/parse_paper.py --engine fast <pdf路径>

engine:
    mineru (默认)  MinerU pipeline：公式/表格/多栏最强，首次运行需下载模型（数百MB）
    fast           pypdf 纯文本抽取：秒级完成，无公式还原，仅在 MinerU 不可用时兜底

产物（写在 PDF 同目录）:
    mineru: paper.md + figures/
    fast:   paper.fast.md
"""

import argparse
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
VENV_BIN = os.path.join(HERE, ".venv", "Scripts")


def log(msg: str) -> None:
    print(f"[parse_paper] {msg}", flush=True)


def run_mineru(pdf: str, paper_dir: str) -> int:
    import importlib.util

    if importlib.util.find_spec("mineru") is None:
        pip_py = os.path.join(VENV_BIN, "python.exe")
        if not os.path.exists(pip_py):
            pip_py = "python"
        log("当前是 lite 环境（未装 MinerU），无法做公式/表格/图表级解析。")
        log(f'升级只需一条命令，之后重跑本命令即可：\n  {pip_py} -m pip install "mineru[pipeline]" six')
        log("现在只要纯文本稿的话，加 --engine fast 运行。")
        return 1

    out_dir = os.path.join(paper_dir, "_mineru_out")
    mineru_bin = os.path.join(VENV_BIN, "mineru.exe")
    if not os.path.exists(mineru_bin):
        mineru_bin = "mineru"

    env = dict(os.environ)
    # 国内网络优先走 modelscope 下载模型，可用 MINERU_MODEL_SOURCE 覆盖
    env.setdefault("MINERU_MODEL_SOURCE", "modelscope")

    attempts = [
        [mineru_bin, "-p", pdf, "-o", out_dir, "-b", "pipeline"],
        [mineru_bin, "-p", pdf, "-o", out_dir, "-b", "pipeline", "-m", "txt"],
    ]
    last_err = ""
    for cmd in attempts:
        log(f"运行: {' '.join(cmd)}（首次运行会下载模型，请耐心等待）")
        proc = subprocess.run(
            cmd, capture_output=True, text=True, encoding="utf-8", errors="replace", env=env
        )
        if proc.returncode == 0:
            break
        last_err = (proc.stderr or proc.stdout or "")[-2000:]
        log(f"失败(returncode={proc.returncode})，尝试下一种参数组合…")
    else:
        print(last_err, file=sys.stderr)
        log("MinerU 运行失败。可先用 --engine fast 兜底，稍后再试 mineru。")
        return 1

    # 在输出目录中递归找最大的 .md 作为正文
    md_files = []
    for root, _dirs, files in os.walk(out_dir):
        for f in files:
            if f.endswith(".md"):
                p = os.path.join(root, f)
                md_files.append((os.path.getsize(p), p))
    if not md_files:
        log(f"MinerU 成功但未找到 markdown 产物，请检查 {out_dir}")
        return 1
    _, best_md = max(md_files)

    target_md = os.path.join(paper_dir, "paper.md")
    shutil.copyfile(best_md, target_md)

    # figures：MinerU 把图片放在 md 同级的 images/ 下，保持同名以便 paper.md 相对链接有效
    figures_src = os.path.join(os.path.dirname(best_md), "images")
    figures_dst = os.path.join(paper_dir, "images")
    n_figs = 0
    if os.path.isdir(figures_src):
        os.makedirs(figures_dst, exist_ok=True)
        for f in os.listdir(figures_src):
            if f.lower().endswith((".jpg", ".jpeg", ".png")):
                shutil.copyfile(os.path.join(figures_src, f), os.path.join(figures_dst, f))
                n_figs += 1

    shutil.rmtree(out_dir, ignore_errors=True)
    log(f"完成: {target_md} ({os.path.getsize(target_md)} bytes), figures/ {n_figs} 张图")
    return 0


def run_fast(pdf: str, paper_dir: str) -> int:
    from pypdf import PdfReader

    reader = PdfReader(pdf)
    parts = [f"<!-- fast 模式：pypdf 纯文本抽取，无公式/表格还原能力，共 {len(reader.pages)} 页 -->", ""]
    for i, page in enumerate(reader.pages, 1):
        text = page.extract_text() or ""
        parts.append(f"\n\n---\n\n<!-- 第 {i} 页 -->\n\n{text}")
    target = os.path.join(paper_dir, "paper.fast.md")
    with open(target, "w", encoding="utf-8") as fh:
        fh.write("".join(parts))
    log(f"完成: {target} ({os.path.getsize(target)} bytes)")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("pdf")
    ap.add_argument("--engine", choices=["mineru", "fast"], default="mineru")
    args = ap.parse_args()

    pdf = os.path.abspath(args.pdf)
    if not os.path.isfile(pdf):
        print(f"文件不存在: {pdf}", file=sys.stderr)
        return 2
    paper_dir = os.path.dirname(pdf)

    if args.engine == "fast":
        return run_fast(pdf, paper_dir)
    return run_mineru(pdf, paper_dir)


if __name__ == "__main__":
    sys.exit(main())

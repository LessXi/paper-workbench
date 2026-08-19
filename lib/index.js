"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.inject = exports.name = void 0;
exports.apply = apply;
const dsh_tools_1 = require("@deepseek-ai/dsh-tools");
const node_child_process_1 = require("node:child_process");
const node_fs_1 = require("node:fs");
const node_path_1 = require("node:path");
exports.name = 'paper-workbench';
exports.inject = ['tools'];
/** 在当前工作目录（论文工作台）定位解析环境 */
function locate(workdir) {
    const root = (0, node_path_1.resolve)(workdir);
    const toolsDir = (0, node_path_1.join)(root, '.zcode', 'tools');
    const py = (0, node_fs_1.existsSync)((0, node_path_1.join)(toolsDir, '.venv', 'Scripts', 'python.exe'))
        ? (0, node_path_1.join)(toolsDir, '.venv', 'Scripts', 'python.exe')
        : (0, node_path_1.join)(toolsDir, '.venv', 'bin', 'python');
    return {
        root,
        isWorkspace: (0, node_fs_1.existsSync)((0, node_path_1.join)(root, 'registry.md')) && (0, node_fs_1.existsSync)((0, node_path_1.join)(root, 'library')),
        venvReady: (0, node_fs_1.existsSync)(py),
        mineruReady: (0, node_fs_1.existsSync)((0, node_path_1.join)(toolsDir, '.venv', 'Lib', 'site-packages', 'mineru')),
        py,
        script: (0, node_path_1.join)(toolsDir, 'parse_paper.py'),
    };
}
function run(cmd, args, timeoutMs) {
    return new Promise((resolvePromise, reject) => {
        (0, node_child_process_1.execFile)(cmd, args, { timeout: timeoutMs, maxBuffer: 16 * 1024 * 1024, windowsHide: true }, (err, stdout, stderr) => {
            if (err)
                reject(new Error(`paper: ${err.message}\n${String(stderr).slice(-2000)}`));
            else
                resolvePromise(String(stdout).trim());
        });
    });
}
function apply(ctx) {
    ctx.tools.register((0, dsh_tools_1.defineTool)({
        name: 'paper',
        description: '论文工作台工具。action=status 检查当前目录工作台状态（数据层/解析环境/档位）；' +
            'action=parse 用工作台解析环境把 PDF 转成 markdown（engine=mineru 公式表格图完整，engine=fast 秒级纯文本）。' +
            '仅操作当前工作目录 .zcode/ 下的环境，不写其他路径。',
        parameters: {
            action: {
                type: 'string',
                required: true,
                enum: ['status', 'parse'],
                description: 'status=检查工作台状态；parse=解析 PDF',
            },
            pdf: {
                type: 'string',
                description: 'parse 必填：PDF 相对或绝对路径',
            },
            engine: {
                type: 'string',
                enum: ['mineru', 'fast'],
                description: 'parse 可选，默认 mineru',
            },
            workdir: {
                type: 'string',
                description: '论文工作台根目录，默认当前工作目录',
            },
        },
        output: {
            schema: { type: 'string' },
            render: (_args, value) => [{ type: 'text', text: String(value) }],
        },
        execute: async (args) => {
            const loc = locate(args.workdir || process.cwd());
            if (args.action === 'status') {
                return Promise.resolve(JSON.stringify({
                    workspace: loc.root,
                    is_workspace: loc.isWorkspace,
                    env_ready: loc.venvReady,
                    engine_full: loc.mineruReady,
                    hint: loc.venvReady
                        ? (loc.mineruReady ? 'full 就绪' : 'lite 就绪（升级：pip install "mineru[pipeline]" six）')
                        : '未初始化：说 /paper-init 生成工作台',
                }, null, 2));
            }
            if (args.action === 'parse') {
                if (!loc.venvReady)
                    throw new Error('paper: 解析环境不存在，先运行 /paper-init');
                if (!args.pdf)
                    throw new Error('paper: parse 需要 pdf 参数');
                const engineArgs = args.engine === 'fast' ? ['--engine', 'fast'] : [];
                return run(loc.py, [loc.script, ...engineArgs, (0, node_path_1.resolve)(args.pdf)], 900_000);
            }
            throw new Error(`paper: unknown action ${String(args.action)}`);
        },
        timeoutMs: 900_000,
    }));
}

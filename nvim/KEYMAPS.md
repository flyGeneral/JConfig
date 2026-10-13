# Neovim 快捷键总表

> Leader = `空格`。LSP 类键位在对应语言文件打开后生效;gitsigns 键位在 git 仓库内生效。

## 窗口 / 面板

| 键 | 作用 |
|---|---|
| `<C-h/j/k/l>` | 方向移动:nvim 分屏之间,到边缘后穿透到 tmux 面板(tmux 侧已配 vim-tmux-navigator,全网格统一导航) |
| `<C-\>` | 最近两个面板间来回跳(tmux 侧) |
| `<leader>sv` / `<leader>sh` | 垂直 / 水平分屏 |
| `<leader>nh` | 清除搜索高亮 |

## 文件 / 搜索(Telescope、nvim-tree)

| 键 | 作用 |
|---|---|
| `<C-p>` | 查找文件(find_files) |
| `<C-f>` | 全文搜索(live_grep,依赖系统 ripgrep) |
| `<leader>rs` | 重新打开上次 Telescope 结果 |
| `<leader>o` | 最近打开的文件 |
| `<leader>e` | 文件树开关 |

## Buffer(bufferline)

| 键 | 作用 |
|---|---|
| `<leader>b1` ~ `<leader>b9` | 跳到第 N 个 buffer |
| `bn` / `bp` | 下 / 上一个 buffer |
| `<leader>bc` | 关闭当前 buffer |
| `<leader>bp` | 选择关闭(BufferLinePickClose) |
| `<leader>bo` | 关闭其他所有 buffer |
| `<leader>bg` | 选择跳转(BufferLinePick) |

## 大纲(aerial)

| 键 | 作用 |
|---|---|
| `<leader>a` | 大纲侧栏开关 |
| `<leader>af` | 悬浮导航窗口 |
| `]a` / `[a` | 下 / 上一个符号 |
| 大纲窗口内 | `<CR>` 跳转、`o` 折叠、`{` / `}` 上/下一个、`q` 关闭、`?` 帮助 |

## LSP(对应语言文件内生效)

| 键 | 作用 |
|---|---|
| `gd` / `gD` / `gi` / `gr` | 定义 / 声明 / 实现 / 引用 |
| `K` | 悬浮文档 |
| `<leader>rn` | 重命名 |
| `<leader>ca` | 代码操作(code action) |
| `<leader>D` | 类型定义 |
| `<A-f>` | 格式化代码 |
| `<leader>wa` / `wr` / `wl` | 加 / 删 / 列 workspace 目录 |
| `<leader>df` | 诊断浮窗 |
| `[d` / `]d` | 上 / 下一条诊断 |
| `<leader>q` | 诊断列表加入 loclist |

## Git(gitsigns / lazygit / fugitive)

| 键 | 作用 |
|---|---|
| `<leader>j` / `<leader>k` | 下 / 上一个改动 hunk |
| `<leader>hs` / `hr` / `hu` | 暂存 / 重置 / 撤销暂存 hunk |
| `<leader>hS` / `hR` | 暂存 / 重置整个 buffer |
| `<leader>hv` / `hi` | hunk 预览 / 内联预览 |
| `<leader>hb` / `hd` / `hD` | 行 blame / diff / 与 HEAD diff |
| `<leader>hq` / `hQ` | 当前 hunk / 全部改动进 quickfix |
| `<leader>tb` / `td` / `tw` | 开关行 blame / 删除标记 / 词级 diff |
| `]c` / `[c` | 下 / 上一个改动(冲突场景同键跳冲突块) |
| `<leader>lg` | 打开 LazyGit(用户级安装于 ~/.local/bin) |
| `:Git` / `:gp` | fugitive(`:git` 输入时自动转 `:Git`;`:gp` = push) |

## 移动 / 编辑

| 键 | 作用 |
|---|---|
| `s` / `S` | leap 跳转(两字符搜索) |
| `gs` | leap 跨窗口跳转 |
| `v` 模式 `J` / `K` | 选中块下移 / 上移 |
| `gc` / `gcc` | 行注释开关(单行 / 带 motion,0.10+ 内置) |
| `gb` / `gbc` | 块注释 |
| `gco` / `gcO` / `gcA` | 下方 / 上方新增注释行 / 行尾注释 |

## 补全(nvim-cmp,插入模式)

| 键 | 作用 |
|---|---|
| `<C-n>` / `<C-p>` | 下 / 上选补全项(可跳 snippet 占位符) |
| `<C-Space>` | 手动触发补全(`<A-.>` 同效,`<A-,>` 取消) |
| `<CR>` | 确认选中项 |
| `<C-b>` / `<C-f>` | 文档窗口上 / 下滚动 |

## tmux 侧(prefix = `C-a`)

| 键 | 作用 |
|---|---|
| `C-h/j/k/l`(无前缀) | 与 nvim 联动的方向导航(见上) |
| `prefix h/j/k/l` | tmux 面板跳转(原有配置) |
| `prefix -` / `prefix \|` | 垂直 / 水平分屏 |
| `prefix a` | 发送前缀本身 |

## 历史包袱备注

- `<C-[>` 等同 ESC,不可用作快捷键(aerial 曾误绑,已改为 `]a` / `[a`)
- 普通 shell 面板中 `<C-l>` 清屏会被方向导航占用(跳右面板);`C-h/j/k` 在 shell 中本无意义
- `bn` / `bp` 覆盖了内置 `:bn` / `:bp` 的简写输入

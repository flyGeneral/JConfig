#!/usr/bin/env python3
# add by cjh: tmux 状态栏段, 显示本机 claude 会话状态(⛔等审批 ⚙执行中 ?等输入 💤挂机), 供 status-right #() 调用
#   当前聚焦 pane 所在的会话加 bg=colour237 高亮(与窗口列表当前窗口风格一致)
#   无 claude / 无会话 / 查询失败时输出空串, 状态栏不显示任何多余内容(dotfiles 迁移到无 claude 的服务器也安全)
#   agents 列表带 TTL 缓存 + flock; 焦点高亮每次实时计算(切窗口 1~2s 内跟上)
# add by cjh end
import fcntl, json, os, shutil, subprocess, sys, time

TTL = 4                                   # agents 列表缓存秒数; 状态栏 1s 刷新一次
CACHE = '/tmp/claude-agents-status.%d' % os.getuid()   # 固定路径, 不随 TMPDIR 变化
LOCK = CACHE + '.lock'

# 状态 -> (图标, 名称颜色); 颜色沿用本机 tmux 的 gruvbox 风格
STYLE = {
    'perm': ('⛔', 'colour203,bold'),   # 正在等权限审批
    'wait': ('?',  'colour215'),        # 等其他输入(提问等)
    'fail': ('✖',  'colour203'),        # 失败
    'busy': ('⚙',  'colour214'),        # 执行中
    'done': ('✔',  'colour142'),        # 完成
    'idle': ('💤', 'colour243,dim'),    # 挂机
}
ORDER = {'perm': 0, 'wait': 1, 'fail': 2, 'busy': 3, 'done': 4, 'idle': 5}

def classify(a):
    st = (a.get('status') or a.get('state') or '').lower()
    wf = (a.get('waitingFor') or '').lower()
    if 'permission' in wf:
        return 'perm'
    if st in ('busy', 'working'):
        return 'busy'
    if st in ('waiting', 'blocked'):
        return 'wait'
    if st == 'failed':
        return 'fail'
    if st in ('done', 'stopped'):
        return 'done'
    return 'idle'

def fetch_agents():
    if not shutil.which('claude'):
        return []                        # 没装 claude: 静默
    try:
        p = subprocess.run(['claude', 'agents', '--json', '--all'],
                           capture_output=True, text=True, timeout=5)
        return json.loads(p.stdout or '[]')
    except Exception:
        return None                      # 查询失败: 让调用方回退旧缓存

def load_cache():
    try:
        with open(CACHE) as f:
            return json.load(f)
    except Exception:
        return None

def get_agents():
    try:
        stale = time.time() - os.path.getmtime(CACHE) >= TTL
    except OSError:
        stale = True
    if not stale:
        cached = load_cache()
        if cached is not None:
            return cached
    fd = os.open(LOCK, os.O_CREAT | os.O_RDWR, 0o644)
    try:
        fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except OSError:
        cached = load_cache()            # 别的进程正在刷新: 先用旧值
        return cached or []
    agents = fetch_agents()
    if agents is None:
        agents = load_cache() or []      # 失败回退旧缓存, 不写坏数据
    tmp = CACHE + '.tmp'
    with open(tmp, 'w') as f:
        json.dump(agents, f)
    os.replace(tmp, CACHE)               # 原子替换
    return agents

def focused_descendant_pids():
    # 所有"聚焦 pane"(已 attach 会话的激活窗口激活 pane)的全部后代进程 pid
    try:
        out = subprocess.run(['tmux', 'list-panes', '-a', '-F',
            '#{session_attached} #{window_active} #{pane_active} #{pane_pid}'],
            capture_output=True, text=True, timeout=2).stdout
    except Exception:
        return set()
    roots = [f[3] for f in (l.split() for l in out.splitlines())
             if f[0] != '0' and f[1] == '1' and f[2] == '1']   # attached数>0 + 激活窗口的激活pane
    if not roots:
        return set()
    try:
        ps = subprocess.run(['ps', '-eo', 'pid,ppid'],
                            capture_output=True, text=True, timeout=2).stdout
    except Exception:
        return set()
    children = {}
    for line in ps.splitlines()[1:]:
        parts = line.split()
        if len(parts) == 2:
            children.setdefault(parts[1], []).append(parts[0])
    found, frontier = set(), list(roots)
    for _ in range(8):                   # 限 8 层(可能嵌套多层 shell), 防环
        nxt = []
        for p in frontier:
            for c in children.get(p, []):
                if c not in found:
                    found.add(c)
                    nxt.append(c)
        frontier = nxt
        if not frontier:
            break
    return found

def render(agents, cur_pids):
    ents = []
    for a in agents:
        if a.get('kind') == 'background' and a.get('state') in ('done', 'stopped', 'failed'):
            continue                     # 已退出(完成/停止/失败)的后台任务残留记录: 不占状态栏(总控台里仍可查)
        name = a.get('name') or os.path.basename(a.get('cwd') or '?').rstrip('/') or '?'
        name = name.replace('#', '')     # 防止名字里的 # 注入 tmux 颜色标记
        if len(name) > 12:
            name = name[:11] + '…'
        k = classify(a)
        icon, color = STYLE[k]
        hl = str(a.get('pid', '')) in cur_pids   # 聚焦 pane 里的会话: 加背景高亮
        if hl:
            color = color.replace(',dim', '') + ',bg=colour237,bold'
        ents.append((ORDER[k], icon + '#[fg=' + color + ']' + name + '#[default]'))
    ents.sort(key=lambda e: e[0])
    shown = [t for _, t in ents[:6]]
    if len(ents) > 6:
        shown.append('#[fg=colour243]+' + str(len(ents) - 6) + '#[default]')
    if not shown:
        return ''
    sep = ' #[fg=colour33]│#[default] '   # 会话间蓝色竖线分隔(饱和蓝, 无状态色冲突)
    return sep.join(shown) + ' '

if __name__ == '__main__':
    sys.stdout.write(render(get_agents(), focused_descendant_pids()))

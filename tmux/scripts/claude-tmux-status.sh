#!/usr/bin/env python3
# add by cjh: tmux 状态栏段, 显示本机 claude 会话状态(⛔等审批 ⚙执行中 💤挂机 ✔完成), 供 status-right #() 调用
#   无 claude / 无会话 / 查询失败时输出空串, 状态栏不显示任何多余内容(dotfiles 迁移到无 claude 的服务器也安全)
#   结果带 TTL 缓存 + flock, 避免每次刷新都真起一个 claude 进程
# add by cjh end
import fcntl, json, os, shutil, subprocess, sys, time

TTL = 4                                   # 缓存秒数; 状态栏 1s 刷新一次
CACHE = '/tmp/claude-agents-status.%d' % os.getuid()   # 固定路径, 不随 TMPDIR 变化
LOCK = CACHE + '.lock'

# 状态 -> (图标, 名称颜色); 颜色沿用本机 tmux 的 gruvbox 风格
STYLE = {
    'perm': ('⛔', 'colour203,bold'),   # 正在等权限审批
    'wait': ('?',  'colour215'),        # 等其他输入(提问等)
    'fail': ('✖',  'colour203'),        # 失败
    'busy': ('⚙',  'colour214'),        # 执行中
    'done': ('✔',  'colour142'),        # 后台任务完成
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

def render():
    if not shutil.which('claude'):
        return ''                        # 没装 claude: 静默
    try:
        p = subprocess.run(['claude', 'agents', '--json', '--all'],
                           capture_output=True, text=True, timeout=5)
        agents = json.loads(p.stdout or '[]')
    except Exception:
        return ''
    ents = []
    for a in agents:
        if a.get('kind') == 'background' and a.get('state') in ('done', 'stopped', 'failed'):
            continue                     # 已退出(完成/停止/失败)的后台任务残留记录: 不占状态栏(总控台里仍可查)
        name = a.get('name') or os.path.basename(a.get('cwd') or '?').rstrip('/') or '?'
        name = name.replace('#', '')     # 防止名字里的 # 注入 tmux 颜色标记
        if len(name) > 12:
            name = name[:11] + '…'
        icon, color = STYLE[classify(a)]
        ents.append((ORDER[classify(a)], icon + '#[fg=' + color + ']' + name + '#[default]'))
    ents.sort(key=lambda e: e[0])
    shown = [t for _, t in ents[:6]]
    if len(ents) > 6:
        shown.append('#[fg=colour243]+' + str(len(ents) - 6) + '#[default]')
    if not shown:
        return ''
    return '#[fg=colour243]│#[default] ' + '  '.join(shown) + ' '

def read_cache():
    try:
        with open(CACHE) as f:
            return f.read()
    except OSError:
        return None

def main():
    try:
        stale = time.time() - os.path.getmtime(CACHE) >= TTL
    except OSError:
        stale = True
    if not stale:
        out = read_cache()
        if out is not None:
            sys.stdout.write(out)
            return
    fd = os.open(LOCK, os.O_CREAT | os.O_RDWR, 0o644)
    try:
        fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except OSError:
        sys.stdout.write(read_cache() or '')   # 别的进程正在刷新: 先用旧值
        return
    out = render()
    tmp = CACHE + '.tmp'
    with open(tmp, 'w') as f:
        f.write(out)
    os.replace(tmp, CACHE)               # 原子替换
    sys.stdout.write(out)

if __name__ == '__main__':
    main()

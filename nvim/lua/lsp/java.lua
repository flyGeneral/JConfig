-- Java LSP：eclipse.jdt.ls 由 nvim-jdtls 启动（lspconfig.jdtls 已废弃）
-- 依赖：mason 安装的 jdtls 二进制 + JDK 17+（用户级安装于 ~/.local/opt/jdk-21）
local M = {}

-- 查找 JDK：JAVA_HOME 优先，其次用户级 JDK，最后系统 PATH 里的 java
local function find_java()
    local candidates = {}
    if vim.env.JAVA_HOME then
        table.insert(candidates, vim.env.JAVA_HOME)
    end
    table.insert(candidates, vim.fn.expand("~/.local/opt/jdk-21"))
    if vim.fn.executable("java") == 1 then
        return nil, vim.fn.exepath("java") -- 系统 PATH 已有 java，无需设置环境
    end
    for _, home in ipairs(candidates) do
        local bin = home .. "/bin/java"
        if vim.fn.executable(bin) == 1 then
            return home, bin
        end
    end
end

function M.start()
    if vim.fn.executable("jdtls") ~= 1 then
        vim.notify("Java LSP 需要 jdtls（mason 已配置自动安装）", vim.log.levels.WARN)
        return
    end

    local java_home, _ = find_java()
    if not (java_home or vim.fn.executable("java") == 1) then
        vim.notify(
            "Java LSP 需要 JDK 17+（用户级安装于 ~/.local/opt/jdk-21，或 sudo apt install openjdk-21-jdk）",
            vim.log.levels.WARN
        )
        return
    end

    -- 项目根识别：gradle/maven 标记优先，回退 .git / 当前目录
    local root = vim.fs.root(0, { "gradlew", "mvnw", "pom.xml", "build.gradle", "settings.gradle", ".git" })
        or vim.fn.getcwd()

    -- 每个项目独立 workspace，避免多项目缓存互踩
    local project = vim.fs.basename(root)
    local workspace = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project

    local config = {
        cmd = {
            "jdtls",
            "-data", workspace,
        },
        root_dir = root,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        -- 悬浮/补全由全局 LspAttach autocmd 统一配置键位，这里无需 on_attach
    }

    -- 确保 jdtls 进程能找到 java（应对非 shell 启动 nvim 的场景）
    if java_home then
        config.cmd_env = {
            JAVA_HOME = java_home,
            PATH = java_home .. "/bin:" .. vim.env.PATH,
        }
    end

    -- start_or_attach 对同一 root 幂等，重复打开 java 文件不会重复启动
    require("jdtls").start_or_attach(config)
end

return M

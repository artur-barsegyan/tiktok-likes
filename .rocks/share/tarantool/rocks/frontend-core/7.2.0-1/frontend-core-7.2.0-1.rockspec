package = 'frontend-core'
version = '7.2.0-1'
source  = {
    url = 'git+https://github.com/tarantool/frontend-core.git',
    tag = '7.2.0',
}
dependencies = {
    'lua >= 5.1',
}
build = {
    type = 'make';
    install = {
        lua = {
            ['frontend-core'] = 'frontend-core.lua',
            -- ['frontend-core.bundle'] -- installed with make
        },
    },
    install_variables = {
        INST_LUADIR="$(LUADIR)",
    },

}

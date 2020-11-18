package = 'space-explorer'
version = 'scm-1'
source  = {
    url = 'git+ssh://git@gitlab.com:tarantool/enterprise/space-explorer.git',
    branch = 'master',
}
dependencies = {
    'lua >= 5.1',
}
build = {
    type = 'make';
    install = {
        lua = {
            ['space-explorer'] = 'space-explorer.lua';
            ['space-explorer.space-manager'] = 'space-explorer/space-manager.lua';
            ['space-explorer.utils'] = 'space-explorer/utils.lua';
            -- ['space-explorer.bundle'] -- installed with make
        },
    },
    install_variables = {
        INST_LUADIR="$(LUADIR)",
    },
}

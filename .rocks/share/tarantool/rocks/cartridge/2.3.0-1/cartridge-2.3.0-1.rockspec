package = 'cartridge'
version = '2.3.0-1'
source  = {
    url = 'git+https://github.com/tarantool/cartridge.git',
    tag = '2.3.0',
}
dependencies = {
    'lua >= 5.1',
    'ddl == 1.1.0-1',
    'http == 1.1.0-1',
    'checks == 3.0.1-1',
    'lulpeg == 0.1.2-1',
    'errors == 2.1.4-1',
    'vshard == 0.1.16-1',
    'membership == 2.2.0-1',
    'frontend-core == 7.2.0-1',
}

external_dependencies = {
    TARANTOOL = {
        header = 'tarantool/module.h',
    },
}

build = {
    type = 'cmake',
    variables = {
        version = '2.3.0-1',
        TARANTOOL_DIR = '$(TARANTOOL_DIR)',
        TARANTOOL_INSTALL_LIBDIR = '$(LIBDIR)',
        TARANTOOL_INSTALL_LUADIR = '$(LUADIR)',
        TARANTOOL_INSTALL_BINDIR = '$(BINDIR)',
    },
    copy_directories = {'doc'},
}

package = 'cartridge-cli-extensions'
version = '1.0.0-1'
source  = {
    url = 'git+https://github.com/tarantool/cartridge-cli-extensions.git',
    tag = '1.0.0',
}

dependencies = {
    'lua ~> 5.1',
}

build = {
    type = 'cmake',
    variables = {
        version = '1.0.0-1',
        TARANTOOL_INSTALL_LUADIR = '$(LUADIR)',
    },
}

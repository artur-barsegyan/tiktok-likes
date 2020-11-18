package = 'errors'
version = '2.1.3-1'
source = {
    url = 'git+https://github.com/tarantool/errors.git',
    tag = '2.1.3',
}

description = {
    summary = 'Convenient error handling in tarantool',
    homepage = 'https://github.com/tarantool/errors',
    license = 'BSD',
}

dependencies = {
    'lua >= 5.1',
}

build = {
    type = 'cmake',
    variables = {
        TARANTOOL_INSTALL_LUADIR = '$(LUADIR)',
    },
    copy_directories = {'doc'},
}


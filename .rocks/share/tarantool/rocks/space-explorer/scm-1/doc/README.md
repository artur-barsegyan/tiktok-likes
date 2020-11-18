# Space explorer

Rock for exploring tarantool spaces in cartridge

## Installation

- Add `'space-explorer == ...'` to rockspec dependencies
- Run `tarantoolctl rocks make`
- Add `require('space-explorer').init()` after `cartridge.cfg` call

## Example

*example-app-scm-1.rockspec*
```lua
package = 'example-app'
version = 'scm-1'
source  = {
    url = '/dev/null',
}
dependencies = {
    'tarantool',
    'lua >= 5.1',
    'luatest == 0.2.0-1',
    'ldecnumber == 1.1.3-1',
    'cartridge == scm-1',
    'space-explorer == scm-1'
}
build = {
    type = 'none';
}
```

*init.lua*
```lua
#!/usr/bin/env tarantool

require('strict').on()

local cartridge = require('cartridge')

local ok, err = cartridge.cfg({
    roles = {
        'cartridge.roles.vshard-storage',
        'cartridge.roles.vshard-router',
        'app.roles.api',
        'app.roles.storage',
    },
    cluster_cookie = 'example-app-cluster-cookie',
})

require('space-explorer').init()

assert(ok, tostring(err))
```

## Guide

Space explore guide can be seen [here](https://www.tarantool.io/en/enterprise_doc/1.10/admin/#exploring-spaces).


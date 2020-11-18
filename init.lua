#!/usr/bin/env tarantool

require('strict').on()

package.setsearchroot()

-- configure cartridge

local cartridge = require('cartridge')

local ok, err = cartridge.cfg({
    roles = {
        'cartridge.roles.vshard-storage',
        'cartridge.roles.vshard-router',
        'cartridge.roles.metrics',
        'app.roles.custom',
        'cartridge.roles.crud-storage',
        'cartridge.roles.crud-router'
    },
    cluster_cookie = 'tiktok-likes-cluster-cookie',
})

require('space-explorer').init()

assert(ok, tostring(err))

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


-- register admin function probe to use it with "cartridge admin"

-- local cli_admin = require('cartridge-cli-extensions.admin')

-- cli_admin.init()

-- local probe = {
--     usage = 'Probe instance',
--     args = {
--         uri = {
--             type = 'string',
--             usage = 'Instance URI',
--         },
--     },
--     call = function(opts)
--         opts = opts or {}

--         if opts.uri == nil then
--             return nil, "Please, pass instance URI via --uri flag"
--         end

--         local cartridge_admin = require('cartridge.admin')
--         local ok, err = cartridge_admin.probe_server(opts.uri)

--         if not ok then
--             return nil, err.err
--         end

--         return {
--             string.format('Probe %q: OK', opts.uri),
--         }
--     end,
-- }

-- local ok, err = cli_admin.register('probe', probe.usage, probe.args, probe.call)
-- assert(ok, err)

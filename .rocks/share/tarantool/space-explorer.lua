local json = require('json')
local space_manager = require('space-explorer.space-manager')
local space_bundle = require('space-explorer.bundle')
local cartridge = require('cartridge')
local cartridge_pool = require('cartridge.pool')
local utils = require('space-explorer.utils')
local ok, front = pcall(require, 'frontend-core')
if not ok then
    -- in v4.0.0 we have changed rock name
    -- from "front" to "frontend"
    front = require('front')
end

local server_hash = function(server)
    return server.uuid
end


local json_response = function(data, status)
    local code = status
    if code == nil then
        code = 200
    end
    return {
        status = code,
        body = json.encode(data),
        headers = { ['content-type'] = 'application/json' }
    }
end

local get_box_by_server = function(server)
    local connectbox = cartridge_pool.connect(server.uri)
    return connectbox
end



local choose_server_by_hash = function(hash)
    local servers = cartridge.admin_get_servers()
    for _, server in ipairs(servers) do
        if server_hash(server) == hash then
            return get_box_by_server(server)
        end
    end
    return nil
end

local get_space_by_req = function(req)
    local connectbox = choose_server_by_hash(req:stash('host_hash'))
    local space_id = tonumber(req:stash('space_id'), 10)
    local space = connectbox.space[space_id]
    assert(space, 'should be space')
    return space
end

local space_list = function(req)
    local connectbox = choose_server_by_hash(req:stash('host_hash'))
    if connectbox == nil then
        return json_response({ code = 'error', message = 'not_connected'}, 500)
    end
    local res = space_manager.space_list(connectbox)
    return json_response({code = 'ok', data = res})
end

local space_items = function(req)
    local connectbox = choose_server_by_hash(req:stash('host_hash'))
    if connectbox == nil then
        return json_response({ code = 'error', message = 'not_connected'}, 500)
    end
    local space_id = tonumber(req:stash('space_id'), 10)
    local conditions = {}
    if req.method == 'POST' then
        conditions = req:json()
    end

    local items = space_manager.space_items(connectbox, space_id, conditions)
    return json_response({ code = 'ok', data = items})
end

local function even(arr, detector)
    for _, value in ipairs(arr) do
        if detector(value) then
            return value
        end
    end
    return nil
end

local function select_host_property(host)
    local props = {'uri', 'status', 'uuid', 'alias'}
    local res = {}
    for _, prop in ipairs(props) do
        res[prop] = host[prop]
    end
    res['hash'] = host['uuid']
    return res
end

local function host_list(req)
    local servers = cartridge.admin_get_servers()
    local res = utils.map(servers, select_host_property)
    return json_response({code = 'ok', data = res})
end

local request_handler = function(cb)
    local processed = function (req)
        local ok, res = pcall(cb, req)
        if ok == true then
            return res
        else
            return json_response({code = 'error', message = res}, 400)
        end
    end
    return processed
end

local function init()
    local httpd = cartridge.service_get('httpd')

    if httpd ~= nil then
        httpd:route(
            { path = '/space-explorer/api/0.0/hosts/:host_hash/spaces/:space_id/data', method = 'GET'},
            request_handler(space_items)
        )
        httpd:route(
            { path = '/space-explorer/api/0.0/hosts/:host_hash/spaces/:space_id/data', method = 'POST' },
            request_handler(space_items)
        )

        httpd:route(
            { path = '/space-explorer/api/0.0/hosts/:host_hash/spaces'},
            request_handler(space_list)
        )
        httpd:route(
            { path = '/space-explorer/api/0.0/hosts'},
            request_handler(host_list)
        )
        front.add('space-explorer', space_bundle)
    end
end

return {
    init = init
}

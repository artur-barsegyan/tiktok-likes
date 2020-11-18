local cartridge = require('cartridge')
local crud = require('crud')
local uuid = require('uuid')
local json = require('json')

local function create_response(obj, err)
    local resp
    if err ~= nil then
        resp = { body = json.encode({status = "Error!", error = err}), status = 500 }
    else
        resp = { body = json.encode({status = "Success!", result = obj}), status = 200 }
    end

    return resp
end

function create_user(req)
    local fullname = req:post_param("fullname")
    local obj, err = crud.insert_object('users', { user_id = uuid.new(), fullname = fullname })

    return create_response(obj, err)
end

function add_video(req)
    local description = req:post_param("description")
    local obj, err = crud.insert_object('videos', { video_id = uuid.new(), description = description, likes = 0 })

    return create_response(obj, err)
end

function like_video(req)
    local video_id = req:post_param("video_id")
    local user_id = req:post_param("user_id")

    -- TODO: 2 or more writers simultaneously
    local obj, err = crud.update('videos', uuid.fromstr(video_id), {{'+', 'likes', 1}})
    if err == nil then
        obj, err = crud.insert_object('likes', { like_id = uuid.new(),
                                                      video_id = uuid.fromstr(video_id),
                                                      user_id = uuid.fromstr(user_id)})
    end

    return create_response(obj, err)
end


local function init(opts) -- luacheck: no unused args
    local httpd = cartridge.service_get('httpd')
    httpd:route({path = '/like', method = 'POST'}, like_video)
    httpd:route({path = '/create_user', method = 'POST'}, create_user)
    httpd:route({path = '/add_video', method = 'POST'}, add_video)

    return true
end

local function stop()
end

local function validate_config(conf_new, conf_old) -- luacheck: no unused args
    return true
end

local function apply_config(conf, opts) -- luacheck: no unused args
    -- if opts.is_master then
    -- end

    return true
end

return {
    role_name = 'app.roles.custom',
    init = init,
    stop = stop,
    validate_config = validate_config,
    apply_config = apply_config,
    -- dependencies = {'cartridge.roles.vshard-router'},
}

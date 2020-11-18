local cartridge = require('cartridge')
local crud = require('crud')
local uuid = require('uuid')
local json = require('json')

function add_user(request)
    local fullname = request:post_param("fullname")
    local result, err = crud.insert_object('users', { user_id = uuid.new(), fullname = fullname })
    if err ~= nil then
        return { body = json.encode({status = "Error!", error = err}), status = 500 }
    end

    return { body = json.encode({status = "Success!", result = result}), status = 200 }
end

function add_video(request)
    local description = request:post_param("description")
    local result, err = crud.insert_object('videos', { video_id = uuid.new(), description = description, likes = 0 })
    if err ~= nil then
        return { body = json.encode({status = "Error!", error = err}), status = 500 }
    end

    return { body = json.encode({status = "Success!", result = result}), status = 200 }
end

function like_video(request)
    local video_id = request:post_param("video_id")
    local user_id = request:post_param("user_id")

    local result, err = crud.update('videos', uuid.fromstr(video_id), {{'+', 'likes', 1}})
    if err ~= nil then
        return { body = json.encode({status = "Error!", error = err}), status = 500 }
    end

    result, err = crud.insert_object('likes', { like_id = uuid.new(),
                                                video_id = uuid.fromstr(video_id),
                                                user_id = uuid.fromstr(user_id)})
    if err ~= nil then
        return { body = json.encode({status = "Error!", error = err}), status = 500 }
    end

    return { body = json.encode({status = "Success!", result = result}), status = 200 }
end


local function init(opts) -- luacheck: no unused args
    local httpd = cartridge.service_get('httpd')
    httpd:route({path = '/like', method = 'POST'}, like_video)
    httpd:route({path = '/add_user', method = 'POST'}, add_user)
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

local utils = require('space-explorer.utils')

local space_manager = {
}

local context_choose = function(spc, index_name)
    if index_name ~= nil then
        local function is_condition_index(el)
            return el.name == index_name
        end
        local index = utils.even(spc.index, is_condition_index)
        assert(index ~= nil, 'not existed index')
        return index
    end
    return spc
end

function space_manager.space_list(connectbox)
    local mapped_property = {'engine', 'field_count', 'temporary',  'enabled', 'name', 'id'}
    local mapped_index_property = {'unique', 'parts', 'id', 'name', 'type'}
    local res = {}
    local space_sizing = connectbox:eval([[
        local sizing = {};
        for _, spc in pairs(box.space) do
            if sizing[spc.name] == nil and spc.id > box.schema.SYSTEM_ID_MAX then
                sizing[spc.name] = { bsize = spc:bsize(), len = spc.engine == 'memtx' and spc:len() or 0, is_local = spc.is_local  }
            end
        end
        return sizing
    ]])
    for space_name, spc in pairs(connectbox.space) do
        if spc.id > box.schema.SYSTEM_ID_MAX then

            local add_spc = {space_name = space_name, format = spc:format()}
            for _, prop in ipairs(mapped_property) do
                add_spc[prop] = spc[prop]
            end
            local indexes = {}
            for key, index in pairs(spc.index) do
                if type(key) == 'string' then
                    local mapped_index = {}
                    for _, index_prop in ipairs(mapped_index_property) do
                        mapped_index[index_prop] = index[index_prop]
                    end
                    table.insert(indexes, mapped_index)
                end
            end
            add_spc['index'] = indexes
            add_spc['bsize'] = space_sizing[spc.name].bsize
            add_spc['len'] = space_sizing[spc.name].len
            add_spc['is_local'] = space_sizing[spc.name].is_local

            table.insert(res, add_spc)
        end
    end
    return res
end

local default_conditions = {
    limit = 50,
    offset = 0,
    iterator = nil,
    index = nil,
    key = nil,
}

function space_manager.space_items(connectbox, space_id, conditions)
    local real_conditions = utils.merge(default_conditions, conditions)
    local spc = connectbox.space[space_id]
    assert(spc ~= nil, 'not existed space')

    local context = context_choose(spc, real_conditions.index)
    return context:select(
        conditions.key,
        {
            iterator = real_conditions.iterator,
            limit = real_conditions.limit,
            offset = real_conditions.offset,
        }
    )
end


return space_manager

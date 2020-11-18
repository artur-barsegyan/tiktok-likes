local utils = {}

local function merge(...)
    local ret = {}

    for i = 1, select('#', ...) do
        local tbl = select(i, ...)
        assert(type(tbl) == 'table')
        for k, v in pairs(tbl) do
            ret[k] = v
        end
    end

    return ret
end

local function map(t, transform)
    local mapped_table = {}
    for k, v in pairs(t) do
        mapped_table[k] = transform(v)
    end
    return mapped_table
end

local function reduce(t, cb, start_value)
    local acc = start_value
    for k, v in ipairs(t) do
        acc = cb(acc, v)
    end
    return acc
end

local function even(arr, detector)
    for _, value in pairs(arr) do
        if detector(value) then
            return value
        end
    end
    return nil
end


return {
    merge = merge,
    map = map,
    reduce = reduce,
    even = even
}

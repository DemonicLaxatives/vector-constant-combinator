local util = {}

--- @param path string
--- @return string
function util.rebase_path(path)
    local result = path:gsub('^__base__', "__vector-constant-combinator__")
    return result
end

return util
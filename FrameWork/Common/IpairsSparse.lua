--可以遍历松散数组的迭代器

local function IpairsSparse(t)
    -- tmpIndex will hold sorted indices, otherwise
    -- this iterator would be no different from pairs iterator
    local tmpIndex = {}
    local index, _ = next(t)
    while index do
        tmpIndex[#tmpIndex+1] = index
        index, _ = next(t, index)
    end
    -- sort table indices
    table.sort(tmpIndex)
    local j = 1
  
    return function()
        -- get index value
        local i = tmpIndex[j]
        j = j + 1
        if i then
            return i, t[i]
        end
    end
end

SetGlobal("IpairsSparse",IpairsSparse)
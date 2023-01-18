present_table = function(x)
    result = {}
    for i, tab in ipairs(x) do
        result[i] = "{" .. table.concat(tab, ", ") .. "}"
    end
    return "{" .. table.concat(result, ", ") .. "}"
end

neighbors = function()
    local memo = {}
    return function(x)
        local hash = table.concat(x, ",")
        if memo[hash] == nil then
            memo[hash] = {
                { x[1] - 1, x[2] },
                { x[1] + 1, x[2] },
                { x[1], x[2] - 1 },
                { x[1], x[2] + 1 },
            }
        end
        return memo[hash]
    end
end

get_neighbors = neighbors()
print(present_table(get_neighbors({ 2, 3 })))
print(present_table(get_neighbors({ 1, 4 })))
print(present_table(get_neighbors({ 2, 3 })))

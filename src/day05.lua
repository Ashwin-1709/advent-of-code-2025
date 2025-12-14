function append(table, value)
    table[#table + 1] = value
end

function compare(a, b)
    if #a ~= #b then
        return #a > #b
    end
    return a >= b
end

function parse()
    local id_range, ingredients, read_range = {}, {}, true
    for line in io.lines("input.txt") do
        if line == "" then
            read_range = false
            goto continue
        end
        if read_range then
            local l, r = string.match(line, "(%d+)%-(%d+)")
            append(id_range, {
                l = l,
                r = r
            })
        else
            append(ingredients, line)
        end
        ::continue::
    end

    local function compare_ranges(a, b)
        if a.l ~= b.l then
            return not compare(a.l, b.l)
        else
            return not compare(a.r, b.r)
        end
    end

    table.sort(id_range, compare_ranges)
    return id_range, ingredients
end

function solve(id_range, ingredients)
    local fresh, fresh_ids = 0, 0
    for _, id in pairs(ingredients) do
        local match = false
        for _, range in pairs(id_range) do
            if compare(id, range.l) and compare(range.r, id) then
                match = true
                goto continue
            end
        end
        ::continue::
        if match then
            fresh = fresh + 1
        end
    end

    local curl, curr = -1, -1
    for _, range in pairs(id_range) do
        local l, r = tonumber(range.l), tonumber(range.r)
        if curl == -1 and curr == -1 then
            curl = l
            curr = r
            goto next
        end
        if l > curr then
            fresh_ids = fresh_ids + curr - curl + 1
            curl = l
            curr = r
        else
            curl = math.min(l, curl)
            curr = math.max(r, curr)
            goto next
        end
        ::next::
    end

    fresh_ids = fresh_ids + curr - curl + 1
    return fresh, fresh_ids
end

local id_range, ingredients = parse()
print(solve(id_range, ingredients))

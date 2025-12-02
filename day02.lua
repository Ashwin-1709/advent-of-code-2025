function parse()
    local file = io.open("input.txt")
    local content = file:read("*all")
    local pattern = "%d+-%d+"
    local ranges = {}
    for match in string.gmatch(content, pattern) do
        local range_pattern = "(%d+)-(%d+)"
        l, r = string.match(match, range_pattern)
        ranges[l] = r
    end
    return ranges
end

function solve(ranges)
    local invalid_ids, multi_seq_ids = 0, 0

    local function is_mirror(s)
        if #s % 2 ~= 0 then
            return false
        end
        local first_half = string.sub(s, 1, #s // 2)
        local second_half = string.sub(s, #s // 2 + 1, #s)
        return first_half == second_half
    end

    local function is_multiseq_chunk(s, chunk_size)
        if #s % chunk_size ~= 0 then
            return false
        end
        local first_chunk = string.sub(s, 1, chunk_size)
        for x = chunk_size + 1, #s, chunk_size do
            local current_chunk = string.sub(s, x, x + chunk_size - 1)
            if current_chunk ~= first_chunk then
                return false
            end
        end
        return true
    end

    local function is_multiseq_id(s)
        for chunk_size = 1, #s // 2 do
            if is_multiseq_chunk(s, chunk_size) then
                return true
            end
        end
        return false
    end

    for l, r in pairs(ranges) do
        for x = tonumber(l), tonumber(r) do
            local s = tostring(x)
            if is_mirror(s) then
                invalid_ids = invalid_ids + x
                multi_seq_ids = multi_seq_ids + x
            elseif is_multiseq_id(s) then
                multi_seq_ids = multi_seq_ids + x
            end
        end
    end
    return invalid_ids, multi_seq_ids
end

ranges = parse()
print(solve(ranges))

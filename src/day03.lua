NINF = -math.maxinteger

function parse()
    local index, banks = 1, {}
    for bank in io.lines("input.txt") do
        banks[index] = bank
        index = index + 1
    end
    return banks
end

function solve(banks)
    local joltage, multi_joltage = 0, 0

    for _, bank in ipairs(banks) do 
        local cache = {}
        function cache.generate_key(index, moves_pending)
            return tostring(index) .. ":" .. tostring(moves_pending)
        end

        local function dp(index, moves_pending)
            if moves_pending == 0 then
                return 0
            end
            if index > #bank then
                return NINF
            end 
            local state = cache.generate_key(index, moves_pending)
            if cache[state] ~= nil then
                return cache[state]
            end
            cache[state] = dp(index + 1, moves_pending)
            if moves_pending > 0 then
                local taken = dp(index + 1, moves_pending - 1)
                local current = tonumber(string.sub(bank, index, index))
                local dig = taken
                while dig > 0 do
                    current = current * 10
                    dig = dig // 10
                end
                cache[state] = math.max(cache[state], current + taken)
            end
            return cache[state]
        end

        joltage = joltage + dp(1, 2)
        multi_joltage = multi_joltage + dp(1, 12)
    end
    return joltage, multi_joltage
end

banks = parse()
print(solve(banks))


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
        local dp = {}
        function dp.generate_key(index, moves_pending)
            return tostring(index) .. ":" .. tostring(moves_pending)
        end

        local function f(index, moves_pending)
            if moves_pending == 0 then
                return 0
            end
            if index > #bank then
                return NINF
            end 
            local state = dp.generate_key(index, moves_pending)
            if dp[state] ~= nil then
                return dp[state]
            end
            dp[state] = f(index + 1, moves_pending)
            if moves_pending > 0 then
                local taken = f(index + 1, moves_pending - 1)
                local current = tonumber(string.sub(bank, index, index))
                local dig = taken
                while dig > 0 do
                    current = current * 10
                    dig = dig // 10
                end
                dp[state] = math.max(dp[state], current + taken)
            end
            return dp[state]
        end

        joltage = joltage + f(1, 2)
        multi_joltage = multi_joltage + f(1, 12)
    end
    return joltage, multi_joltage
end

banks = parse()
print(solve(banks))


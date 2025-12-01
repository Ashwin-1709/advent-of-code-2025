local max_limit = 100

function parse()
    operations, index = {}, 1
    local input = "input.txt"
    for line in io.lines(input) do
        operations[index] = line
        index = index + 1
    end
    return operations
end

function solve(operations)
    local at_zero, current_pos, cross_zero = 0, 50, 0
    for _, op in ipairs(operations) do
        local moves = tonumber(string.sub(op, 2))
        local full_circles = math.floor(moves / max_limit)
        local dir = op:sub(1, 1)
        cross_zero = cross_zero + full_circles

        local pending = moves % max_limit
        for step = 1, pending do
            if dir == 'L' then
                current_pos = current_pos - 1
                if current_pos < 0 then
                    current_pos = 99
                end
            else 
                current_pos = current_pos + 1
                if current_pos >= max_limit then
                    current_pos = 0
                end
            end

            if current_pos == 0 then
                cross_zero = cross_zero + 1
            end
        end

        if current_pos == 0 then
            at_zero = at_zero + 1
        end
        
    end
    return at_zero, cross_zero
end

operations = parse()
print(solve(operations))

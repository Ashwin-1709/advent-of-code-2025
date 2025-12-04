local roll = '@'
local dx = {0, -1, -1, -1, 0, 1, 1, 1}
local dy = {-1, -1, 0, 1, 1, 1, 0, -1}


function parse()
    local grid, n = {}, 1
    for row in io.lines("input.txt") do
        grid[n] = row
        n = n + 1
    end
    return grid
end

function update_grid(grid, row, col, new_char)
    local original_row_str = grid[row]
    local len = string.len(original_row_str)
    local part_before = string.sub(original_row_str, 1, col - 1)
    local part_after = string.sub(original_row_str, col + 1, len)
    grid[row] = part_before .. new_char .. part_after
end

function solve(grid)
    local valid, removed = 0, {}
    local function ok(n, m, x, y)
        return x <= n and x > 0 and y <= m and y > 0
    end
    for x, row in ipairs(grid) do
        for y = 1, #row do
            local rolls = 0
            if string.sub(row, y, y) ~= roll then
                goto continue
            end
            for c = 1, 8 do
                local nx = x + dx[c]
                local ny = y + dy[c]
                if ok(#grid, #row, nx, ny) and string.sub(grid[nx], ny, ny) == roll then
                    rolls = rolls + 1
                end
            end
            if rolls < 4 then
                valid = valid + 1
                removed[valid] = {x = x, y = y}
            end
            ::continue::
        end
    end
    for _, cell in ipairs(removed) do
        update_grid(grid, cell.x, cell.y, '.')
    end
    return valid
end

local grid = parse()
local total_removed = 0
while true do
    local count = solve(grid)
    if count == 0 then
        break
    end
    total_removed = total_removed + count
end

print(total_removed)

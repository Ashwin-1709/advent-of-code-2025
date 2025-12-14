function append(table, value)
    table[#table + 1] = value
end

function make_key(x, y)
    return x .. "|" .. y
end

Queue = {}
function Queue.new()
    queueTable = {
        data = {},
        front = 1,
        tail = 0,

        push = function(self, value)
            self.tail = self.tail + 1
            self.data[self.tail] = value
        end,

        pop = function(self)
            local value = self.data[self.front]
            self.data[self.front] = nil
            self.front = self.front + 1
            return value
        end,

        is_empty = function(self)
            return self.front > self.tail
        end
    }
    return queueTable
end

function parse()
    local grid, sx, sy = {}, -1, -1
    for row in io.lines("input.txt") do
        append(grid, row)
        local y = string.find(row, 'S')
        if y ~= nil then
            sx = #grid
            sy = y
        end
    end
    return grid, sx, sy
end

function count_timelines(grid, sx, sy)
    local N, M = #grid, #grid[1]
    local dp = {}
    for x = 1, N do
        dp[x] = {}
        for y = 1, M do
            dp[x][y] = -1
        end
    end

    local function f(x, y) 
        if x == N then
            return 1
        end
        if dp[x][y] ~= -1 then
            return dp[x][y]
        end
        dp[x][y] = 0
        local drop = string.sub(grid[x + 1], y, y)
        if drop == '.' then
            dp[x][y] = dp[x][y] + f(x + 1, y)
        else
            if y - 1 >= 1 then
                dp[x][y] = dp[x][y] + f(x + 1, y - 1)
            end
            if y + 1 <= M then
                dp[x][y] = dp[x][y] + f(x + 1, y + 1)
            end
        end

        return dp[x][y]
    end
    
    return f(sx, sy)
end

function solve(grid, sx, sy)
    local splits, timelines = 0, 0
    local seen, Q  = {}, Queue.new()

    Q:push({
        x = sx,
        y = sy
    })

    local function ok(x, y, n, m)
        return x >= 1 and y >= 1 and x <= n and y <= m
    end

    while not Q:is_empty() do
        local cur = Q:pop()
        local cell = make_key(cur.x, cur.y)
        if seen[cell] or not ok(cur.x + 1, cur.y, #grid, #grid[cur.x]) then
            goto continue
        end
        seen[make_key(cur.x, cur.y)] = true
        local nxt = string.sub(grid[cur.x + 1], cur.y, cur.y)
        if nxt == '.' then
            Q:push({
                x = cur.x + 1,
                y = cur.y
            })
        else
            splits = splits + 1
            if ok(cur.x + 1, cur.y - 1, #grid, #grid[cur.x]) then
                Q:push({
                    x = cur.x + 1,
                    y = cur.y - 1
                })
            end
            if ok(cur.x + 1, cur.y + 1, #grid, #grid[cur.x]) then
                Q:push({
                    x = cur.x + 1,
                    y = cur.y + 1
                })
            end
        end
        ::continue::
    end
    return splits, count_timelines(grid, sx, sy)
end

grid, sx, sy = parse()
print(solve(grid, sx, sy))

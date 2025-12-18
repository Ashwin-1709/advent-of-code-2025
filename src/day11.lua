local function append(table, value)
    table[#table + 1] = value
end

local function split(str, del)
    local tokens = {}
    local pattern = string.format("([^%s]+)", del)
    for token in string.gmatch(str, pattern) do
        append(tokens, token)
    end
    return tokens
end

local function parse()
    local graph = {}
    for row in io.lines("input.txt") do
        local node, edge_list = table.unpack(split(row, ':'))
        graph[node] = split(edge_list, ' ')
    end
    return graph
end

local function get_paths(graph, start_node, end_node)
    local dp = {}
    local function f(node)
        if node == end_node then
            return 1
        end
        if dp[node] ~= nil then
            return dp[node]
        end
        dp[node] = 0
        for _, nxt in ipairs(graph[node]) do
            dp[node] = dp[node] + f(nxt)
        end
        return dp[node]
    end

    return f(start_node)
end

local function paths_with_conditions(graph, start_node, end_node)
    local node_id = {
        ["dac"] = 0,
        ["fft"] = 1
    }
    local dp = {}

    for node, _ in pairs(graph) do
        dp[node] = {}
        for mask = 0, 3 do
            dp[node][mask] = -1
        end
    end

    local function f(node, mask)
        if node == end_node then
            if mask == 3 then
                return 1
            end
            return 0
        end
        if dp[node][mask] ~= -1 then
            return dp[node][mask]
        end
        dp[node][mask] = 0
        for _, nxt in ipairs(graph[node]) do
            local nxt_mask = 0
            if node_id[nxt] ~= nil then
                nxt_mask = nxt_mask | (1 << node_id[nxt])
            end
            dp[node][mask] = dp[node][mask] + f(nxt, mask | nxt_mask)
        end
        return dp[node][mask]
    end

    return f(start_node, 0)
end

local graph = parse()
print(paths_with_conditions(graph, "svr", "out"))
print(get_paths(graph, "you", "out"))

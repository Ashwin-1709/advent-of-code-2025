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
    local coordinates = {}
    for junction in io.lines("input.txt") do
        local x, y, z = table.unpack(split(junction, ','))
        append(coordinates, {
            x = tonumber(x),
            y = tonumber(y),
            z = tonumber(z)
        })
    end
    return coordinates
end

local function get_all_distances(coordinates)
    local distances = {}
    for i, a in ipairs(coordinates) do
        for j, b in ipairs(coordinates) do
            if j >= i then
                goto continue
            end
            append(distances, {
                from = j,
                to = i,
                dis = (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y) + (a.z - b.z) * (a.z - b.z)
            })
        end
        ::continue::
    end

    table.sort(distances, function(a, b)
        return a.dis < b.dis
    end)

    return distances
end

DSU = {}
function DSU.new()
    DSUTable = {
        parent = {},
        size = {},

        init = function(self, node_cnt)
            for node = 1, node_cnt do
                append(self.parent, node)
                append(self.size, 1)
            end
        end,

        find = function(self, node)
            if self.parent[node] == node then
                return node
            end
            self.parent[node] = self:find(self.parent[node])
            return self.parent[node]
        end,

        join = function(self, to, from)
            local par_to, par_from = self:find(to), self:find(from)
            if par_to ~= par_from then
                if self.size[par_to] < self.size[par_from] then
                    par_to, par_from = par_from, par_to
                end
                self.size[par_to] = self.size[par_to] + self.size[par_from]
                self.parent[par_from] = par_to
            end
        end
    }
    return DSUTable
end

local function limited_join(coordinates, distances, max_joins)
    local dsu, join_id = DSU.new(), 1
    dsu:init(#coordinates)

    while max_joins > 0 and join_id <= #distances do
        local best_join = distances[join_id]
        local l, r = best_join.to, best_join.from
        if dsu:find(l) ~= dsu:find(r) then
            dsu:join(l, r)
        end
        max_joins = max_joins - 1
        join_id = join_id + 1
    end

    local unique_roots = {}
    local component_sizes = {}

    for i = 1, #coordinates do
        local root = dsu:find(i)
        if not unique_roots[root] then
            unique_roots[root] = true
            append(component_sizes, dsu.size[root])
        end
    end

    table.sort(component_sizes, function(a, b)
        return a > b
    end)

    local top_3_comp = 1
    for i = 1, math.min(3, #component_sizes) do
        top_3_comp = top_3_comp * component_sizes[i]
    end

    return top_3_comp
end

local function join_till_mst(coordinates, distances)
    local dsu, join_id, inter_comp_edge = DSU.new(), 1, 0
    dsu:init(#coordinates)

    while inter_comp_edge < #coordinates - 1 do
        local best_join = distances[join_id]
        local l, r = best_join.to, best_join.from
        if dsu:find(l) ~= dsu:find(r) then
            dsu:join(l, r)
            inter_comp_edge = inter_comp_edge + 1
        end
        join_id = join_id + 1
    end

    local to, from = distances[join_id - 1].to, distances[join_id - 1].from
    return coordinates[to].x * coordinates[from].x
end

local coordinates = parse()
local distances = get_all_distances(coordinates)

local top_3_comp = limited_join(coordinates, distances, 1000)
local last_join_result = join_till_mst(coordinates, distances)
print(top_3_comp, last_join_result)

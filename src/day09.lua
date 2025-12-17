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
        local x, y = table.unpack(split(junction, ','))
        append(coordinates, {
            x = tonumber(x),
            y = tonumber(y)
        })
    end
    return coordinates
end

local function get_max_area_rectangle(coordinates)
    local simple_area, within_polygon_area = 0, 0

    local function is_inside_polygon(px, py)
        local is_inside = false
        for i = 1, #coordinates do
            local v1 = coordinates[i]
            local v2 = coordinates[i % #coordinates + 1]
            if v1.x == v2.x then
                if px == v1.x and py >= math.min(v1.y, v2.y) and py <= math.max(v1.y, v2.y) then
                    return true
                end
            else
                if py == v1.y and px >= math.min(v1.x, v2.x) and px <= math.max(v1.x, v2.x) then
                    return true
                end
            end
            if v1.x == v2.x and v1.x > px then
                if (v1.y > py) ~= (v2.y > py) then
                    is_inside = not is_inside
                end
            end
        end
        return is_inside
    end

    local function is_entire_rect_inside(x1, y1, x2, y2)
        local minX, maxX = math.min(x1, x2), math.max(x1, x2)
        local minY, maxY = math.min(y1, y2), math.max(y1, y2)

        if not (is_inside_polygon(minX, minY) and is_inside_polygon(maxX, minY) and is_inside_polygon(minX, maxY) and
            is_inside_polygon(maxX, maxY)) then
            return false
        end

        for i = 1, #coordinates do
            local v1 = coordinates[i]
            local v2 = coordinates[i % #coordinates + 1]

            if v1.x == v2.x then
                if v1.x > minX and v1.x < maxX then
                    local wMinY, wMaxY = math.min(v1.y, v2.y), math.max(v1.y, v2.y)
                    if not (wMaxY <= minY or wMinY >= maxY) then
                        return false
                    end
                end
            else
                if v1.y > minY and v1.y < maxY then
                    local wMinX, wMaxX = math.min(v1.x, v2.x), math.max(v1.x, v2.x)
                    if not (wMaxX <= minX or wMinX >= maxX) then
                        return false
                    end
                end
            end
        end
        return true
    end

    for i, s in ipairs(coordinates) do
        for j, t in ipairs(coordinates) do
            if j < i then
                local sx, sy = s.x, s.y
                local tx, ty = t.x, t.y
                local area = (math.abs(sy - ty) + 1) * (math.abs(sx - tx) + 1)

                simple_area = math.max(simple_area, area)

                if is_entire_rect_inside(sx, sy, tx, ty) then
                    within_polygon_area = math.max(within_polygon_area, area)
                end
            end
        end
    end
    return simple_area, within_polygon_area
end

local coordinates = parse()
print(get_max_area_rectangle(coordinates))

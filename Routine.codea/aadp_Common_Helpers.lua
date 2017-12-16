function trim(in_string)
    return (in_string:gsub("^%s*(.-)%s*$", "%1"))
end

function clamp(value, min, max)
    if value <= min then return min end
    if value >= max then return max end
    return value
end

function math.clamp(value, min, max)
    return clamp(value, min, max)
end

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function string:splitToNumbers(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = tonumber(c) end)
    return fields
end

function string:splitToNumbers0(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    local index = 0
    self:gsub(pattern,
        function(c)
            fields[index] = tonumber(c)
            index = index + 1
        end)
    return fields
end

function string:starts(Start)
   return self:sub(1,string.len(Start))==Start
end

function string:ends(End)
   return End=='' or self:sub(-string.len(End))==End
end

function removeFromTable(in_table, in_value)
    table.removeItem(in_table, in_value)
end

function table.removeItem(in_table, in_value)
    for i,v in ipairs(in_table) do
        if v == in_value then
            table.remove(in_table, i)
            return
        end
    end
end

function boolToNumber(in_bool)
    if in_bool then
        return 1
    else
        return 0
    end
end

function numberToBool(in_number)
    if math.ceil(in_number) == 0 then
        return false
    else
        return true
    end
end

function table.find(t, item)
  for i, v in ipairs(t) do
    if v == item then
      return i
    end
  end
  return -1
end

function table.contains(t, item)
  for _, v in ipairs(t) do
    if v == item then
      return true
    end
  end
  return false
end

function table.insertUnique(t, item)
    if not table.contains(t, item) then
        table.insert(t, item)
        return true
    end
    return false
end

function table.addRangeUnique(t, items)
    for i,v in ipairs(items) do
        table.insertUnique(t, v)
    end
end

function url_encode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str	
end
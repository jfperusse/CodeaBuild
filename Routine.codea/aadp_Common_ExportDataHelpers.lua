--[[
function table.contains(t, item) -- find element v of l satisfying f(v)
  for _, v in ipairs(t) do
    if v == item then
      return true
    end
  end
  return false
end

function string:starts(Start)
   return self:sub(1,string.len(Start))==Start
end
]]

-- Always save to project data.
-- If not an exported project, save to special tab as well.
function saveExportData(in_key, in_data)
    saveProjectData(in_key, in_data)
    
    dataText = tostring(in_data)
    if type(in_data) == "string" then
        dataText = '"' .. dataText .. '"'
    end
    
    -- isRuntime is part of my CommonAddon (see CodeaProjectBuilder)
    -- There might be official ways to do this since the last time I checked!
    if not isRuntime() then
        local projectTabs = listProjectTabs()
        if table.contains(projectTabs, "ExportData") then
            local exportData = readProjectTab("ExportData")
            i, j = exportData:find('\nexportDataArray["' .. in_key .. '"] = ', 1, true)
            if i == nil then
                exportData = exportData ..
                    'exportDataArray["' .. in_key .. '"] = ' .. dataText .. "\n"
                saveProjectTab("ExportData", exportData)
            else
                k, l = exportData:find("\n", i + 2, true)
                if k == nil then
                    alert("ExportData has an invalid format!", "Error")
                else
                    exportData = exportData:sub(1, i) ..
                        'exportDataArray["' .. in_key .. '"] = ' .. dataText ..
                        exportData:sub(k)
                    saveProjectTab("ExportData", exportData)
                end
            end
        else
            saveProjectTab("ExportData",
                "-- DO NOT MODIFY THIS FILE MANUALLY!\n" ..
                "exportDataArray = {}\n" ..
                'exportDataArray["' .. in_key .. '"] = ' .. dataText .. "\n")
        end
    end
end

-- If we find it in project data, use that.
-- Otherwise, try reading it from the exportDataArray (exported project only).
function readExportData(in_key, in_default)
    result = readProjectData(in_key)
    if debugExportTabs or (result == nil and isRuntime()) then
        if exportDataArray ~= nil then
            if exportDataArray[in_key] == nil then
                return in_default
            end
            return exportDataArray[in_key]
        end
    end
    if result == nil then
        return in_default
    end
    return result
end

function clearExportData()
    saveProjectTab("ExportData", nil)
    exportDataArray = nil
end

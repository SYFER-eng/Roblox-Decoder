local function decode(str)
    local decoded = ""
    local i = 1
    
    while i <= #str do
        if str:sub(i,i) == "X" then
            local numEnd = str:find("Y", i)
            if numEnd then
                local num = tonumber(str:sub(i+1, numEnd-1), 36)
                decoded = decoded .. string.char(num)
                i = numEnd + 1
            else
                i = i + 1
            end
        else
            i = i + 1
        end
    end
    
    return decoded
end

-- Automatically detect and decode the input
local function autoDecodeAndExecute()
    local env = getfenv()
    local oldPrint = env.print
    
    env.print = function(...)
        local args = {...}
        for i, v in ipairs(args) do
            if type(v) == "string" then
                args[i] = decode(v)
            end
        end
        return oldPrint(unpack(args))
    end
    
    return function(encoded)
        local decoded = decode(encoded)
        return loadstring(decoded)()
    end
end

return autoDecodeAndExecute()

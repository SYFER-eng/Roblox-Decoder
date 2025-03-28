-- Advanced Lua Decoder v2.1
-- Created by SYFER

local function createSecureEnvironment()
    return setmetatable({}, {__index = getfenv()})
end

local function decodeString(str)
    local decoded = ""
    local index = 1
    
    while index <= #str do
        -- Find next valid pattern
        local letterStart, letterEnd = str:find("[a-zA-Z]", index)
        if not letterStart then break end
        
        local numStart = letterEnd + 1
        local numEnd = str:find("[^a-zA-Z0-9]", numStart)
        if not numEnd then break end
        
        -- Extract and convert
        local num = str:sub(numStart, numEnd - 1)
        local charCode = tonumber(num, 36)
        
        if charCode then
            decoded = decoded .. string.char(charCode)
        end
        
        index = numEnd + 1
    end
    
    return decoded
end

local function executeScript(decodedScript)
    local env = createSecureEnvironment()
    local fn, err = loadstring(decodedScript)
    
    if fn then
        setfenv(fn, env)
        return pcall(fn)
    end
    return false, err
end

-- Main execution
local encoded = getfenv(1).encoded
if encoded then
    local decodedScript = decodeString(encoded)
    local success, result = executeScript(decodedScript)
    
    if not success then
        warn("Execution failed:", result)
    end
end

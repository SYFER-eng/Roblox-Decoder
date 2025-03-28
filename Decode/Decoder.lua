-- Advanced Lua Decoder v2.0
-- Created by SYFER

local function createDecoderEnvironment()
    local env = {
        string = string,
        table = table,
        math = math,
        tonumber = tonumber,
        getfenv = getfenv,
        loadstring = loadstring
    }
    return env
end

local function generateDecodeKey()
    local key = ""
    for i = 1, 32 do
        key = key .. string.char(math.random(65, 90))
    end
    return key
end

local function validateEncodedString(str)
    if not str or type(str) ~= "string" then
        return false, "Invalid encoded string"
    end
    if str:len() < 1 then
        return false, "Empty encoded string"
    end
    return true
end

local function extractPatterns(encoded)
    local patterns = {}
    local pattern = "([a-zA-Z])([0-9a-z]+)[^a-zA-Z0-9]"
    
    for letter, num in encoded:gmatch(pattern) do
        table.insert(patterns, {
            letter = letter,
            value = num
        })
    end
    return patterns
end

local function processDecodedChunks(chunks)
    local result = ""
    for _, chunk in ipairs(chunks) do
        local charCode = tonumber(chunk.value, 36)
        if charCode then
            result = result .. string.char(charCode)
        end
    end
    return result
end

local function verifyDecodedScript(script)
    local success, result = pcall(function()
        local f = loadstring(script)
        if f then
            return true
        end
        return false
    end)
    return success and result
end

local function initializeDecoder()
    local env = createDecoderEnvironment()
    local key = generateDecodeKey()
    
    return {
        environment = env,
        key = key,
        decode = function(encoded)
            local valid, errorMsg = validateEncodedString(encoded)
            if not valid then
                return nil, errorMsg
            end
            
            local patterns = extractPatterns(encoded)
            local decodedScript = processDecodedChunks(patterns)
            
            if verifyDecodedScript(decodedScript) then
                return decodedScript
            end
            return nil, "Invalid script format"
        end
    }
end

-- Initialize the decoder
local decoder = initializeDecoder()

-- Get the encoded string from the script
local script = getfenv(1).encoded

-- Main execution
if script then
    local success, result = pcall(function()
        local decodedScript = decoder.decode(script)
        if decodedScript then
            setfenv(loadstring(decodedScript), decoder.environment)()
        end
    end)
    
    if not success then
        warn("Decoder failed:", result)
    end
end

-- Cleanup
decoder = nil
script = nil

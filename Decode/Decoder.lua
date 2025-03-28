local function decode(encoded)
    local decoded = ""
    local pattern = "([a-zA-Z])([0-9a-z]+)[^a-zA-Z0-9]"
    
    for letter, num in encoded:gmatch(pattern) do
        local charCode = tonumber(num, 36)
        decoded = decoded .. string.char(charCode)
    end
    
    return decoded
end

-- Get the encoded string from the script
local script = getfenv(1).encoded

-- Decode and execute
if script then
    local decodedScript = decode(script)
    loadstring(decodedScript)()
end

local d=string.char
local b=tonumber
local function decode(encoded)
    local c={}
    for e in encoded:gmatch("([^_]+)") do 
        table.insert(c,(b(e,16)-5)/3)
    end
    local f=""
    for g,h in ipairs(c)do 
        f=f..d(h)
    end
    return f
end

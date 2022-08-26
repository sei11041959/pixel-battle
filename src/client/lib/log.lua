log = {}

function log:info(text)
    return print("[ INFO ]  "..text)
end

function log:error(text)
    return print("[ ERROR ] "..text)
end

function log:warn(text)
    return print("[ WARN ]  "..text)
end
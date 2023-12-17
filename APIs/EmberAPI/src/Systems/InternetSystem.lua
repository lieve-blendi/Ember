local Internet = {}

local http = require("socket.http")
local ltn12 = require("ltn12")

function Internet.HTTPGet(adress, redirect)
    local resp = {}

    local status, code, headers = http.request{
        url = adress,
        sink = ltn12.sink.table(resp),
        method = "GET",
        redirect = redirect,
        location = adress
    }

    return {
        status = status,
        code = code,
        headers = headers,
        response = resp
    }
end

function Internet.HTTPDownload(adress, file, callback, redirect)
    local co = coroutine.create(function ()
        local result = Internet:HttpGET(adress, redirect).response[1]
        love.filesystem.write(file, result)
        callback(result)
    end)

    coroutine.resume(co)
end

return Internet
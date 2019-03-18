local _UTILS = { _VERSION = '1.0' }  

local mt = { __index = _UTILS }

local http = require ("resty.http")
local httpc = http:new()

--判断是否是数字
function _UTILS.isNumber( ... )
	local args = {...}
	local num
	for _,v in ipairs(args) do
		num = tonumber(v)
		if nil == num then
			return false
		end
	end
	return true
end

--判断table是否为空
function _UTILS.isTableEmpty(t)
	if t == nil or next(t)== nil then
		return true
	else
		return false
	end
end

function _UTILS.isUrl(url)
	local regex = [[^(?:(http[s]?):)?//([^:/\?]+)(?::(\d+))?([^\?]*)\??(.*)]]
	local m = ngx.re.match(url, regex, "jo")
	if m then
		return true
	else
		return false
	end
end

function _UTILS.isGoodUrl(url)
	local res, err = httpc:request_uri(url, {
		method = "POST",
		body = "",
		ssl_verify = false,
		headers = {
          ["Content-Type"] = "application/x-www-form-urlencoded",
        }
    })
    if res ~= nil then
		if 200 ~= res.status then
			return false
		else
			return true
		end
	else
		return false
	end
end

return _UTILS
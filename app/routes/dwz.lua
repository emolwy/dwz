local dwz = require("model.dwz")
local cjson = require("cjson")
local utils = require("libs.utils")

function isShortUrl(url)
	local temp = {}
	for str in string.gmatch(url.."/","(.-)/") do
		table.insert(temp,str)
	end
	local res = dwz:query_by_keyword(temp[4])
	if res and "qbb88.cn" == temp[3] then
		return true
	else
		return false
	end
end

local args = ngx.req.get_post_args()
local url = args.dwz_longurl
local message = ''

if not url or url == ""  or url == nil then
	message = '{"error":"0001","msg":"您还未输入长网址。"}'
	ngx.say(cjson.encode(message)) 
elseif not utils.isUrl(url) then
	message = '{"error":"0002","msg":"这不是正确格式的网址，请重新输入。"}'
	ngx.say(cjson.encode(message))
elseif not utils.isGoodUrl(url) then
	message = '{"error":"0003","msg":"您输入的网址不存在，请重新输入。"}'
	ngx.say(cjson.encode(message))
else
	local res,err = dwz:query_by_url(url)
	if utils.isTableEmpty(res) then
		if not isShortUrl(url) then
			local cres,err = dwz:create(url)
			message = '{"success":"0000","msg":"短网址生成成功"，"短网址":http://qbb88.cn/'..cres..'}'
			--ngx.say(cres)
			ngx.say(cjson.encode(message))
		else
			message = '{"error":"0004","msg":"这是一个短网址，请勿缩短。"}'
			ngx.say(cjson.encode(message))
		end
	else
		message = '{"success":"0000","msg":"短网址生成成功"，"短网址":http://qbb88.cn/'..res[1].keyword..'}'
		--ngx.say(res[1].keyword)
		ngx.say(cjson.encode(message))
	end
end


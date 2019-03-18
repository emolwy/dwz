local _DWZ = { _VERSION = '0.10' }

local hex = require("libs.hexcovert62")
local mysql = require("libs.mysql")
local db = mysql:new()

function _DWZ:query_by_keyword(keyword)
	return db:query("SELECT url FROM links WHERE keyword=?",{keyword})
end

function _DWZ:query_by_id(id)
	return db:query("SELECT url,keyword FROM links WHERE links_id=?",{id})
end 

function _DWZ:query_by_url(url)
	return db:query("SELECT keyword FROM links WHERE url=?",{url})
end


function _DWZ:getai()
	local linksid = db:select("SELECT auto_increment FROM information_schema.TABLES WHERE TABLE_SCHEMA='dwz' AND TABLE_NAME='links';")
	return linksid[1].auto_increment
end


function _DWZ:getkeyword()	
	return hex:_encode_62(self:getai())
end


function _DWZ:create(url)
	local keyword = self:getkeyword()
	local res,err = db:query("INSERT INTO links (url,type,keyword,create_time,update_time,remarks) VALUES (?,'SYS','"..keyword.."',current_timestamp(),current_timestamp(),'')",{url})
	if not res or err then
		return false
	else
		return keyword
	end
end

function _DWZ:update_by_id(id,url)
	local res,err = db:query("UPDATE links SET url=?,update_time=current_timestamp() WHERE links_id=?",{url,id})
	if not res or err then
		return false
	else 
		return true
	end
end

function _DWZ:update_by_keyword(keyword,url)
	local res,err = db:query("UPDATE links SET url=?,update_time=current_timestamp() WHERE keyword=?",{url,keyword})
	if not res or err then
		return false
	else 
		return true
	end
end

return _DWZ






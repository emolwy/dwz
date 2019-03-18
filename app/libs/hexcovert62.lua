--author：liweiye
--date：2018-03-15
--10进制与62进制相互转换

local _HEX = { _VERSION = '0.10' }   

local mt = { __index = _HEX }

--定义62进制的字符集
local base62 = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9'}

--10进制转62进制
function _HEX._encode_62(self,nums)

	local temp = {}

	if tonumber(nums) == 0 then
		table.insert(temp, base62[1])
	end

	while tonumber(nums) >= 1 do
		table.insert(temp, base62[math.floor(nums%62)+1])
		nums = nums/62
	end

	return string.reverse(table.concat(temp,''))
end

--62进制转10进制
function _HEX._decode_62(self,str)

	local nums = 0

	for i=1,string.len(str) do
		for j=1,#base62 do
			if string.sub(str,i,i) == base62[j] then
				nums=nums+(j-1)*math.pow(62, string.len(str)-i)
			end
		end
	end

	return nums
end

return _HEX
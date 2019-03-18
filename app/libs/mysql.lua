local mysql = require("resty.mysql")
local config= require("config.config")
local utils = require("libs.utils")

local _M = {_VERSION = '1.0'}   

local mt = { __index = _M }

function _M:new(conf)
    conf = conf or config.mysql
    local instance = {}
    instance.conf = conf
    setmetatable(instance, { __index = self})
    return instance
end

function _M:exec(sql)
    if not sql then
        ngx.log(ngx.ERR, "sql parse error! please check")
        return nil, "sql parse error! please check"
    end

    local conf = self.conf
    local db, err = mysql:new()
    if not db then
        ngx.say("failed to instantiate mysql: ", err)
        return
    end
    db:set_timeout(conf.timeout) -- 1 sec

    local ok, err, errno, sqlstate = db:connect(conf.connect_config)
    if not ok then
        ngx.say("failed to connect: ", err, ": ", errno, " ", sqlstate)
        return
    end

    ngx.log(ngx.ERR, "connected to mysql, reused_times:", db:get_reused_times(), " sql:", sql)

    db:query("SET NAMES utf8")
    local res, err, errno, sqlstate = db:query(sql)
    if not res then
        ngx.log(ngx.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    end

    local ok, err = db:set_keepalive(conf.pool_config.max_idle_timeout, conf.pool_config.pool_size)
    if not ok then
        ngx.say("failed to set keepalive: ", err)
    end

    return res, err, errno, sqlstate
end

function _M:query(sql,params)
    sql = self:parsesql(sql, params)
    return self:exec(sql)
end

function _M:select(sql)
    return self:exec(sql, params)
end

function _M:insert(sql,params)
    local res, err, errno, sqlstate = self:query(sql, params)
    if res and not err then
        return  res.insert_id, err
    else
        return res, err
    end
end

function _M:update(sql,params)
    return self:query(sql, params)
end

function _M:delete(sql, params)
    local res, err, errno, sqlstate = self:query(sql, params)
    if res and not err then
        return res.affected_rows, err
    else
        return res, err
    end
end

--sql语句切割
function _M:split(str,delimiter)
    if str==nil or str=='' or delimiter==nil then
        return nil
    end
    
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result,match)
    end
    return result
end

--sql语句组合
function _M:concat(t,params)
    if utils.isTableEmpty(params) or utils.isTableEmpty(t) or type(t)~="table" or type(params)~="table" or #t~=#params+1 or #t==0 then
        return nil
    else
        local result = t[1]
        for i=1, #params do
            result = result  .. params[i].. t[i+1]
        end
        return result
    end
end

--sql语句参数过滤，防注入
function _M:parsesql(sql,params)
    if utils.isTableEmpty(params) then
        return sql
    end

    local new_params = {}
    for i, v in ipairs(params) do
        if v and type(v) == "string" then
            v = ngx.quote_sql_str(v)
        end
        table.insert(new_params, v)
    end
    
    local t = self:split(sql,"?")
    local sql = self:concat(t, new_params)
    return sql
end

return _M
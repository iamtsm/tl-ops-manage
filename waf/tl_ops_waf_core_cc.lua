-- tl_ops_waf_core_cc
-- en : waf core cc impl
-- zn : waf cc防护
-- @author iamtsm
-- @email 1905333456@qq.com

local tl_ops_constant_waf_cc = require("constant.tl_ops_constant_waf_cc");
local tl_ops_constant_waf_scope = require("constant.tl_ops_constant_waf_scope");
local tl_ops_utils_func = require("utils.tl_ops_utils_func");
local cache_cc = require("cache.tl_ops_cache"):new("tl-ops-waf-cc");
local find = ngx.re.find
local cjson = require("cjson");

local shared_balance = ngx.shared.tlopsbalance
local shared_waf = ngx.shared.tlopswaf
local MAX_URL_LEN = 50

-- 全局拦截
-- true : 通过, false : 拦截
local tl_ops_waf_core_cc_filter_global_pass = function()    
    -- 作用域
    local cc_scope, _ = cache_cc:get(tl_ops_constant_waf_cc.cache_key.scope);
    if not cc_scope then
        return false
    end

    -- 根据作用域进行waf拦截
    if cc_scope ~= tl_ops_constant_waf_scope.global then
        return false
    end
    
    -- 配置列表
    local cc_list, _ = cache_cc:get(tl_ops_constant_waf_cc.cache_key.list);
    if not cc_list then
        return false
    end
    
    local cc_list_table = cjson.decode(cc_list);
    if not cc_list_table then
        return false
    end
    
    -- 获取当前url
    local request_uri = string.sub(tl_ops_utils_func:get_req_uri(), 1, MAX_URL_LEN);
    if not request_uri then
        request_uri = ""
    end
    -- 获取当前ip
    local ip = tl_ops_utils_func:get_req_ip();
    if not ip then
        ip = ""
    end
    -- cc key
    local cc_key = tl_ops_constant_waf_cc.cache_key.prefix .. ip .. request_uri

    local cur_host = ngx.var.host

    for _, cc in ipairs(cc_list_table) do
        repeat
            local host = cc.host
            local time = cc.time
            local count = cc.count
            -- 域名为空跳过规则
            if host == nil or host == '' then
                break
            end
            -- 域名不匹配跳过规则
            if host ~= "*" and host ~= cur_host then
                break
            end
            -- 首次
            local res, _ = shared_waf:get(cc_key)
            if not res then
                shared_waf:set(cc_key, 1, time)
                break
            end
            -- 没有达到cc次数
            if res < count then
                shared_waf:incr(cc_key, 1)
                break
            end
            -- 触发cc
            return false
        until true
    end

    return true
end


-- 匹配到服务层拦截
-- true : 通过, false : 拦截
local tl_ops_waf_core_cc_filter_service_pass = function(service_name)
    if not service_name then
        return false
    end
    
    -- 作用域
    local cc_scope, _ = cache_cc:get(tl_ops_constant_waf_cc.cache_key.scope);
    if not cc_scope then
        return false
    end

    -- 根据作用域进行waf拦截
    if cc_scope ~= tl_ops_constant_waf_scope.service then
        return false
    end
    
    -- 配置列表
    local cc_list, _ = cache_cc:get(tl_ops_constant_waf_cc.cache_key.list);
    if not cc_list then
        return false
    end
    
    local cc_list_table = cjson.decode(cc_list);
    if not cc_list_table then
        return false
    end

    -- 获取当前url
    local request_uri = string.sub(tl_ops_utils_func:get_req_uri(), 1, MAX_URL_LEN);
    if not request_uri then
        request_uri = ""
    end
    -- 获取当前ip
    local ip = tl_ops_utils_func:get_req_ip();
    if not ip then
        ip = ""
    end
    -- cc key
    local cc_key = tl_ops_constant_waf_cc.cache_key.prefix .. ip .. request_uri

    local cur_host = ngx.var.host

    for _, cc in ipairs(cc_list_table) do
        repeat
            local host = cc.host
            local service = cc.service
            local time = cc.time
            local count = cc.count
            -- 域名为空跳过规则
            if host == nil or host == '' then
                break
            end
            -- 域名不匹配跳过规则
            if host ~= "*" and host ~= cur_host then
                break
            end
            -- 服务为空
            if service == nil or service == '' then
                break
            end
            -- 服务不匹配
            if service ~= service_name then
                break
            end
            -- 首次
            local res, _ = shared_waf:get(cc_key)
            if not res then
                shared_waf:set(cc_key, 1, time)
                break
            end
            -- 没有达到cc次数
            if res < count then
                shared_waf:incr(cc_key, 1)
                break
            end
            -- 触发cc
            return false
        until true
    end

    return true
end


-- 匹配到节点层拦截
-- true : 通过, false : 拦截
local tl_ops_waf_core_cc_filter_node_pass = function(service_name, node_id)
    if not service_name or not node_id then
        return false
    end
    
    -- 作用域
    local cc_scope, _ = cache_cc:get(tl_ops_constant_waf_cc.cache_key.scope);
    if not cc_scope then
        return false
    end

    -- 根据作用域进行waf拦截
    if cc_scope ~= tl_ops_constant_waf_scope.node then
        return false
    end
    
    -- 配置列表
    local cc_list, _ = cache_cc:get(tl_ops_constant_waf_cc.cache_key.list);
    if not cc_list then
        return false
    end
    
    local cc_list_table = cjson.decode(cc_list);
    if not cc_list_table then
        return false
    end

    -- 获取当前url
    local request_uri = string.sub(tl_ops_utils_func:get_req_uri(), 1, MAX_URL_LEN);
    if not request_uri then
        request_uri = ""
    end
    -- 获取当前ip
    local ip = tl_ops_utils_func:get_req_ip();
    if not ip then
        ip = ""
    end
    -- cc key
    local cc_key = tl_ops_constant_waf_cc.cache_key.prefix .. ip .. request_uri

    for _, cc in ipairs(cc_list_table) do
        repeat
            local host = cc.host
            local service = cc.service
            local node = cc.node
            local time = cc.time
            local count = cc.count
            -- 域名为空跳过规则
            if host == nil or host == '' then
                break
            end
            -- 域名不匹配跳过规则
            if host ~= "*" and host ~= cur_host then
                break
            end
            -- 服务为空
            if service == nil or service == '' then
                break
            end
            -- 服务不匹配
            if service ~= service_name then
                break
            end
            -- 节点为空
            if node == nil or node == '' then
                break
            end
            -- 节点不匹配
            if node ~= node_id then
                break
            end
            -- 首次
            local res, _ = shared_waf:get(cc_key)
            if not res then
                shared_waf:set(cc_key, 1, time)
                break
            end
            -- 没有达到cc次数
            if res < count then
                shared_waf:incr(cc_key, 1)
                break
            end
            -- 触发cc
            return false
        until true
    end

    return true
end


return {
    tl_ops_waf_core_cc_filter_global_pass = tl_ops_waf_core_cc_filter_global_pass,
    tl_ops_waf_core_cc_filter_service_pass = tl_ops_waf_core_cc_filter_service_pass,
    tl_ops_waf_core_cc_filter_node_pass = tl_ops_waf_core_cc_filter_node_pass
}
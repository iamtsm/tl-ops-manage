-- tl_ops_api
-- en : api router
-- zn : 对外api接口
-- @author iamtsm
-- @email 1905333456@qq.com

local tlog              = require("utils.tl_ops_utils_log"):new("tl_ops_api_router");
local tl_ops_api_core   = require("api.tl_ops_api_core");
local tl_ops_utils_func = require("utils.tl_ops_utils_func");

local _M = {}

function _M:init( )
    local request_uri = tl_ops_utils_func:get_req_uri()
    for uri ,router in pairs(tl_ops_api_core) do
        if ngx.re.find(request_uri, uri, 'jo') then
            tlog:dbg("访问接口 : request_uri=",request_uri)
            router()
            ngx.exit(200)
        end
    end
end

return _M
-- tl_ops_ctx
-- en : ctx数据
-- zn : 共享数据
-- @author iamtsm
-- @email 1905333456@qq.com

local cjson, _  = require("cjson.safe")
local utils     = require("utils.tl_ops_utils_func");
local tlops_api = require("api.tl_ops_api_core")
local _M = {}


function _M:init()
    ngx.ctx.pid             = ngx.var.pid
    ngx.ctx.args            = ngx.var.args
    ngx.ctx.uri             = ngx.var.uri
    ngx.ctx.host            = ngx.var.host
    ngx.ctx.scheme          = ngx.var.scheme
    ngx.ctx.method          = ngx.var.request_method
    ngx.ctx.hostname        = ngx.var.hostname
    ngx.ctx.remote_addr     = utils.get_req_ip()
    ngx.ctx.content_length  = ngx.var.content_length
    ngx.ctx.content_type    = ngx.var.content_type
    ngx.ctx.http_referer    = ngx.var.http_referer
    ngx.ctx.http_user_agent = ngx.var.http_user_agent

    ngx.ctx.tlops_api       = tlops_api
end

return _M
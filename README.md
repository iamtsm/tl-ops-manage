# tl-ops-manage (tl openresty lua manage)


# 基于openresty的轻量级服务管理功能集合实现


优点 : 轻量化，易扩展，支持可视化操作，记录朔源。

## 规划/进度

- [x] 负载策略 
- [x] 健康检查
- [x] 健康检查动态配置
- [x] 节点动态扩展
- [x] 数据持久化
- [x] Web管理界面
- [ ] 限流熔断
- [ ] 灰度发布

#### 负载策略 ： 
    自定义url负载策略，资源负载策略，随机负载策略。★★服务节点动态扩展★★

#### 数据持久化 ：
    配置策略持久化，操作记录可朔源。★★支持多级缓存★★

#### 健康检查 ： 
    服务节点健康检查自动化，可配置。 ★★支持动态新增修改配置★★

#### 限流熔断 ：
    限流熔断策略自动化，可配置。

#### 灰度发布 ：
    api，功能灰度策略发布，可配置。

##### 持续更新中 ...


---------

## 使用方式

### 1. 安装openresty环境

    官网安装openresty

### 2. 修改nginx.conf引入本项目lua包

    lua_package_path "/xxx/tl-ops-manage/?.lua;;"

### 3. 修改nginx.conf引入/conf/tl_ops_manage.conf

    1. include "/xxx/tl-ops-manage/conf/*.conf;"

    2. 修改tl_ops_manage.conf中的路径

### 4. 修改/constant/下配置

    tl_ops_constant_log.lua 修改dir路径

### 5. 启动nginx/openresty

    http://localhost/tlops/tl_ops_web_index.html  管理后台

---------

## 目录结构 （待更新）




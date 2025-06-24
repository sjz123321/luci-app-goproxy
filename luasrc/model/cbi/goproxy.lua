local sys = require "luci.sys"
local http = require "luci.http"

-- 保存后自动重载服务（兼容所有 LuCI/OpenWrt 版本）
if http.formvalue("cbi.apply") then
    sys.call("/etc/init.d/goproxy restart >/dev/null 2>&1")
end

local function get_goproxy_status()
    local status = luci.sys.exec("/etc/goproxy/check.sh 2>/dev/null"):gsub("\n", "")
    if status == "running" then
        return "<span style='color:green;font-weight:bold'>正在运行</span>"
    else
        return "<span style='color:red;font-weight:bold'>未运行</span>"
    end
end

m = Map("goproxy", translate("Goproxy 设置"))

s = m:section(TypedSection, "main", translate("基础设置"))
s.anonymous = true

-- 状态
local st = s:option(DummyValue, "_status", translate("Goproxy 运行状态"))
st.rawhtml = true
st.default = get_goproxy_status()

-- 启用
local o = s:option(Flag, "enable", translate("启用Goproxy"))
o.rmempty = false

-- 参数模式
o = s:option(ListValue, "param_mode", translate("参数模式"))
o:value("default", translate("默认"))
o:value("custom", translate("自定义命令行参数"))

-- 自定义参数
local custom_arg = s:option(Value, "custom_args", translate("自定义命令行参数"))
custom_arg:depends("param_mode", "custom")
custom_arg.placeholder = "--listen :8080 --target http://example.com"
custom_arg.description = translate("无需添加 <b>--daemon --forever</b>，系统会自动附加这两个参数。")

return m
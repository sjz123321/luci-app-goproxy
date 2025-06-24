local sys = require "luci.sys"
local http = require "luci.http"

local function get_goproxy_status()
    local status = sys.exec("/etc/goproxy/check.sh 2>/dev/null"):gsub("\n", "")
    if status == "running" then
        return "<span style='color:green;font-weight:bold'>............</span>"
    else
        return "<span style='color:red;font-weight:bold'>.........</span>"
    end
end

m = Map("goproxy", translate("Goproxy ......"))
m.apply_on_parse = true
-- on_after_commit .............................................
function m.on_after_commit(self)
    sys.call("sleep 1; /etc/init.d/goproxy restart >/dev/null 2>&1 &")
end

s = m:section(TypedSection, "main", translate("............"))
s.anonymous = true

-- ............
local st = s:option(DummyValue, "_status", translate("Goproxy ............"))
st.rawhtml = true
st.default = get_goproxy_status()

-- ............
local o = s:option(Flag, "enable", translate("......Goproxy"))
o.rmempty = false

-- ............
o = s:option(ListValue, "param_mode", translate("............"))
o:value("default", translate("......"))
o:value("custom", translate("........................"))

-- ...............
local custom_arg = s:option(Value, "custom_args", translate("........................"))
custom_arg:depends("param_mode", "custom")
custom_arg.placeholder = "--listen :8080 --target http://example.com"
custom_arg.description = translate("............ <b>--daemon --forever</b>..........................................")

return m
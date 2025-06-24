module("luci.controller.goproxy",package.seeall)
function index()
        entry({"admin","services","goproxy"},cbi("goproxy"),_("Goproxy")).dependent = false
end
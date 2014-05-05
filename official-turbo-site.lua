--- Official website for Turbo.lua.
-- Do whatever you like with this code!

_G.TURBO_SSL = true
local turbo = require "turbo"
local tmpl = turbo.web.Mustache.TemplateHelper("./")
local SFH = turbo.web.StaticFileHandler

local gioloop = turbo.ioloop.instance()
local function _set_content_type(header)
    header:add("Content-Type", "application/json")
end
local function _log_line_cb(log)
    if log[1]:find("[async.lua]", 0, true) then
        -- Do not log HTTPClient.
        io.stdout:write(log[1].."\n")
        return
    end
    local res = coroutine.yield(turbo.async.HTTPClient():fetch(
        "http://127.0.0.1:5984/turbo-www", {
            method="POST",
            body=turbo.escape.json_encode({
                timestamp=turbo.util.gettimeofday(),
                line=log[1],
                logtype=log[2]
            }),
            on_headers=_set_content_type
        }))
    if res.error then
        gioloop:add_callback(_log_line_cb, log)
    end
end

turbo.log.success = function(str) gioloop:add_callback(_log_line_cb, {str, "success"}) end
turbo.log.notice = function(str) gioloop:add_callback(_log_line_cb, {str, "notice"}) end
turbo.log.error = function(str) gioloop:add_callback(_log_line_cb, {str, "error"}) end
turbo.log.warning = function(str) gioloop:add_callback(_log_line_cb, {str, "warning"}) end

local TemplateRenderer = class("TemplateRenderer", turbo.web.RequestHandler)
function TemplateRenderer:get()
    local page = tmpl:render(self.options, {
        foot = tmpl:render("foot.mustache"), 
        head = tmpl:render("header.mustache")
    })
    self:write(page)
end

local app = turbo.web.Application({
    {"^/$",             TemplateRenderer,   "index.mustache"},
    {"^/about$",        TemplateRenderer,   "about.mustache"},
    {"^/community$",    TemplateRenderer,   "community.mustache"},
    {"^/contact$",      TemplateRenderer,   "contact.mustache"},
    {"^/modules$",      TemplateRenderer,   "modules.mustache"},
    {"^/sponsor$",      TemplateRenderer,   "sponsor.mustache"},
    -- End of templates.
    {"^/doc/$",         SFH,                "./doc/index.html"},
    {"^/doc/(.*)$",     SFH,                "./doc/"},
    {"^/lib/(.*)$",     SFH,                "./lib/"},
    {"^/assets/(.*)$",  SFH,                "./assets/"},
    -- Redirect to Get started guide.
    {"^/gettingstarted$", turbo.web.RedirectHandler, "/doc/get_started.html"},
})

local srv = turbo.httpserver.HTTPServer(app)
srv:bind(8889)
srv:start(1)
turbo.ioloop.instance():start()

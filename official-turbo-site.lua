--- Official website for Turbo.lua.
-- Do whatever you like with this code!

_G.TURBO_SSL = true
local turbo = require "turbo"
local tmpl = turbo.web.Mustache.TemplateHelper("./")
local SFH = turbo.web.StaticFileHandler

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
local port = tonumber(os.getenv("turbo-www-port")) or 80
srv:bind(port)
turbo.log.success("Binding to port: " .. tostring(port))
srv:start(1)
turbo.ioloop.instance():start()

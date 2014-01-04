--- Official website for Turbo.lua.
-- Do whatever you like with this code!

local turbo = require "turbo"
local tmpl = turbo.web.Mustache.TemplateHelper("./")
local SFH = turbo.web.StaticFileHandler

local Index = class("Index", turbo.web.RequestHandler)
function Index:get()
    local index = tmpl:load("index.mustache")
    local page = tmpl:render(index, {
        menu = tmpl:render("menu.mustache"), 
        foot = tmpl:render("foot.mustache"), 
        head = tmpl:render("header.mustache")
    })
    self:write(page)
end

local TemplateRenderer = class("TemplateRenderer", turbo.web.RequestHandler)
function TemplateRenderer:get()
    local page = tmpl:render(self.options)
    self:write(page)
end

local app = turbo.web.Application({
    {"^/$",             Index},
    {"^/performance$",  TemplateRenderer,   "performance.mustache"},
    {"^/lua$",          TemplateRenderer,   "lua.mustache"},
    {"^/community$",    TemplateRenderer,   "community.mustache"},
    {"^/download$",     TemplateRenderer,   "download.mustache"},
    {"^/code$",         TemplateRenderer,   "code.mustache"},
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

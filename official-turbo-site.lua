--- Official website for Turbo.lua.
-- Do whatever you like with this code!

local turbo = require "turbo"

local Templater = class("Templater", turbo.web.RequestHandler)
local tmpl = turbo.web.Mustache.TemplateHelper("./")

function Templater:get(name)
	local index = tmpl:load("index.mustache")
	local menu = tmpl:render("menu.mustache")
	local page = tmpl:render(index, {menu = menu})
	self:write(page)
end

local app = turbo.web.Application({
	{"^/$", Templater},
	{"^/doc/$", turbo.web.StaticFileHandler, "./doc/index.html"},
	{"^/doc/(.*)$", turbo.web.StaticFileHandler, "./doc/"},
	{"^/lib/(.*)$", turbo.web.StaticFileHandler, "./lib/"},
	{"^/assets/(.*)$", turbo.web.StaticFileHandler, "./assets/"},
})

local srv = turbo.httpserver.HTTPServer(app)
srv:bind(8888)
srv:start(4)
turbo.ioloop.instance():start()
--- Official website for Turbo.lua.
-- Do whatever you like with this code!

local turbo = require "turbo"
local tmpl = turbo.web.Mustache.TemplateHelper("./")
local menu = tmpl:render("menu.mustache")
local foot = tmpl:render("foot.mustache")
local head = tmpl:render("header.mustache")


local Index = class("Index", turbo.web.RequestHandler)
function Index:get()
	local index = tmpl:load("index.mustache")
	local page = tmpl:render(index, {menu=menu, foot=foot, head=head})
	self:write(page)
end

local Performance = class("Performance", turbo.web.RequestHandler)
function Performance:get()
	local performance = tmpl:load("performance.mustache")
	local page = tmpl:render(performance, {menu=menu, foot=foot, head=head})
	self:write(page)
end

local Lua = class("Lua", turbo.web.RequestHandler)
function Lua:get()
	local lua = tmpl:load("lua.mustache")
	local page = tmpl:render(lua, {menu=menu, foot=foot, head=head})
	self:write(page)
end

local Community = class("Community", turbo.web.RequestHandler)
function Community:get()
	local community = tmpl:load("community.mustache")
	local page = tmpl:render(community, {menu=menu, foot=foot, head=head})
	self:write(page)
end

local app = turbo.web.Application({
	{"^/$", Index},
	{"^/performance$", Performance},
	{"^/lua$", Lua},
	{"^/community$", Community},
	{"^/gettingstarted$", turbo.web.RedirectHandler,
		"/doc/get_started.html"},
	
	{"^/doc/$", turbo.web.StaticFileHandler, "./doc/index.html"},
	{"^/doc/(.*)$", turbo.web.StaticFileHandler, "./doc/"},
	{"^/lib/(.*)$", turbo.web.StaticFileHandler, "./lib/"},
	{"^/assets/(.*)$", turbo.web.StaticFileHandler, "./assets/"},
})

local srv = turbo.httpserver.HTTPServer(app)
srv:bind(8888)
srv:start(1)
turbo.ioloop.instance():start()
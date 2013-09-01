--- Official website for Turbo.lua.
-- Do whatever you like with this code!

local turbo = require "turbo"



local app = turbo.web.Application:new({
	{"^/$", turbo.web.StaticFileHandler, "./index.html"},
	{"^/doc/$", turbo.web.StaticFileHandler, "./doc/index.html"},
	{"^/doc/(.*)$", turbo.web.StaticFileHandler, "./doc/"},
	{"^/lib/(.*)$", turbo.web.StaticFileHandler, "./lib/"},
	{"^/assets/(.*)$", turbo.web.StaticFileHandler, "./assets/"},
})

local srv = turbo.httpserver.HTTPServer(app)
srv:bind(8888)
srv:start(1)
turbo.ioloop.instance():start()
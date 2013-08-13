--- Official website for Turbo.lua.
-- Do whatever you like with this code!

local turbo = require "turbo"

local app = turbo.web.Application:new({
	{"/(.*)$", turbo.web.StaticFileHandler, "./"}
})

local srv = turbo.httpserver.HTTPServer(app)
srv:bind(8888)
srv:start(4)
turbo.ioloop.instance():start()
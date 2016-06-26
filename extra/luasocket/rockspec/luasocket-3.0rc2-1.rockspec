package = "LuaSocket"
version = "3.0rc2-1"
source = {
	url = "git://github.com/diegonehab/luasocket.git",
	tag = "v3.0-rc2",
}
description = {
	summary = "Network support for the Lua language",
	detailed = [[
		LuaSocket is a Lua extension library that is composed by two parts: a C core
		that provides support for the TCP and UDP transport layers, and a set of Lua
		modules that add support for functionality commonly needed by applications
		that deal with the Internet.
	]],
	homepage = "http://luaforge.net/projects/luasocket/",
	license = "MIT"
}
dependencies = {
   "lua >= 5.1"
}

build = {
	type = "builtin",
	modules = {
		["socket.core"] = {
			sources = { "src/luasocket.c", "src/timeout.c", "src/buffer.c", "src/io.c", "src/auxiliar.c", "src/options.c", "src/inet.c", "src/except.c", "src/select.c", "src/tcp.c", "src/udp.c", "src/compat.c", "src/wsocket.c" },
			defines = {"LUASOCKET_DEBUG", "NDEBUG", "LUASOCKET_API=__declspec(dllexport)", "MIME_API=__declspec(dllexport)"},
			incdir = "/src",
			libraries = {"ws2_32"}
		},
		["mime.core"] = {
			sources = { "src/mime.c", "src/compat.c" },
			defines = {"LUASOCKET_DEBUG", "NDEBUG", "LUASOCKET_API=__declspec(dllexport)", "MIME_API=__declspec(dllexport)"},
			incdir = "/src"
		},
		["socket.http"] = "src/http.lua",
		["socket.url"] = "src/url.lua",
		["socket.tp"] = "src/tp.lua",
		["socket.ftp"] = "src/ftp.lua",
		["socket.headers"] = "src/headers.lua",
		["socket.smtp"] = "src/smtp.lua",
		ltn12 = "src/ltn12.lua",
		socket = "src/socket.lua",
		mime = "src/mime.lua"
	},
	copy_directories = { "doc", "samples", "etc", "test" }
}

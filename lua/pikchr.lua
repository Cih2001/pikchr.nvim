local M = {}

local server = nil
local input = ""

local function get_plugin_dir()
	local info = debug.getinfo(1, "S")
	local script_path = info.source:sub(2)
	return vim.fn.fnamemodify(script_path, ":h")
end

local function serve(path)
	if path == "source" then
		return input
	end

	local plugin_dir = get_plugin_dir()
	local original_path = plugin_dir .. "/index.html"
	local fr = io.open(original_path, "r")
	if not fr then
		vim.notify("Failed to read index.html", vim.log.levels.ERROR)
		return
	end
	local content = fr:read("*a")
	fr:close()

	-- Replace the server address correct port
	content = content:gsub(
		"const%s+response%s+=%s+await%s+fetch%(.-http://localhost:%d+/source",
		'const response = await fetch("http://localhost:' .. M.server_port .. "/source"
	)

	return content
end

function M.stop_server()
	if server then
		server:close()
		server = nil
	end
end

function M.start_server()
	if server then
		vim.notify("Pikchr server is already running at http://localhost:" .. M.server_port, vim.log.levels.WARN)
		return
	end
	local uv = vim.loop

	server = uv.new_tcp()
	server:bind("127.0.0.1", M.server_port)
	server:listen(128, function(err)
		assert(not err, err)
		local client = uv.new_tcp()
		server:accept(client)

		client:read_start(function(err2, chunk)
			assert(not err2, err2)

			if not chunk then
				client:close()
				return
			end

			local req_line = chunk:match("^[^\r\n]+")
			local _, path = req_line:match("^(%w+)%s+/([^%s]+)")

			local data = serve(path)
			if data then
				local res = "HTTP/1.1 200 OK\r\nContent-Type: text/html" .. "\r\n\r\n" .. data
				client:write(res)
			else
				client:write("HTTP/1.1 404 Not Found\r\n\r\n")
			end
			client:close()
		end)
	end)

	vim.notify("Visit Pikchr server at http://localhost:" .. M.server_port, vim.log.levels.INFO)
end

function M.setup(cfg)
	cfg = cfg or {
		server_port = 2222,
	}

	M = cfg

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
		group = vim.api.nvim_create_augroup("pikchr_au", { clear = true }),
		pattern = "*.pikchr",
		callback = function()
			input = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
		end,
	})
end

return M

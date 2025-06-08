local pikchr = require("pikchr")

vim.api.nvim_create_user_command("Pikchr", function(args)
	if args.args == "start" then
		pikchr.start_server()
	elseif args.args == "stop" then
		pikchr.stop_server()
	else
		print("Usage: :Pikchr start|stop")
	end
end, {
	nargs = 1,
	complete = function(_, _, _)
		return { "start", "stop" }
	end,
})

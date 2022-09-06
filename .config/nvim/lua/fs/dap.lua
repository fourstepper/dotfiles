local has_dap, dap = pcall(require, "dap")
if not has_dap then
	return
end

require("dapui").setup()

-- Automatically start dap-ui if debugging session is started
require("dapui").listeners.after.event_initialized["dapui_config"] = function()
	require("dapui").i.open()
end
require("dapui").listeners.before.event_terminated["dapui_config"] = function()
	require("dapui").i.close()
end
require("dapui").listeners.before.event_exited["dapui_config"] = function()
	require("dapui").i.close()
end

-- TODO: Python configuration doesn't work, debugpy adapter isn't found by python3 even though it's installed. F5 does nothing.
dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
	},
}
dap.adapters.python = {
	type = "executable",
	command = "python3",
	args = { "-m", "debugpy.adapter" },
}

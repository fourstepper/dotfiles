local has_dap, dap = pcall(require, "dap")
if not has_dap then
	return
end

local has_dapui, dapui = pcall(require, "dapui")
if not has_dap then
	return
end

dapui.setup()

-- Auto start the dap-ui on debugging session start
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

require("dap-python").setup("python3")
require("dap-go").setup()

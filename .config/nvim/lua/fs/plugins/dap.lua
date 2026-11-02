return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = {
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			-- Auto start the dap-ui on debugging session start
			require("dap").listeners.after.event_initialized["dapui_config"] = function()
				require("dapui").open()
			end

			-- Adapter executable from mason's debugpy package
			require("dap-python").setup("debugpy-adapter")
			require("dap-go").setup()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		main = "dapui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		opts = {},
	},
}

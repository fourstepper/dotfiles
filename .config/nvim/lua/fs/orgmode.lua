-- Load custom tree-sitter grammar for org filetype
require("orgmode").setup_ts_grammar()

require("orgmode").setup({
	org_agenda_files = { "~/workspace/personal/org/*" },
	org_default_notes_file = "~/workspace/personal/org/refile.org",
})

local has_comment, comment = pcall(require, "Comment")
if not has_comment then
	return
end

comment.setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

local tree_cb = require("nvim-tree.config").nvim_tree_callback
require'nvim-tree'.setup {
  view = {
    mappings = {},
    -- sets relativenumber current cursor to number
    number = true,
    relativenumber = true
  }
}

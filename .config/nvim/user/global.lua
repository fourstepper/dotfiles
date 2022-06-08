local globals = {
    mapleader = " ",
    tmux_navigator_no_mappings = '1',
}

for k, v in pairs(globals) do
  vim.g[k] = v
end

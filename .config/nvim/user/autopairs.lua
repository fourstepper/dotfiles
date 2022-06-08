local status_ok, pairs = pcall(require, "nvim-autopairs")
if not status_ok then
  return
end

pairs.setup{
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` after select function or method item
  auto_select = false, -- automatically select the first item
}

require("formatter").setup({
  filetype = {
    terraform = {
      function()
        return {
          exe = "terraform",
          args = { "fmt"},
          stdin = false
        }
      end
    },
    hcl = {
      function()
        return {
          exe = "terragrunt",
          args = { "hclfmt"},
          stdin = false
        }
      end
    },
    python = {
        require('formatter.filetypes.python').black,
    },
    go = {
        require('formatter.filetypes.go').gofmt,
    },
    ["*"] = {
      function()
        return {
          -- remove trailing whitespace
          exe = "sed",
          args = {"-i", "'s/[ \t]*$//'"},
          stdin = false
        }
      end
    }
  }
})

-- Call formatter on each save
vim.cmd([[
augroup Format
    autocmd!
    autocmd BufWritePost * FormatWrite
augroup END
]])

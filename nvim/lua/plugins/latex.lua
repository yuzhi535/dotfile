return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_imaps_leader = ";"
      vim.g.vimtex_delim_stopline = 200
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-shell-escape",
        },
      }
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_quickfix_ignore_filters = {
        "Overfull",
        "Underfull",
      }

      vim.api.nvim_create_augroup("vimtex", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = "vimtex",
        pattern = "VimtexEventQuit",
        command = "VimtexClean",
      })
      vim.api.nvim_create_autocmd("User", {
        group = "vimtex",
        pattern = "VimtexEventViewReverse",
        callback = function()
          vim.system({ "open", "-a", "kitty" })
        end,
      })
    end,
  },
}

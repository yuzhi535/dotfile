return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
 _     ____  ____  ____  ____  _____
/ \ |\/ ___\/   _\/  _ \/  _ \/  __/
| | //|    \|  /  | / \|| | \||  \  
| \// \___ ||  \__| \_/|| |_/||  /_ 
\__/  \____/\____/\____/\____/\____\
            ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
      opts.theme = "doom"
    end,
  },
}

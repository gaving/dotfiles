---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["-"] = { "<CMD>Switch<CR>", "Switch" },
    ["<C-d>"] = { "<CMD>Sayonara<CR>", "Kill buffer", opts = { nowait = true } },
    [",q"] = { "<CMD>q<CR>", "Quit", opts = { nowait = true } },
    [",,"] = { "<CMD>write<CR>", "Write" },
    [",b"] = { "<CMD>Telescope buffers<CR>", "Find buffers" },
    [",c"] = { "<CMD>Telescope git_commits<CR>", "Find git commits" },
    [",f"] = { "<CMD>Telescope find_files<CR>", "Find files" },
    [",p"] = { "<CMD>Telescope git_files<CR>", "Find git files" },
    [",/"] = { "<CMD>Telescope live_grep<CR>", "Grep for string" },
    [",?"] = { "<CMD>Telescope grep_string<CR>", "Grep string under cursor" },
    [",s"] = { "<CMD>Alpha<CR>", "Startscreen" },
    [",z"] = { "<CMD>e $HOME/.config/zsh/config<CR>", "open zsh config" },
    [",Z"] = { "<CMD>e $HOME/.config/zsh/custom<CR>", "open zsh custom" },
  }
}

return M

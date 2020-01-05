local nvim = require("conjure.aniseed.nvim")
local nu = require("conjure.aniseed.nvim.util")
local function ft_map(ft, mode, from, to)
  return nvim.ex.autocmd("FileType", ft, (mode .. "map"), "<buffer>", ("<localleader>" .. from), ("<Plug>(" .. to .. ")"))
end
local function init()
  nvim.set_keymap("n", "<Plug>(conjure_log_split)", ":lua require('conjure.log').split()<cr>", {noremap = true, silent = true})
  nvim.set_keymap("n", "<Plug>(conjure_log_vsplit)", ":lua require('conjure.log').vsplit()<cr>", {noremap = true, silent = true})
  nvim.set_keymap("n", "<Plug>(conjure_prepl_sync)", ":lua require('conjure.prepl').sync()<cr>", {noremap = true, silent = true})
  nvim.set_keymap("n", "<Plug>(conjure_eval_current_form)", ":lua require('conjure.eval')['current-form']()<cr>", {noremap = true, silent = true})
  nvim.ex.augroup("conjure")
  nvim.ex.autocmd_()
  ft_map("clojure", "n", "ls", "conjure_log_split")
  ft_map("clojure", "n", "lv", "conjure_log_vsplit")
  ft_map("clojure", "n", "ps", "conjure_prepl_sync")
  ft_map("clojure", "n", "ee", "conjure_eval_current_form")
  return nvim.ex.augroup("END")
end
return {["aniseed/module"] = "conjure.mapping", init = init}
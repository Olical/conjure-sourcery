local _0_0 = nil
do
  local name_23_0_ = "conjure.mapping"
  local loaded_23_0_ = package.loaded[name_23_0_]
  local module_23_0_ = nil
  if ("table" == type(loaded_23_0_)) then
    module_23_0_ = loaded_23_0_
  else
    module_23_0_ = {}
  end
  module_23_0_["aniseed/module"] = name_23_0_
  module_23_0_["aniseed/locals"] = (module_23_0_["aniseed/locals"] or {})
  module_23_0_["aniseed/local-fns"] = (module_23_0_["aniseed/local-fns"] or {})
  package.loaded[name_23_0_] = module_23_0_
  _0_0 = module_23_0_
end
local function _1_(...)
  _0_0["aniseed/local-fns"] = {require = {nu = "conjure.aniseed.nvim.util", nvim = "conjure.aniseed.nvim"}}
  return {require("conjure.aniseed.nvim.util"), require("conjure.aniseed.nvim")}
end
local _2_ = _1_(...)
local nu = _2_[1]
local nvim = _2_[2]
do local _ = ({nil, _0_0, nil})[2] end
local ft_map = nil
do
  local v_23_0_ = nil
  local function ft_map0(ft, mode, from, to)
    return nvim.ex.autocmd("FileType", ft, (mode .. "map"), "<buffer>", ("<localleader>" .. from), ("<Plug>(" .. to .. ")"))
  end
  v_23_0_ = ft_map0
  _0_0["aniseed/locals"]["ft-map"] = v_23_0_
  ft_map = v_23_0_
end
local init = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function init0()
      nvim.set_keymap("n", "<Plug>(conjure_log_split)", ":lua require('conjure.log').split()<cr>", {noremap = true, silent = true})
      nvim.set_keymap("n", "<Plug>(conjure_log_vsplit)", ":lua require('conjure.log').vsplit()<cr>", {noremap = true, silent = true})
      nvim.set_keymap("n", "<Plug>(conjure_prepl_sync)", ":lua require('conjure.prepl').sync()<cr>", {noremap = true, silent = true})
      nvim.set_keymap("n", "<Plug>(conjure_eval_current_form)", ":lua require('conjure.eval')['current-form']()<cr>", {noremap = true, silent = true})
      nvim.set_keymap("n", "<Plug>(conjure_eval_root_form)", ":lua require('conjure.eval')['root-form']()<cr>", {noremap = true, silent = true})
      nvim.ex.augroup("conjure")
      nvim.ex.autocmd_()
      ft_map("clojure", "n", "ls", "conjure_log_split")
      ft_map("clojure", "n", "lv", "conjure_log_vsplit")
      ft_map("clojure", "n", "ps", "conjure_prepl_sync")
      ft_map("clojure", "n", "ee", "conjure_eval_current_form")
      ft_map("clojure", "n", "er", "conjure_eval_root_form")
      return nvim.ex.augroup("END")
    end
    v_23_0_0 = init0
    _0_0["init"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["init"] = v_23_0_
  init = v_23_0_
end
return nil
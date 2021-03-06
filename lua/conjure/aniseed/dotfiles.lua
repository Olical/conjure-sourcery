local _0_0 = nil
do
  local name_23_0_ = "conjure.aniseed.dotfiles"
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
  _0_0["aniseed/local-fns"] = {require = {compile = "conjure.aniseed.compile", nvim = "conjure.aniseed.nvim"}}
  return {require("conjure.aniseed.compile"), require("conjure.aniseed.nvim")}
end
local _2_ = _1_(...)
local compile = _2_[1]
local nvim = _2_[2]
do local _ = ({nil, _0_0, nil})[2] end
local config_dir = nil
do
  local v_23_0_ = nvim.fn.stdpath("config")
  _0_0["aniseed/locals"]["config-dir"] = v_23_0_
  config_dir = v_23_0_
end
compile.glob("**/*.fnl", (config_dir .. "/fnl"), (config_dir .. "/lua"))
return require("dotfiles.init")

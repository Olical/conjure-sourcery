local _0_0 = nil
do
  local name_23_0_ = "conjure.config"
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
  _0_0["aniseed/local-fns"] = {require = {ani = "conjure.aniseed.core", mapping = "conjure.mapping"}}
  return {require("conjure.aniseed.core"), require("conjure.mapping")}
end
local _2_ = _1_(...)
local ani = _2_[1]
local mapping = _2_[2]
do local _ = ({nil, _0_0, nil})[2] end
local core = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = {langs = {clojure = "conjure.langs.clojure", fennel = "conjure.langs.fennel"}}
    _0_0["core"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["core"] = v_23_0_
  core = v_23_0_
end
local filetypes = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function filetypes0()
      return ani.keys(core.langs)
    end
    v_23_0_0 = filetypes0
    _0_0["filetypes"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["filetypes"] = v_23_0_
  filetypes = v_23_0_
end
return nil
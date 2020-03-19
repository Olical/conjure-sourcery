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
  _0_0["aniseed/local-fns"] = {require = {core = "conjure.aniseed.core"}}
  return {require("conjure.aniseed.core")}
end
local _2_ = _1_(...)
local core = _2_[1]
do local _ = ({nil, _0_0, nil})[2] end
local langs = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = {fennel = "conjure.lang.fennel-aniseed"}
    _0_0["langs"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["langs"] = v_23_0_
  langs = v_23_0_
end
local mappings = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = {["close-hud"] = "q", ["eval-buf"] = "eb", ["eval-current-form"] = "ee", ["eval-file"] = "ef", ["eval-motion"] = "E", ["eval-root-form"] = "er", ["eval-visual"] = "E", ["eval-word"] = "ew", ["log-split"] = "ls", ["log-vsplit"] = "lv", prefix = "<localleader>"}
    _0_0["mappings"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["mappings"] = v_23_0_
  mappings = v_23_0_
end
local hud = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = {["max-height"] = 10, ["max-width"] = 80, ["passive-close-duration"] = 500}
    _0_0["hud"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["hud"] = v_23_0_
  hud = v_23_0_
end
local filetypes = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function filetypes0()
      return core.keys(langs)
    end
    v_23_0_0 = filetypes0
    _0_0["filetypes"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["filetypes"] = v_23_0_
  filetypes = v_23_0_
end
local filetype__3emodule_name = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function filetype__3emodule_name0(filetype)
      return langs[filetype]
    end
    v_23_0_0 = filetype__3emodule_name0
    _0_0["filetype->module-name"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["filetype->module-name"] = v_23_0_
  filetype__3emodule_name = v_23_0_
end
return nil
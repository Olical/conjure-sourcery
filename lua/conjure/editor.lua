local _0_0 = nil
do
  local name_23_0_ = "conjure.editor"
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
  _0_0["aniseed/local-fns"] = {require = {a = "conjure.aniseed.core", nvim = "conjure.aniseed.nvim"}}
  return {require("conjure.aniseed.core"), require("conjure.aniseed.nvim")}
end
local _2_ = _1_(...)
local a = _2_[1]
local nvim = _2_[2]
do local _ = ({nil, _0_0, nil})[2] end
local percent_fn = nil
do
  local v_23_0_ = nil
  local function percent_fn0(total_fn)
    local function _3_(pc)
      return math.floor(((total_fn() / 100) * (pc * 100)))
    end
    return _3_
  end
  v_23_0_ = percent_fn0
  _0_0["aniseed/locals"]["percent-fn"] = v_23_0_
  percent_fn = v_23_0_
end
local percent_width = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function _3_()
      return nvim.o.columns
    end
    v_23_0_0 = percent_fn(_3_)
    _0_0["percent-width"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["percent-width"] = v_23_0_
  percent_width = v_23_0_
end
local percent_height = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function _3_()
      return nvim.o.lines
    end
    v_23_0_0 = percent_fn(_3_)
    _0_0["percent-height"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["percent-height"] = v_23_0_
  percent_height = v_23_0_
end
return nil
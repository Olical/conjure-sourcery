local _0_0 = nil
do
  local name_23_0_ = "conjure.aniseed.string"
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
local join = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function join0(...)
      local args = {...}
      local function _3_(...)
        if (2 == #args) then
          return args
        else
          return {"", core.first(args)}
        end
      end
      local _4_ = _3_(...)
      local sep = _4_[1]
      local xs = _4_[2]
      local count = core.count(xs)
      local result = ""
      if (count > 0) then
        for i = 1, count do
          local x = xs[i]
          local function _5_(...)
            if (1 == i) then
              return ""
            else
              return sep
            end
          end
          local function _6_(...)
            if core["string?"](x) then
              return x
            elseif core["nil?"](x) then
              return ""
            else
              return core["pr-str"](x)
            end
          end
          result = (result .. _5_(...) .. _6_(...))
        end
      end
      return result
    end
    v_23_0_0 = join0
    _0_0["join"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["join"] = v_23_0_
  join = v_23_0_
end
return nil

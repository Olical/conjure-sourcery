local _0_0 = nil
do
  local name_23_0_ = "conjure.eval"
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
  _0_0["aniseed/local-fns"] = {require = {extract = "conjure.extract", log = "conjure.log", prepl = "conjure.prepl"}}
  return {require("conjure.log"), require("conjure.extract"), require("conjure.prepl")}
end
local _2_ = _1_(...)
local log = _2_[1]
local extract = _2_[2]
local prepl = _2_[3]
do local _ = ({nil, _0_0, nil})[2] end
local current_form = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function current_form0()
      local form = extract.form({})
      if form then
        log.append({";; Evaluating current form"})
        return prepl.send((form.content .. "\n"))
      end
    end
    v_23_0_0 = current_form0
    _0_0["current-form"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["current-form"] = v_23_0_
  current_form = v_23_0_
end
local root_form = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function root_form0()
      local form = extract.form({["root?"] = true})
      if form then
        log.append({";; Evaluating root form"})
        return prepl.send((form.content .. "\n"))
      end
    end
    v_23_0_0 = root_form0
    _0_0["root-form"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["root-form"] = v_23_0_
  root_form = v_23_0_
end
return nil
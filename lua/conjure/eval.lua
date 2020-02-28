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
  _0_0["aniseed/local-fns"] = {require = {extract = "conjure.extract", lang = "conjure.lang"}}
  return {require("conjure.extract"), require("conjure.lang")}
end
local _2_ = _1_(...)
local extract = _2_[1]
local lang = _2_[2]
do local _ = ({nil, _0_0, nil})[2] end
local current_form = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function current_form0()
      return lang.call("display-result", lang.call("eval-str", extract.form({}).content))
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
      return lang.call("display-result", lang.call("eval-str", extract.form({["root?"] = true}).content))
    end
    v_23_0_0 = root_form0
    _0_0["root-form"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["root-form"] = v_23_0_
  root_form = v_23_0_
end
local word = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function word0()
      return lang.call("display-result", lang.call("eval-str", extract.word()))
    end
    v_23_0_0 = word0
    _0_0["word"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["word"] = v_23_0_
  word = v_23_0_
end
local file = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function file0()
      return lang.call("display-result", lang.call("eval-file", extract["file-path"]()))
    end
    v_23_0_0 = file0
    _0_0["file"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["file"] = v_23_0_
  file = v_23_0_
end
local buf = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function buf0()
      return lang.call("display-result", lang.call("eval-str", extract.buf()))
    end
    v_23_0_0 = buf0
    _0_0["buf"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["buf"] = v_23_0_
  buf = v_23_0_
end
return nil
local _0_0 = nil
do
  local name_23_0_ = "conjure.lang.fennel"
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
  _0_0["aniseed/local-fns"] = {require = {["ani-eval"] = "conjure.aniseed.eval", ani = "conjure.aniseed.core", log = "conjure.log", nvim = "conjure.aniseed.nvim", str = "conjure.aniseed.string"}}
  return {require("conjure.aniseed.core"), require("conjure.aniseed.eval"), require("conjure.log"), require("conjure.aniseed.nvim"), require("conjure.aniseed.string")}
end
local _2_ = _1_(...)
local ani = _2_[1]
local ani_eval = _2_[2]
local log = _2_[3]
local nvim = _2_[4]
local str = _2_[5]
do local _ = ({nil, _0_0, nil})[2] end
local log_buf_name = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = ("conjure-" .. nvim.fn.getpid() .. ".fnl")
    _0_0["log-buf-name"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["log-buf-name"] = v_23_0_
  log_buf_name = v_23_0_
end
local welcome_message = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = {";; Welcome to Conjure, let's write some Fennel!"}
    _0_0["welcome-message"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["welcome-message"] = v_23_0_
  welcome_message = v_23_0_
end
local display_eval_result = nil
do
  local v_23_0_ = nil
  local function display_eval_result0(ok_3f, result)
    local result_str = nil
    if ok_3f then
      result_str = ani["pr-str"](result)
    else
      result_str = result
    end
    local result_lines = str.split(result_str, "[^\n]+")
    local function _4_()
      if ok_3f then
        return result_lines
      else
        local function _4_(_241)
          return ("; " .. _241)
        end
        return ani.map(_4_, result_lines)
      end
    end
    log.append(_4_())
    return nvim.out_write((result_str .. "\n"))
  end
  v_23_0_ = display_eval_result0
  _0_0["aniseed/locals"]["display-eval-result"] = v_23_0_
  display_eval_result = v_23_0_
end
local buffer_header_length = nil
do
  local v_23_0_ = 20
  _0_0["aniseed/locals"]["buffer-header-length"] = v_23_0_
  buffer_header_length = v_23_0_
end
local default_module_name = nil
do
  local v_23_0_ = "aniseed.user"
  _0_0["aniseed/locals"]["default-module-name"] = v_23_0_
  default_module_name = v_23_0_
end
local buffer_module_pattern = nil
do
  local v_23_0_ = "[(]%s*module%s*(.-)[%s){]"
  _0_0["aniseed/locals"]["buffer-module-pattern"] = v_23_0_
  buffer_module_pattern = v_23_0_
end
local buffer_module_name = nil
do
  local v_23_0_ = nil
  local function buffer_module_name0()
    local header = str.join("\n", nvim.buf_get_lines(0, 0, buffer_header_length, false))
    return (string.match(header, buffer_module_pattern) or default_module_name)
  end
  v_23_0_ = buffer_module_name0
  _0_0["aniseed/locals"]["buffer-module-name"] = v_23_0_
  buffer_module_name = v_23_0_
end
local eval = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval0(code)
      return display_eval_result(ani_eval.str(("(module " .. buffer_module_name() .. ")" .. code)))
    end
    v_23_0_0 = eval0
    _0_0["eval"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["eval"] = v_23_0_
  eval = v_23_0_
end
return nil
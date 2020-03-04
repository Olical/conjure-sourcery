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
  _0_0["aniseed/local-fns"] = {require = {["ani-eval"] = "aniseed.eval", core = "conjure.aniseed.core", log = "conjure.log", nvim = "conjure.aniseed.nvim", str = "conjure.aniseed.string"}}
  return {require("aniseed.eval"), require("conjure.aniseed.core"), require("conjure.log"), require("conjure.aniseed.nvim"), require("conjure.aniseed.string")}
end
local _2_ = _1_(...)
local ani_eval = _2_[1]
local core = _2_[2]
local log = _2_[3]
local nvim = _2_[4]
local str = _2_[5]
do local _ = ({nil, _0_0, nil})[2] end
local log_buf_name = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = ("conjure-aniseed-" .. nvim.fn.getpid() .. ".fnl")
    _0_0["log-buf-name"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["log-buf-name"] = v_23_0_
  log_buf_name = v_23_0_
end
local buf_header_length = nil
do
  local v_23_0_ = 20
  _0_0["aniseed/locals"]["buf-header-length"] = v_23_0_
  buf_header_length = v_23_0_
end
local default_module_name = nil
do
  local v_23_0_ = "aniseed.user"
  _0_0["aniseed/locals"]["default-module-name"] = v_23_0_
  default_module_name = v_23_0_
end
local buf_module_pattern = nil
do
  local v_23_0_ = "[(]%s*module%s*(.-)[%s){]"
  _0_0["aniseed/locals"]["buf-module-pattern"] = v_23_0_
  buf_module_pattern = v_23_0_
end
local buf_context = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function buf_context0()
      local header = str.join("\n", nvim.buf_get_lines(0, 0, buf_header_length, false))
      return (string.match(header, buf_module_pattern) or default_module_name)
    end
    v_23_0_0 = buf_context0
    _0_0["buf-context"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["buf-context"] = v_23_0_
  buf_context = v_23_0_
end
local eval_str = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_str0(opts)
      local code = nil
      local function _3_()
        if opts.context then
          return ("(module " .. opts.context .. ") ")
        else
          return ""
        end
      end
      code = (_3_() .. opts.code .. "\n")
      local ok_3f, result = ani_eval.str(code, {filename = opts["file-path"]})
      return {["ok?"] = ok_3f, result = result}
    end
    v_23_0_0 = eval_str0
    _0_0["eval-str"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["eval-str"] = v_23_0_
  eval_str = v_23_0_
end
local eval_file = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_file0(opts)
      opts.code = core.slurp(opts["file-path"])
      if opts.code then
        return eval_str(opts)
      end
    end
    v_23_0_0 = eval_file0
    _0_0["eval-file"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["eval-file"] = v_23_0_
  eval_file = v_23_0_
end
local display_result = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function display_result0(opts)
      if opts then
        local _3_ = opts
        local result = _3_["result"]
        local ok_3f = _3_["ok?"]
        local result_str = nil
        if ok_3f then
          result_str = core["pr-str"](result)
        else
          result_str = result
        end
        local result_lines = str.split(result_str, "[^\n]+")
        local function _5_()
          if ok_3f then
            return result_lines
          else
            local function _5_(_241)
              return ("; " .. _241)
            end
            return core.map(_5_, result_lines)
          end
        end
        log.append(_5_())
        return nvim.out_write((result_str .. "\n"))
      end
    end
    v_23_0_0 = display_result0
    _0_0["display-result"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["display-result"] = v_23_0_
  display_result = v_23_0_
end
return nil
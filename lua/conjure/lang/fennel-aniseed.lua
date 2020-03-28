local _0_0 = nil
do
  local name_23_0_ = "conjure.lang.fennel-aniseed"
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
  _0_0["aniseed/local-fns"] = {require = {["ani-core"] = "aniseed.core", ["ani-eval"] = "aniseed.eval", ["ani-test"] = "aniseed.test", a = "conjure.aniseed.core", hud = "conjure.hud", log = "conjure.log", mapping = "conjure.mapping", nvim = "conjure.aniseed.nvim", str = "conjure.aniseed.string", text = "conjure.text", view = "conjure.aniseed.view"}}
  return {require("conjure.aniseed.core"), require("aniseed.core"), require("aniseed.eval"), require("aniseed.test"), require("conjure.hud"), require("conjure.log"), require("conjure.mapping"), require("conjure.aniseed.nvim"), require("conjure.aniseed.string"), require("conjure.text"), require("conjure.aniseed.view")}
end
local _2_ = _1_(...)
local a = _2_[1]
local ani_core = _2_[2]
local ani_eval = _2_[3]
local ani_test = _2_[4]
local hud = _2_[5]
local log = _2_[6]
local mapping = _2_[7]
local nvim = _2_[8]
local str = _2_[9]
local text = _2_[10]
local view = _2_[11]
do local _ = ({nil, _0_0, nil})[2] end
local buf_suffix = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = ".fnl"
    _0_0["buf-suffix"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["buf-suffix"] = v_23_0_
  buf_suffix = v_23_0_
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
local config = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = {["buf-header-length"] = 20, ["hud-sample-limit"] = 24, ["log-sample-limit"] = 64, mappings = {["run-all-tests"] = "ta", ["run-buf-tests"] = "tt"}}
    _0_0["config"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["config"] = v_23_0_
  config = v_23_0_
end
local context = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function context0()
      local header = str.join("\n", nvim.buf_get_lines(0, 0, config["buf-header-length"], false))
      return (string.match(header, buf_module_pattern) or default_module_name)
    end
    v_23_0_0 = context0
    _0_0["context"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["context"] = v_23_0_
  context = v_23_0_
end
local preview = nil
do
  local v_23_0_ = nil
  local function preview0(_3_0)
    local _4_ = _3_0
    local sample_limit = _4_["sample-limit"]
    local opts = _4_["opts"]
    local function _5_()
      if (("file" == opts.origin) or ("buf" == opts.origin)) then
        return text["right-sample"](opts["file-path"], sample_limit)
      else
        return text["left-sample"](opts.code, sample_limit)
      end
    end
    return ("; " .. opts.action .. " (" .. opts.origin .. "): " .. _5_())
  end
  v_23_0_ = preview0
  _0_0["aniseed/locals"]["preview"] = v_23_0_
  preview = v_23_0_
end
local display = nil
do
  local v_23_0_ = nil
  local function display0(opts)
    hud.display(opts)
    return log.append(opts)
  end
  v_23_0_ = display0
  _0_0["aniseed/locals"]["display"] = v_23_0_
  display = v_23_0_
end
local display_request = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function display_request0(opts)
      return display({lines = {preview({["sample-limit"] = config["log-sample-limit"], opts = opts})}})
    end
    v_23_0_0 = display_request0
    _0_0["display-request"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["display-request"] = v_23_0_
  display_request = v_23_0_
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
      opts["ok?"] = ok_3f
      opts.result = result
      return opts
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
      opts.code = a.slurp(opts["file-path"])
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
          result_str = view.serialise(result)
        else
          result_str = result
        end
        local result_lines = str.split(result_str, "[^\n]+")
        local prefixed_result_lines = nil
        if ok_3f then
          prefixed_result_lines = result_lines
        else
          local function _5_(_241)
            return ("; " .. _241)
          end
          prefixed_result_lines = a.map(_5_, result_lines)
        end
        hud.display({lines = {preview({["sample-limit"] = config["hud-sample-limit"], opts = opts}), unpack(prefixed_result_lines)}})
        return log.append({lines = prefixed_result_lines})
      end
    end
    v_23_0_0 = display_result0
    _0_0["display-result"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["display-result"] = v_23_0_
  display_result = v_23_0_
end
local wrapped_test = nil
do
  local v_23_0_ = nil
  local function wrapped_test0(req, f)
    display({lines = req})
    do
      local res = ani_core["with-out-str"](f)
      local lines = nil
      local _3_
      if ("" == res) then
        _3_ = "No results."
      else
        _3_ = res
      end
      lines = text["prefixed-lines"](_3_, "; ")
      hud.display({lines = a.concat(req, lines)})
      return log.append({lines = lines})
    end
  end
  v_23_0_ = wrapped_test0
  _0_0["aniseed/locals"]["wrapped-test"] = v_23_0_
  wrapped_test = v_23_0_
end
local run_buf_tests = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function run_buf_tests0()
      local c = context()
      local req = {("; run-buf-tests (" .. c .. ")")}
      local function _3_()
        return ani_test.run(c)
      end
      return wrapped_test(req, _3_)
    end
    v_23_0_0 = run_buf_tests0
    _0_0["run-buf-tests"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["run-buf-tests"] = v_23_0_
  run_buf_tests = v_23_0_
end
local run_all_tests = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function run_all_tests0()
      return wrapped_test({"; run-all-tests"}, ani_test["run-all"])
    end
    v_23_0_0 = run_all_tests0
    _0_0["run-all-tests"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["run-all-tests"] = v_23_0_
  run_all_tests = v_23_0_
end
local on_filetype = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function on_filetype0()
      mapping.buf("n", config.mappings["run-buf-tests"], "conjure.lang.fennel-aniseed", "run-buf-tests")
      return mapping.buf("n", config.mappings["run-all-tests"], "conjure.lang.fennel-aniseed", "run-all-tests")
    end
    v_23_0_0 = on_filetype0
    _0_0["on-filetype"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["on-filetype"] = v_23_0_
  on_filetype = v_23_0_
end
return nil
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
  _0_0["aniseed/local-fns"] = {require = {["ani-core"] = "aniseed.core", ["ani-eval"] = "aniseed.eval", ["ani-test"] = "aniseed.test", a = "conjure.aniseed.core", extract = "conjure.extract", hud = "conjure.hud", log = "conjure.log", mapping = "conjure.mapping", nvim = "conjure.aniseed.nvim", str = "conjure.aniseed.string", text = "conjure.text", view = "conjure.aniseed.view"}}
  return {require("conjure.aniseed.core"), require("aniseed.core"), require("aniseed.eval"), require("aniseed.test"), require("conjure.extract"), require("conjure.hud"), require("conjure.log"), require("conjure.mapping"), require("conjure.aniseed.nvim"), require("conjure.aniseed.string"), require("conjure.text"), require("conjure.aniseed.view")}
end
local _2_ = _1_(...)
local a = _2_[1]
local ani_core = _2_[2]
local ani_eval = _2_[3]
local ani_test = _2_[4]
local extract = _2_[5]
local hud = _2_[6]
local log = _2_[7]
local mapping = _2_[8]
local nvim = _2_[9]
local str = _2_[10]
local text = _2_[11]
local view = _2_[12]
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
local context_pattern = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = "[(]%s*module%s*(.-)[%s){]"
    _0_0["context-pattern"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["context-pattern"] = v_23_0_
  context_pattern = v_23_0_
end
local comment_prefix = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = "; "
    _0_0["comment-prefix"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["comment-prefix"] = v_23_0_
  comment_prefix = v_23_0_
end
local config = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = {mappings = {["run-all-tests"] = "ta", ["run-buf-tests"] = "tt"}}
    _0_0["config"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["config"] = v_23_0_
  config = v_23_0_
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
        hud.display({lines = a.concat({opts.preview}, prefixed_result_lines)})
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
local eval_str = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_str0(opts)
      local code = (("(module " .. (opts.context or "aniseed.user") .. ") ") .. opts.code .. "\n")
      local ok_3f, result = ani_eval.str(code, {filename = opts["file-path"]})
      opts["ok?"] = ok_3f
      opts.result = result
      return display_result(opts)
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
      local c = extract.context()
      local req = {("; run-buf-tests (" .. c .. ")")}
      if c then
        local function _3_()
          return ani_test.run(c)
        end
        return wrapped_test(req, _3_)
      end
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
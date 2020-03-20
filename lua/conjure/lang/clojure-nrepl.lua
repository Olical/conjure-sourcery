local _0_0 = nil
do
  local name_23_0_ = "conjure.lang.clojure-nrepl"
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
  _0_0["aniseed/local-fns"] = {require = {code = "conjure.code", hud = "conjure.hud", log = "conjure.log", nvim = "conjure.aniseed.nvim", str = "conjure.aniseed.string"}}
  return {require("conjure.code"), require("conjure.hud"), require("conjure.log"), require("conjure.aniseed.nvim"), require("conjure.aniseed.string")}
end
local _2_ = _1_(...)
local code = _2_[1]
local hud = _2_[2]
local log = _2_[3]
local nvim = _2_[4]
local str = _2_[5]
do local _ = ({nil, _0_0, nil})[2] end
local buf_suffix = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = ".cljc"
    _0_0["buf-suffix"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["buf-suffix"] = v_23_0_
  buf_suffix = v_23_0_
end
local default_namespace_name = nil
do
  local v_23_0_ = "user"
  _0_0["aniseed/locals"]["default-namespace-name"] = v_23_0_
  default_namespace_name = v_23_0_
end
local buf_namespace_pattern = nil
do
  local v_23_0_ = "[(]%s*ns%s*(.-)[%s){]"
  _0_0["aniseed/locals"]["buf-namespace-pattern"] = v_23_0_
  buf_namespace_pattern = v_23_0_
end
local config = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = {}
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
      return (string.match(header, buf_namespace_pattern) or default_namespace_name)
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
        return code["right-sample"](opts["file-path"], sample_limit)
      else
        return code["left-sample"](opts.code, sample_limit)
      end
    end
    return ("; " .. opts.action .. " (" .. opts.origin .. "): " .. _5_())
  end
  v_23_0_ = preview0
  _0_0["aniseed/locals"]["preview"] = v_23_0_
  preview = v_23_0_
end
local display_request = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function display_request0(opts)
      local display_opts = {lines = {preview({["sample-limit"] = config["log-sample-limit"], opts = opts})}}
      hud.display(display_opts)
      return log.append(display_opts)
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
      return opts
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
      return nil
    end
    v_23_0_0 = display_result0
    _0_0["display-result"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["display-result"] = v_23_0_
  display_result = v_23_0_
end
return nil
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
  _0_0["aniseed/local-fns"] = {require = {config = "conjure.config", extract = "conjure.extract", hud = "conjure.hud", lang = "conjure.lang", log = "conjure.log", nvim = "conjure.aniseed.nvim", text = "conjure.text"}}
  return {require("conjure.config"), require("conjure.extract"), require("conjure.hud"), require("conjure.lang"), require("conjure.log"), require("conjure.aniseed.nvim"), require("conjure.text")}
end
local _2_ = _1_(...)
local config = _2_[1]
local extract = _2_[2]
local hud = _2_[3]
local lang = _2_[4]
local log = _2_[5]
local nvim = _2_[6]
local text = _2_[7]
do local _ = ({nil, _0_0, nil})[2] end
local preview = nil
do
  local v_23_0_ = nil
  local function preview0(opts)
    local sample_limit = config.preview["sample-limit"]
    local function _3_()
      if (("file" == opts.origin) or ("buf" == opts.origin)) then
        return text["right-sample"](opts["file-path"], sample_limit)
      else
        return text["left-sample"](opts.code, sample_limit)
      end
    end
    return (lang.get("comment-prefix") .. opts.action .. " (" .. opts.origin .. "): " .. _3_())
  end
  v_23_0_ = preview0
  _0_0["aniseed/locals"]["preview"] = v_23_0_
  preview = v_23_0_
end
local display_request = nil
do
  local v_23_0_ = nil
  local function display_request0(opts)
    hud.display({lines = {opts.preview}})
    return log.append({lines = {opts.preview}})
  end
  v_23_0_ = display_request0
  _0_0["aniseed/locals"]["display-request"] = v_23_0_
  display_request = v_23_0_
end
local file = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function file0()
      local opts = {["file-path"] = extract["file-path"](), action = "eval", origin = "file"}
      opts.preview = preview(opts)
      display_request(opts)
      return lang.call("eval-file", opts)
    end
    v_23_0_0 = file0
    _0_0["file"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["file"] = v_23_0_
  file = v_23_0_
end
local eval_str = nil
do
  local v_23_0_ = nil
  local function eval_str0(opts)
    vim.schedule(hud["clear-passive-timer"])
    opts.action = "eval"
    opts.context = (nvim.b.conjure_context or extract.context())
    opts["file-path"] = extract["file-path"]()
    opts.preview = preview(opts)
    display_request(opts)
    return lang.call("eval-str", opts)
  end
  v_23_0_ = eval_str0
  _0_0["aniseed/locals"]["eval-str"] = v_23_0_
  eval_str = v_23_0_
end
local current_form = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function current_form0()
      local _3_ = extract.form({})
      local range = _3_["range"]
      local content = _3_["content"]
      return eval_str({code = content, origin = "current-form", range = range})
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
      local _3_ = extract.form({["root?"] = true})
      local range = _3_["range"]
      local content = _3_["content"]
      return eval_str({code = content, origin = "root-form", range = range})
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
      local _3_ = extract.word()
      local range = _3_["range"]
      local content = _3_["content"]
      return eval_str({code = content, origin = "word", range = range})
    end
    v_23_0_0 = word0
    _0_0["word"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["word"] = v_23_0_
  word = v_23_0_
end
local buf = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function buf0()
      local _3_ = extract.buf()
      local range = _3_["range"]
      local content = _3_["content"]
      return eval_str({code = content, origin = "buf", range = range})
    end
    v_23_0_0 = buf0
    _0_0["buf"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["buf"] = v_23_0_
  buf = v_23_0_
end
local command = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function command0(code)
      return eval_str({code = code, origin = "command"})
    end
    v_23_0_0 = command0
    _0_0["command"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["command"] = v_23_0_
  command = v_23_0_
end
local range = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function range0(start, _end)
      local _3_ = extract.range(start, _end)
      local range1 = _3_["range"]
      local content = _3_["content"]
      return eval_str({code = content, origin = "range", range = range1})
    end
    v_23_0_0 = range0
    _0_0["range"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["range"] = v_23_0_
  range = v_23_0_
end
local selection = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function selection0(kind)
      local _3_ = extract.selection({["visual?"] = not kind, kind = (kind or nvim.fn.visualmode())})
      local range0 = _3_["range"]
      local content = _3_["content"]
      return eval_str({code = content, origin = "selection", range = range0})
    end
    v_23_0_0 = selection0
    _0_0["selection"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["selection"] = v_23_0_
  selection = v_23_0_
end
return nil
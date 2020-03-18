local _0_0 = nil
do
  local name_23_0_ = "conjure.mapping"
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
  _0_0["aniseed/local-fns"] = {require = {config = "conjure.config", core = "conjure.aniseed.core", eval = "conjure.eval", extract = "conjure.extract", hud = "conjure.hud", lang = "conjure.lang", nvim = "conjure.aniseed.nvim", str = "conjure.aniseed.string"}}
  return {require("conjure.config"), require("conjure.aniseed.core"), require("conjure.eval"), require("conjure.extract"), require("conjure.hud"), require("conjure.lang"), require("conjure.aniseed.nvim"), require("conjure.aniseed.string")}
end
local _2_ = _1_(...)
local config = _2_[1]
local core = _2_[2]
local eval = _2_[3]
local extract = _2_[4]
local hud = _2_[5]
local lang = _2_[6]
local nvim = _2_[7]
local str = _2_[8]
do local _ = ({nil, _0_0, nil})[2] end
local viml__3elua = nil
do
  local v_23_0_ = nil
  local function viml__3elua0(m, f, opts)
    return ("lua require('" .. m .. "')['" .. f .. "'](" .. (opts.args or "") .. ")")
  end
  v_23_0_ = viml__3elua0
  _0_0["aniseed/locals"]["viml->lua"] = v_23_0_
  viml__3elua = v_23_0_
end
local plug = nil
do
  local v_23_0_ = nil
  local function plug0(name)
    return ("<Plug>(" .. name .. ")")
  end
  v_23_0_ = plug0
  _0_0["aniseed/locals"]["plug"] = v_23_0_
  plug = v_23_0_
end
local map_plug = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function map_plug0(mode, name, m, f)
      return nvim.set_keymap(mode, plug(name), (":" .. viml__3elua(m, f, {}) .. "<cr>"), {noremap = true, silent = true})
    end
    v_23_0_0 = map_plug0
    _0_0["map-plug"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["map-plug"] = v_23_0_
  map_plug = v_23_0_
end
local map_local__3eplug = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function map_local__3eplug0(mode, keys, name)
      return nvim.buf_set_keymap(0, mode, (config.mappings.prefix .. keys), plug(name), {silent = true})
    end
    v_23_0_0 = map_local__3eplug0
    _0_0["map-local->plug"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["map-local->plug"] = v_23_0_
  map_local__3eplug = v_23_0_
end
local on_filetype = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function on_filetype0()
      map_local__3eplug("n", config.mappings["log-split"], "conjure_log_split")
      map_local__3eplug("n", config.mappings["log-vsplit"], "conjure_log_vsplit")
      map_local__3eplug("n", config.mappings["eval-current-form"], "conjure_eval_current_form")
      map_local__3eplug("n", config.mappings["eval-root-form"], "conjure_eval_root_form")
      map_local__3eplug("n", config.mappings["eval-word"], "conjure_eval_word")
      map_local__3eplug("n", config.mappings["eval-file"], "conjure_eval_file")
      map_local__3eplug("n", config.mappings["eval-buf"], "conjure_eval_buf")
      map_local__3eplug("n", config.mappings["eval-motion"], "conjure_eval_motion")
      map_local__3eplug("v", config.mappings["eval-visual"], "conjure_eval_visual")
      map_local__3eplug("n", config.mappings["close-hud"], "conjure_close_hud")
      return lang.call("on-filetype")
    end
    v_23_0_0 = on_filetype0
    _0_0["on-filetype"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["on-filetype"] = v_23_0_
  on_filetype = v_23_0_
end
local setup_filetypes = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function setup_filetypes0(filetypes)
      nvim.ex.augroup("conjure_init_filetypes")
      nvim.ex.autocmd_()
      nvim.ex.autocmd("FileType", str.join(",", filetypes), viml__3elua("conjure.mapping", "on-filetype", {}))
      return nvim.ex.augroup("END")
    end
    v_23_0_0 = setup_filetypes0
    _0_0["setup-filetypes"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["setup-filetypes"] = v_23_0_
  setup_filetypes = v_23_0_
end
local eval_ranged_command = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_ranged_command0(start, _end, code)
      if ("" == code) then
        return eval.range(core.dec(start), _end)
      else
        return eval.command(code)
      end
    end
    v_23_0_0 = eval_ranged_command0
    _0_0["eval-ranged-command"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["eval-ranged-command"] = v_23_0_
  eval_ranged_command = v_23_0_
end
local eval_selection = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_selection0(kind)
      return eval.selection(kind)
    end
    v_23_0_0 = eval_selection0
    _0_0["eval-selection"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["eval-selection"] = v_23_0_
  eval_selection = v_23_0_
end
local setup_plug_mappings = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function setup_plug_mappings0()
      map_plug("n", "conjure_log_split", "conjure.log", "split")
      map_plug("n", "conjure_log_vsplit", "conjure.log", "vsplit")
      map_plug("n", "conjure_eval_current_form", "conjure.eval", "current-form")
      map_plug("n", "conjure_eval_root_form", "conjure.eval", "root-form")
      map_plug("n", "conjure_eval_word", "conjure.eval", "word")
      map_plug("n", "conjure_eval_file", "conjure.eval", "file")
      map_plug("n", "conjure_eval_buf", "conjure.eval", "buf")
      map_plug("v", "conjure_eval_visual", "conjure.mapping", "eval-selection")
      map_plug("n", "conjure_close_hud", "conjure.hud", "close")
      nvim.ex.function_(str.join("\n", {"ConjureEvalMotion(kind)", "call luaeval(\"require('conjure.mapping')['eval-selection'](_A)\", a:kind)", "endfunction"}))
      nvim.set_keymap("n", plug("conjure_eval_motion"), ":set opfunc=ConjureEvalMotion<cr>g@", {noremap = true, silent = true})
      return nvim.ex.command_("-nargs=? -range ConjureEval", viml__3elua("conjure.mapping", "eval-ranged-command", {args = "<line1>, <line2>, <q-args>"}))
    end
    v_23_0_0 = setup_plug_mappings0
    _0_0["setup-plug-mappings"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["setup-plug-mappings"] = v_23_0_
  setup_plug_mappings = v_23_0_
end
return nil
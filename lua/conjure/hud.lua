local _0_0 = nil
do
  local name_23_0_ = "conjure.hud"
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
  _0_0["aniseed/local-fns"] = {require = {buffer = "conjure.buffer", config = "conjure.config", core = "conjure.aniseed.core", lang = "conjure.lang", nvim = "conjure.aniseed.nvim"}}
  return {require("conjure.buffer"), require("conjure.config"), require("conjure.aniseed.core"), require("conjure.lang"), require("conjure.aniseed.nvim")}
end
local _2_ = _1_(...)
local buffer = _2_[1]
local config = _2_[2]
local core = _2_[3]
local lang = _2_[4]
local nvim = _2_[5]
do local _ = ({nil, _0_0, nil})[2] end
local hud_buf_name = nil
do
  local v_23_0_ = nil
  local function hud_buf_name0()
    return ("conjure-hud-" .. nvim.fn.getpid() .. lang.get("buf-suffix"))
  end
  v_23_0_ = hud_buf_name0
  _0_0["aniseed/locals"]["hud-buf-name"] = v_23_0_
  hud_buf_name = v_23_0_
end
local state = nil
do
  local v_23_0_ = (_0_0["aniseed/locals"].state or {id = nil, timer = nil})
  _0_0["aniseed/locals"]["state"] = v_23_0_
  state = v_23_0_
end
local close = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function close0()
      __fnl_global__clear_2dpassive_2dtimer()
      if state.id then
        nvim.win_close(state.id, true)
        state.id = nil
        return nil
      end
    end
    v_23_0_0 = close0
    _0_0["close"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["close"] = v_23_0_
  close = v_23_0_
end
local clear_passive_timer = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function clear_passive_timer0()
      if state.timer then
        do end (state.timer):close()
        state.timer = nil
        return nil
      end
    end
    v_23_0_0 = clear_passive_timer0
    _0_0["clear-passive-timer"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["clear-passive-timer"] = v_23_0_
  clear_passive_timer = v_23_0_
end
local close_passive = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function close_passive0()
      if not state.timer then
        state.timer = vim.loop.new_timer()
        return (state.timer):start(config.hud["passive-close-duration"], 0, vim.schedule_wrap(close))
      end
    end
    v_23_0_0 = close_passive0
    _0_0["close-passive"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["close-passive"] = v_23_0_
  close_passive = v_23_0_
end
local display = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function display0(_3_0)
      local _4_ = _3_0
      local lines = _4_["lines"]
      close()
      do
        local buf = buffer["upsert-hidden"](hud_buf_name())
        local max_line_length = math.max(unpack(core.map(core.count, lines)))
        local line_count = core.count(lines)
        local opts = {anchor = "NW", col = 424242, focusable = false, height = math.min(config.hud["max-height"], line_count), relative = "editor", row = 0, style = "minimal", width = math.min(config.hud["max-width"], max_line_length)}
        nvim.buf_set_lines(buf, 0, -1, false, lines)
        state.id = nvim.open_win(buf, false, opts)
        return nvim.win_set_option(state.id, "wrap", false)
      end
    end
    v_23_0_0 = display0
    _0_0["display"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["display"] = v_23_0_
  display = v_23_0_
end
return nil
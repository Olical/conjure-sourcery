local _0_0 = nil
do
  local name_23_0_ = "conjure.log"
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
  _0_0["aniseed/local-fns"] = {require = {a = "conjure.aniseed.core", buffer = "conjure.buffer", config = "conjure.config", editor = "conjure.editor", lang = "conjure.lang", nvim = "conjure.aniseed.nvim"}}
  return {require("conjure.aniseed.core"), require("conjure.buffer"), require("conjure.config"), require("conjure.editor"), require("conjure.lang"), require("conjure.aniseed.nvim")}
end
local _2_ = _1_(...)
local a = _2_[1]
local buffer = _2_[2]
local config = _2_[3]
local editor = _2_[4]
local lang = _2_[5]
local nvim = _2_[6]
do local _ = ({nil, _0_0, nil})[2] end
local state = nil
do
  local v_23_0_ = (_0_0["aniseed/locals"].state or {hud = {id = nil}})
  _0_0["aniseed/locals"]["state"] = v_23_0_
  state = v_23_0_
end
local log_buf_name = nil
do
  local v_23_0_ = nil
  local function log_buf_name0()
    return ("conjure-log-" .. nvim.fn.getpid() .. lang.get("buf-suffix"))
  end
  v_23_0_ = log_buf_name0
  _0_0["aniseed/locals"]["log-buf-name"] = v_23_0_
  log_buf_name = v_23_0_
end
local upsert_buf = nil
do
  local v_23_0_ = nil
  local function upsert_buf0()
    return buffer["upsert-hidden"](log_buf_name())
  end
  v_23_0_ = upsert_buf0
  _0_0["aniseed/locals"]["upsert-buf"] = v_23_0_
  upsert_buf = v_23_0_
end
local close_hud = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function close_hud0()
      if state.hud.id then
        local function _3_()
          return nvim.win_close(state.hud.id, true)
        end
        pcall(_3_)
        state.hud.id = nil
        return nil
      end
    end
    v_23_0_0 = close_hud0
    _0_0["close-hud"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["close-hud"] = v_23_0_
  close_hud = v_23_0_
end
local display_hud = nil
do
  local v_23_0_ = nil
  local function display_hud0()
    if (config.log.hud["enabled?"] and not state.hud.id) then
      local buf = upsert_buf()
      local opts = {anchor = "NW", col = 424242, focusable = false, height = editor["percent-height"](config.log.hud.height), relative = "editor", row = 0, style = "minimal", width = editor["percent-width"](config.log.hud.width)}
      state.hud.id = nvim.open_win(buf, false, opts)
      nvim.win_set_option(state.hud.id, "wrap", false)
      return nvim.win_set_cursor(state.hud.id, {nvim.buf_line_count(buf), 0})
    end
  end
  v_23_0_ = display_hud0
  _0_0["aniseed/locals"]["display-hud"] = v_23_0_
  display_hud = v_23_0_
end
local append = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function append0(lines)
      if not a["empty?"](lines) then
        do
          local buf = upsert_buf()
          local old_lines = nvim.buf_line_count(buf)
          local _3_
          if buffer["empty?"](buf) then
            _3_ = 0
          else
            _3_ = -1
          end
          nvim.buf_set_lines(buf, _3_, -1, false, lines)
          do
            local new_lines = nvim.buf_line_count(buf)
            local function _5_(win)
              local _6_ = nvim.win_get_cursor(win)
              local row = _6_[1]
              local col = _6_[2]
              if ((buf == nvim.win_get_buf(win)) and (old_lines == row)) then
                return nvim.win_set_cursor(win, {new_lines, 0})
              end
            end
            a["run!"](_5_, nvim.list_wins())
          end
        end
        return display_hud()
      end
    end
    v_23_0_0 = append0
    _0_0["append"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["append"] = v_23_0_
  append = v_23_0_
end
local create_win = nil
do
  local v_23_0_ = nil
  local function create_win0(split_fn)
    local buf = upsert_buf()
    local win = split_fn(log_buf_name())
    nvim.win_set_cursor(win, {nvim.buf_line_count(buf), 0})
    nvim.win_set_option(win, "wrap", false)
    return buffer.unlist(buf)
  end
  v_23_0_ = create_win0
  _0_0["aniseed/locals"]["create-win"] = v_23_0_
  create_win = v_23_0_
end
local split = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function split0()
      return create_win(nvim.ex.split)
    end
    v_23_0_0 = split0
    _0_0["split"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["split"] = v_23_0_
  split = v_23_0_
end
local vsplit = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function vsplit0()
      return create_win(nvim.ex.vsplit)
    end
    v_23_0_0 = vsplit0
    _0_0["vsplit"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["vsplit"] = v_23_0_
  vsplit = v_23_0_
end
return nil
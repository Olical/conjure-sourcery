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
  _0_0["aniseed/local-fns"] = {require = {buffer = "conjure.buffer", core = "conjure.aniseed.core", lang = "conjure.lang", nvim = "conjure.aniseed.nvim"}}
  return {require("conjure.buffer"), require("conjure.aniseed.core"), require("conjure.lang"), require("conjure.aniseed.nvim")}
end
local _2_ = _1_(...)
local buffer = _2_[1]
local core = _2_[2]
local lang = _2_[3]
local nvim = _2_[4]
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
local open_win = nil
do
  local v_23_0_ = (_0_0["aniseed/locals"]["open-win"] or nil)
  _0_0["aniseed/locals"]["open-win"] = v_23_0_
  open_win = v_23_0_
end
local close = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function close0()
      if open_win then
        nvim.win_close(open_win, true)
        open_win = nil
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
        local opts = {anchor = "NE", col = 424242, focusable = false, height = math.min(10, line_count), relative = "editor", row = 0, style = "minimal", width = math.min(80, max_line_length)}
        nvim.buf_set_lines(buf, 0, -1, false, lines)
        open_win = nvim.open_win(buf, false, opts)
        return nvim.win_set_option(open_win, "wrap", false)
      end
    end
    v_23_0_0 = display0
    _0_0["display"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["display"] = v_23_0_
  display = v_23_0_
end
              -- (display table: 0x41e97620) (display table: 0x41542a00) (close)
return nil
local ani = require("conjure.aniseed.core")
local nvim = require("conjure.aniseed.nvim")
local str = require("conjure.aniseed.string")
local function read_range(_0_0, _1_0)
  local _1_ = _0_0
  local srow = _1_[1]
  local scol = _1_[2]
  local _2_ = _1_0
  local erow = _2_[1]
  local ecol = _2_[2]
  do
    local lines = nvim.buf_get_lines(0, (srow - 1), erow, false)
    local function _3_(s)
      return string.sub(s, 0, ecol)
    end
    local function _4_(s)
      return string.sub(s, scol)
    end
    return str.join("\n", ani.update(ani.update(lines, #lines, _3_), 1, _4_))
  end
end
local function current_char()
  local _2_ = nvim.win_get_cursor(0)
  local row = _2_[1]
  local col = _2_[2]
  local _3_ = nvim.buf_get_lines(0, (row - 1), row, false)
  local line = _3_[1]
  local char = (col + 1)
  return string.sub(line, char, char)
end
local function nil_pos_3f(pos)
  return (not pos or (0 == unpack(pos)))
end
local function form(_2_0)
  local _3_ = _2_0
  local root_3f = _3_["root?"]
  do
    local flags = flags
    local function _4_()
      if root_3f then
        return "r"
      else
        return ""
      end
    end
    flags = ("Wnz" .. _4_())
    local cursor_char = current_char()
    local start = start
    local function _5_()
      if (cursor_char == "(") then
        return "c"
      else
        return ""
      end
    end
    start = nvim.fn.searchpairpos("(", "", ")", (flags .. "b" .. _5_()))
    local _end = nil
    local function _6_()
      if (cursor_char == ")") then
        return "c"
      else
        return ""
      end
    end
    _end = nvim.fn.searchpairpos("(", "", ")", (flags .. _6_()))
    if (not nil_pos_3f(start) and not nil_pos_3f(_end)) then
      return {content = read_range(start, _end), range = {["end"] = ani.update(_end, 2, ani.dec), start = ani.update(start, 2, ani.dec)}}
    end
  end
end
return {["aniseed/module"] = "conjure.extract", form = form}
local ani = require("conjure.aniseed.core")
local nvim = require("conjure.aniseed.nvim")
local str = require("conjure.aniseed.string")
local function read_range(_0_0)
  local _1_ = _0_0
  local _2_ = _1_["start"]
  local srow = _2_[1]
  local scol = _2_[2]
  local _3_ = _1_["end"]
  local erow = _3_[1]
  local ecol = _3_[2]
  do
    local lines = nvim.buf_get_lines(0, (srow - 1), erow, false)
    local function _4_(s)
      return string.sub(s, 0, ecol)
    end
    local function _5_(s)
      return string.sub(s, scol)
    end
    return str.join("\n", ani.update(ani.update(lines, #lines, _4_), 1, _5_))
  end
end
local function current_char()
  local _1_ = nvim.win_get_cursor(0)
  local row = _1_[1]
  local col = _1_[2]
  local _2_ = nvim.buf_get_lines(0, (row - 1), row, false)
  local line = _2_[1]
  local char = (col + 1)
  return string.sub(line, char, char)
end
local function nil_pos_3f(pos)
  return (not pos or (0 == unpack(pos)))
end
local function form(_1_0)
  local _2_ = _1_0
  local root_3f = _2_["root?"]
  do
    local flags = flags
    local function _3_()
      if root_3f then
        return "r"
      else
        return ""
      end
    end
    flags = ("Wnz" .. _3_())
    local cursor_char = current_char()
    local start = start
    local function _4_()
      if (cursor_char == "(") then
        return "c"
      else
        return ""
      end
    end
    start = nvim.fn.searchpairpos("(", "", ")", (flags .. "b" .. _4_()))
    local _end = nil
    local function _5_()
      if (cursor_char == ")") then
        return "c"
      else
        return ""
      end
    end
    _end = nvim.fn.searchpairpos("(", "", ")", (flags .. _5_()))
    if (not nil_pos_3f(start) and not nil_pos_3f(_end)) then
      local range = {["end"] = _end, start = start}
      return {content = read_range(range), range = range}
    end
  end
end
return {["aniseed/module"] = "conjure.extract", form = form}
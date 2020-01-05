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
    local lines = nvim.buf_get_lines(0, ani.dec(srow), erow, false)
    local function _4_(s)
      return string.sub(s, 0, ecol)
    end
    local function _5_(s)
      return string.sub(s, scol)
    end
    return str.join("\n", ani.update(ani.update(lines, #lines, _4_), 1, _5_))
  end
end
local function current_form()
  local flags = "Wcn"
  local _end = nvim.fn.searchpairpos("(", "", ")", flags)
  local start = nvim.fn.searchpairpos("(", "", ")", (flags .. "b"))
  local range = {["end"] = _end, start = start}
  if ((0 ~= unpack(start)) and (0 ~= unpack(_end))) then
    return {content = read_range(range), range = range}
  end
end
return {["aniseed/module"] = "conjure.extract", ["current-form"] = current_form}
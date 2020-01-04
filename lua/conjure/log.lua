local ani = require("conjure.aniseed.core")
local nvim = require("conjure.aniseed.nvim")
local log_buf_name = (nvim.fn.tempname() .. "_conjure.cljc")
local function upsert_buf()
  local buf = nvim.fn.bufnr(log_buf_name)
  if (-1 == buf) then
    local buf = nvim.fn.bufadd(log_buf_name)
    nvim.buf_set_lines(buf, 0, 1, false, {";; Welcome to Conjure!"})
    nvim.buf_set_option(buf, "buftype", "nofile")
    nvim.buf_set_option(buf, "bufhidden", "hide")
    nvim.buf_set_option(buf, "swapfile", false)
    nvim.buf_set_option(buf, "buflisted", false)
    return buf
  else
    return buf
  end
end
local function append(lines)
  local buf = upsert_buf()
  local old_lines = nvim.buf_line_count(buf)
  nvim.buf_set_lines(buf, -1, -1, false, lines)
  do
    local new_lines = nvim.buf_line_count(buf)
    local function _0_(win)
      local _1_ = nvim.win_get_cursor(win)
      local row = _1_[1]
      local col = _1_[2]
      if ((buf == nvim.win_get_buf(win)) and (col == 0) and (old_lines == row)) then
        return nvim.win_set_cursor(win, {new_lines, 0})
      end
    end
    return ani["run!"](_0_, nvim.list_wins())
  end
end
local function create_win(split_fn)
  local buf = upsert_buf()
  return nvim.win_set_cursor(split_fn(log_buf_name), {nvim.buf_line_count(buf), 0})
end
local function split()
  return create_win(nvim.ex.split)
end
local function vsplit()
  return create_win(nvim.ex.vsplit)
end
return {["aniseed/module"] = "conjure.log", append = append, split = split, vsplit = vsplit}
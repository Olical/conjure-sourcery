local ani = require("conjure.aniseed.core")
local nvim = require("conjure.aniseed.nvim")
local log_buf_name = "conjure.cljc"
local function upsert_log_buf()
  local buf = nvim.fn.bufnr(log_buf_name)
  if (-1 == buf) then
    return nvim.fn.bufadd(log_buf_name)
  else
    return buf
  end
end
local function upsert_log_win(buf)
  local function _0_(_241)
    return (buf == _241)
  end
  if not ani.some(_0_, nvim.fn.tabpagebuflist()) then
    nvim.ex.split(log_buf_name)
    nvim.ex.setlocal("winfixwidth")
    nvim.ex.setlocal("winfixheight")
    nvim.ex.setlocal("buftype=nofile")
    nvim.ex.setlocal("bufhidden=hide")
    nvim.ex.setlocal("nowrap")
    nvim.ex.setlocal("noswapfile")
    nvim.ex.setlocal("nobuflisted")
    nvim.ex.setlocal("nospell")
    nvim.ex.setlocal("foldmethod=marker")
    nvim.ex.setlocal("foldlevel=0")
    nvim.ex.setlocal("foldmarker={{{,}}}")
    nvim.ex.normal_("G")
    nvim.ex.wincmd("p")
  end
  local function _1_(_241)
    return ((buf == nvim.fn.winbufnr(_241)) and _241)
  end
  return ani.some(_1_, nvim.list_wins())
end
local function log_append(lines)
  local buf = upsert_log_buf()
  local win = upsert_log_win(buf)
  nvim.buf_set_lines(buf, -1, -1, true, lines)
                -- (let table: 0x41446b80 (when (> lines 0) (nvim.win_set_cursor win table: 0x414504d8)))
  return nil
end
return {["aniseed/module"] = "conjure.ui", ["log-append"] = log_append}
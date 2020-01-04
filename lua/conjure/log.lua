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
  return nvim.buf_set_lines(upsert_buf(), -1, -1, false, lines)
end
return {["aniseed/module"] = "conjure.log", append = append}
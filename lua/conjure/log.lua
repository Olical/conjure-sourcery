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
  _0_0["aniseed/local-fns"] = {require = {core = "conjure.aniseed.core", lang = "conjure.lang", nvim = "conjure.aniseed.nvim"}}
  return {require("conjure.aniseed.core"), require("conjure.lang"), require("conjure.aniseed.nvim")}
end
local _2_ = _1_(...)
local core = _2_[1]
local lang = _2_[2]
local nvim = _2_[3]
do local _ = ({nil, _0_0, nil})[2] end
local unlist = nil
do
  local v_23_0_ = nil
  local function unlist0(buf)
    return nvim.buf_set_option(buf, "buflisted", false)
  end
  v_23_0_ = unlist0
  _0_0["aniseed/locals"]["unlist"] = v_23_0_
  unlist = v_23_0_
end
local upsert_buf = nil
do
  local v_23_0_ = nil
  local function upsert_buf0()
    local buf = nvim.fn.bufnr(lang.get("log-buf-name"))
    if (-1 == buf) then
      local buf0 = nvim.fn.bufadd(lang.get("log-buf-name"))
      nvim.buf_set_option(buf0, "buftype", "nofile")
      nvim.buf_set_option(buf0, "bufhidden", "hide")
      nvim.buf_set_option(buf0, "swapfile", false)
      unlist(buf0)
      return buf0
    else
      return buf
    end
  end
  v_23_0_ = upsert_buf0
  _0_0["aniseed/locals"]["upsert-buf"] = v_23_0_
  upsert_buf = v_23_0_
end
local append = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function append0(lines)
      local buf = upsert_buf()
      local old_lines = nvim.buf_line_count(buf)
      local _3_
      if ((old_lines <= 1) and (0 == core.count(core.first(nvim.buf_get_lines(buf, 0, -1, false))))) then
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
          if ((buf == nvim.win_get_buf(win)) and (col == 0) and (old_lines == row)) then
            return nvim.win_set_cursor(win, {new_lines, 0})
          end
        end
        return core["run!"](_5_, nvim.list_wins())
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
    nvim.win_set_cursor(split_fn(lang.get("log-buf-name")), {nvim.buf_line_count(buf), 0})
    return unlist(buf)
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
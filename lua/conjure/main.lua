              -- ((. (require conjure.main) single-eval) (+ 10 20) )
local ani = require("conjure.aniseed.core")
local nvim = require("conjure.aniseed.nvim")
local nu = require("conjure.aniseed.nvim.util")
local log = require("conjure.log")
local mapping = require("conjure.mapping")
local function parse(s)
  return {tag = s:match(":tag :%a+"):sub(7), val = s:match(":val %b\"\""):sub(7, -2)}
end
local function chan_on_data(chan_id, data)
  do
    local _0_ = parse(ani.first(data))
    local val = _0_["val"]
    local tag = _0_["tag"]
    log.append({(";; " .. tag), val})
  end
  nvim.fn.chanclose(chan_id)
  return nil
end
nu["fn-bridge"]("ConjureChanOnData", "conjure.main", "chan-on-data")
local function main()
  return mapping.init()
end
local function single_eval(code)
  do
    local chan_id = nvim.fn.sockconnect("tcp", ("localhost:" .. ani.first(nvim.fn.readfile(".prepl-port"))), {on_data = "ConjureChanOnData"})
    nvim.fn.chansend(chan_id, code)
  end
  return nil
end
return {["aniseed/module"] = "conjure.main", ["chan-on-data"] = chan_on_data, ["single-eval"] = single_eval, main = main}
              -- ((. (require conjure-sourcery.main) single-eval) (+ 10 20) )
local ani = require("conjure-sourcery.aniseed.core")
local nvim = require("conjure-sourcery.aniseed.nvim")
local nu = require("conjure-sourcery.aniseed.nvim.util")
local function parse(s)
  return {tag = s:match(":tag :%a+"):sub(7), val = s:match(":val %b\"\""):sub(7, -2)}
end
local function chan_on_data(chan_id, data)
  ani.pr(parse(ani.first(data)))
  nvim.fn.chanclose(chan_id)
  return nil
end
nu["fn-bridge"]("ConjureSourceryChanOnData", "conjure-sourcery.main", "chan-on-data")
local function main()
  return ani.pr("Sourcery!?")
end
local function single_eval(code)
  do
    local chan_id = nvim.fn.sockconnect("tcp", ("localhost:" .. ani.first(nvim.fn.readfile(".prepl-port"))), {on_data = "ConjureSourceryChanOnData"})
    nvim.fn.chansend(chan_id, code)
  end
  return nil
end
return {["aniseed/module"] = "conjure-sourcery.main", ["chan-on-data"] = chan_on_data, ["single-eval"] = single_eval, main = main}
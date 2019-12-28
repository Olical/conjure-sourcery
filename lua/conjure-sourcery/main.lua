local ani = require("aniseed.core")
local nvim = require("aniseed.nvim")
local nu = require("aniseed.nvim.util")
local function main()
  do
    local chan_id = nvim.fn.sockconnect("tcp", "localhost:5555", {on_data = "ConjureSourceryChanOnData"})
    nvim.fn.chansend(chan_id, "(+ 10 20)\n")
  end
  return nil
end
local function parse(s)
  return {tag = s:match(":tag :%a+"):sub(7), val = s:match(":val %b\"\""):sub(7, -2)}
end
local function chan_on_data(chan_id, data)
  ani.pr("resp=>", parse(ani.first(data)))
  nvim.fn.chanclose(chan_id)
  return nil
end
nu["fn-bridge"]("ConjureSourceryChanOnData", "conjure-sourcery.main", "chan-on-data")
              -- ((. (require conjure-sourcery.main) main))
return {["aniseed/module"] = "conjure-sourcery.main", ["chan-on-data"] = chan_on_data, main = main}
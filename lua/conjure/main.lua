local mapping = require("conjure.mapping")
local prepl = require("conjure.prepl")
local function main()
  mapping.init()
  return prepl.sync()
end
return {["aniseed/module"] = "conjure.main", main = main}
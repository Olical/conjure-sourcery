local extract = require("conjure.extract")
local prepl = require("conjure.prepl")
local log = require("conjure.log")
local function current_form()
  local form = extract["current-form"]()
  if form then
    log.append({";; Evaluating current form"})
    return prepl.send((form.content .. "\n"))
  end
end
return {["aniseed/module"] = "conjure.eval", ["current-form"] = current_form}
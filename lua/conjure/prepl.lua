local ani = require("conjure.aniseed.core")
local nvim = require("conjure.aniseed.nvim")
local nu = require("conjure.aniseed.nvim.util")
local log = require("conjure.log")
local conn = nil
local function parse(s)
  return {tag = s:match(":tag :%a+"):sub(7), val = s:match(":val %b\"\""):sub(7, -2)}
end
local function cleanup()
  if conn then
    nvim.fn.chanclose(conn["chan-id"])
    log.append({(";; Disconnected from " .. conn.address)})
    conn = nil
    return nil
  end
end
local function chan_on_data(_chan_id, data, name)
  local msg = ani.first(data)
  if ("" == msg) then
    return cleanup()
  else
    local _0_ = parse(msg)
    local val = _0_["val"]
    local tag = _0_["tag"]
    return log.append({(";; " .. name .. " " .. tag), val})
  end
end
nu["fn-bridge"]("ConjureChanOnData", "conjure.prepl", "chan-on-data")
local prepl_port_file = ".prepl-port"
local function sync()
  cleanup()
  if (1 == nvim.fn.filereadable(prepl_port_file)) then
    local address = ("localhost:" .. ani.first(nvim.fn.readfile(prepl_port_file)))
    local chan_id = nvim.fn.sockconnect("tcp", address, {on_data = "ConjureChanOnData"})
    if (0 == chan_id) then
      return log.append({(";; Failed to connect to " .. address)})
    else
      log.append({(";; Connected to " .. address)})
      conn = {["chan-id"] = chan_id, address = address}
      return nil
    end
  end
end
return {["aniseed/module"] = "conjure.prepl", ["chan-on-data"] = chan_on_data, sync = sync}
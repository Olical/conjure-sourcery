local _0_0 = nil
do
  local name_23_0_ = "conjure.prepl"
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
  _0_0["aniseed/local-fns"] = {require = {ani = "conjure.aniseed.core", log = "conjure.log", nu = "conjure.aniseed.nvim.util", nvim = "conjure.aniseed.nvim"}}
  return {require("conjure.aniseed.core"), require("conjure.log"), require("conjure.aniseed.nvim.util"), require("conjure.aniseed.nvim")}
end
local _2_ = _1_(...)
local ani = _2_[1]
local log = _2_[2]
local nu = _2_[3]
local nvim = _2_[4]
do local _ = ({nil, _0_0, nil})[2] end
local conn = nil
do
  local v_23_0_ = nil
  _0_0["aniseed/locals"]["conn"] = v_23_0_
  conn = v_23_0_
end
local parse = nil
do
  local v_23_0_ = nil
  local function parse0(s)
    return {tag = s:match(":tag :%a+"):sub(7), val = s:match(":val %b\"\""):sub(7, -2)}
  end
  v_23_0_ = parse0
  _0_0["aniseed/locals"]["parse"] = v_23_0_
  parse = v_23_0_
end
local cleanup = nil
do
  local v_23_0_ = nil
  local function cleanup0()
    if conn then
      nvim.fn.chanclose(conn["chan-id"])
      log.append({(";; Disconnected from " .. conn.address)})
      conn = nil
      return nil
    end
  end
  v_23_0_ = cleanup0
  _0_0["aniseed/locals"]["cleanup"] = v_23_0_
  cleanup = v_23_0_
end
local chan_on_data = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function chan_on_data0(_chan_id, data, name)
      local msg = ani.first(data)
      if ("" == msg) then
        return cleanup()
      else
        local _3_ = parse(msg)
        local val = _3_["val"]
        local tag = _3_["tag"]
        return log.append({(";; " .. name .. " " .. tag), val})
      end
    end
    v_23_0_0 = chan_on_data0
    _0_0["chan-on-data"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["chan-on-data"] = v_23_0_
  chan_on_data = v_23_0_
end
nu["fn-bridge"]("ConjureChanOnData", "conjure.prepl", "chan-on-data")
local prepl_port_file = nil
do
  local v_23_0_ = ".prepl-port"
  _0_0["aniseed/locals"]["prepl-port-file"] = v_23_0_
  prepl_port_file = v_23_0_
end
local sync = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function sync0()
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
    v_23_0_0 = sync0
    _0_0["sync"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["sync"] = v_23_0_
  sync = v_23_0_
end
local send = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function send0(code)
      if conn then
        return nvim.fn.chansend(conn["chan-id"], code)
      end
    end
    v_23_0_0 = send0
    _0_0["send"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["send"] = v_23_0_
  send = v_23_0_
end
return nil
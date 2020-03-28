local _0_0 = nil
do
  local name_23_0_ = "conjure.lang.clojure-nrepl"
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
  _0_0["aniseed/local-fns"] = {require = {a = "conjure.aniseed.core", bencode = "conjure.bencode", hud = "conjure.hud", lang = "conjure.lang", log = "conjure.log", nvim = "conjure.aniseed.nvim", str = "conjure.aniseed.string", text = "conjure.text", uuid = "conjure.uuid"}}
  return {require("conjure.aniseed.core"), require("conjure.bencode"), require("conjure.hud"), require("conjure.lang"), require("conjure.log"), require("conjure.aniseed.nvim"), require("conjure.aniseed.string"), require("conjure.text"), require("conjure.uuid")}
end
local _2_ = _1_(...)
local a = _2_[1]
local bencode = _2_[2]
local hud = _2_[3]
local lang = _2_[4]
local log = _2_[5]
local nvim = _2_[6]
local str = _2_[7]
local text = _2_[8]
local uuid = _2_[9]
do local _ = ({nil, _0_0, nil})[2] end
local buf_suffix = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = ".cljc"
    _0_0["buf-suffix"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["buf-suffix"] = v_23_0_
  buf_suffix = v_23_0_
end
local default_namespace_name = nil
do
  local v_23_0_ = "user"
  _0_0["aniseed/locals"]["default-namespace-name"] = v_23_0_
  default_namespace_name = v_23_0_
end
local buf_namespace_pattern = nil
do
  local v_23_0_ = "[(]%s*ns%s*(.-)[%s){]"
  _0_0["aniseed/locals"]["buf-namespace-pattern"] = v_23_0_
  buf_namespace_pattern = v_23_0_
end
local config = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = {}
    _0_0["config"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["config"] = v_23_0_
  config = v_23_0_
end
local context = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function context0()
      local header = str.join("\n", nvim.buf_get_lines(0, 0, config["buf-header-length"], false))
      return (string.match(header, buf_namespace_pattern) or default_namespace_name)
    end
    v_23_0_0 = context0
    _0_0["context"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["context"] = v_23_0_
  context = v_23_0_
end
local preview = nil
do
  local v_23_0_ = nil
  local function preview0(_3_0)
    local _4_ = _3_0
    local sample_limit = _4_["sample-limit"]
    local opts = _4_["opts"]
    local function _5_()
      if (("file" == opts.origin) or ("buf" == opts.origin)) then
        return text["right-sample"](opts["file-path"], sample_limit)
      else
        return text["left-sample"](opts.code, sample_limit)
      end
    end
    return ("; " .. opts.action .. " (" .. opts.origin .. "): " .. _5_())
  end
  v_23_0_ = preview0
  _0_0["aniseed/locals"]["preview"] = v_23_0_
  preview = v_23_0_
end
local display_request = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function display_request0(opts)
      local display_opts = {lines = {preview({["sample-limit"] = config["log-sample-limit"], opts = opts})}}
      hud.display(display_opts)
      return log.append(display_opts)
    end
    v_23_0_0 = display_request0
    _0_0["display-request"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["display-request"] = v_23_0_
  display_request = v_23_0_
end
local eval_str = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_str0(opts)
      return opts
    end
    v_23_0_0 = eval_str0
    _0_0["eval-str"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["eval-str"] = v_23_0_
  eval_str = v_23_0_
end
local eval_file = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_file0(opts)
      return opts
    end
    v_23_0_0 = eval_file0
    _0_0["eval-file"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["eval-file"] = v_23_0_
  eval_file = v_23_0_
end
local display_result = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function display_result0(opts)
      return nil
    end
    v_23_0_0 = display_result0
    _0_0["display-result"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["display-result"] = v_23_0_
  display_result = v_23_0_
end
local state = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = (_0_0.state or {conns = {}})
    _0_0["state"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["state"] = v_23_0_
  state = v_23_0_
end
local display = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function display0(opts)
      local function _3_()
        hud.display(opts)
        return log.append(opts)
      end
      return lang["with-filetype"]("clojure", _3_)
    end
    v_23_0_0 = display0
    _0_0["display"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["display"] = v_23_0_
  display = v_23_0_
end
local display_conn_status = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function display_conn_status0(conn, status)
      return display({lines = {(";; " .. conn.host .. ":" .. conn.port .. " (" .. status .. ")")}})
    end
    v_23_0_0 = display_conn_status0
    _0_0["display-conn-status"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["display-conn-status"] = v_23_0_
  display_conn_status = v_23_0_
end
local remove_conn = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function remove_conn0(_3_0)
      local _4_ = _3_0
      local id = _4_["id"]
      do
        local conn = state.conns[id]
        if conn then
          if not (conn.sock):is_closing() then
            do end (conn.sock):close()
          end
          state.conns[id] = nil
          return display_conn_status(conn, "disconnected")
        end
      end
    end
    v_23_0_0 = remove_conn0
    _0_0["remove-conn"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["remove-conn"] = v_23_0_
  remove_conn = v_23_0_
end
local remove_all_conns = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function remove_all_conns0()
      return a["run!"](remove_conn, a.vals(state.conns))
    end
    v_23_0_0 = remove_all_conns0
    _0_0["remove-all-conns"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["remove-all-conns"] = v_23_0_
  remove_all_conns = v_23_0_
end
local send = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function send0(conn, msg, cb)
      local msg_id = uuid.v4()
      msg["id"] = msg_id
      conn.msgs[msg_id] = {cb = cb, msg = msg}
      return (conn.sock):write(bencode.encode(msg))
    end
    v_23_0_0 = send0
    _0_0["send"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["send"] = v_23_0_
  send = v_23_0_
end
local add_conn = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function add_conn0(_3_0)
      local _4_ = _3_0
      local host = _4_["host"]
      local port = _4_["port"]
      do
        local conn = {host = host, id = uuid.v4(), msgs = {}, port = port, sock = vim.loop.new_tcp()}
        state.conns[conn.id] = conn
        local function _5_(err)
          if err then
            display_conn_status(conn, err)
            return remove_conn(conn)
          else
            local function _6_(err0, chunk)
              if err0 then
                return display_conn_status(conn, err0)
              else
                local result = bencode.decode(chunk)
                local cb = conn.msgs[result.id].cb
                local ok_3f, err1 = pcall(cb, result)
                if not ok_3f then
                  print(("conjure.lang.clojure-nrepl error: " .. err1))
                end
                if result.status then
                  conn.msgs[result.id] = nil
                  return nil
                end
              end
            end
            do end (conn.sock):read_start(vim.schedule_wrap(_6_))
            return display_conn_status(conn, "connected")
          end
        end
        do end (conn.sock):connect(host, port, vim.schedule_wrap(_5_))
        return conn
      end
    end
    v_23_0_0 = add_conn0
    _0_0["add-conn"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["add-conn"] = v_23_0_
  add_conn = v_23_0_
end
local try_nrepl_port_file = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function try_nrepl_port_file0()
      local port = nil
      do
        local _3_0 = a.slurp(".nrepl-port")
        if _3_0 then
          port = tonumber(_3_0)
        else
          port = _3_0
        end
      end
      if port then
        return add_conn({host = "127.0.0.1", port = port})
      end
    end
    v_23_0_0 = try_nrepl_port_file0
    _0_0["try-nrepl-port-file"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["try-nrepl-port-file"] = v_23_0_
  try_nrepl_port_file = v_23_0_
end
              -- (def c (try-nrepl-port-file)) (remove-conn c) (remove-all-conns) state.conns (send c table: 0x406235e8 a.pr)
return nil
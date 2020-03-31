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
  _0_0["aniseed/local-fns"] = {require = {a = "conjure.aniseed.core", bencode = "conjure.bencode", bridge = "conjure.bridge", hud = "conjure.hud", lang = "conjure.lang", log = "conjure.log", mapping = "conjure.mapping", nvim = "conjure.aniseed.nvim", str = "conjure.aniseed.string", text = "conjure.text", uuid = "conjure.uuid", view = "conjure.aniseed.view"}}
  return {require("conjure.aniseed.core"), require("conjure.bencode"), require("conjure.bridge"), require("conjure.hud"), require("conjure.lang"), require("conjure.log"), require("conjure.mapping"), require("conjure.aniseed.nvim"), require("conjure.aniseed.string"), require("conjure.text"), require("conjure.uuid"), require("conjure.aniseed.view")}
end
local _2_ = _1_(...)
local a = _2_[1]
local bencode = _2_[2]
local bridge = _2_[3]
local hud = _2_[4]
local lang = _2_[5]
local log = _2_[6]
local mapping = _2_[7]
local nvim = _2_[8]
local str = _2_[9]
local text = _2_[10]
local uuid = _2_[11]
local view = _2_[12]
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
local default_context = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = "user"
    _0_0["default-context"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["default-context"] = v_23_0_
  default_context = v_23_0_
end
local context_pattern = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = "[(]%s*ns%s*(.-)[%s){]"
    _0_0["context-pattern"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["context-pattern"] = v_23_0_
  context_pattern = v_23_0_
end
local comment_prefix = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = "; "
    _0_0["comment-prefix"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["comment-prefix"] = v_23_0_
  comment_prefix = v_23_0_
end
local config = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = {["debug?"] = false, mappings = {["add-conn-from-port-file"] = "cf", ["remove-all-conns"] = "cR", ["remove-conn"] = "cr"}}
    _0_0["config"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["config"] = v_23_0_
  config = v_23_0_
end
local state = nil
do
  local v_23_0_ = (_0_0["aniseed/locals"].state or {["loaded?"] = false, conns = {}})
  _0_0["aniseed/locals"]["state"] = v_23_0_
  state = v_23_0_
end
local display = nil
do
  local v_23_0_ = nil
  local function display0(opts)
    local function _3_()
      hud.display(opts)
      return log.append(opts)
    end
    return lang["with-filetype"]("clojure", _3_)
  end
  v_23_0_ = display0
  _0_0["aniseed/locals"]["display"] = v_23_0_
  display = v_23_0_
end
local display_conn_status = nil
do
  local v_23_0_ = nil
  local function display_conn_status0(conn, status)
    return display({lines = {("; " .. conn.host .. ":" .. conn.port .. " (" .. status .. ")")}})
  end
  v_23_0_ = display_conn_status0
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
            do end (conn.sock):read_stop()
            do end (conn.sock):shutdown()
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
local dbg = nil
do
  local v_23_0_ = nil
  local function dbg0(desc, data)
    if config["debug?"] then
      display({lines = a.concat({("; debug " .. desc)}, text["split-lines"](view.serialise(data)))})
    end
    return data
  end
  v_23_0_ = dbg0
  _0_0["aniseed/locals"]["dbg"] = v_23_0_
  dbg = v_23_0_
end
local send = nil
do
  local v_23_0_ = nil
  local function send0(conn, msg, cb)
    local msg_id = uuid.v4()
    msg["id"] = msg_id
    dbg("->", msg)
    conn.msgs[msg_id] = {cb = cb, msg = msg}
    return (conn.sock):write(bencode.encode(msg))
  end
  v_23_0_ = send0
  _0_0["aniseed/locals"]["send"] = v_23_0_
  send = v_23_0_
end
local done_3f = nil
do
  local v_23_0_ = nil
  local function done_3f0(msg)
    return (msg and msg.status and ("done" == a.first(msg.status)))
  end
  v_23_0_ = done_3f0
  _0_0["aniseed/locals"]["done?"] = v_23_0_
  done_3f = v_23_0_
end
local with_all_msgs_fn = nil
do
  local v_23_0_ = nil
  local function with_all_msgs_fn0(cb)
    local acc = {}
    local function _3_(msg)
      table.insert(acc, msg)
      if done_3f(msg) then
        return cb(acc)
      end
    end
    return _3_
  end
  v_23_0_ = with_all_msgs_fn0
  _0_0["aniseed/locals"]["with-all-msgs-fn"] = v_23_0_
  with_all_msgs_fn = v_23_0_
end
local decode_all = nil
do
  local v_23_0_ = nil
  local function decode_all0(s)
    local progress = 1
    do
      local acc = {}
      while (progress < a.count(s)) do
        local msg, consumed = bencode.decode(s, progress)
        if a["nil?"](msg) then
          error(consumed)
        end
        table.insert(acc, msg)
        progress = consumed
      end
      return acc
    end
  end
  v_23_0_ = decode_all0
  _0_0["aniseed/locals"]["decode-all"] = v_23_0_
  decode_all = v_23_0_
end
local handle_read_fn = nil
do
  local v_23_0_ = nil
  local function handle_read_fn0(conn)
    local function _3_(err, chunk)
      if err then
        return display_conn_status(conn, err)
      elseif not chunk then
        return remove_conn(conn)
      else
        local function _4_(msg)
          dbg("<-", msg)
          do
            local cb = conn.msgs[msg.id].cb
            local ok_3f, err0 = pcall(cb, msg)
            if not ok_3f then
              a.println(("conjure.lang.clojure-nrepl error:" .. err0))
            end
            if done_3f(msg) then
              conn.msgs[msg.id] = nil
              return nil
            end
          end
        end
        return a["run!"](_4_, decode_all(chunk))
      end
    end
    return vim.schedule_wrap(_3_)
  end
  v_23_0_ = handle_read_fn0
  _0_0["aniseed/locals"]["handle-read-fn"] = v_23_0_
  handle_read_fn = v_23_0_
end
local handle_connect_fn = nil
do
  local v_23_0_ = nil
  local function handle_connect_fn0(conn)
    local function _3_(err)
      if err then
        display_conn_status(conn, err)
        return remove_conn(conn)
      else
        do end (conn.sock):read_start(handle_read_fn(conn))
        display_conn_status(conn, "connected")
        local function _4_(msgs)
          return a["assoc-in"](conn, {"sessions", "user"}, a.get(a.last(msgs), "new-session"))
        end
        return send(conn, {op = "clone"}, with_all_msgs_fn(_4_))
      end
    end
    return vim.schedule_wrap(_3_)
  end
  v_23_0_ = handle_connect_fn0
  _0_0["aniseed/locals"]["handle-connect-fn"] = v_23_0_
  handle_connect_fn = v_23_0_
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
        local conn = {host = host, id = uuid.v4(), msgs = {}, port = port, sessions = {}, sock = vim.loop.new_tcp()}
        local existing = nil
        local function _5_(conn0)
          return ((host == conn0.host) and (port == conn0.port) and conn0)
        end
        existing = a.some(_5_, a.vals(state.conns))
        if existing then
          remove_conn(existing)
        end
        state.conns[conn.id] = conn
        do end (conn.sock):connect(host, port, handle_connect_fn(conn))
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
local add_conn_from_port_file = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function add_conn_from_port_file0()
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
      else
        return display({lines = {"; No .nrepl-port file found."}})
      end
    end
    v_23_0_0 = add_conn_from_port_file0
    _0_0["add-conn-from-port-file"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["add-conn-from-port-file"] = v_23_0_
  add_conn_from_port_file = v_23_0_
end
local display_result = nil
do
  local v_23_0_ = nil
  local function display_result0(opts, resp)
    local lines = nil
    if resp.out then
      lines = text["prefixed-lines"](resp.out, "; (out) ")
    elseif resp.err then
      lines = text["prefixed-lines"](resp.err, "; (err) ")
    elseif resp.value then
      lines = text["split-lines"](resp.value)
    else
      lines = nil
    end
    if lines then
      local function _4_()
        hud.display({lines = a.concat({opts.preview}, lines)})
        return log.append({lines = lines})
      end
      return lang["with-filetype"]("clojure", _4_)
    end
  end
  v_23_0_ = display_result0
  _0_0["aniseed/locals"]["display-result"] = v_23_0_
  display_result = v_23_0_
end
local conns = nil
do
  local v_23_0_ = nil
  local function conns0(opts)
    local xs = a.vals(state.conns)
    if (a["empty?"](xs) and (not opts or not opts["silent?"])) then
      display({lines = {"; No connections."}})
    end
    return xs
  end
  v_23_0_ = conns0
  _0_0["aniseed/locals"]["conns"] = v_23_0_
  conns = v_23_0_
end
local eval_str = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_str0(opts)
      local function _3_(conn)
        local function _4_()
          local session = a["get-in"](conn, {"sessions", "user"})
          if session then
            return {session = session}
          end
        end
        local function _5_(_241)
          return display_result(opts, _241)
        end
        return send(conn, a.merge({code = opts.code, op = "eval"}, _4_()), _5_)
      end
      return a["run!"](_3_, conns())
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
      a.assoc(opts, "code", ("(load-file \"" .. opts["file-path"] .. "\")"))
      return eval_str(opts)
    end
    v_23_0_0 = eval_file0
    _0_0["eval-file"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["eval-file"] = v_23_0_
  eval_file = v_23_0_
end
local remove_conn_interactive = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function remove_conn_interactive0()
      return a.println("Not implemented yet.")
    end
    v_23_0_0 = remove_conn_interactive0
    _0_0["remove-conn-interactive"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["remove-conn-interactive"] = v_23_0_
  remove_conn_interactive = v_23_0_
end
local on_filetype = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function on_filetype0()
      mapping.buf("n", config.mappings["remove-all-conns"], "conjure.lang.clojure-nrepl", "remove-all-conns")
      mapping.buf("n", config.mappings["remove-conn"], "conjure.lang.clojure-nrepl", "remove-conn-interactive")
      return mapping.buf("n", config.mappings["add-conn-from-port-file"], "conjure.lang.clojure-nrepl", "add-conn-from-port-file")
    end
    v_23_0_0 = on_filetype0
    _0_0["on-filetype"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["on-filetype"] = v_23_0_
  on_filetype = v_23_0_
end
if not state["loaded?"] then
  state["loaded?"] = true
  return vim.schedule(nvim.ex.augroup("conjure_clojure_nrepl_cleanup"), nvim.ex.autocmd_(), nvim.ex.autocmd("VimLeavePre *", bridge["viml->lua"]("conjure.lang.clojure-nrepl", "remove-all-conns", {})), nvim.ex.augroup("END"), add_conn_from_port_file())
end
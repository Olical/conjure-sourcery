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
  _0_0["aniseed/local-fns"] = {require = {["conjure-config"] = "conjure.config", a = "conjure.aniseed.core", bencode = "conjure.bencode", bridge = "conjure.bridge", hud = "conjure.hud", lang = "conjure.lang", log = "conjure.log", mapping = "conjure.mapping", nvim = "conjure.aniseed.nvim", str = "conjure.aniseed.string", text = "conjure.text", uuid = "conjure.uuid", view = "conjure.aniseed.view"}}
  return {require("conjure.aniseed.core"), require("conjure.bencode"), require("conjure.bridge"), require("conjure.config"), require("conjure.hud"), require("conjure.lang"), require("conjure.log"), require("conjure.mapping"), require("conjure.aniseed.nvim"), require("conjure.aniseed.string"), require("conjure.text"), require("conjure.uuid"), require("conjure.aniseed.view")}
end
local _2_ = _1_(...)
local a = _2_[1]
local bencode = _2_[2]
local bridge = _2_[3]
local conjure_config = _2_[4]
local hud = _2_[5]
local lang = _2_[6]
local log = _2_[7]
local mapping = _2_[8]
local nvim = _2_[9]
local str = _2_[10]
local text = _2_[11]
local uuid = _2_[12]
local view = _2_[13]
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
    local v_23_0_0 = {["debug?"] = false, mappings = {["connect-port-file"] = "cf", ["last-exception"] = "ex", ["result-1"] = "e1", ["result-2"] = "e2", ["result-3"] = "e3", disconnect = "cd", interrupt = "ei"}}
    _0_0["config"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["config"] = v_23_0_
  config = v_23_0_
end
local state = nil
do
  local v_23_0_ = (_0_0["aniseed/locals"].state or {["loaded?"] = false, conn = nil})
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
local conn_or_warn = nil
do
  local v_23_0_ = nil
  local function conn_or_warn0(f)
    local conn = a.get(state, "conn")
    if conn then
      return f(conn)
    else
      return display({lines = {"; No connection."}})
    end
  end
  v_23_0_ = conn_or_warn0
  _0_0["aniseed/locals"]["conn-or-warn"] = v_23_0_
  conn_or_warn = v_23_0_
end
local display_conn_status = nil
do
  local v_23_0_ = nil
  local function display_conn_status0(status)
    local function _3_(conn)
      return display({lines = {("; " .. conn.host .. ":" .. conn.port .. " (" .. status .. ")")}})
    end
    return conn_or_warn(_3_)
  end
  v_23_0_ = display_conn_status0
  _0_0["aniseed/locals"]["display-conn-status"] = v_23_0_
  display_conn_status = v_23_0_
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
  local function send0(msg, cb)
    local conn = a.get(state, "conn")
    if conn then
      local msg_id = uuid.v4()
      a.assoc(msg, "id", msg_id)
      dbg("->", msg)
      a["assoc-in"](conn, {"msgs", msg_id}, {["sent-at"] = os.time(), cb = cb, msg = msg})
      do end (conn.sock):write(bencode.encode(msg))
      return nil
    end
  end
  v_23_0_ = send0
  _0_0["aniseed/locals"]["send"] = v_23_0_
  send = v_23_0_
end
local done_3f = nil
do
  local v_23_0_ = nil
  local function done_3f0(msg)
    local function _3_(_241)
      return ("done" == _241)
    end
    return (msg and msg.status and a.some(_3_, msg.status))
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
local disconnect = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function disconnect0()
      local function _3_(conn)
        if not (conn.sock):is_closing() then
          do end (conn.sock):read_stop()
          do end (conn.sock):shutdown()
          do end (conn.sock):close()
        end
        display_conn_status("disconnected")
        return a.assoc(state, "conn", nil)
      end
      return conn_or_warn(_3_)
    end
    v_23_0_0 = disconnect0
    _0_0["disconnect"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["disconnect"] = v_23_0_
  disconnect = v_23_0_
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
        local _5_
        if opts then
          _5_ = {opts.preview}
        else
        _5_ = nil
        end
        hud.display({lines = a.concat(_5_, lines)})
        return log.append({lines = lines})
      end
      return lang["with-filetype"]("clojure", _4_)
    end
  end
  v_23_0_ = display_result0
  _0_0["aniseed/locals"]["display-result"] = v_23_0_
  display_result = v_23_0_
end
local handle_read_fn = nil
do
  local v_23_0_ = nil
  local function handle_read_fn0()
    local function _3_(err, chunk)
      local conn = a.get(state, "conn")
      if err then
        return display_conn_status(err)
      elseif not chunk then
        return disconnect()
      else
        local function _4_(msg)
          dbg("<-", msg)
          do
            local cb = nil
            local function _5_(_241)
              return display_result(nil, _241)
            end
            cb = a["get-in"](conn, {"msgs", msg.id, "cb"}, _5_)
            local ok_3f, err0 = pcall(cb, msg)
            if not ok_3f then
              a.println("conjure.lang.clojure-nrepl error:", err0)
            end
            if done_3f(msg) then
              return a["assoc-in"](conn, {"msgs", msg.id}, nil)
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
  local function handle_connect_fn0()
    local function _3_(err)
      local conn = a.get(state, "conn")
      if err then
        display_conn_status(err)
        return disconnect()
      else
        do end (conn.sock):read_start(handle_read_fn())
        display_conn_status("connected")
        local function _4_(msgs)
          return a.assoc(conn, "session", a.get(a.last(msgs), "new-session"))
        end
        return send({op = "clone"}, with_all_msgs_fn(_4_))
      end
    end
    return vim.schedule_wrap(_3_)
  end
  v_23_0_ = handle_connect_fn0
  _0_0["aniseed/locals"]["handle-connect-fn"] = v_23_0_
  handle_connect_fn = v_23_0_
end
local connect = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function connect0(_3_0)
      local _4_ = _3_0
      local host = _4_["host"]
      local port = _4_["port"]
      do
        local conn = {host = host, msgs = {}, port = port, session = nil, sock = vim.loop.new_tcp()}
        if a.get(state, "conn") then
          disconnect()
        end
        a.assoc(state, "conn", conn)
        return (conn.sock):connect(host, port, handle_connect_fn())
      end
    end
    v_23_0_0 = connect0
    _0_0["connect"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["connect"] = v_23_0_
  connect = v_23_0_
end
local connect_port_file = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function connect_port_file0()
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
        return connect({host = "127.0.0.1", port = port})
      else
        return display({lines = {"; No .nrepl-port file found."}})
      end
    end
    v_23_0_0 = connect_port_file0
    _0_0["connect-port-file"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["connect-port-file"] = v_23_0_
  connect_port_file = v_23_0_
end
local eval_str = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_str0(opts)
      local function _3_(_)
        local function _4_()
          local session = a["get-in"](state, {"conn", "session"})
          if session then
            return {session = session}
          end
        end
        local function _5_(_241)
          return display_result(opts, _241)
        end
        return send(a.merge({code = opts.code, op = "eval"}, _4_()), _5_)
      end
      return conn_or_warn(_3_)
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
local interrupt = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function interrupt0()
      local function _3_(conn)
        local msgs = nil
        local function _4_(msg)
          return ("eval" == msg.msg.op)
        end
        msgs = a.filter(_4_, a.vals(conn.msgs))
        if a["empty?"](msgs) then
          return display({lines = {"; Nothing to interrupt."}})
        else
          local function _5_(a0, b)
            return (a0["sent-at"] < b["sent-at"])
          end
          table.sort(msgs, _5_)
          do
            local oldest = a.first(msgs)
            local function _6_()
              if oldest.msg.session then
                return {session = oldest.msg.session}
              end
            end
            send(a.merge({id = oldest.msg.id, op = "interrupt"}, _6_()))
            return display({lines = {("; Interrupted: " .. text["left-sample"](oldest.msg.code, conjure_config.preview["sample-limit"]))}})
          end
        end
      end
      return conn_or_warn(_3_)
    end
    v_23_0_0 = interrupt0
    _0_0["interrupt"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["interrupt"] = v_23_0_
  interrupt = v_23_0_
end
local eval_str_fn = nil
do
  local v_23_0_ = nil
  local function eval_str_fn0(code)
    local function _3_()
      return nvim.ex.ConjureEval(code)
    end
    return _3_
  end
  v_23_0_ = eval_str_fn0
  _0_0["aniseed/locals"]["eval-str-fn"] = v_23_0_
  eval_str_fn = v_23_0_
end
local last_exception = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = eval_str_fn("*e")
    _0_0["last-exception"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["last-exception"] = v_23_0_
  last_exception = v_23_0_
end
local result_1 = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = eval_str_fn("*1")
    _0_0["result-1"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["result-1"] = v_23_0_
  result_1 = v_23_0_
end
local result_2 = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = eval_str_fn("*2")
    _0_0["result-2"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["result-2"] = v_23_0_
  result_2 = v_23_0_
end
local result_3 = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = eval_str_fn("*3")
    _0_0["result-3"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["result-3"] = v_23_0_
  result_3 = v_23_0_
end
local on_filetype = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function on_filetype0()
      mapping.buf("n", config.mappings.disconnect, "conjure.lang.clojure-nrepl", "disconnect")
      mapping.buf("n", config.mappings["connect-port-file"], "conjure.lang.clojure-nrepl", "connect-port-file")
      mapping.buf("n", config.mappings.interrupt, "conjure.lang.clojure-nrepl", "interrupt")
      mapping.buf("n", config.mappings["last-exception"], "conjure.lang.clojure-nrepl", "last-exception")
      mapping.buf("n", config.mappings["result-1"], "conjure.lang.clojure-nrepl", "result-1")
      mapping.buf("n", config.mappings["result-2"], "conjure.lang.clojure-nrepl", "result-2")
      return mapping.buf("n", config.mappings["result-3"], "conjure.lang.clojure-nrepl", "result-3")
    end
    v_23_0_0 = on_filetype0
    _0_0["on-filetype"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["on-filetype"] = v_23_0_
  on_filetype = v_23_0_
end
if not state["loaded?"] then
  a.assoc(state, "loaded?", true)
  local function _3_()
    nvim.ex.augroup("conjure_clojure_nrepl_cleanup")
    nvim.ex.autocmd_()
    nvim.ex.autocmd("VimLeavePre *", bridge["viml->lua"]("conjure.lang.clojure-nrepl", "disconnect", {}))
    nvim.ex.augroup("END")
    return connect_port_file()
  end
  return vim.schedule(_3_)
end
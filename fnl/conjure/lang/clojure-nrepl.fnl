(module conjure.lang.clojure-nrepl
  {require {nvim conjure.aniseed.nvim
            a conjure.aniseed.core
            str conjure.aniseed.string
            view conjure.aniseed.view
            hud conjure.hud
            log conjure.log
            lang conjure.lang
            text conjure.text
            mapping conjure.mapping
            bencode conjure.bencode
            bridge conjure.bridge
            uuid conjure.uuid}})

;; TODO Sessions so *e / *1 work and can be cancelled.
;; TODO Some messages never get completed.
;; TODO Handle things lacking IDs.

(def buf-suffix ".cljc")
(def default-context "user")
(def context-pattern "[(]%s*ns%s*(.-)[%s){]")
(def comment-prefix "; ")

(def config
  {:debug? false
   :mappings {:remove-conn "cr"
              :remove-all-conns "cR"
              :add-conn-from-port-file "cf"}})

(defonce state
  {:conns {}})

(defn- display [opts]
  (lang.with-filetype
    :clojure
    (fn []
      (hud.display opts)
      (log.append opts))))

(defn- display-conn-status [conn status]
  (display
    {:lines [(.. ";; " conn.host ":" conn.port " (" status ")")]}))

(defn remove-conn [{: id}]
  (let [conn (. state.conns id)]
    (when conn
      (when (not (conn.sock:is_closing))
        (conn.sock:read_stop)
        (conn.sock:close))
      (tset state.conns id nil)
      (display-conn-status conn :disconnected))))

(defn remove-all-conns []
  (a.run! remove-conn (a.vals state.conns)))

(defn- dbg [desc data]
  (when config.debug?
    (display {:lines (a.concat
                       [(.. "; debug " desc)]
                       (text.split-lines (view.serialise data)))}))
  data)

(defn send [conn msg cb]
  (let [msg-id (uuid.v4)]
    (tset msg :id msg-id)
    (dbg "->" msg)
    (tset conn.msgs msg-id {:msg msg :cb cb})
    (conn.sock:write (bencode.encode msg))))

(defn- handle-read-fn [conn]
  (vim.schedule_wrap
    (fn [err chunk]
      (if
        err (display-conn-status conn err)
        (not chunk) (remove-conn conn)
        (let [result (dbg "<-" (bencode.decode chunk))
              cb (. (. conn.msgs result.id) :cb)
              (ok? err) (pcall cb result)]
          (when (not ok?)
            (a.println (.. "conjure.lang.clojure-nrepl error:" err)))
          (when (and result.status
                     (= :done (a.first result.status)))
            (tset conn.msgs result.id nil)))))))

(defn- handle-connect-fn [conn]
  (vim.schedule_wrap
    (fn [err]
      (if err
        (do
          (display-conn-status conn err)
          (remove-conn conn))

        (do
          (conn.sock:read_start (handle-read-fn conn))
          (display-conn-status conn :connected))))))

(defn add-conn [{: host : port}]
  (let [conn {:sock (vim.loop.new_tcp)
              :id (uuid.v4)
              :host host
              :port port
              :msgs {}}
        existing (a.some
                   (fn [conn]
                     (and (= host conn.host) (= port conn.port) conn))
                   (a.vals state.conns))]

    (when existing
      (remove-conn existing))

    (tset state.conns conn.id conn)
    (conn.sock:connect host port (handle-connect-fn conn))
    conn))

(defn add-conn-from-port-file []
  (let [port (-?> (a.slurp ".nrepl-port") (tonumber))]
    (when port
      (add-conn
        {:host "127.0.0.1"
         :port port}))))

(defn display-result [opts resp]
  (let [lines (if
                resp.out (text.prefixed-lines resp.out "; (out) ")
                resp.err (text.prefixed-lines resp.err "; (err) ")
                resp.value (text.split-lines resp.value)
                nil)]
    (when lines
      (hud.display {:lines (a.concat [opts.preview] lines)})
      (log.append {:lines lines}))))

(defn eval-str [opts]
  (let [conn (a.first (a.vals state.conns))]
    (when conn
      (send
        conn
        {:op :eval :code opts.code}
        #(display-result opts $1)))))

(defn eval-file [opts]
  (a.assoc opts :code (.. "(load-file \"" opts.file-path "\")"))
  (eval-str opts))

(defn remove-conn-interactive []
  (a.println "Not implemented yet."))

(defn on-filetype []
  (mapping.buf :n config.mappings.remove-all-conns
               :conjure.lang.clojure-nrepl :remove-all-conns)
  (mapping.buf :n config.mappings.remove-conn
               :conjure.lang.clojure-nrepl :remove-conn-interactive)
  (mapping.buf :n config.mappings.add-conn-from-port-file
               :conjure.lang.clojure-nrepl :add-conn-from-port-file))

(nvim.ex.augroup :conjure_clojure_nrepl_cleanup)
(nvim.ex.autocmd_)
(nvim.ex.autocmd
  "VimLeavePre *"
  (bridge.viml->lua :conjure.lang.clojure-nrepl :remove-all-conns {}))
(nvim.ex.augroup :END)

(comment
  (def c (try-nrepl-port-file))
  (remove-conn c)
  (remove-all-conns)
  state.conns

  (send c {:op :eval :code "(/ 10 2)"} a.pr))

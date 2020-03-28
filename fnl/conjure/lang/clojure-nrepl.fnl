(module conjure.lang.clojure-nrepl
  {require {nvim conjure.aniseed.nvim
            a conjure.aniseed.core
            str conjure.aniseed.string
            hud conjure.hud
            log conjure.log
            lang conjure.lang
            text conjure.text
            bencode conjure.bencode
            uuid conjure.uuid}})

;; TODO Sessions so *e / *1 work and can be cancelled.
;; TODO Some messages never get completed.
;; TODO Handle things lacking IDs.
;; TODO Cleanup conns on exit.

(def buf-suffix ".cljc")
(def default-context "user")
(def context-pattern "[(]%s*ns%s*(.-)[%s){]")
(def comment-prefix "; ")

(def config
  {})

(defonce state
  {:conns {}})

(defn display [opts]
  (lang.with-filetype
    :clojure
    (fn []
      (hud.display opts)
      (log.append opts))))

(defn display-conn-status [conn status]
  (display
    {:lines [(.. ";; " conn.host ":" conn.port " (" status ")")]}))

(defn remove-conn [{: id}]
  (let [conn (. state.conns id)]
    (when conn
      (when (not (conn.sock:is_closing))
        (conn.sock:close))
      (tset state.conns id nil)
      (display-conn-status conn :disconnected))))

(defn remove-all-conns []
  (a.run! remove-conn (a.vals state.conns)))

(defn send [conn msg cb]
  (let [msg-id (uuid.v4)]
    (tset msg :id msg-id)
    (tset conn.msgs msg-id {:msg msg :cb cb})
    (conn.sock:write (bencode.encode msg))))

(defn add-conn [{: host : port}]
  (let [conn {:sock (vim.loop.new_tcp)
              :id (uuid.v4)
              :host host
              :port port
              :msgs {}}]
    (tset state.conns conn.id conn)
    (conn.sock:connect
      host port
      (vim.schedule_wrap
        (fn [err]
          (if err
            (do
              (display-conn-status conn err)
              (remove-conn conn))

            (do
              (conn.sock:read_start
                (vim.schedule_wrap
                  (fn [err chunk]
                    (if err
                      (display-conn-status conn err)
                      (let [result (bencode.decode chunk)
                            cb (. (. conn.msgs result.id) :cb)
                            (ok? err) (pcall cb result)]
                        (when (not ok?)
                          (a.println (.. "conjure.lang.clojure-nrepl error: " err)))
                        (when result.status
                          (tset conn.msgs result.id nil)))))))
              (display-conn-status conn :connected))))))
    conn))

(defn try-nrepl-port-file []
  (let [port (-?> (a.slurp ".nrepl-port") (tonumber))]
    (when port
      (add-conn
        {:host "127.0.0.1"
         :port port}))))

(defn display-result [opts resp]
  ; (display {:lines ["; debug" (a.pr-str resp)]})

  (let [lines (if
                resp.out (text.prefixed-lines resp.out "; (out) ")
                resp.err (text.prefixed-lines resp.err "; (err) ")
                resp.value [resp.value]
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

(comment
  (def c (try-nrepl-port-file))
  (remove-conn c)
  (remove-all-conns)
  state.conns

  (send c {:op :eval :code "(/ 10 2)"} a.pr))

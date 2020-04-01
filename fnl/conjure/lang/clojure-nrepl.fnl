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
            uuid conjure.uuid
            conjure-config conjure.config}})

;; TODO Session switching.
;; TODO File / line / column metadata.
;; TODO Handle partial chunks of bencode data. (stream wrapper)
;; TODO Split up into multiple modules.
;; TODO Reusing CLJS sessions hides stdout.

(def buf-suffix ".cljc")
(def default-context "user")
(def context-pattern "[(]%s*ns%s*(.-)[%s){]")
(def comment-prefix "; ")

(def config
  {:debug? false
   :mappings {:disconnect "cd"
              :connect-port-file "cf"
              :interrupt "ei"

              :last-exception "ex"
              :result-1 "e1"
              :result-2 "e2"
              :result-3 "e3"

              :session-clone "sc"
              :session-fresh "sf"
              :session-close "sq"
              :session-close-all "sQ"
              :session-list "sl"
              :session-next "sn"
              :session-prev "sp"
              :session-select "ss"}})

(defonce- state
  {:loaded? false
   :conn nil})

(defn- display [lines]
  (lang.with-filetype
    :clojure
    (fn []
      (let [opts {:lines lines}]
        (hud.display opts)
        (log.append opts)))))

(defn- with-conn-or-warn [f]
  (let [conn (a.get state :conn)]
    (if conn
      (f conn)
      (display ["; No connection"]))))

(defn- display-conn-status [status]
  (with-conn-or-warn
    (fn [conn]
      (display [(.. "; " conn.host ":" conn.port " (" status ")")]))))

(defn- dbg [desc data]
  (when config.debug?
    (display (a.concat
               [(.. "; debug " desc)]
               (text.split-lines (view.serialise data)))))
  data)

(defn- send [msg cb]
  (let [conn (a.get state :conn)]
    (when conn
      (let [msg-id (uuid.v4)]
        (a.assoc msg :id msg-id)
        (dbg "->" msg)
        (a.assoc-in conn [:msgs msg-id]
                    {:msg msg
                     :cb (or cb (fn []))
                     :sent-at (os.time)})
        (conn.sock:write (bencode.encode msg))
        nil))))

(defn- status= [msg state]
  (and msg msg.status (a.some #(= state $1) msg.status)))

(defn- with-all-msgs-fn [cb]
  (let [acc []]
    (fn [msg]
      (table.insert acc msg)
      (when (status= msg :done)
        (cb acc)))))

(defn disconnect []
  (with-conn-or-warn
    (fn [conn]
      (when (not (conn.sock:is_closing))
        (conn.sock:read_stop)
        (conn.sock:shutdown)
        (conn.sock:close))
      (display-conn-status :disconnected)
      (a.assoc state :conn nil))))

(defn- decode-all [s]
  (var progress 1)
  (let [acc []]
    (while (< progress (a.count s))
      (let [(msg consumed) (bencode.decode s progress)]

        (when (a.nil? msg)
          (error consumed))

        (table.insert acc msg)
        (set progress consumed)))
    acc))

(defn- display-result [opts resp]
  (let [lines (if
                resp.out (text.prefixed-lines resp.out "; (out) ")
                resp.err (text.prefixed-lines resp.err "; (err) ")
                resp.value (text.split-lines resp.value)
                nil)]
    (when lines
      (lang.with-filetype
        :clojure
        (fn []
          (hud.display {:lines (a.concat
                                 (when opts
                                   [opts.preview])
                                 lines)})
          (log.append {:lines lines}))))))

(defn- clone-session [session]
  (send
    {:op :clone
     :session session}
    (with-all-msgs-fn
      (fn [msgs]
        (let [new-session (-> msgs
                              (->> (a.last))
                              (a.get :new-session))]
          (a.assoc-in state [:conn :session] new-session)
          (display [(.. "; Cloned session: "
                        (or session "(fresh)") " -> " new-session)]))))))

(defn- with-sessions [cb]
  (with-conn-or-warn
    (fn [_]
      (send
        {:op :ls-sessions}
        (fn [msg]
          (->> (a.get msg :sessions)
               (a.filter
                 (fn [session]
                   (not= msg.session session)))
               (cb)))))))

(defn- reuse-session [session]
  (a.assoc-in state [:conn :session] session)
  (display [(.. "; Reused session: " session)]))

(defn- reuse-or-create-session []
  (with-sessions
    (fn [sessions]
      (if (a.empty? sessions)
        (clone-session)
        (reuse-session (a.first sessions))))))

(defn- handle-read-fn []
  (vim.schedule_wrap
    (fn [err chunk]
      (let [conn (a.get state :conn)]
        (if
          err (display-conn-status err)
          (not chunk) (disconnect)
          (->> (decode-all chunk)
               (a.run!
                 (fn [msg]
                   (dbg "<-" msg)
                   (let [cb (a.get-in conn [:msgs msg.id :cb] #(display-result nil $1))
                         (ok? err) (pcall cb msg)]
                     (when (not ok?)
                       (display [(.. "; conjure.lang.clojure-nrepl error: " err)]))
                     (when (status= msg :unknown-session)
                       (display ["; Unknown session, correcting"])
                       (reuse-or-create-session))
                     (when (status= msg :done)
                       (a.assoc-in conn [:msgs msg.id] nil)))))))))))

(defn- handle-connect-fn []
  (vim.schedule_wrap
    (fn [err]
      (let [conn (a.get state :conn)]
        (if err
          (do
            (display-conn-status err)
            (disconnect))

          (do
            (conn.sock:read_start (handle-read-fn))
            (display-conn-status :connected)
            (reuse-or-create-session)))))))

(defn connect [{: host : port}]
  (let [conn {:sock (vim.loop.new_tcp)
              :host host
              :port port
              :msgs {}
              :session nil}]

    (when (a.get state :conn)
      (disconnect))

    (a.assoc state :conn conn)
    (conn.sock:connect host port (handle-connect-fn))))

(defn connect-port-file []
  (let [port (-?> (a.slurp ".nrepl-port") (tonumber))]
    (if port
      (connect
        {:host "127.0.0.1"
         :port port})
      (display ["; No .nrepl-port file found"]))))

(defn eval-str [opts]
  (with-conn-or-warn
    (fn [_]
      (send
        {:op :eval
         :code opts.code
         :session (a.get-in state [:conn :session])}
        #(display-result opts $1)))))

(defn eval-file [opts]
  (a.assoc opts :code (.. "(load-file \"" opts.file-path "\")"))
  (eval-str opts))

(defn interrupt []
  (with-conn-or-warn
    (fn [conn]
      (let [msgs (->> (a.vals conn.msgs)
                      (a.filter
                        (fn [msg]
                          (= :eval msg.msg.op))))]
        (if (a.empty? msgs)
          (display ["; Nothing to interrupt"])
          (do
            (table.sort
              msgs
              (fn [a b]
                (< a.sent-at b.sent-at)))
            (let [oldest (a.first msgs)]
              (send {:op :interrupt
                     :id oldest.msg.id
                     :session oldest.msg.session})
              (display
                [(.. "; Interrupted: "
                     (text.left-sample
                       oldest.msg.code
                       conjure-config.preview.sample-limit))]))))))))

(defn- eval-str-fn [code]
  (fn []
    (nvim.ex.ConjureEval code)))

(def last-exception (eval-str-fn "*e"))
(def result-1 (eval-str-fn "*1"))
(def result-2 (eval-str-fn "*2"))
(def result-3 (eval-str-fn "*3"))

(defn clone-current-session []
  (with-conn-or-warn
    (fn [conn]
      (clone-session (a.get conn :session)))))

(defn clone-fresh-session []
  (with-conn-or-warn
    (fn [conn]
      (clone-session))))

(defn- close-session [session cb]
  (send {:op :close :session session} cb))

(defn close-current-session []
  (with-conn-or-warn
    (fn [conn]
      (let [session (a.get conn :session)]
        (a.assoc conn :session nil)
        (display [(.. "; Closed current session: " session)])
        (close-session session reuse-or-create-session)))))

(defn display-sessions []
  (with-sessions
    (fn [sessions]
      (display (a.concat [(.. "; Sessions (" (a.count sessions) "):")]
                         (a.map-indexed (fn [[idx session]]
                                          (.. ";  " idx " - " session))
                                        sessions))))))

(defn close-all-sessions []
  (with-sessions
    (fn [sessions]
      (a.run! close-session sessions)
      (display [(.. "; Closed all sessions (" (a.count sessions)")")])
      (clone-session))))

(defn on-filetype []
  (mapping.buf :n config.mappings.disconnect
               :conjure.lang.clojure-nrepl :disconnect)
  (mapping.buf :n config.mappings.connect-port-file
               :conjure.lang.clojure-nrepl :connect-port-file)
  (mapping.buf :n config.mappings.interrupt
               :conjure.lang.clojure-nrepl :interrupt)

  (mapping.buf :n config.mappings.last-exception
               :conjure.lang.clojure-nrepl :last-exception)
  (mapping.buf :n config.mappings.result-1 :conjure.lang.clojure-nrepl :result-1)
  (mapping.buf :n config.mappings.result-2 :conjure.lang.clojure-nrepl :result-2)
  (mapping.buf :n config.mappings.result-3 :conjure.lang.clojure-nrepl :result-3)

  (mapping.buf :n config.mappings.session-clone
               :conjure.lang.clojure-nrepl :clone-current-session)
  (mapping.buf :n config.mappings.session-fresh
               :conjure.lang.clojure-nrepl :clone-fresh-session)
  (mapping.buf :n config.mappings.session-close
               :conjure.lang.clojure-nrepl :close-current-session)
  (mapping.buf :n config.mappings.session-close-all
               :conjure.lang.clojure-nrepl :close-all-sessions)
  (mapping.buf :n config.mappings.session-list
               :conjure.lang.clojure-nrepl :display-sessions))

(when (not state.loaded?)
  (a.assoc state :loaded? true)
  (vim.schedule
    (fn []
      (nvim.ex.augroup :conjure_clojure_nrepl_cleanup)
      (nvim.ex.autocmd_)
      (nvim.ex.autocmd
        "VimLeavePre *"
        (bridge.viml->lua :conjure.lang.clojure-nrepl :disconnect {}))
      (nvim.ex.augroup :END)

      (connect-port-file))))

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
;; TODO Mappings for *e *1 *2 *3 values
;; TODO Handle partial chunks of bencode data. (stream wrapper)

(def buf-suffix ".cljc")
(def default-context "user")
(def context-pattern "[(]%s*ns%s*(.-)[%s){]")
(def comment-prefix "; ")

(def config
  {:debug? false
   :mappings {:disconnect "cd"
              :connect-port-file "cf"
              :interrupt "ei"}})

(defonce- state
  {:loaded? false
   :conn nil})

(defn- display [opts]
  (lang.with-filetype
    :clojure
    (fn []
      (hud.display opts)
      (log.append opts))))

(defn- conn-or-warn [f]
  (let [conn (a.get state :conn)]
    (if conn
      (f conn)
      (display {:lines ["; No connection."]}))))

(defn- display-conn-status [status]
  (conn-or-warn
    (fn [conn]
      (display
        {:lines [(.. "; " conn.host ":" conn.port " (" status ")")]}))))

(defn- dbg [desc data]
  (when config.debug?
    (display {:lines (a.concat
                       [(.. "; debug " desc)]
                       (text.split-lines (view.serialise data)))}))
  data)

(defn- send [msg cb]
  (let [conn (a.get state :conn)]
    (when conn
      (let [msg-id (uuid.v4)]
        (a.assoc msg :id msg-id)
        (dbg "->" msg)
        (a.assoc-in conn [:msgs msg-id]
                    {:msg msg
                     :cb cb
                     :sent-at (os.time)})
        (conn.sock:write (bencode.encode msg))))))

(defn- done? [msg]
  (and msg msg.status (a.some #(= :done $1) msg.status)))

(defn- with-all-msgs-fn [cb]
  (let [acc []]
    (fn [msg]
      (table.insert acc msg)
      (when (done? msg)
        (cb acc)))))

(defn disconnect []
  (conn-or-warn
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
                       (a.println "conjure.lang.clojure-nrepl error:" err))
                     (when (done? msg)
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
            (send
              {:op :clone}
              (with-all-msgs-fn
                (fn [msgs]
                  (a.assoc conn :session
                           (-> msgs
                               (->> (a.last))
                               (a.get :new-session))))))))))))

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
      (display {:lines ["; No .nrepl-port file found."]}))))

(defn eval-str [opts]
  (conn-or-warn
    (fn [_]
      (send
        (a.merge
          {:op :eval
           :code opts.code}
          (let [session (a.get-in state [:conn :session])]
            (when session
              {:session session})))
        #(display-result opts $1)))))

(defn eval-file [opts]
  (a.assoc opts :code (.. "(load-file \"" opts.file-path "\")"))
  (eval-str opts))

(defn interrupt []
  (conn-or-warn
    (fn [conn]
      (let [msgs (->> (a.vals conn.msgs)
                      (a.filter
                        (fn [msg]
                          (= :eval msg.msg.op))))]
        (if (a.empty? msgs)
          (display {:lines ["; Nothing to interrupt."]})
          (do
            (table.sort
              msgs
              (fn [a b]
                (< a.sent-at b.sent-at)))
            (let [oldest (a.first msgs)]
              (send (a.merge
                      {:op :interrupt
                       :id oldest.msg.id}
                      (when oldest.msg.session
                        {:session oldest.msg.session})))
              (display
                {:lines [(.. "; Interrupted: "
                             (text.left-sample
                               oldest.msg.code
                               conjure-config.preview.sample-limit))]}))))))))

(defn on-filetype []
  (mapping.buf :n config.mappings.disconnect
               :conjure.lang.clojure-nrepl :disconnect)
  (mapping.buf :n config.mappings.connect-port-file
               :conjure.lang.clojure-nrepl :connect-port-file)
  (mapping.buf :n config.mappings.interrupt
               :conjure.lang.clojure-nrepl :interrupt))

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

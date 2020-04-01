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

;; TODO One conn to rule them all.
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
   :mappings {:remove-conn "cr"
              :remove-all-conns "cR"
              :add-conn-from-port-file "cf"
              :interrupt "ei"}})

(defonce- state
  {:loaded? false
   :conns {}})

(defn- display [opts]
  (lang.with-filetype
    :clojure
    (fn []
      (hud.display opts)
      (log.append opts))))

(defn- display-conn-status [conn status]
  (display
    {:lines [(.. "; " conn.host ":" conn.port " (" status ")")]}))

(defn- dbg [desc data]
  (when config.debug?
    (display {:lines (a.concat
                       [(.. "; debug " desc)]
                       (text.split-lines (view.serialise data)))}))
  data)

(defn- send [conn msg cb]
  (let [msg-id (uuid.v4)]
    (tset msg :id msg-id)
    (dbg "->" msg)
    (tset conn.msgs msg-id
          {:msg msg
           :cb cb
           :sent-at (os.time)})
    (conn.sock:write (bencode.encode msg))))

(defn- done? [msg]
  (and msg msg.status (a.some #(= :done $1) msg.status)))

(defn- with-all-msgs-fn [cb]
  (let [acc []]
    (fn [msg]
      (table.insert acc msg)
      (when (done? msg)
        (cb acc)))))

(defn remove-conn [{: id}]
  (let [conn (. state.conns id)]
    (when conn
      (when (not (conn.sock:is_closing))
        (conn.sock:read_stop)
        (conn.sock:shutdown)
        (conn.sock:close))
      (tset state.conns id nil)
      (display-conn-status conn :disconnected))))

(defn remove-all-conns []
  (a.run! remove-conn (a.vals state.conns)))

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

(defn- handle-read-fn [conn]
  (vim.schedule_wrap
    (fn [err chunk]
      (if
        err (display-conn-status conn err)
        (not chunk) (remove-conn conn)
        (->> (decode-all chunk)
             (a.run!
               (fn [msg]
                 (dbg "<-" msg)
                 (let [cb (a.get-in conn [:msgs msg.id :cb] #(display-result nil $1))
                       (ok? err) (pcall cb msg)]
                   (when (not ok?)
                     (a.println "conjure.lang.clojure-nrepl error:" err))
                   (when (done? msg)
                     (tset conn.msgs msg.id nil))))))))))

(defn- handle-connect-fn [conn]
  (vim.schedule_wrap
    (fn [err]
      (if err
        (do
          (display-conn-status conn err)
          (remove-conn conn))

        (do
          (conn.sock:read_start (handle-read-fn conn))
          (display-conn-status conn :connected)
          (send
            conn
            {:op :clone}
            (with-all-msgs-fn
              (fn [msgs]
                (set conn.session
                     (-> msgs
                         (->> (a.last))
                         (a.get :new-session)))))))))))

(defn add-conn [{: host : port}]
  (let [conn {:sock (vim.loop.new_tcp)
              :id (uuid.v4)
              :host host
              :port port
              :msgs {}
              :session nil}
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
    (if port
      (add-conn
        {:host "127.0.0.1"
         :port port})
      (display {:lines ["; No .nrepl-port file found."]}))))

(defn- conns [opts]
  (let [xs (a.vals state.conns)]
    (when (and (a.empty? xs) (or (not opts) (not opts.silent?)))
      (display {:lines ["; No connections."]}))
    xs))

(defn eval-str [opts]
  (a.run!
    (fn [conn]
      (send
        conn
        (a.merge
          {:op :eval
           :code opts.code}
          (when conn.session
            {:session conn.session}))
        #(display-result opts $1)))
    (conns)))

(defn eval-file [opts]
  (a.assoc opts :code (.. "(load-file \"" opts.file-path "\")"))
  (eval-str opts))

(defn remove-conn-interactive []
  (a.println "Not implemented yet."))

(defn interrupt []
  (let [msgs (a.mapcat
               (fn [conn]
                 (->> (a.vals conn.msgs)
                      (a.filter
                        (fn [msg]
                          (= :eval msg.msg.op)))
                      (a.map
                        (fn [msg]
                          (a.merge {:conn conn} msg)))))
               (conns))]
    (if (a.empty? msgs)
      (display {:lines ["; Nothing to interrupt."]})
      (do
        (table.sort
          msgs
          (fn [a b]
            (< a.sent-at b.sent-at)))
        (let [oldest (a.first msgs)]
          (send oldest.conn
                (a.merge
                  {:op :interrupt
                   :id oldest.msg.id}
                  (when oldest.msg.session
                    {:session oldest.msg.session})))
          (display
            {:lines [(.. "; Interrupted: "
                         (text.left-sample
                           oldest.msg.code
                           conjure-config.preview.sample-limit))]}))))))

(defn on-filetype []
  (mapping.buf :n config.mappings.remove-all-conns
               :conjure.lang.clojure-nrepl :remove-all-conns)
  (mapping.buf :n config.mappings.remove-conn
               :conjure.lang.clojure-nrepl :remove-conn-interactive)
  (mapping.buf :n config.mappings.add-conn-from-port-file
               :conjure.lang.clojure-nrepl :add-conn-from-port-file)
  (mapping.buf :n config.mappings.interrupt
               :conjure.lang.clojure-nrepl :interrupt))

(when (not state.loaded?)
  (set state.loaded? true)
  (vim.schedule
    (fn []
      (nvim.ex.augroup :conjure_clojure_nrepl_cleanup)
      (nvim.ex.autocmd_)
      (nvim.ex.autocmd
        "VimLeavePre *"
        (bridge.viml->lua :conjure.lang.clojure-nrepl :remove-all-conns {}))
      (nvim.ex.augroup :END)

      (add-conn-from-port-file))))

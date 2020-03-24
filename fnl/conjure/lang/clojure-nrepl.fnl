(module conjure.lang.clojure-nrepl
  {require {nvim conjure.aniseed.nvim
            core conjure.aniseed.core
            str conjure.aniseed.string
            code conjure.code
            hud conjure.hud
            log conjure.log
            lang conjure.lang
            bencode conjure.bencode
            uuid conjure.uuid}})

;; Similarities to Fennel that could do with extracting:
;;  * context extraction
;;  * preview generation
;;  * request displaying
;; Maybe automate all of this or make it more DRY anyway. Could just have a
;; comment-prefix like buf-suffix that you set to `; `.

(def buf-suffix ".cljc")

(def- default-namespace-name "user")
(def- buf-namespace-pattern "[(]%s*ns%s*(.-)[%s){]")

(def config
  {})

(defn context []
  (let [header (->> (nvim.buf_get_lines 0 0 config.buf-header-length false)
                    (str.join "\n"))]
    (or (string.match header buf-namespace-pattern)
        default-namespace-name)))

(defn- preview [{: sample-limit : opts}]
  (.. "; " opts.action " (" opts.origin "): "
      (if (or (= :file opts.origin) (= :buf opts.origin))
        (code.right-sample opts.file-path sample-limit)
        (code.left-sample opts.code sample-limit))))

(defn display-request [opts]
  (let [display-opts
        {:lines [(preview
                   {:opts opts
                    :sample-limit config.log-sample-limit})]}]
    (hud.display display-opts)
    (log.append display-opts)))

(defn eval-str [opts]
  opts)

(defn eval-file [opts]
  opts)

(defn display-result [opts]
  nil)

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
  (core.run! remove-conn (core.vals state.conns)))

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
                          (print (.. "conjure.lang.clojure-nrepl error: " err)))
                        (when result.status
                          (tset conn.msgs result.id nil)))))))
              (display-conn-status conn :connected))))))
    conn))

(defn try-nrepl-port-file []
  (let [port (-?> (core.slurp ".nrepl-port") (tonumber))]
    (when port
      (add-conn
        {:host "127.0.0.1"
         :port port}))))

;; Will need to change how evals happen.
;; Let the lang decide if it's sync or async.
;; Really Conjure passes code and context to the lang then it can decide if it displays the results.
;; This gives the lang more freedom.

;; TODO Sessions.
;; TODO Auto remove completed messages.

(comment
  (def c (try-nrepl-port-file))
  (remove-conn c)
  (remove-all-conns)
  state.conns

  (send c {:op :eval :code "(/ 10 2)"} core.pr))

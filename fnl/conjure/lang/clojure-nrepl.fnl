(module conjure.lang.clojure-nrepl
  {require {nvim conjure.aniseed.nvim
            core conjure.aniseed.core
            str conjure.aniseed.string
            code conjure.code
            hud conjure.hud
            log conjure.log
            bencode conjure.bencode}})

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

(defonce- state {})

(defn disconnect []
  (when state.sock
    (state.sock:close)
    (set state.sock nil)))

(defn connect []
  (disconnect)
  (let [port (-?> (core.slurp ".nrepl-port") (tonumber))]
    (if port
      (do
        (set state.sock (vim.loop.new_tcp))
        (state.sock:connect
          "127.0.0.1" port
          (vim.schedule_wrap
            (fn [err]
              (when err
                (log.append {:lines [";; Error! " err]}))

              (state.sock:read_start
                (vim.schedule_wrap
                  (fn [err chunk]
                    (log.append
                      {:lines [(if err
                                 (.. ";; err " err)
                                 (core.pr-str (bencode.decode chunk)))]}))))
              (log.append {:lines [";; Connected!"]})))))
      (log.append {:lines [";; No port file found."]}))))

;; Will need to change how evals happen.
;; Let the lang decide if it's sync or async.
;; Really Conjure passes code and context to the lang then it can decide if it displays the results.
;; This gives the lang more freedom.

(comment
  (connect)
  (state.sock:write (bencode.encode {:op "eval" :code "(/ 10 0)"}))
  (state.sock:write (bencode.encode {:op "eval" :code "(require 'clojure.repl) (clojure.repl/doc +)"}))
  (disconnect))

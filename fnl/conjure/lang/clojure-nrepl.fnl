(module conjure.lang.clojure-nrepl
  {require {nvim conjure.aniseed.nvim
            str conjure.aniseed.string
            code conjure.code
            hud conjure.hud
            log conjure.log}})

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

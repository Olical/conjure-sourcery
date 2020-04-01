(module conjure.eval
  {require {a conjure.aniseed.core
            nvim conjure.aniseed.nvim
            extract conjure.extract
            lang conjure.lang
            text conjure.text
            config conjure.config
            hud conjure.hud
            log conjure.log}})

(defn- preview [opts]
  (let [sample-limit config.preview.sample-limit]
    (.. (lang.get :comment-prefix)
        opts.action " (" opts.origin "): "
        (if (or (= :file opts.origin) (= :buf opts.origin))
          (text.right-sample opts.file-path sample-limit)
          (text.left-sample opts.code sample-limit)))))

(defn- display-request [opts]
  (hud.display {:lines [opts.preview]})
  (log.append {:lines [opts.preview]}))

(defn file []
  (let [opts {:file-path (extract.file-path)
              :origin :file
              :action :eval}]
    (set opts.preview (preview opts))
    (display-request opts)
    (lang.call :eval-file opts)))

(defn- eval-str [opts]
  (vim.schedule hud.clear-passive-timer)
  (set opts.action :eval)
  (set opts.context
       (or nvim.b.conjure_context
           (extract.context)))
  (set opts.file-path (extract.file-path))
  (set opts.preview (preview opts))
  (display-request opts)
  (lang.call :eval-str opts))

(defn current-form []
  (let [{: content : range} (extract.form {})]
    (eval-str
      {:code content
       :range range
       :origin :current-form})))

(defn root-form []
  (let [{: content : range} (extract.form {:root? true})]
    (eval-str
      {:code content
       :range range
       :origin :root-form})))

(defn word []
  (let [{: content : range} (extract.word)]
    (eval-str
      {:code content
       :range range
       :origin :word})))

(defn buf []
  (let [{: content : range} (extract.buf)]
    (eval-str
      {:code content
       :range range
       :origin :buf})))

(defn command [code]
  (eval-str
    {:code code
     :origin :command}))

(defn range [start end]
  (let [{: content : range} (extract.range start end)]
    (eval-str
      {:code content
       :range range
       :origin :range})))

(defn selection [kind]
  (let [{: content : range}
        (extract.selection
          {:kind (or kind (nvim.fn.visualmode))
           :visual? (not kind)})]
    (eval-str
      {:code content
       :range range
       :origin :selection})))

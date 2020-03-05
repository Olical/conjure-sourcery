(module conjure.eval
  {require {nvim conjure.aniseed.nvim
            extract conjure.extract
            lang conjure.lang
            core conjure.aniseed.core}})

(defn file []
  (let [opts {:file-path (extract.file-path)
              :origin :file
              :action :eval}]
    (lang.call :display-request opts)
    (->> (lang.call :eval-file opts)
         (lang.call :display-result))))

(defn- eval-str [opts]
  (set opts.action :eval)
  (set opts.context
       (or nvim.b.conjure_context
           (lang.call :buf-context)))
  (set opts.file-path (extract.file-path))
  (lang.call :display-request opts)
  (->> opts
       (lang.call :eval-str)
       (lang.call :display-result)))

(defn current-form []
  (let [{: content : range} (extract.form {})]
    (eval-str
      {:code content
       :range range
       :origin :current-form})))

;; TODO This is always returning nil.
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

(defn range [start end]
  (let [{: content : range} (extract.range start end)]
    (eval-str
      {:code content
       :range range
       :origin :range})))

(defn command [code]
  (eval-str
    {:code code
     :origin :command}))

(defn selection [kind]
  (let [{: content : range}
        (extract.selection
          {:kind (or kind (nvim.fn.visualmode))
           :visual? (not kind)})]
    (eval-str
      {:code content
       :range range
       :origin :selection})))

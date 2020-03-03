(module conjure.eval
  {require {extract conjure.extract
            lang conjure.lang}})

(defn- eval-str [code opts]
  (set opts.code code)
  (set opts.context (lang.call :buf-eval-context))
  (->> opts
       (lang.call :eval-str)
       (lang.call :display-result)))

(defn current-form []
  (eval-str
    (. (extract.form {}) :content)
    {}))

(defn root-form []
  (eval-str
    (. (extract.form {:root? true}) :content)
    {}))

(defn word []
  (eval-str (extract.word) {}))

(defn file []
  (->> (lang.call :eval-file {:file-path (extract.file-path)})
       (lang.call :display-result)))

(defn buf []
  (eval-str
    (extract.buf)
    {:file-path (extract.file-path)}))

(defn str [code]
  (eval-str code {}))

;; TODO Lang specific: Tests in Aniseed + config for mapping.

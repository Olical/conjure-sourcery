(module conjure.eval
  {require {nvim conjure.aniseed.nvim
            extract conjure.extract
            lang conjure.lang}})

(defn- eval-str [code opts]
  (set opts.code code)
  (set opts.action :eval)
  (set opts.context
       (or nvim.b.conjure_context
           (lang.call :buf-context)))
  (lang.call :display-request opts)
  (->> opts
       (lang.call :eval-str)
       (lang.call :display-result)))

(defn current-form []
  (eval-str
    (. (extract.form {}) :content)
    {:origin :current-form}))

(defn root-form []
  (eval-str
    (. (extract.form {:root? true}) :content)
    {:origin :root-form}))

(defn word []
  (eval-str
    (extract.word)
    {:origin :word}))

(defn file []
  (let [opts {:file-path (extract.file-path)
              :origin :file
              :action :eval}]
    (lang.call :display-request opts)
    (->> (lang.call :eval-file opts)
         (lang.call :display-result))))

(defn buf []
  (eval-str
    (extract.buf)
    {:file-path (extract.file-path)
     :origin :buf}))

(defn str [code]
  (eval-str
    code
    {:origin :user}))

;; TODO Lang specific: Tests in Aniseed + config for mapping.

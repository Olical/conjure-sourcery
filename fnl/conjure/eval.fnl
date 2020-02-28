(module conjure.eval
  {require {extract conjure.extract
            lang conjure.lang}})

(defn current-form []
  (-> (extract.form {})
      (. :content)
      (->> (lang.call :eval-str)
           (lang.call :display-result))))

(defn root-form []
  (-> (extract.form {:root? true})
      (. :content)
      (->> (lang.call :eval-str)
           (lang.call :display-result))))

(defn word []
  (->> (extract.word)
       (lang.call :eval-str)
       (lang.call :display-result)))

(defn file []
  (->> (extract.file-path)
       (lang.call :eval-file)
       (lang.call :display-result)))

(defn buf []
  (->> (extract.buf)
       (lang.call :eval-str)
       (lang.call :display-result)))

;; TODO selection
;; TODO range (maybe like selection but %ConjureEval will be good)
;; TODO given string
;; TODO motion

;; TODO Lang specific: Tests in Aniseed + config for mapping.

(module conjure.eval
  {require {extract conjure.extract
            lang conjure.lang}})

(defn current-form []
  (-> (extract.form {})
      (. :content)
      (->> (lang.call :eval))))

(defn root-form []
  (-> (extract.form {:root? true})
      (. :content)
      (->> (lang.call :eval))))

(defn word []
  (-> (extract.word)
      (. :content)
      (->> (lang.call :eval))))

;; TODO file
;; TODO buffer
;; TODO selection
;; TODO range (same as selection?)
;; TODO given string
;; TODO motion

;; TODO Lang specific: Tests in Aniseed + config for mapping.

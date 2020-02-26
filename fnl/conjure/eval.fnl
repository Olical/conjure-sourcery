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

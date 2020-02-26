(module conjure.eval
  {require {extract conjure.extract
            lang conjure.lang}})

(defn current-form []
  (-> (extract.form {})
      (. :content)
      (lang.current.eval)))

(defn root-form []
  (-> (extract.form {:root? true})
      (. :content)
      (lang.current.eval)))

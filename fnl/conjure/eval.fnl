(module conjure.eval
  {require {extract conjure.extract
            lang conjure.lang}})

(defn current-form []
  (lang.current.eval (extract.form)))

(defn root-form []
  (lang.current.eval (extract.form {:root? true})))

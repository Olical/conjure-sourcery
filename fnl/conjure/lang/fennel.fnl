(module conjure.lang.fennel
  {require {ani-eval aniseed.eval}})

(defn eval [code]
  (ani-eval.str code))

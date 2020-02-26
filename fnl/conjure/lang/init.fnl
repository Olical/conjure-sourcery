(module conjure.lang)

(defn- print-warning []
  (print "No Conjure language selected."))

(defonce current
  {:eval print-warning})

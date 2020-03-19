(module conjure.code
  {:require {core conjure.aniseed.core}})

(defn- trim [s]
  (string.gsub s "^%s*(.-)%s*$" "%1"))

(defn left-sample [s limit]
  (let [flat (-> (string.gsub s "\n" " ")
                 (string.gsub "%s+" " ")
                 (trim))]
    (if (>= limit (core.count flat))
      flat
      (.. (string.sub flat 0 (core.dec limit)) "..."))))

(defn right-sample [s limit]
  (string.reverse (left-sample (string.reverse s) limit)))

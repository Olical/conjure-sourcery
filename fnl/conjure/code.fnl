(module conjure.code
  {:require {core conjure.aniseed.core}})

(defn sample [s limit]
  (let [flat (-> (string.gsub s "\n" " ")
                 (string.gsub "%s+" " "))]
    (if (>= limit (core.count flat))
      flat
      (.. (string.sub flat 0 limit) "…"))))

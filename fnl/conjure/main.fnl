(module conjure.main
  {require {mapping conjure.mapping
            prepl conjure.prepl}})

(defn main []
  (mapping.init)
  (prepl.sync))

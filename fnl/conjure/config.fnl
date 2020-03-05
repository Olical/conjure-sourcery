(module conjure.config
  {require {core conjure.aniseed.core}})

(def langs
  {:fennel :conjure.lang.fennel-aniseed})

(def mappings
  {:prefix "<localleader>"
   :log-split "ls"
   :log-vsplit "lv"
   :eval-current-form "ee"
   :eval-root-form "er"
   :eval-word "ew"
   :eval-file "ef"
   :eval-buf "eb"
   :eval-visual "E"
   :eval-motion "E"})

(defn filetypes []
  (core.keys langs))

(defn filetype->module-name [filetype]
  (. langs filetype))

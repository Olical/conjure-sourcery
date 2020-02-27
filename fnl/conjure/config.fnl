(module conjure.config
  {require {ani conjure.aniseed.core}})

(def langs
  {:clojure :conjure.lang.clojure
   :fennel :conjure.lang.fennel})

(def mappings
  {:prefix "<localleader>"
   :log-split "ls"
   :log-vsplit "lv"
   :eval-current-form "ee"
   :eval-root-form "er"
   :eval-word "ew"})

(defn filetypes []
  (ani.keys langs))

(defn filetype->module-name [filetype]
  (. langs filetype))

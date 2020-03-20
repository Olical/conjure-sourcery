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
   :eval-motion "E"
   :close-hud "q"})

(def hud
  {:max-width 80
   :max-height 20
   :enabled? true
   :close-passive? true
   :close-passive-timeout 500})

(defn filetypes []
  (core.keys langs))

(defn filetype->module-name [filetype]
  (. langs filetype))

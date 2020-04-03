(module conjure.config
  {require {a conjure.aniseed.core}})

(def langs
  {:fennel :conjure.lang.fennel-aniseed
   :clojure :conjure.lang.clojure-nrepl})

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

(def log
  {:hud {:width 0.42
         :height 0.32
         :enabled? true}})

(def extract
  {:context-header-lines 24})

(def preview
  ;; TODO Make this percentage based.
  {:sample-limit 32})

(defn filetypes []
  (a.keys langs))

(defn filetype->module-name [filetype]
  (. langs filetype))

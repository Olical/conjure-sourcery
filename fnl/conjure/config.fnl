(module conjure.config
  {require {ani conjure.aniseed.core
            mapping conjure.mapping}})

(def core
  {:langs {:clojure :conjure.langs.clojure
           :fennel :conjure.langs.fennel}})

(defn filetypes []
  (ani.keys core.langs))

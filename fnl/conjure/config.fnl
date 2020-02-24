(module conjure.config
  {require {ani conjure.aniseed.core
            mapping conjure.mapping}})

(def core
  {:langs {:clojure :conjure.lang.clojure
           :fennel :conjure.lang.fennel}})

(defn filetypes []
  (ani.keys core.langs))

(defn filetype->module-name [filetype]
  (. core.langs filetype))

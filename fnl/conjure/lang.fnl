(module conjure.lang
  {require {nvim conjure.aniseed.nvim
            fennel conjure.aniseed.fennel
            config conjure.config}})

(defn- safe-require [name]
  (let [(ok? result) (xpcall
                       (fn []
                         (require name))
                       fennel.traceback)]
    (if ok?
      result
      (nvim.err_writeln result))))

(defonce- overrides {})

(defn with-filetype [ft f]
  (set overrides.filetype ft)
  (let [result (f)]
    (set overrides.filetype nil)
    result))

(defn current []
  (let [ft (or overrides.filetype nvim.bo.filetype)
        mod-name (config.filetype->module-name ft)]
    (if mod-name
      (safe-require mod-name)
      (nvim.err_writeln (.. "No Conjure language for filetype: " ft)))))

(defn get [k]
  (-?> (current)
       (. k)))

(defn call [fn-name ...]
  (let [f (get fn-name)]
    (when f
      (f ...))))

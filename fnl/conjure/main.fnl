(module conjure.main
  {require {mapping conjure.mapping
            config conjure.config}})

(defn main []
  (mapping.setup-plug-mappings)
  (mapping.setup-filetypes (config.filetypes)))

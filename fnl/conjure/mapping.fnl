(module conjure.mapping
  {require {nvim conjure.aniseed.nvim
            str conjure.aniseed.string
            config conjure.config}})

(defn- viml->lua [m f]
  (.. "lua require('" m "')['" f "']()"))

(defn- plug [name]
  (.. "<Plug>(" name ")"))

(defn- map-plug [name m f]
  (nvim.set_keymap
    :n (plug name)
    (.. ":" (viml->lua m f) "<cr>")
    {:noremap true
     :silent true}))

(defn- map-local->plug [keys name]
  (nvim.buf_set_keymap
    0 :n (.. config.mappings.prefix keys)
    (plug name)
    {:silent true}))

(defn on-filetype []
  (map-local->plug
    config.mappings.log-split :conjure_log_split)
  (map-local->plug
    config.mappings.log-vsplit :conjure_log_vsplit)
  (map-local->plug
    config.mappings.eval-current-form :conjure_eval_current_form)
  (map-local->plug
   config.mappings.eval-root-form :conjure_eval_root_form)
  (map-local->plug
   config.mappings.eval-word :conjure_eval_word)
  (map-local->plug
   config.mappings.eval-file :conjure_eval_file)
  (map-local->plug
   config.mappings.eval-buf :conjure_eval_buf))

(defn setup-filetypes [filetypes]
  (nvim.ex.augroup :conjure_init_filetypes)
  (nvim.ex.autocmd_)
  (nvim.ex.autocmd
    :FileType (str.join "," filetypes)
    (viml->lua :conjure.mapping :on-filetype))
  (nvim.ex.augroup :END))

(defn setup-plug-mappings [filetypes]
  (map-plug :conjure_log_split :conjure.log :split)
  (map-plug :conjure_log_vsplit :conjure.log :vsplit)
  (map-plug :conjure_eval_current_form :conjure.eval :current-form)
  (map-plug :conjure_eval_root_form :conjure.eval :root-form)
  (map-plug :conjure_eval_word :conjure.eval :word)
  (map-plug :conjure_eval_file :conjure.eval :file)
  (map-plug :conjure_eval_buf :conjure.eval :buf))

(module conjure.mapping
  {require {nvim conjure.aniseed.nvim
            str conjure.aniseed.string}})

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
    0 :n (.. :<localleader> keys)
    (plug name)
    {:silent true}))

(defn on-filetype []
  (map-local->plug :ls :conjure_log_split)
  (map-local->plug :lv :conjure_log_vsplit)
  (map-local->plug :ee :conjure_eval_current_form)
  (map-local->plug :er :conjure_eval_root_form))

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
  (map-plug :conjure_eval_root_form :conjure.eval :root-form))

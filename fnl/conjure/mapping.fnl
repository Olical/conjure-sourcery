(module conjure.mapping
  {require {nvim conjure.aniseed.nvim
            core conjure.aniseed.core
            str conjure.aniseed.string
            config conjure.config
            extract conjure.extract
            eval conjure.eval}})

(defn- viml->lua [m f opts]
  (.. "lua require('" m "')['" f "'](" (or opts.args "") ")"))

(defn- plug [name]
  (.. "<Plug>(" name ")"))

(defn- map-plug [name m f]
  (nvim.set_keymap
    :n (plug name)
    (.. ":" (viml->lua m f {}) "<cr>")
    {:noremap true
     :silent true}))

(defn- map-local->plug [mode keys name]
  (nvim.buf_set_keymap
    0 mode (.. config.mappings.prefix keys)
    (plug name)
    {:silent true}))

(defn on-filetype []
  (map-local->plug
    :n config.mappings.log-split :conjure_log_split)
  (map-local->plug
    :n config.mappings.log-vsplit :conjure_log_vsplit)
  (map-local->plug
    :n config.mappings.eval-current-form :conjure_eval_current_form)
  (map-local->plug
    :n config.mappings.eval-root-form :conjure_eval_root_form)
  (map-local->plug
    :n config.mappings.eval-word :conjure_eval_word)
  (map-local->plug
    :n config.mappings.eval-file :conjure_eval_file)
  (map-local->plug
    :n config.mappings.eval-buf :conjure_eval_buf)
  (map-local->plug
    :n config.mappings.eval-motion :conjure_eval_motion)
  (map-local->plug
    :v config.mappings.eval-visual :conjure_eval_visual))

(defn setup-filetypes [filetypes]
  (nvim.ex.augroup :conjure_init_filetypes)
  (nvim.ex.autocmd_)
  (nvim.ex.autocmd
    :FileType (str.join "," filetypes)
    (viml->lua :conjure.mapping :on-filetype {}))
  (nvim.ex.augroup :END))

(defn eval-ranged-command [start end code]
  (if (= "" code)
    (eval.str (extract.range (core.dec start) end))
    (eval.str code)))

(defn eval-motion [kind]
  (core.pr kind))

(defn setup-plug-mappings [filetypes]
  (map-plug :conjure_log_split :conjure.log :split)
  (map-plug :conjure_log_vsplit :conjure.log :vsplit)
  (map-plug :conjure_eval_current_form :conjure.eval :current-form)
  (map-plug :conjure_eval_root_form :conjure.eval :root-form)
  (map-plug :conjure_eval_word :conjure.eval :word)
  (map-plug :conjure_eval_file :conjure.eval :file)
  (map-plug :conjure_eval_buf :conjure.eval :buf)

  ;; TODO Handle block and inline, not just whole lines.
  ;; I think I need a range / command + a visual mapping that uses selection.
  ;; That way the motion one can lean on the selection function while keeping ConjureEval simple.

  (nvim.set_keymap
    :v (plug :conjure_eval_visual)
    ":ConjureEval<cr>"
    {:noremap true
     :silent true})

  (nvim.ex.function_
    (->> ["ConjureEvalMotion(kind)"
          "call luaeval(\"require('conjure.mapping')['eval-motion'](_A)\", a:kind)"
          "endfunction"]
         (str.join "\n")))

  (nvim.set_keymap
    :n (plug :conjure_eval_motion)
    ":set opfunc=ConjureEvalMotion<cr>g@"
    {:noremap true
     :silent true})


  ;; TODO Add completion via -complete=custom,{func}
  ;; Requires completion implemented in Aniseed?
  (nvim.ex.command_ "-nargs=? -range ConjureEval"
                    (viml->lua :conjure.mapping :eval-ranged-command
                               {:args "<line1>, <line2>, <q-args>"})))

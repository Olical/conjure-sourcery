(local nvim (require :conjure.aniseed.nvim))
(local nu (require :conjure.aniseed.nvim.util))

(fn ft-map [ft mode from to]
  (nvim.ex.autocmd
    :FileType ft
    (.. mode :map) :<buffer>
    (.. :<localleader> from)
    (.. "<Plug>(" to ")")))

(fn init []
  (nvim.set_keymap
    :n "<Plug>(conjure_log_split)"
    ":lua require('conjure.log').split()<cr>"
    {:noremap true
     :silent true})

  (nvim.set_keymap
    :n "<Plug>(conjure_log_vsplit)"
    ":lua require('conjure.log').vsplit()<cr>"
    {:noremap true
     :silent true})

  (nvim.set_keymap
    :n "<Plug>(conjure_prepl_sync)"
    ":lua require('conjure.prepl').sync()<cr>"
    {:noremap true
     :silent true})

  (nvim.set_keymap
    :n "<Plug>(conjure_eval_current_form)"
    ":lua require('conjure.eval')['current-form']()<cr>"
    {:noremap true
     :silent true})

  (nvim.set_keymap
    :n "<Plug>(conjure_eval_root_form)"
    ":lua require('conjure.eval')['root-form']()<cr>"
    {:noremap true
     :silent true})

  ;; TODO Optional and configurable.
  ;; TODO Clojure specific mappings but make eval generic.
  ;; Need a module that handles dispatching code to the right places.
  (nvim.ex.augroup :conjure)
  (nvim.ex.autocmd_)
  (ft-map :clojure :n :ls :conjure_log_split)
  (ft-map :clojure :n :lv :conjure_log_vsplit)
  (ft-map :clojure :n :ps :conjure_prepl_sync)
  (ft-map :clojure :n :ee :conjure_eval_current_form)
  (ft-map :clojure :n :er :conjure_eval_root_form)
  (nvim.ex.augroup :END))

{:aniseed/module :conjure.mapping
 :init init}

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

  ;; TODO Optional and configurable.
  (nvim.ex.augroup :conjure)
  (nvim.ex.autocmd_)
  (ft-map :clojure :n :ls :conjure_log_split)
  (ft-map :clojure :n :lv :conjure_log_vsplit)
  (nvim.ex.augroup :END))

{:aniseed/module :conjure.mapping
 :init init}

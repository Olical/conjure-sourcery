(local nvim (require :conjure.aniseed.nvim))
(local extract (require :conjure.extract))

(fn with-buf [lines cursor f]
  (nvim.ex.edit (.. (nvim.fn.tempname) "-test.clj"))
  (nvim.buf_set_lines 0 0 -1 false lines)
  (nvim.win_set_cursor 0 cursor)
  (f)
  (nvim.ex.bdelete_))

{:aniseed/module :conjure.extract-test
 :aniseed/tests
 {:current-form
  (fn [t]
    (with-buf
      ["(ns foo)"
       ""
       "(+ 10 20 (* 10 2))"]
      [3 10]
      (fn []
        (t.pr= {:range {:start [3 10]
                        :end [3 17]}
                :content "(* 10 2)"}
               (extract.current-form)))))}}

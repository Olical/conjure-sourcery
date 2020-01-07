(local nvim (require :conjure.aniseed.nvim))
(local extract (require :conjure.extract))

(fn with-buf [lines f]
  (let [at (fn [cursor]
             (nvim.win_set_cursor 0 cursor))]
    (nvim.ex.split (.. (nvim.fn.tempname) "_test.clj"))
    (nvim.buf_set_lines 0 0 -1 false lines)
    (f at)
    (nvim.ex.bdelete_)))

{:aniseed/module :conjure.extract-test
 :aniseed/tests
 {:current-form
  (fn [t]
    (with-buf
      ["(ns foo)"
       ""
       "(+ 10 20 (* 10 2))"]
      (fn [at]
        (at [3 10])
        (t.pr= {:range {:start [3 10]
                        :end [3 17]}
                :content "(* 10 2)"}
               (extract.current-form))

        (at [3 9])
        (t.pr= {:range {:start [3 10]
                        :end [3 17]}
                :content "(* 10 2)"}
               (extract.current-form))

        (at [3 16])
        (t.pr= {:range {:start [3 10]
                        :end [3 17]}
                :content "(* 10 2)"}
               (extract.current-form))

        (at [3 9])
        (t.pr= {:range {:start [3 1]
                        :end [3 18]}
                :content "(+ 10 20 (* 10 2))"}
               (extract.current-form))
        
        (at [3 17])
        (t.pr= {:range {:start [3 1]
                        :end [3 18]}
                :content "(+ 10 20 (* 10 2))"}
               (extract.current-form)))))}}

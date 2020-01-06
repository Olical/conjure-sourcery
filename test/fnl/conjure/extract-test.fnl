(local nvim (require :conjure.aniseed.nvim))
(local extract (require :conjure.extract))

{:aniseed/module :conjure.extract-test
 :aniseed/tests
 {:current-form
  (fn [t]
    (nvim.ex.edit "test/example.clj")
    (nvim.win_set_cursor 0 [6 1])
    (t.pr= {:range {:start [6 1]
                    :end [6 21]}
            :content "(comment (add 10 20))"}
           (extract.current-form)))}}

(local nvim (require :conjure.aniseed.nvim))

(fn with-buf [lines f]
  (let [at (fn [cursor]
             (nvim.win_set_cursor 0 cursor))]
    (nvim.ex.split (.. (nvim.fn.tempname) "_test.clj"))
    (nvim.buf_set_lines 0 0 -1 false lines)
    (f at)
    (nvim.ex.bdelete_)))

{:aniseed/module :conjure.test-utils
 :with-buf with-buf}

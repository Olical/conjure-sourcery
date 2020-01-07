(local ani (require :conjure.aniseed.core))
(local nvim (require :conjure.aniseed.nvim))

(local log-buf-name (.. (nvim.fn.tempname) "_conjure.cljc"))

(fn upsert-buf []
  (let [buf (nvim.fn.bufnr log-buf-name)]
    (if (= -1 buf)
      (let [buf (nvim.fn.bufadd log-buf-name)]
        (nvim.buf_set_lines buf 0 1 false [";; Welcome to Conjure!"])
        (nvim.buf_set_option buf :buftype :nofile)
        (nvim.buf_set_option buf :bufhidden :hide)
        (nvim.buf_set_option buf :swapfile false)
        (nvim.buf_set_option buf :buflisted false)
        buf)
      buf)))

;; TODO Implement trimming using a marker so as not to cut forms in half.
(fn append [lines]
  (let [buf (upsert-buf)
        old-lines (nvim.buf_line_count buf)]
    (nvim.buf_set_lines
      buf
      -1 -1 false lines)

    (let [new-lines (nvim.buf_line_count buf)]
      (ani.run!
        (fn [win]
          (let [[row col] (nvim.win_get_cursor win)]
            (when (and (= buf (nvim.win_get_buf win))
                       (= col 0)
                       (= old-lines row))
              (nvim.win_set_cursor win [new-lines 0]))))
        (nvim.list_wins)))))

(fn create-win [split-fn]
  (let [buf (upsert-buf)]
    (nvim.win_set_cursor
      (split-fn log-buf-name)
      [(nvim.buf_line_count buf) 0])))

(fn split []
  (create-win nvim.ex.split))

(fn vsplit []
  (create-win nvim.ex.vsplit))

{:aniseed/module :conjure.log
 :append append
 :split split
 :vsplit vsplit}
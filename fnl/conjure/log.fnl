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

(fn append [lines]
  (nvim.buf_set_lines
    (upsert-buf)
    -1 -1 false lines))

(fn create-win [split-fn]
  (upsert-buf)
  (split-fn log-buf-name)
  (nvim.ex.normal_ "G"))

(fn split []
  (create-win nvim.ex.split))

(fn vsplit []
  (create-win nvim.ex.vsplit))

{:aniseed/module :conjure.log
 :append append
 :split split
 :vsplit vsplit}

(module conjure.buffer
  {require {nvim conjure.aniseed.nvim}})

(defn unlist [buf]
  "The buflisted attribute is reset when a new window is opened. Since the
  buffer upsert is decoupled from the window we have to run this whenever we
  split the buffer into some new window."
  (nvim.buf_set_option buf :buflisted false))

(defn upsert-hidden [buf-name]
  (let [buf (nvim.fn.bufnr buf-name)]
    (if (= -1 buf)
      (let [buf (nvim.fn.bufadd buf-name)]
        (nvim.buf_set_option buf :buftype :nofile)
        (nvim.buf_set_option buf :bufhidden :hide)
        (nvim.buf_set_option buf :swapfile false)
        (unlist buf)
        buf)
      buf)))



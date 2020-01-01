(local ani (require :conjure.aniseed.core))
(local nvim (require :conjure.aniseed.nvim))

(local log-buf-name "conjure.cljc")

(fn upsert-log-buf []
  (let [buf (nvim.fn.bufnr log-buf-name)]
    (if (= -1 buf)
      (nvim.fn.bufadd log-buf-name)
      buf)))

(fn upsert-log-win [buf]
  (when (not (ani.some #(= buf $1) (nvim.fn.tabpagebuflist)))
    (nvim.ex.split log-buf-name)
    (nvim.ex.setlocal "winfixwidth")
    (nvim.ex.setlocal "winfixheight")
    (nvim.ex.setlocal "buftype=nofile")
    (nvim.ex.setlocal "bufhidden=hide")
    (nvim.ex.setlocal "nowrap")
    (nvim.ex.setlocal "noswapfile")
    (nvim.ex.setlocal "nobuflisted")
    (nvim.ex.setlocal "nospell")
    (nvim.ex.setlocal "foldmethod=marker")
    (nvim.ex.setlocal "foldlevel=0")
    (nvim.ex.setlocal "foldmarker={{{,}}}")
    (nvim.ex.normal_ "G")
    (nvim.ex.wincmd "p"))

  (ani.some #(and (= buf (nvim.fn.winbufnr $1)) $1) (nvim.list_wins)))

(fn log-append [lines]
  (let [buf (upsert-log-buf)
        win (upsert-log-win buf)]
    (nvim.buf_set_lines buf -1 -1 true lines)
    (comment (let [lines (nvim.buf_line_count buf)]
               (when (> lines 0)
                 (nvim.win_set_cursor win [lines 0]))))))

{:aniseed/module :conjure.ui
 :log-append log-append}

(module conjure.log
  {require {core conjure.aniseed.core
            nvim conjure.aniseed.nvim
            lang conjure.lang}})

(defn- unlist [buf]
  (nvim.buf_set_option buf :buflisted false))

(defn- upsert-buf []
  (let [buf (nvim.fn.bufnr (lang.get :log-buf-name))]
    (if (= -1 buf)
      (let [buf (nvim.fn.bufadd (lang.get :log-buf-name))]
        (nvim.buf_set_option buf :buftype :nofile)
        (nvim.buf_set_option buf :bufhidden :hide)
        (nvim.buf_set_option buf :swapfile false)
        (unlist buf)
        buf)
      buf)))

;; TODO Implement trimming using a marker so as not to cut forms in half.
;; TODO Log tools to display eval input and output.
;; TODO Floating window log output display.

(defn append [lines]
  (let [buf (upsert-buf)
        old-lines (nvim.buf_line_count buf)]

    (nvim.buf_set_lines
      buf
      (if (and (<= old-lines 1)
               (= 0 (core.count (core.first (nvim.buf_get_lines buf 0 -1 false)))))
        0
        -1)
      -1 false lines)

    (let [new-lines (nvim.buf_line_count buf)]
      (core.run!
        (fn [win]
          (let [[row col] (nvim.win_get_cursor win)]
            (when (and (= buf (nvim.win_get_buf win))
                       (= col 0)
                       (= old-lines row))
              (nvim.win_set_cursor win [new-lines 0]))))
        (nvim.list_wins)))))

(defn- create-win [split-fn]
  (let [buf (upsert-buf)]
    (nvim.win_set_cursor
      (split-fn (lang.get :log-buf-name))
      [(nvim.buf_line_count buf) 0])
    (unlist buf)))

(defn split []
  (create-win nvim.ex.split))

(defn vsplit []
  (create-win nvim.ex.vsplit))

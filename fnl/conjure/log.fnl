(module conjure.log
  {require {core conjure.aniseed.core
            nvim conjure.aniseed.nvim
            lang conjure.lang}})

(defn- unlist [buf]
  "The buflisted attribute is reset when a new window is opened. Since the
  buffer upsert is decoupled from the window we have to run this whenever we
  split the buffer into some new window."
  (nvim.buf_set_option buf :buflisted false))

(defn- log-buf-name []
  (.. "conjure-" (lang.get :filetype) "-" (nvim.fn.getpid) ".log"))

(defn- upsert-buf []
  (let [buf-name (log-buf-name)
        buf (nvim.fn.bufnr buf-name)]
    (if (= -1 buf)
      (let [buf (nvim.fn.bufadd buf-name)]
        (nvim.buf_set_option buf :buftype :nofile)
        (nvim.buf_set_option buf :bufhidden :hide)
        (nvim.buf_set_option buf :swapfile false)
        (nvim.buf_set_option buf :filetype (lang.get :filetype))
        (unlist buf)
        buf)
      buf)))

;; TODO Implement trimming using a marker so as not to cut forms in half.
;; TODO Floating window log output display.

(defn- buf-empty? [buf]
  (and (<= (nvim.buf_line_count buf) 1)
       (= 0 (core.count (core.first (nvim.buf_get_lines buf 0 -1 false))))))

(defn append [lines]
  (let [buf (upsert-buf)
        old-lines (nvim.buf_line_count buf)]

    (nvim.buf_set_lines
      buf
      (if (buf-empty? buf) 0 -1)
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
  (let [buf (upsert-buf)
        win (split-fn (log-buf-name))]
    (nvim.win_set_cursor
      win
      [(nvim.buf_line_count buf) 0])
    (nvim.win_set_option win :wrap false)
    (unlist buf)))

(defn split []
  (create-win nvim.ex.split))

(defn vsplit []
  (create-win nvim.ex.vsplit))

(module conjure.hud
  {require {nvim conjure.aniseed.nvim
            core conjure.aniseed.core
            buffer conjure.buffer
            lang conjure.lang}})

;; Much like conjure.log this can be used to display messages, although only one at a time.
;; It maintains a floating window, maybe viewing a bit of the log?
;; Hidden after cursor move (etc) + time or <esc>.
;; I think if you don't interact it stays there, just in case you looked away from your screen.

(defn- hud-buf-name []
  (.. "conjure-hud-" (nvim.fn.getpid) (lang.get :buf-suffix)))

(defonce- open-win nil)

(defn close []
  (when open-win
    (nvim.win_close open-win true)
    (set open-win nil)))

(defn display [{: lines}]
  (close)
  (let [buf (buffer.upsert-hidden (hud-buf-name))
        max-line-length (math.max (unpack (core.map core.count lines)))
        line-count (core.count lines)
        opts {;; Ensure it always sticks to the top right.
              :relative :editor
              :row 0
              :col 424242
              :anchor :NE

              :width (math.min 80 max-line-length)
              :height (math.min 10 line-count)
              :focusable false
              :style :minimal}]
    (nvim.buf_set_lines buf 0 -1 false lines)
    (set open-win (nvim.open_win buf false opts))
    (nvim.win_set_option open-win :wrap false)))

(comment
  (display
    {:lines ["foooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo000000000000000000000000000" "bar"
             "(+ 1 2 3)"
             "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"]})
  (display {:lines [";; This is small."]})
  (close))

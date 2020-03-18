(module conjure.hud
  {require {nvim conjure.aniseed.nvim
            core conjure.aniseed.core
            buffer conjure.buffer
            lang conjure.lang
            config conjure.config}})

;; Much like conjure.log this can be used to display messages, although only one at a time.
;; It maintains a floating window, maybe viewing a bit of the log?
;; Hidden after cursor move (etc) + time or <esc>.
;; I think if you don't interact it stays there, just in case you looked away from your screen.

(defn- hud-buf-name []
  (.. "conjure-hud-" (nvim.fn.getpid) (lang.get :buf-suffix)))

(defonce- open-win {:id nil})

(defn close []
  (when open-win.id
    (nvim.win_close open-win.id true)
    (set open-win.id nil)))

;; TODO Consider centering at top or bottom / moving if it obscures the cursor.
;; Keeping it simple and in the top right for now.
(defn display [{: lines}]
  (close)
  (let [buf (buffer.upsert-hidden (hud-buf-name))
        max-line-length (math.max (unpack (core.map core.count lines)))
        line-count (core.count lines)
        opts {;; Ensure it always sticks to the top right.
              :relative :editor
              :row 0
              :col 424242
              :anchor :NW

              :width (math.min config.hud.max-width max-line-length)
              :height (math.min config.hud.max-height line-count)
              :focusable false
              :style :minimal}]
    (nvim.buf_set_lines buf 0 -1 false lines)
    (set open-win.id (nvim.open_win buf false opts))
    (nvim.win_set_option open-win.id :wrap false)))

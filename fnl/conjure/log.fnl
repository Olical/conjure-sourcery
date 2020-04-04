(module conjure.log
  {require {a conjure.aniseed.core
            nvim conjure.aniseed.nvim
            buffer conjure.buffer
            lang conjure.lang
            config conjure.config
            editor conjure.editor}})

;; TODO Don't display HUD if we can see the bottom of a log.
;; TODO Use markers to scroll to the last entry.
;; TODO Implement trimming using a marker so as not to cut forms in half.

(defonce- state
  {:hud {:id nil}})

(defn- log-buf-name []
  (.. "conjure-log-" (nvim.fn.getpid) (lang.get :buf-suffix)))

(defn- upsert-buf []
  (buffer.upsert-hidden (log-buf-name)))

(defn close-hud []
  (when state.hud.id
    (pcall (fn [] (nvim.win_close state.hud.id true)))
    (set state.hud.id nil)))

(defn- display-hud []
  (when (and config.log.hud.enabled? (not state.hud.id))
    (let [buf (upsert-buf)
          opts {;; Ensure it always sticks to the top right.
                :relative :editor
                :row 0
                :col 424242
                :anchor :NW

                :width (editor.percent-width config.log.hud.width)
                :height (editor.percent-height config.log.hud.height)
                :focusable false
                :style :minimal}]
      (set state.hud.id (nvim.open_win buf false opts))
      (nvim.win_set_option state.hud.id :wrap false)
      (nvim.win_set_cursor state.hud.id [(nvim.buf_line_count buf) 0]))))

(defn append [lines]
  (when (not (a.empty? lines))
    (let [buf (upsert-buf)
          old-lines (nvim.buf_line_count buf)]

      (nvim.buf_set_lines
        buf
        (if (buffer.empty? buf) 0 -1)
        -1 false lines)

      (let [new-lines (nvim.buf_line_count buf)]
        (a.run!
          (fn [win]
            (let [[row col] (nvim.win_get_cursor win)]
              (when (and (= buf (nvim.win_get_buf win))
                         (= old-lines row))
                (nvim.win_set_cursor win [new-lines 0]))))
          (nvim.list_wins))))

    (display-hud)))

(defn- create-win [split-fn]
  (let [buf (upsert-buf)
        win (split-fn (log-buf-name))]
    (nvim.win_set_cursor
      win
      [(nvim.buf_line_count buf) 0])
    (nvim.win_set_option win :wrap false)
    (buffer.unlist buf)))

(defn split []
  (create-win nvim.ex.split))

(defn vsplit []
  (create-win nvim.ex.vsplit))

(defn tab []
  (create-win nvim.ex.tabnew))

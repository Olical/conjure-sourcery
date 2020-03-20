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

(defonce- state
  {:id nil
   :timer nil})

(defn clear-passive-timer []
  (when state.timer
    (state.timer:close)
    (set state.timer nil)))

(defn close []
  (clear-passive-timer)
  (when state.id
    (pcall (fn [] (nvim.win_close state.id true)))
    (set state.id nil)))

(defn close-passive []
  (when (and (not state.timer)
             config.hud.close-passive?
             state.id)
    (set state.timer (vim.loop.new_timer))
    (state.timer:start
      config.hud.close-passive-timeout 0
      (vim.schedule_wrap close))))

(defn display [{: lines}]
  (when config.hud.enabled?
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
      (set state.id (nvim.open_win buf false opts))
      (nvim.win_set_option state.id :wrap false))))

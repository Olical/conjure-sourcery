(module conjure.editor
  {require {a conjure.aniseed.core
            nvim conjure.aniseed.nvim}})

(defn- percent-fn [total-fn]
  (fn [pc]
    (math.floor (* (/ (total-fn) 100) (* pc 100)))))

(defn width []
  nvim.o.columns)

(defn height []
  nvim.o.lines)

(def percent-width (percent-fn width))
(def percent-height (percent-fn height))

(defn cursor-left []
  (nvim.fn.screencol))

(defn cursor-top []
  (nvim.fn.screenrow))

(defn go-to [path line column]
  (nvim.ex.edit path)
  (nvim.win_set_cursor 0 [line (a.dec column)]))

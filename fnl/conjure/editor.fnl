(module conjure.editor
  {require {a conjure.aniseed.core
            nvim conjure.aniseed.nvim}})

(defn- percent-fn [total-fn]
  (fn [pc]
    (math.floor (* (/ (total-fn) 100) (* pc 100)))))

(def percent-width (percent-fn (fn [] nvim.o.columns)))
(def percent-height (percent-fn (fn [] nvim.o.lines)))

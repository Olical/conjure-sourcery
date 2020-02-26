(module conjure.lang.fennel
  {require {nvim conjure.aniseed.nvim
            ani conjure.aniseed.core
            str conjure.aniseed.string
            ani-eval aniseed.eval
            log conjure.log}})

(def log-buf-name (.. "conjure-" (nvim.fn.getpid) ".fnl"))
(def welcome-message [";; Welcome to Conjure, let's write some Fennel!"])

;; TODO Split safe module loading into something reusable.
;; TODO Use safe load to try and load Aniseed. Use built in if not there.

(defn- display-eval-result [ok? result]
  ;; TODO Split result into lines.
  (let [result-str (if ok?
                     (ani.pr-str result)
                     result)
        result-lines (str.split result-str "[^\n]+")]
    (log.append
      (if ok?
        result-lines
        (ani.map #(.. "; " $1) result-lines)))
    (nvim.out_write
      (.. result-str
          "\n"))))

(def- buffer-header-length 20)
(def- default-module-name "aniseed.user")
(def- buffer-module-pattern "[(]%s*module%s*(.-)[%s){]")
(defn- buffer-module-name []
  (let [header (->> (nvim.buf_get_lines 0 0 buffer-header-length false)
                    (str.join "\n"))]
    (or (string.match header buffer-module-pattern)
        default-module-name)))

(defn eval [code]
  (-> (.. "(module " (buffer-module-name) ")" code)
      (ani-eval.str)
      (display-eval-result)))

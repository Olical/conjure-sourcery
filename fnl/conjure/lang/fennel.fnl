(module conjure.lang.fennel
  {require {nvim conjure.aniseed.nvim
            core conjure.aniseed.core
            str conjure.aniseed.string
            ani-eval aniseed.eval
            log conjure.log}})

(def log-buf-name (.. "conjure-aniseed-" (nvim.fn.getpid) ".fnl"))
(def greeting-lines
  [";; Welcome to Conjure, let's write some Fennel!"])

(def- buf-header-length 20)
(def- default-module-name "aniseed.user")
(def- buf-module-pattern "[(]%s*module%s*(.-)[%s){]")

(defn buf-context []
  (let [header (->> (nvim.buf_get_lines 0 0 buf-header-length false)
                    (str.join "\n"))]
    (or (string.match header buf-module-pattern)
        default-module-name)))

(defn eval-str [opts]
  (let [code (.. (if opts.context
                   (.. "(module " opts.context ") ")
                   "")
                 opts.code "\n")
        (ok? result) (ani-eval.str code {:filename opts.file-path})]
    {:ok? ok?
     :result result}))

(defn eval-file [opts]
  (set opts.code (core.slurp opts.file-path))
  (eval-str opts))

(defn display-result [{: ok? : result}]
  (let [result-str (if ok?
                     (core.pr-str result)
                     result)
        result-lines (str.split result-str "[^\n]+")]
    (log.append
      (if ok?
        result-lines
        (core.map #(.. "; " $1) result-lines)))
    (nvim.out_write
      (.. result-str
          "\n"))))

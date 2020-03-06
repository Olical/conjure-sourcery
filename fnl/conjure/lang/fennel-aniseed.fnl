(module conjure.lang.fennel-aniseed
  {require {nvim conjure.aniseed.nvim
            core conjure.aniseed.core
            str conjure.aniseed.string
            view conjure.aniseed.view
            ani-eval aniseed.eval
            code conjure.code
            log conjure.log}})

(def buf-suffix ".fnl")

(def- default-module-name "aniseed.user")
(def- buf-module-pattern "[(]%s*module%s*(.-)[%s){]")

(def config
  {:log-sample-limit 64
   :buf-header-length 20})

(defn buf-context []
  (let [header (->> (nvim.buf_get_lines 0 0 config.buf-header-length false)
                    (str.join "\n"))]
    (or (string.match header buf-module-pattern)
        default-module-name)))

(defn display-request [opts]
  (log.append
    [(.. "; " opts.action " (" opts.origin "): "
         (if (or (= :file opts.origin) (= :buf opts.origin))
           opts.file-path
           (code.sample opts.code config.log-sample-limit)))]))

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
  (when opts.code
    (eval-str opts)))

(defn display-result [opts]
  (when opts
    (let [{: ok? : result} opts
          result-str (if ok?
                       (view.serialise result)
                       result)
          result-lines (str.split result-str "[^\n]+")]
      (log.append
        (if ok?
          result-lines
          (core.map #(.. "; " $1) result-lines)))
      (nvim.out_write
        (.. result-str
            "\n")))))

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
(defn- buf-module-name []
  (let [header (->> (nvim.buf_get_lines 0 0 buf-header-length false)
                    (str.join "\n"))]
    (or (string.match header buf-module-pattern)
        default-module-name)))

(defn- base-eval [code opts]
  (let [(ok? result) (ani-eval.str (.. code "\n") opts)]
    {:ok? ok?
     :result result}))

;; so every eval needs to be one map
;; opts map contains: code, module / namespace, file-path and any extra things
;; module lookup will be called for you, is optional
;; eval-file may be simpler but also take a map containing file-path
;; so buf-module-name becomes open but it can be set but b:conjure_module or whatever
;; the contract between eval and display result is lang dependant, core keys are shared protocol
;; offer log tools to display code snippets for eval-str / eval-file etc, but it's up to you to choose

;; allows creative freedom with log output, need to implement breaks for trimming too

(defn eval-str [opts]
  (base-eval (.. "(module " (buf-module-name) ")" opts.code)
             {:filename opts.file-path}))

(defn eval-file [opts]
  (base-eval (core.slurp opts.file-path)
             {:filename opts.file-path}))

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

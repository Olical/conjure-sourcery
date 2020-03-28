(module conjure.lang.fennel-aniseed
  {require {nvim conjure.aniseed.nvim
            a conjure.aniseed.core
            str conjure.aniseed.string
            view conjure.aniseed.view
            ani-core aniseed.core
            ani-eval aniseed.eval
            ani-test aniseed.test
            mapping conjure.mapping
            text conjure.text
            hud conjure.hud
            log conjure.log
            extract conjure.extract}})

(def buf-suffix ".fnl")
(def default-context "aniseed.user")
(def context-pattern "[(]%s*module%s*(.-)[%s){]")
(def comment-prefix "; ")

(def config
  {:mappings {:run-buf-tests "tt"
              :run-all-tests "ta"}})

(defn- display [opts]
  (hud.display opts)
  (log.append opts))

(defn display-result [opts]
  (when opts
    (let [{: ok? : result} opts
          result-str (if ok?
                       (view.serialise result)
                       result)
          result-lines (str.split result-str "[^\n]+")
          prefixed-result-lines (if ok?
                                  result-lines
                                  (a.map #(.. "; " $1) result-lines))]
      (hud.display {:lines [opts.preview
                            (unpack prefixed-result-lines)]})
      (log.append {:lines prefixed-result-lines}))))

(defn eval-str [opts]
  (let [code (.. (if opts.context
                   (.. "(module " opts.context ") ")
                   "")
                 opts.code "\n")
        (ok? result) (ani-eval.str code {:filename opts.file-path})]
    (set opts.ok? ok?)
    (set opts.result result)
    (display-result opts)))

(defn eval-file [opts]
  (set opts.code (a.slurp opts.file-path))
  (when opts.code
    (eval-str opts)))

(defn- wrapped-test [req f]
  (display {:lines req})
  (let [res (ani-core.with-out-str f)
        lines (-> (if (= "" res)
                    "No results."
                    res)
                  (text.prefixed-lines "; "))]
    (hud.display {:lines (a.concat req lines)})
    (log.append {:lines lines})))

(defn run-buf-tests []
  (let [c (extract.context)
        req [(.. "; run-buf-tests (" c ")")]]
    (wrapped-test req #(ani-test.run c))))

(defn run-all-tests []
  (wrapped-test ["; run-all-tests"] ani-test.run-all))

(defn on-filetype []
  (mapping.buf :n config.mappings.run-buf-tests
               :conjure.lang.fennel-aniseed :run-buf-tests)
  (mapping.buf :n config.mappings.run-all-tests
               :conjure.lang.fennel-aniseed :run-all-tests))

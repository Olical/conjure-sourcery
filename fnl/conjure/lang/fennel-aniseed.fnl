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
            log conjure.log}})

(def buf-suffix ".fnl")

(def- default-module-name "aniseed.user")
(def- buf-module-pattern "[(]%s*module%s*(.-)[%s){]")

(def config
  {:log-sample-limit 64
   :hud-sample-limit 24
   :buf-header-length 20
   :mappings {:run-buf-tests "tt"
              :run-all-tests "ta"}})

(defn context []
  (let [header (->> (nvim.buf_get_lines 0 0 config.buf-header-length false)
                    (str.join "\n"))]
    (or (string.match header buf-module-pattern)
        default-module-name)))

(defn- preview [{: sample-limit : opts}]
  (.. "; " opts.action " (" opts.origin "): "
      (if (or (= :file opts.origin) (= :buf opts.origin))
        (text.right-sample opts.file-path sample-limit)
        (text.left-sample opts.code sample-limit))))

(defn- display [opts]
  (hud.display opts)
  (log.append opts))

(defn display-request [opts]
  (display
    {:lines [(preview
               {:opts opts
                :sample-limit config.log-sample-limit})]}))

(defn eval-str [opts]
  (let [code (.. (if opts.context
                   (.. "(module " opts.context ") ")
                   "")
                 opts.code "\n")
        (ok? result) (ani-eval.str code {:filename opts.file-path})]
    (set opts.ok? ok?)
    (set opts.result result)
    opts))

(defn eval-file [opts]
  (set opts.code (a.slurp opts.file-path))
  (when opts.code
    (eval-str opts)))

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
      (hud.display {:lines [(preview
                              {:opts opts
                               :sample-limit config.hud-sample-limit})
                            (unpack prefixed-result-lines)]})
      (log.append {:lines prefixed-result-lines}))))

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
  (let [c (context)
        req [(.. "; run-buf-tests (" c ")")]]
    (wrapped-test req #(ani-test.run c))))

(defn run-all-tests []
  (wrapped-test ["; run-all-tests"] ani-test.run-all))

(defn on-filetype []
  (mapping.buf :n config.mappings.run-buf-tests
               :conjure.lang.fennel-aniseed :run-buf-tests)
  (mapping.buf :n config.mappings.run-all-tests
               :conjure.lang.fennel-aniseed :run-all-tests))

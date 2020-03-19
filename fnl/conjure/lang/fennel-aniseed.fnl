(module conjure.lang.fennel-aniseed
  {require {nvim conjure.aniseed.nvim
            core conjure.aniseed.core
            str conjure.aniseed.string
            view conjure.aniseed.view
            ani-eval aniseed.eval
            ani-test aniseed.test
            mapping conjure.mapping
            code conjure.code
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
        (code.right-sample opts.file-path sample-limit)
        (code.left-sample opts.code sample-limit))))

(defn display-request [opts]
  (let [display-opts
        {:lines [(preview
                   {:opts opts
                    :sample-limit config.log-sample-limit})]}]
    (hud.display display-opts)
    (log.append display-opts)))

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
  (set opts.code (core.slurp opts.file-path))
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
                                  (core.map #(.. "; " $1) result-lines))]
      (hud.display {:lines [(preview
                              {:opts opts
                               :sample-limit config.hud-sample-limit})
                            (unpack prefixed-result-lines)]})
      (log.append {:lines prefixed-result-lines}))))

;; TODO Refactor testing to return the text as data.
;; I can then display in hud and log if there is no error.
;; Maybe I can just have a core.with-out-str?

(defn run-buf-tests []
  (ani-test.run (context)))

(defn run-all-tests []
  (ani-test.run-all))

(defn on-filetype []
  (mapping.map-local->plug
    :n config.mappings.run-buf-tests
    :conjure_lang_fennel_aniseed_run_buf_tests)
  (mapping.map-local->plug
    :n config.mappings.run-all-tests
    :conjure_lang_fennel_aniseed_run_all_tests))

(mapping.map-plug
  :n :conjure_lang_fennel_aniseed_run_buf_tests
  :conjure.lang.fennel-aniseed :run-buf-tests)

(mapping.map-plug
  :n :conjure_lang_fennel_aniseed_run_all_tests
  :conjure.lang.fennel-aniseed :run-all-tests)

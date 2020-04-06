(module conjure.eval
  {require {a conjure.aniseed.core
            nvim conjure.aniseed.nvim
            extract conjure.extract
            lang conjure.lang
            text conjure.text
            config conjure.config
            editor conjure.editor
            log conjure.log}})

;; TODO Eval form at mark.
;; TODO Go to definition.
;; TODO Completion.
;; TODO Languages: Janet, Racket, MIT Scheme.

(defn- preview [opts]
  (let [sample-limit (editor.percent-width
                       config.preview.sample-limit)]
    (.. (lang.get :comment-prefix)
        opts.action " (" opts.origin "): "
        (if (or (= :file opts.origin) (= :buf opts.origin))
          (text.right-sample opts.file-path sample-limit)
          (text.left-sample opts.code sample-limit)))))

(defn- display-request [opts]
  (log.append [opts.preview] {:break? true}))

(defn file []
  (let [opts {:file-path (extract.file-path)
              :origin :file
              :action :eval}]
    (set opts.preview (preview opts))
    (display-request opts)
    (lang.call :eval-file opts)))

(defn- lang-exec-fn [action f-name]
  (fn [opts]
    (set opts.action action)
    (set opts.context
         (or nvim.b.conjure_context
             (extract.context)))
    (set opts.file-path (extract.file-path))
    (set opts.preview (preview opts))
    (display-request opts)
    (lang.call f-name opts)))

(def- eval-str (lang-exec-fn :eval :eval-str))
(def- doc-str (lang-exec-fn :doc :doc-str))

(defn current-form []
  (let [form (extract.form {})]
    (when form
      (let [{: content : range} form]
        (eval-str
          {:code content
           :range range
           :origin :current-form})))))

(defn root-form []
  (let [form (extract.form {:root? true})]
    (when form
      (let [{: content : range} form]
        (eval-str
          {:code content
           :range range
           :origin :root-form})))))

(defn word []
  (let [{: content : range} (extract.word)]
    (eval-str
      {:code content
       :range range
       :origin :word})))

(defn doc-word []
  (let [{: content : range} (extract.word)]
    (doc-str
      {:code content
       :range range
       :origin :word})))

(defn buf []
  (let [{: content : range} (extract.buf)]
    (eval-str
      {:code content
       :range range
       :origin :buf})))

(defn command [code]
  (eval-str
    {:code code
     :origin :command}))

(defn range [start end]
  (let [{: content : range} (extract.range start end)]
    (eval-str
      {:code content
       :range range
       :origin :range})))

(defn selection [kind]
  (let [{: content : range}
        (extract.selection
          {:kind (or kind (nvim.fn.visualmode))
           :visual? (not kind)})]
    (eval-str
      {:code content
       :range range
       :origin :selection})))

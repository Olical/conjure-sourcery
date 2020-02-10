;; high level tools to make things happen and display the results

(module conjure.eval
  {require {extract conjure.extract
            prepl conjure.prepl
            log conjure.log}})

(defn current-form []
  (let [form (extract.form {})]
    (when form
      (log.append [";; Evaluating current form"])
      (prepl.send (.. (. form :content) "\n")))))

(defn root-form []
  (let [form (extract.form {:root? true})]
    (when form
      (log.append [";; Evaluating root form"])
      (prepl.send (.. (. form :content) "\n")))))

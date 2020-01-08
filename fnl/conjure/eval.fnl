;; high level tools to make things happen and display the results

(local extract (require :conjure.extract))
(local prepl (require :conjure.prepl))
(local log (require :conjure.log))

(fn current-form []
  (let [form (extract.form {})]
    (when form
      (log.append [";; Evaluating current form"])
      (prepl.send (.. (. form :content) "\n")))))

(fn root-form []
  (let [form (extract.form {:root? true})]
    (when form
      (log.append [";; Evaluating root form"])
      (prepl.send (.. (. form :content) "\n")))))

{:aniseed/module :conjure.eval
 :current-form current-form
 :root-form root-form}

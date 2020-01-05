;; high level tools to make things happen and display the results

(local extract (require :conjure.extract))
(local prepl (require :conjure.prepl))
(local log (require :conjure.log))

;; TODO Need to de-escape things like newlines.
(fn current-form []
  (let [form (extract.current-form)]
    (when form
      (log.append [";; Evaluating current form"])
      (prepl.send (.. (. form :content) "\n")))))

{:aniseed/module :conjure.eval
 :current-form current-form}

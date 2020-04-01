(ns foo)

(+ 10 20)
(println "foo" #?(:clj :clojure! :cljs :clojurescript!))

*1 *2 *3 *e

(comment
  (throw (Error. "ohno"))
  (throw (js/Error. "ohno"))
  (do (Thread/sleep 5000)
      (println "FOO"))
  (do (Thread/sleep 5000)
      (println "BAR"))

  (require '[cider.piggieback :as piggieback]
           '[cljs.repl.node :as node-repl])
  (piggieback/cljs-repl (node-repl/repl-env))
  (enable-console-print!)
  :cljs/quit)
(local main (require :conjure.main))

{:aniseed/module :conjure.main-test
 :aniseed/tests
 {:single-eval
  (fn [t]
    (t.= nil (main.single-eval "(+ 10 20)\n")))}}

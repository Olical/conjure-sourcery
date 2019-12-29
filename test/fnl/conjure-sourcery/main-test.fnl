(local main (require :conjure-sourcery.main))

{:aniseed/module :conjure-sourcery.main-test
 :aniseed/tests
 {:single-eval
  (fn [t]
    (t.= nil (main.single-eval "(+ 10 20)\n")))}}

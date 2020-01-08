(local extract (require :conjure.extract))
(local tu (require :conjure.test-utils))

{:aniseed/module :conjure.extract-test
 :aniseed/tests
 {:form
  (fn [t]
    (tu.with-buf
      ["(ns foo)"
       ""
       "(+ 10 20 (* 10 2))"]
      (fn [at]
        (at [3 10])
        (t.pr= {:range {:start [3 10]
                        :end [3 17]}
                :content "(* 10 2)"}
               (extract.form {})
               "inside the form")

        (at [3 10])
        (t.pr= {:range {:start [3 1]
                        :end [3 18]}
                :content "(+ 10 20 (* 10 2))"}
               (extract.form {:root? true})
               "root from inside a child form")

        (at [3 6])
        (t.pr= {:range {:start [3 1]
                        :end [3 18]}
                :content "(+ 10 20 (* 10 2))"}
               (extract.form {:root? true})
               "root from the root")

        (at [3 0])
        (t.pr= {:range {:start [3 1]
                        :end [3 18]}
                :content "(+ 10 20 (* 10 2))"}
               (extract.form {:root? true})
               "root from the opening paren of the root")

        (at [3 9])
        (t.pr= {:range {:start [3 1]
                        :end [3 18]}
                :content "(+ 10 20 (* 10 2))"}
               (extract.form {:root? true})
               "root from the opening paren of the child form")

        (at [2 0])
        (t.= nil (extract.form {:root? true}) "matching nothing for root")

        (at [3 9])
        (t.pr= {:range {:start [3 10]
                        :end [3 17]}
                :content "(* 10 2)"}
               (extract.form {})
               "on the opening paren")

        (at [3 16])
        (t.pr= {:range {:start [3 10]
                        :end [3 17]}
                :content "(* 10 2)"}
               (extract.form {})
               "on the closing paren")

        (at [3 8])
        (t.pr= {:range {:start [3 1]
                        :end [3 18]}
                :content "(+ 10 20 (* 10 2))"}
               (extract.form {})
               "one before the inner form")

        (at [3 17])
        (t.pr= {:range {:start [3 1]
                        :end [3 18]}
                :content "(+ 10 20 (* 10 2))"}
               (extract.form {})
               "on the last paren of the outer form")

        (at [2 0])
        (t.= nil (extract.form {}) "matching nothing")

        (at [1 0])
        (t.pr= {:range {:start [1 1]
                        :end [1 8]}
                :content "(ns foo)"}
               (extract.form {})
               "ns form"))))}}

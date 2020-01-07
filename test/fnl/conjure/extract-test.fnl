(local extract (require :conjure.extract))
(local tu (require :conjure.test-utils))

{:aniseed/module :conjure.extract-test
 :aniseed/tests
 {:current-form
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
               (extract.current-form))

        (at [3 9])
        (t.pr= {:range {:start [3 10]
                        :end [3 17]}
                :content "(* 10 2)"}
               (extract.current-form))

        (at [3 16])
        (t.pr= {:range {:start [3 10]
                        :end [3 17]}
                :content "(* 10 2)"}
               (extract.current-form))

        (at [3 9])
        (t.pr= {:range {:start [3 1]
                        :end [3 18]}
                :content "(+ 10 20 (* 10 2))"}
               (extract.current-form))

        (at [3 17])
        (t.pr= {:range {:start [3 1]
                        :end [3 18]}
                :content "(+ 10 20 (* 10 2))"}
               (extract.current-form)))))}}

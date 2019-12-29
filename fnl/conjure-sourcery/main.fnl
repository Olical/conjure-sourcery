(comment
  ((. (require :conjure-sourcery.main) :single-eval)
   "(+ 10 20)\n"))

(local ani (require :aniseed.core))
(local nvim (require :aniseed.nvim))
(local nu (require :aniseed.nvim.util))

(fn parse [s]
  {:tag (-> s (: :match ":tag :%a+") (: :sub 7))
   :val (-> s (: :match ":val %b\"\"") (: :sub 7 -2))})

(fn chan-on-data [chan-id data]
  (->> data
      (ani.first)
      (parse)
      (ani.pr))
  (nvim.fn.chanclose chan-id)
  nil)

(nu.fn-bridge
  :ConjureSourceryChanOnData
  :conjure-sourcery.main :chan-on-data)

(fn main []
  (ani.pr "Sourcery!?"))

(fn single-eval [code]
  (let [chan-id (nvim.fn.sockconnect
                  :tcp (.. "localhost:"
                           (-> (nvim.fn.readfile ".prepl-port")
                               (ani.first)))
                  {:on_data :ConjureSourceryChanOnData})]
    (nvim.fn.chansend chan-id code))
  nil)

{:aniseed/module :conjure-sourcery.main
 :main main
 :single-eval single-eval
 :chan-on-data chan-on-data}

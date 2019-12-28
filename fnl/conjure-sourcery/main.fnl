(local ani (require :aniseed.core))
(local nvim (require :aniseed.nvim))
(local nu (require :aniseed.nvim.util))

(fn main []
  (let [chan-id (nvim.fn.sockconnect
                  :tcp "localhost:5555"
                  {:on_data :ConjureSourceryChanOnData})]
    (nvim.fn.chansend chan-id "(+ 10 20)\n"))
  nil)

(fn parse [s]
  {:tag (: (: s :match ":tag :%a+") :sub 7)
   :val (: (: s :match ":val %b\"\"") :sub 7 -2)})

(fn chan-on-data [chan-id data]
  (->> data
      (ani.first)
      (parse)
      (ani.pr "resp=>"))
  (nvim.fn.chanclose chan-id)
  nil)

(nu.fn-bridge :ConjureSourceryChanOnData
              :conjure-sourcery.main
              :chan-on-data)

(comment
  ((. (require :conjure-sourcery.main) :main)))

{:aniseed/module :conjure-sourcery.main
 :main main
 :chan-on-data chan-on-data}

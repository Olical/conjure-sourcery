(comment
  ((. (require :conjure.main) :single-eval)
   "(+ 10 20)\n"))

(local ani (require :conjure.aniseed.core))
(local nvim (require :conjure.aniseed.nvim))
(local nu (require :conjure.aniseed.nvim.util))

(local log (require :conjure.log))
(local mapping (require :conjure.mapping))

(fn parse [s]
  {:tag (-> s (: :match ":tag :%a+") (: :sub 7))
   :val (-> s (: :match ":val %b\"\"") (: :sub 7 -2))})

(fn chan-on-data [chan-id data]
  (let [{: tag : val} (->> data
                           (ani.first)
                           (parse))]
    (log.append [(.. ";; " tag) val]))
  (nvim.fn.chanclose chan-id)
  nil)

(nu.fn-bridge
  :ConjureChanOnData
  :conjure.main :chan-on-data)

(fn main []
  (mapping.init))

(fn single-eval [code]
  (let [chan-id (nvim.fn.sockconnect
                  :tcp (.. "localhost:"
                           (-> (nvim.fn.readfile ".prepl-port")
                               (ani.first)))
                  {:on_data :ConjureChanOnData})]
    (nvim.fn.chansend chan-id code))
  nil)

{:aniseed/module :conjure.main
 :main main
 :single-eval single-eval
 :chan-on-data chan-on-data}

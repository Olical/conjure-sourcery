(comment
  ((. (require :conjure.main) :single-eval)
   "(+ 10 20)\n"))

(local ani (require :conjure.aniseed.core))
(local nvim (require :conjure.aniseed.nvim))
(local nu (require :conjure.aniseed.nvim.util))

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
  :ConjureChanOnData
  :conjure.main :chan-on-data)

(fn main []
  ;; TODO Initialise all other modules.
  ;;  * ui for the log and other display methods.
  ;;  * log for high level concepts of UI.
  ;;  * socks for socket management.
  ;;  * eval for evaluation of code via socks.
  ;;  * config for... config.
  ;;  * some module for working out what we should connect to.
  ;;  * keys for all mappings.
  (ani.pr "Sourcery!?"))

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

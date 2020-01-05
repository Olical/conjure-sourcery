(local ani (require :conjure.aniseed.core))
(local nvim (require :conjure.aniseed.nvim))
(local nu (require :conjure.aniseed.nvim.util))

(local log (require :conjure.log))

;; TODO Multiple connections from things other than .prepl-port.
(var conn nil)

;; TODO Hunt for :exception flags.
(fn parse [s]
  {:tag (-> s (: :match ":tag :%a+") (: :sub 7))
   :val (-> s (: :match ":val %b\"\"") (: :sub 7 -2))})

(fn cleanup []
  (when conn
    (nvim.fn.chanclose (. conn :chan-id))
    (log.append [(.. ";; Disconnected from " (. conn :address))])
    (set conn nil)))

(fn chan-on-data [_chan-id data name]
  (let [msg (ani.first data)]
    (if (= "" msg)
      (cleanup)
      (let [{: tag : val} (parse msg)]
        (log.append [(.. ";; " name " " tag) val])))))

(nu.fn-bridge
  :ConjureChanOnData
  :conjure.prepl :chan-on-data)

(local prepl-port-file ".prepl-port")

(fn sync []
  (cleanup)

  (when (= 1 (nvim.fn.filereadable prepl-port-file))
    (let [address (.. "localhost:"
                      (-> (nvim.fn.readfile prepl-port-file)
                          (ani.first)))
          chan-id (nvim.fn.sockconnect
                    :tcp address
                    {:on_data :ConjureChanOnData})]
      (if (= 0 chan-id)
        (log.append [(.. ";; Failed to connect to " address)])
        (do
          (log.append [(.. ";; Connected to " address)])
          (set conn {:chan-id chan-id
                     :address address}))))))

(fn send [code]
  (when conn
    (nvim.fn.chansend (. conn :chan-id) code)))

{:aniseed/module :conjure.prepl
 :chan-on-data chan-on-data
 :sync sync
 :send send}

(module conjure.prepl
  {require {ani conjure.aniseed.core
            nvim conjure.aniseed.nvim
            nu conjure.aniseed.nvim.util
            log conjure.log}})

;; TODO Multiple connections from things other than .prepl-port.
(def- conn nil)

;; TODO Hunt for :exception flags.
;; TODO Need to de-escape things in results like newlines.
(defn- parse [s]
  {:tag (-> s (: :match ":tag :%a+") (: :sub 7))
   :val (-> s (: :match ":val %b\"\"") (: :sub 7 -2))})

(defn- cleanup []
  (when conn
    (nvim.fn.chanclose (. conn :chan-id))
    (log.append [(.. ";; Disconnected from " (. conn :address))])
    (set conn nil)))

(defn chan-on-data [_chan-id data name]
  (let [msg (ani.first data)]
    (if (= "" msg)
      (cleanup)
      (let [{: tag : val} (parse msg)]
        (log.append [(.. ";; " name " " tag) val])))))

(nu.fn-bridge
  :ConjureChanOnData
  :conjure.prepl :chan-on-data)

(def- prepl-port-file ".prepl-port")

(defn sync []
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

(defn send [code]
  (when conn
    (nvim.fn.chansend (. conn :chan-id) code)))

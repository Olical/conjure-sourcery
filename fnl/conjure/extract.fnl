(local ani (require :conjure.aniseed.core))
(local nvim (require :conjure.aniseed.nvim))
(local str (require :conjure.aniseed.string))

;; form (root / current), element, namespace

(fn read-range [{:start [srow scol] :end [erow ecol]}]
  (let [lines (nvim.buf_get_lines
                0 (ani.dec srow) erow false)]
    (-> lines
        (ani.update
          (length lines)
          (fn [s]
            (string.sub s 0 ecol)))
        (ani.update
          1
          (fn [s]
            (string.sub s scol)))
        (->> (str.join "\n")))))

(fn current-form []
  (let [;; 'W' don't Wrap around the end of the file
        ;; 'c' accept a match at the Cursor position
        ;; 'n' do Not move the cursor
        flags "Wcn"

        ;; TODO Handle when cursor is on open or close.
        ;; Need a fn to extract current char using get cursor
        ;; pos and line value.
        end (nvim.fn.searchpairpos
              "(" "" ")" flags)

        ;; 'b' search Backward instead of forward
        start (nvim.fn.searchpairpos
                "(" "" ")" (.. flags "b"))

        range {:start start
               :end end}]
    (when (and (not= 0 (unpack start))
               (not= 0 (unpack end)))
      {:range range
       :content (read-range range)})))

{:aniseed/module :conjure.extract
 :current-form current-form}

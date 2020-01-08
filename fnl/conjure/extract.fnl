(local ani (require :conjure.aniseed.core))
(local nvim (require :conjure.aniseed.nvim))
(local str (require :conjure.aniseed.string))

;; form (root / current), element, namespace

(fn read-range [{:start [srow scol] :end [erow ecol]}]
  (let [lines (nvim.buf_get_lines
                0 (- srow 1) erow false)]
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

(fn buf-char [at]
  (let [[row col] at
        [line] (nvim.buf_get_lines 0 (- row 1) row false)
        char (+ col 1)]
    (string.sub line char char)))

(fn nil-pos? [pos]
  (or (not pos)
      (= 0 (unpack pos))))

(fn current-form []
  (let [cursor (nvim.win_get_cursor 0)
        current-char (buf-char cursor)

        ;; 'W' don't Wrap around the end of the file
        ;; 'n' do Not move the cursor
        ;; 'z' start searching at the cursor column instead of Zero
        ;; 'b' search Backward instead of forward
        ;; 'c' accept a match at the Cursor position
        flags "Wnz"
        start (nvim.fn.searchpairpos
                "(" "" ")"
                (.. flags "b" (if (= current-char "(") "c" "")))
        end (nvim.fn.searchpairpos
              "(" "" ")"
              (.. flags (if (= current-char ")") "c" "")))]

    (let [range {:start start
                 :end end}]
      (when (and (not (nil-pos? start))
                 (not (nil-pos? end)))
        {:range range
         :content (read-range range)}))))

{:aniseed/module :conjure.extract
 :current-form current-form}

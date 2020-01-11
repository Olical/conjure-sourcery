(local ani (require :conjure.aniseed.core))
(local nvim (require :conjure.aniseed.nvim))
(local nu (require :conjure.aniseed.nvim.util))
(local str (require :conjure.aniseed.string))

;; form (root / current), element, namespace

(fn read-range [[srow scol] [erow ecol]]
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

(fn current-char []
  (let [[row col] (nvim.win_get_cursor 0)
        [line] (nvim.buf_get_lines 0 (- row 1) row false)
        char (+ col 1)]
    (string.sub line char char)))

(fn nil-pos? [pos]
  (or (not pos)
      (= 0 (unpack pos))))

(fn cursor-in-code? []
  (let [[row col] (nvim.win_get_cursor 0)
        stack (nvim.fn.synstack row col)
        stack-size (length stack)]
    (or (= 0 stack-size)
        (let [name (nvim.fn.synIDattr (. stack stack-size) :name)]
          (not (or (name:find "Comment$")
                   (name:find "String$")
                   (name:find "Regexp$")))))))

(nu.fn-bridge
  :ConjureCursorInCode
  :conjure.extract :cursor-in-code?
  {:return true})

;; TODO Handle [] and {} pairs, including matching inner or outer most pair.
(fn form [{: root?}]
  (let [;; 'W' don't Wrap around the end of the file
        ;; 'n' do Not move the cursor
        ;; 'z' start searching at the cursor column instead of Zero
        ;; 'b' search Backward instead of forward
        ;; 'c' accept a match at the Cursor position
        ;; 'r' repeat until no more matches found; will find the outer pair
        flags (.. "Wnz" (if root? "r" ""))
        cursor-char (current-char)

        skip-non-code "!ConjureCursorInCode()"

        start (nvim.fn.searchpairpos
                "(" "" ")"
                (.. flags "b" (if (= cursor-char "(") "c" ""))
                skip-non-code)
        end (nvim.fn.searchpairpos
              "(" "" ")"
              (.. flags (if (= cursor-char ")") "c" ""))
              skip-non-code)]

    (when (and (not (nil-pos? start))
               (not (nil-pos? end)))
      {:range {:start (ani.update start 2 ani.dec)
               :end (ani.update end 2 ani.dec)}
       :content (read-range start end)})))

{:aniseed/module :conjure.extract
 :form form
 :cursor-in-code? cursor-in-code?}

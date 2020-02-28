(module conjure.extract
  {require {ani conjure.aniseed.core
            nvim conjure.aniseed.nvim
            str conjure.aniseed.string}})

;; TODO form (root / current)

;; May be language dependant.
;; TODO element
;; TODO namespace

(defn- read-range [[srow scol] [erow ecol]]
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

(defn- current-char []
  (let [[row col] (nvim.win_get_cursor 0)
        [line] (nvim.buf_get_lines 0 (- row 1) row false)
        char (+ col 1)]
    (string.sub line char char)))

(defn- nil-pos? [pos]
  (or (not pos)
      (= 0 (unpack pos))))

(defn skip-match? []
  (let [[row col] (nvim.win_get_cursor 0)
        stack (nvim.fn.synstack row col)
        stack-size (length stack)]
    (and (> stack-size 0)
         (let [name (nvim.fn.synIDattr (. stack stack-size) :name)]
           (or (name:find "Comment$")
               (name:find "String$")
               (name:find "Regexp$"))))))

;; TODO Handle [] and {} pairs, including matching inner or outer most pair.
(defn form [{: root?}]
  (let [;; 'W' don't Wrap around the end of the file
        ;; 'n' do Not move the cursor
        ;; 'z' start searching at the cursor column instead of Zero
        ;; 'b' search Backward instead of forward
        ;; 'c' accept a match at the Cursor position
        ;; 'r' repeat until no more matches found; will find the outer pair
        flags (.. "Wnz" (if root? "r" ""))
        cursor-char (current-char)

        skip-match?-viml "luaeval(\"require('conjure.extract')['skip-match?']()\")"

        start (nvim.fn.searchpairpos
                "(" "" ")"
                (.. flags "b" (if (= cursor-char "(") "c" ""))
                skip-match?-viml)
        end (nvim.fn.searchpairpos
              "(" "" ")"
              (.. flags (if (= cursor-char ")") "c" ""))
              skip-match?-viml)]

    (when (and (not (nil-pos? start))
               (not (nil-pos? end)))
      {:range {:start (ani.update start 2 ani.dec)
               :end (ani.update end 2 ani.dec)}
       :content (read-range start end)})))

(defn word []
  (nvim.fn.expand "<cword>"))

(defn file-path []
  (nvim.fn.expand "%:p"))

(defn buf []
  (str.join "\n" (nvim.buf_get_lines 0 0 -1 false)))

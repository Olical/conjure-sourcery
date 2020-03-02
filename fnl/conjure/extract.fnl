(module conjure.extract
  {require {core conjure.aniseed.core
            nvim conjure.aniseed.nvim
            nu conjure.aniseed.nvim.util
            str conjure.aniseed.string}})

;; TODO form (root / current)

;; May be language dependant.
;; TODO element
;; TODO namespace

(defn- read-range [[srow scol] [erow ecol]]
  (let [lines (nvim.buf_get_lines
                0 (- srow 1) erow false)]
    (-> lines
        (core.update
          (length lines)
          (fn [s]
            (string.sub s 0 ecol)))
        (core.update
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
      {:range {:start (core.update start 2 core.dec)
               :end (core.update end 2 core.dec)}
       :content (read-range start end)})))

(defn word []
  (nvim.fn.expand "<cword>"))

(defn file-path []
  (nvim.fn.expand "%:p"))

(defn range [start end]
  (str.join "\n" (nvim.buf_get_lines 0 start end false)))

(defn buf []
  (range 0 -1))

(defn selection [type ...]
  (let [sel-backup nvim.o.selection
        [visual?] [...]]

    (nvim.ex.let "g:aniseed_reg_backup = @@")
    (set nvim.o.selection :inclusive)

    (if
      visual? (nu.normal (.. "`<" type "`>y"))
      (= type :line) (nu.normal "'[V']y")
      (= type :block) (nu.normal "`[`]y")
      (nu.normal "`[v`]y"))

    (let [selection (nvim.eval "@@")]
      (set nvim.o.selection sel-backup)
      (nvim.ex.let "@@ = g:aniseed_reg_backup")
      selection)))

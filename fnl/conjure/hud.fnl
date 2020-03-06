(module conjure.hud
  {require {nvim conjure.aniseed.nvim}})

;; Much like conjure.log this can be used to display messages, although only one at a time.
;; It maintains a floating window, maybe viewing a bit of the log?
;; Hidden after cursor move (etc) + time or <esc>.
;; I think if you don't interact it stays there, just in case you looked away from your screen.

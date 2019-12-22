(local nvim (require :aniseed.nvim))
(local test (require :aniseed.test))

(nvim.ex.redir_ "> test/results.txt")

; (require :conjure-sourcery-test-suite.core)

(let [results (test.run-all)]
  (if (test.ok? results)
    (nvim.ex.q)
    (nvim.ex.cq)))

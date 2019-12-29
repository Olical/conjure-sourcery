(local nvim (require :conjure-sourcery.aniseed.nvim))
(local test (require :conjure-sourcery.aniseed.test))

(fn main []
  (nvim.ex.redir_ "> test/results.txt")

  (require :conjure-sourcery.main-test)

  (let [results (test.run-all)]
    (if (test.ok? results)
      (nvim.ex.q)
      (nvim.ex.cq))))

{:aniseed/module :conjure-sourcery.test-suite
 :main main}

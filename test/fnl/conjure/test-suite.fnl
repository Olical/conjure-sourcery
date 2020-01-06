(local nvim (require :conjure.aniseed.nvim))
(local test (require :conjure.aniseed.test))

(fn main []
  (nvim.ex.redir_ "> test/results.txt")

  (require :conjure.extract-test)

  (let [results (test.run-all)]
    (if (test.ok? results)
      (nvim.ex.q)
      (nvim.ex.cq))))

{:aniseed/module :conjure.test-suite
 :main main}

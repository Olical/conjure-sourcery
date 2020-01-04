(local mapping (require :conjure.mapping))
(local prepl (require :conjure.prepl))

(fn main []
  (mapping.init)
  (prepl.sync))

{:aniseed/module :conjure.main
 :main main}

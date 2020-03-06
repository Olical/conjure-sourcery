(module conjure.code-test
  {require {code conjure.code}})

(deftest sample
  (t.= "" (code.sample "" 0) "handles empty strings")
  (t.= "f" (code.sample "f" 1) "handles single characters")
  (t.= "foo bar" (code.sample "foo bar" 10) "does nothing if correct")
  (t.= "foo bar" (code.sample "foo    \n\n bar" 10) "replaces lots of whitespace with a space")
  (t.= "foo bar b…" (code.sample "foo    \n\n bar \n\n baz" 10) "cuts the string if too long")
  (t.= "foo bar" (code.sample "   foo \n \n bar  \n" 10) "trims leading and trailing whitespace"))

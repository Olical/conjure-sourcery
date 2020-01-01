local core = require("conjure.aniseed.core")
local str = require("conjure.aniseed.string")
local function ok_3f(_0_0)
  local _1_ = _0_0
  local tests = _1_["tests"]
  local tests_passed = _1_["tests-passed"]
  return (tests == tests_passed)
end
local function display_results(results, prefix)
  do
    local _1_ = results
    local tests = _1_["tests"]
    local assertions_passed = _1_["assertions-passed"]
    local tests_passed = _1_["tests-passed"]
    local assertions = _1_["assertions"]
    local function _2_()
      if ok_3f(results) then
        return "OK"
      else
        return "FAILED"
      end
    end
    print((prefix .. " " .. _2_() .. " " .. tests_passed .. "/" .. tests .. " tests and " .. assertions_passed .. "/" .. assertions .. " assertions passed"))
  end
  return results
end
local function run(module_name)
  local module = package.loaded[module_name]
  local tests = (core["table?"](module) and module["aniseed/tests"])
  if core["table?"](tests) then
    local results = {["assertions-passed"] = 0, ["tests-passed"] = 0, assertions = 0, tests = #tests}
    for label, f in pairs(tests) do
      local test_failed = false
      core.update(results, "tests", core.inc)
      do
        local prefix = ("[" .. module_name .. "/" .. label .. "]")
        local fail = fail
        local function _1_(desc, ...)
          test_failed = true
          local function _2_(...)
            if desc then
              return (" (" .. desc .. ")")
            else
              return ""
            end
          end
          return print((str.join({prefix, " ", ...}) .. _2_(...)))
        end
        fail = _1_
        local begin = begin
        local function _2_()
          return core.update(results, "assertions", core.inc)
        end
        begin = _2_
        local pass = pass
        local function _3_()
          return core.update(results, "assertions-passed", core.inc)
        end
        pass = _3_
        local t = t
        local function _4_(e, r, desc)
          begin()
          if (e == r) then
            return pass()
          else
            return fail(desc, "Expected '", core["pr-str"](e), "' but received '", core["pr-str"](r), "'")
          end
        end
        local function _5_(r, desc)
          begin()
          if r then
            return pass()
          else
            return fail(desc, "Expected truthy result but received '", core["pr-str"](r), "'")
          end
        end
        local function _6_(e, r, desc)
          begin()
          do
            local se = core["pr-str"](e)
            local sr = core["pr-str"](r)
            if (se == sr) then
              return pass()
            else
              return fail(desc, "Expected (with pr) '", se, "' but received '", sr, "'")
            end
          end
        end
        t = {["="] = _4_, ["ok?"] = _5_, ["pr="] = _6_}
        do
          local _7_0, _8_0 = nil, nil
          local function _9_()
            return f(t)
          end
          _7_0, _8_0 = pcall(_9_)
          if ((_7_0 == false) and (nil ~= _8_0)) then
            local err = _8_0
            fail("Exception: ", err)
          end
        end
      end
      if not test_failed then
        core.update(results, "tests-passed", core.inc)
      end
    end
    return display_results(results, ("[" .. module_name .. "]"))
  end
end
local function run_all()
  local function _1_(totals, results)
    for k, v in pairs(results) do
      totals[k] = (v + totals[k])
    end
    return totals
  end
  return display_results(core.reduce(_1_, {["assertions-passed"] = 0, ["tests-passed"] = 0, assertions = 0, tests = 0}, core.filter(core["table?"], core.map(run, core.keys(package.loaded)))), "[total]")
end
return {["aniseed/module"] = "conjure.aniseed.test", ["ok?"] = ok_3f, ["run-all"] = run_all, run = run}

local core = require("conjure.aniseed.core")
local nvim = require("conjure.aniseed.nvim")
local function basename(path)
  return nvim.fn.fnamemodify(path, ":h")
end
local function mkdirp(dir)
  return nvim.fn.mkdir(dir, "p")
end
return {["aniseed/module"] = "conjure.aniseed.fs", basename = basename, mkdirp = mkdirp}

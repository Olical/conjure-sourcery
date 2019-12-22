local core = require("conjure-sourcery.aniseed.core")
local fs = require("conjure-sourcery.aniseed.fs")
local nvim = require("conjure-sourcery.aniseed.nvim")
local fennel = require("conjure-sourcery.aniseed.fennel")
local function str(content, opts)
  local function _0_()
    return fennel.compileString(content, opts)
  end
  return xpcall(_0_, fennel.traceback)
end
local function file(src, dest, opts)
  if ((core["table?"](opts) and opts.force) or (nvim.fn.getftime(src) > nvim.fn.getftime(dest))) then
    local content = core.slurp(src)
    do
      local _0_0, _1_0 = str(content, {filename = src})
      if ((_0_0 == false) and (nil ~= _1_0)) then
        local err = _1_0
        return nvim.err_writeln(err)
      elseif ((_0_0 == true) and (nil ~= _1_0)) then
        local result = _1_0
        do
          fs.mkdirp(fs.basename(dest))
          return core.spit(dest, result)
        end
      end
    end
  end
end
local function glob(src_expr, src_dir, dest_dir, opts)
  local src_dir_len = core.inc(string.len(src_dir))
  local src_paths = nil
  local function _0_(path)
    return string.sub(path, src_dir_len)
  end
  src_paths = core.map(_0_, nvim.fn.globpath(src_dir, src_expr, true, true))
  for _, path in ipairs(src_paths) do
    file((src_dir .. path), string.gsub((dest_dir .. path), ".fnl$", ".lua"), opts)
  end
  return nil
end
return {["aniseed/module"] = "conjure-sourcery.aniseed.compile", file = file, glob = glob, str = str}

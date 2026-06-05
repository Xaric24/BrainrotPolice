-- reel for brainrots new plr

return function(section)
  local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
  local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()
  local source = game:HttpGet(getgitpath("games") .. "106772177198260.lua")
  local loaded = loadstring(source)

  if not loaded then
    elements:Label("Reel script failed to load.", section)
    return
  end

  local ok, module = pcall(loaded)
  if ok and module then
    utils.SafeCall(module, section)
  else
    elements:Label("Reel script failed to start.", section)
  end
end

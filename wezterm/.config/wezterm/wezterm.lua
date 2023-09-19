local wezterm = require("wezterm")

local scheme_for_appearance = function(appearance)
  if appearance:find("Dark") then
    return "Gruvbox Dark (Gogh)"
  else
    return "Gruvbox (Gogh)"
  end
end

return {
  font = wezterm.font("MesloLGS NF"),
  color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
}

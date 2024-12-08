-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
--config.color_scheme = 'Selenized Black (Gogh)'
-- config.color_scheme = 'Sequoia Moonlight'
-- config.color_scheme = "Ef-Cherie"
-- config.color_scheme = "Ef-Bio"
-- config.color_scheme = "Ef-Autumn"
config.color_scheme = "Modus-Operandi"

config.keys = {
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
	{
		key = "m",
		mods = "CMD",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "s",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "S",
		mods = "CMD",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "k",
		mods = "CMD",
		action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
	},
	{
		key = "J",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Next"),
	},
	{
		key = "[",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "]",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "b",
		mods = "CMD",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "j",
		mods = "CMD",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "j",
		mods = "CMD|ALT",
		action = wezterm.action.ScrollByLine(1),
	},
	{
		key = "k",
		mods = "CMD|ALT",
		action = wezterm.action.ScrollByLine(-1),
	},
	{
		key = "u",
		mods = "CMD|ALT",
		action = wezterm.action.ScrollByPage(-1),
	},
	{
		key = "d",
		mods = "CMD|ALT",
		action = wezterm.action.ScrollByPage(1),
	},
	{
		key = "G",
		mods = "CMD|ALT",
		action = wezterm.action.ScrollToBottom,
	},
}

config.mouse_bindings = {
	-- CMD-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- and finally, return the configuration to wezterm
return config

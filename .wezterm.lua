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
	-- Change the default click behavior so that it only selects
	-- text and doesn't open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.DisableDefaultAssignment,
	},
	-- Bind 'Up' event of CTRL-Click to open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
	-- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.Nop,
	},
}

-- and finally, return the configuration to wezterm
return config

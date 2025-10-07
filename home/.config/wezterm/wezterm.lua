local wezterm = require("wezterm")

-- Helper for checking OS
local function is_windows()
	return wezterm.target_triple == "x86_64-pc-windows-msvc"
end

return {
	-- Font configuration
	font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"FiraCode Nerd Font",
		"Cascadia Code",
		"Consolas",
	}),
	font_size = 12.0,

	-- Color scheme (Vim-friendly)
	color_scheme = "Gruvbox Dark",

	-- Window appearance
	window_background_opacity = 0.95,
	window_decorations = "RESIZE",

	-- Tab bar configuration
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = false,

	-- Default shell: WSL Ubuntu starting in user home directory
	default_prog = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" },

	-- Set default domain to WSL Ubuntu
	default_domain = "WSL:Ubuntu",

	-- Cursor configuration
	default_cursor_style = "BlinkingBlock",

	-- Scrollback
	scrollback_lines = 10000,

	-- Vim-oriented keybindings
	keys = {
		-- Pane navigation (Ctrl+Alt + vim keys) - Changed from Alt to avoid GlazeWM conflicts
		{ key = "h", mods = "CTRL|ALT", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "j", mods = "CTRL|ALT", action = wezterm.action.ActivatePaneDirection("Down") },
		{ key = "k", mods = "CTRL|ALT", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "l", mods = "CTRL|ALT", action = wezterm.action.ActivatePaneDirection("Right") },

		-- Pane splitting (Ctrl+Alt + s/v) - Changed from Alt to avoid GlazeWM conflicts
		{ key = "s", mods = "CTRL|ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "v", mods = "CTRL|ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

		-- Close pane (Ctrl+Alt + x) - Changed from Alt to avoid conflicts
		{ key = "x", mods = "CTRL|ALT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

		-- Pane resizing (Ctrl+Alt+Shift + vim keys) - Changed from Alt+Shift to avoid GlazeWM conflicts
		{ key = "h", mods = "CTRL|ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
		{ key = "j", mods = "CTRL|ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
		{ key = "k", mods = "CTRL|ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
		{ key = "l", mods = "CTRL|ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },

		-- Tab navigation (Ctrl + Tab/Shift+Tab)
		{ key = "Tab", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },

		-- Tab creation and closing
		{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
		{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },

		-- Copy/Paste (Ctrl+Shift for vim compatibility)
		{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },

		-- Search (like vim's /)
		{ key = "/", mods = "CTRL", action = wezterm.action.Search({ CaseSensitiveString = "" }) },

		-- Command palette (leader key)
		{ key = "Space", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCommandPalette },

		-- Quick launchers (using different keys to avoid conflicts with pane management)
		{ key = "n", mods = "CTRL|ALT", action = wezterm.action.SpawnCommandInNewTab({ args = { "nvim" } }) },
		{ key = "e", mods = "CTRL|ALT", action = wezterm.action.SpawnCommandInNewTab({ args = { "vim" } }) },

		-- Clear screen (like Ctrl+L in terminal)
		{ key = "l", mods = "CTRL", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },

		-- Toggle fullscreen
		{ key = "F11", mods = "", action = wezterm.action.ToggleFullScreen },

		-- Font size adjustment
		{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
		{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
		{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
	},

	-- Mouse bindings
	mouse_bindings = {
		-- Ctrl+click to open links
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
		-- Paste on right click
		{
			event = { Up = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = wezterm.action.PasteFrom("Clipboard"),
		},
	},

	-- Terminal bell
	audible_bell = "Disabled",

	-- Performance
	max_fps = 60,

	-- WSL-specific settings
	wsl_domains = {
		{
			name = "WSL:Ubuntu",
			distribution = "Ubuntu",
			default_cwd = "/home/josh", -- Explicit WSL user home directory
		},
	},

	-- Additional color customizations for vim-like experience
	colors = {
		cursor_bg = "#fb4934",
		cursor_border = "#fb4934",
		cursor_fg = "#1d2021",
		selection_bg = "#504945",
		selection_fg = "#ebdbb2",
	},
}

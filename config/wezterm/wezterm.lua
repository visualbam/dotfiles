local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Read the stored theme from file, default to mocha if not found
local function get_stored_theme()
	local home = os.getenv("HOME")
	if home then
		local theme_file = home .. "/.config/catppuccin-theme"
		local f = io.open(theme_file, "r")
		if f then
			local theme = f:read("*a"):gsub("%s+", "") -- Read and trim whitespace
			f:close()
			return theme
		end
	end
	return "mocha" -- Default fallback
end

local stored_theme = get_stored_theme()

-- Map stored theme to WezTerm color scheme
local theme_to_wezterm = {
	latte = "Catppuccin Latte",
	frappe = "Catppuccin Frappe",
	macchiato = "Catppuccin Macchiato",
	mocha = "Catppuccin Mocha",
}

-- Set the color scheme based on stored theme
config.color_scheme = theme_to_wezterm[stored_theme] or "Catppuccin Mocha"

-- Smooth scrolling and rendering settings
config.front_end = "WebGpu" -- GPU-accelerated rendering for smooth performance
config.max_fps = 144 -- Higher refresh rate for smoother rendering
config.animation_fps = 60 -- Smooth animations at 60 FPS
config.scrollback_lines = 10000 -- Keep more history for scrolling
config.enable_kitty_graphics = true -- Better graphics support

-- Inherit current working directory for new panes and tabs
config.default_cwd = wezterm.home_dir

-- Tab bar styling
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.tab_max_width = 32

-- Window frame configuration for fancy tab bar
config.window_frame = {
	-- The font used in the tab bar
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	-- The size of the font in the tab bar
	font_size = 12.0,
}

-- Window and title bar styling
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_background_opacity = 1.0
config.macos_window_background_blur = 10

-- Catppuccin color palettes for proper tab bar styling
local catppuccin_palettes = {
	["Catppuccin Latte"] = {
		base = "#eff1f5",
		mantle = "#e6e9ef",
		crust = "#dce0e8",
		text = "#4c4f69",
		blue = "#1e66f5",
		surface0 = "#ccd0da",
		surface1 = "#bcc0cc",
		subtext1 = "#5c5f77",
	},
	["Catppuccin Frappe"] = {
		base = "#303446",
		mantle = "#292c3c",
		crust = "#232634",
		text = "#c6d0f5",
		blue = "#8caaee",
		surface0 = "#414559",
		surface1 = "#51576d",
		subtext1 = "#b5bfe2",
	},
	["Catppuccin Macchiato"] = {
		base = "#24273a",
		mantle = "#1e2030",
		crust = "#181926",
		text = "#cad3f5",
		blue = "#8aadf4",
		surface0 = "#363a4f",
		surface1 = "#494d64",
		subtext1 = "#b8c0e0",
	},
	["Catppuccin Mocha"] = {
		base = "#1e1e2e",
		mantle = "#181825",
		crust = "#11111b",
		text = "#cdd6f4",
		blue = "#89b4fa",
		surface0 = "#313244",
		surface1 = "#45475a",
		subtext1 = "#bac2de",
	},
}

-- Catppuccin theme flavors
local themes = {
	{ label = "Latte (Light)", id = "Catppuccin Latte" },
	{ label = "Frappé (Medium Dark)", id = "Catppuccin Frappe" },
	{ label = "Macchiato (Dark)", id = "Catppuccin Macchiato" },
	{ label = "Mocha (Very Dark)", id = "Catppuccin Mocha" },
}

-- Mapping from Wezterm theme names to Neovim flavours
local theme_to_nvim_flavour = {
	["Catppuccin Latte"] = "latte",
	["Catppuccin Frappe"] = "frappe",
	["Catppuccin Macchiato"] = "macchiato",
	["Catppuccin Mocha"] = "mocha",
}

-- Set environment variable for Neovim based on stored theme
config.set_environment_variables = {
	CATPPUCCIN_FLAVOUR = stored_theme,
}

-- Function to apply theme-specific tab bar colors
local function get_tab_bar_colors(theme_name)
	local palette = catppuccin_palettes[theme_name]
	if not palette then
		return nil
	end

	return {
		background = palette.crust,
		active_tab = {
			bg_color = palette.blue,
			fg_color = palette.crust,
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = palette.mantle,
			fg_color = palette.subtext1,
		},
		inactive_tab_hover = {
			bg_color = palette.surface0,
			fg_color = palette.text,
		},
		new_tab = {
			bg_color = palette.mantle,
			fg_color = palette.text,
		},
		new_tab_hover = {
			bg_color = palette.surface0,
			fg_color = palette.text,
		},
		inactive_tab_edge = palette.surface0,
	}
end

-- Function to get window frame colors
local function get_window_frame_colors(theme_name)
	local palette = catppuccin_palettes[theme_name]
	if not palette then
		return nil
	end

	return {
		active_titlebar_bg = palette.crust,
		inactive_titlebar_bg = palette.mantle,
	}
end

-- Apply colors based on stored theme
local startup_wezterm_theme = theme_to_wezterm[stored_theme] or "Catppuccin Mocha"
local startup_tab_bar_colors = get_tab_bar_colors(startup_wezterm_theme)
local startup_frame_colors = get_window_frame_colors(startup_wezterm_theme)

config.colors = {
	tab_bar = startup_tab_bar_colors,
}

if startup_frame_colors then
	config.window_frame.active_titlebar_bg = startup_frame_colors.active_titlebar_bg
	config.window_frame.inactive_titlebar_bg = startup_frame_colors.inactive_titlebar_bg
end

-- ╔════════════════════════════════════════════════════════════════════════════════╗
-- ║                    KEYBINDINGS & SMART-SPLITS INTEGRATION                      ║
-- ╚════════════════════════════════════════════════════════════════════════════════╝
--
-- IMPORTANT: This configuration integrates wezterm pane navigation with nvim's smart-splits plugin.
--
-- HOW IT WORKS:
-- • Ctrl+h/j/k/l - Smart routing based on active process:
--   - If nvim/vim is running: keystroke is sent to nvim for smart-splits to navigate splits
--   - If nvim/vim is NOT running: wezterm navigates between panes
--
-- • Alt+h/j/k/l  - Unified resizing (works in both contexts):
--   - In nvim: resizes nvim splits (handled by smart-splits in nvim config)
--   - In wezterm: resizes wezterm panes (wezterm-level pane resizing)
--   - Same keybindings for both = less to remember!
--
-- RESULT: Seamless, unified navigation experience across nvim splits and wezterm panes!
-- 
-- TROUBLESHOOTING:
-- If Ctrl+hjkl doesn't work in nvim splits:
-- 1. Ensure smart-splits.nvim is installed and configured (it should be)
-- 2. Verify nvim is detected: Check if pane shows 'nvim' in the process name
-- 3. Try reloading wezterm config: Cmd+Option+R on macOS
-- 4. If still stuck, ensure nvim keymaps are set (check init.lua around line 1240)
--
-- Pane operations keybindings
config.keys = {
	-- Workspace operations with Ctrl+Shift+S leader
	{
		key = "s",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateKeyTable({ name = "workspace", one_shot = true }),
	},

	-- COMMENTED OUT: Direct Ctrl+hjkl pane navigation
	-- Previous implementation that intercepted Ctrl+hjkl at the wezterm level
	-- REASON FOR COMMENTING: This prevented nvim's smart-splits plugin from working
	-- because wezterm would intercept the key before nvim could receive it.
	-- 
	-- NEW BEHAVIOR: Ctrl+hjkl is now handled by smart-splits.nvim with wezterm integration.
	-- When nvim is running, Ctrl+hjkl navigates nvim splits via smart-splits.
	-- When nvim is NOT running, we use a callback to switch wezterm panes.
	-- See the smart-splits integration section below for the new implementation.
	--
	-- { key = "h", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Left") },
	-- { key = "j", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Down") },
	-- { key = "k", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Up") },
	-- { key = "l", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Right") },

	-- Smart-splits.nvim integration for Ctrl+hjkl navigation
	-- These bindings detect if nvim is running in the current pane.
	-- If nvim is active: the keystroke is sent to nvim for smart-splits to handle split navigation
	-- If nvim is NOT active: wezterm navigates to adjacent panes
	-- This allows seamless navigation between nvim splits and wezterm panes!
	{
		key = "h",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local foreground = pane:get_foreground_process_name()
			-- Check if nvim/vim is running in this pane
			if foreground and (foreground:find("nvim") or foreground:find("vim")) then
				-- Send to nvim - smart-splits will handle it
				pane:send_text("\x1b[104;5u", false) -- Ctrl+h
			else
				-- Navigate wezterm panes
				window:perform_action(wezterm.action.ActivatePaneDirection("Left"), pane)
			end
		end),
	},
	{
		key = "j",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local foreground = pane:get_foreground_process_name()
			if foreground and (foreground:find("nvim") or foreground:find("vim")) then
				pane:send_text("\x1b[106;5u", false) -- Ctrl+j
			else
				window:perform_action(wezterm.action.ActivatePaneDirection("Down"), pane)
			end
		end),
	},
	{
		key = "k",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local foreground = pane:get_foreground_process_name()
			if foreground and (foreground:find("nvim") or foreground:find("vim")) then
				pane:send_text("\x1b[107;5u", false) -- Ctrl+k
			else
				window:perform_action(wezterm.action.ActivatePaneDirection("Up"), pane)
			end
		end),
	},
	{
		key = "l",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local foreground = pane:get_foreground_process_name()
			if foreground and (foreground:find("nvim") or foreground:find("vim")) then
				pane:send_text("\x1b[108;5u", false) -- Ctrl+l
			else
				window:perform_action(wezterm.action.ActivatePaneDirection("Right"), pane)
			end
		end),
	},

	-- Split panes (inherit current working directory)
	{ key = "d", mods = "CMD", action = wezterm.action.SplitPane({ direction = "Right" }) },
	{ key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitPane({ direction = "Down" }) },
	-- Close pane
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

	-- Smart-splits.nvim integration for Alt+hjkl resizing
	-- These bindings detect if nvim is running in the current pane.
	-- If nvim is active: the keystroke is sent to nvim for smart-splits to handle split resizing
	-- If nvim is NOT active: wezterm resizes panes
	-- This allows unified Alt+hjkl resizing in both nvim splits and wezterm panes!
	{
		key = "h",
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			local foreground = pane:get_foreground_process_name()
			-- Check if nvim/vim is running in this pane
			if foreground and (foreground:find("nvim") or foreground:find("vim")) then
				-- Send to nvim - smart-splits will handle resizing the split
				pane:send_text("\x1b[104;3u", false) -- Alt+h
			else
				-- Resize wezterm pane
				window:perform_action(wezterm.action.AdjustPaneSize({ "Left", 5 }), pane)
			end
		end),
	},
	{
		key = "j",
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			local foreground = pane:get_foreground_process_name()
			if foreground and (foreground:find("nvim") or foreground:find("vim")) then
				pane:send_text("\x1b[106;3u", false) -- Alt+j
			else
				window:perform_action(wezterm.action.AdjustPaneSize({ "Down", 5 }), pane)
			end
		end),
	},
	{
		key = "k",
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			local foreground = pane:get_foreground_process_name()
			if foreground and (foreground:find("nvim") or foreground:find("vim")) then
				pane:send_text("\x1b[107;3u", false) -- Alt+k
			else
				window:perform_action(wezterm.action.AdjustPaneSize({ "Up", 5 }), pane)
			end
		end),
	},
	{
		key = "l",
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			local foreground = pane:get_foreground_process_name()
			if foreground and (foreground:find("nvim") or foreground:find("vim")) then
				pane:send_text("\x1b[108;3u", false) -- Alt+l
			else
				window:perform_action(wezterm.action.AdjustPaneSize({ "Right", 5 }), pane)
			end
		end),
	},
	-- Open theme switcher with Ctrl+Shift+T
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = wezterm.action.InputSelector({
			action = wezterm.action_callback(function(window, pane, id, label)
				if not id and not label then
					wezterm.log_info("Cancelled theme selection")
				else
					-- Get the nvim flavour from the mapping
					local nvim_flavour = theme_to_nvim_flavour[id]

					if nvim_flavour then
						-- Get current overrides or create empty table
						local overrides = window:get_config_overrides() or {}
						-- Set the color scheme
						overrides.color_scheme = id

						-- Apply theme-specific tab bar colors
						local tab_bar_colors = get_tab_bar_colors(id)
						if tab_bar_colors then
							overrides.colors = {
								tab_bar = tab_bar_colors,
							}
						end

						-- Apply theme-specific window frame colors
						local frame_colors = get_window_frame_colors(id)
						if frame_colors then
							overrides.window_frame = {
								font = wezterm.font({ family = "Roboto", weight = "Bold" }),
								font_size = 12.0,
								active_titlebar_bg = frame_colors.active_titlebar_bg,
								inactive_titlebar_bg = frame_colors.inactive_titlebar_bg,
							}
						end

						-- Set environment variable for Neovim (for new panes)
						overrides.set_environment_variables = {
							CATPPUCCIN_FLAVOUR = nvim_flavour,
						}

						-- Write theme to file for all applications to read
						local home = os.getenv("HOME")
						if home then
							local theme_file = home .. "/.config/catppuccin-theme"
							local f = io.open(theme_file, "w")
							if f then
								f:write(nvim_flavour)
								f:close()
								wezterm.log_info("Wrote theme to " .. theme_file)
							end
						end

					-- Apply the overrides
					window:set_config_overrides(overrides)

					-- Reload Oh-my-posh silently in all panes using the shell function
					local tab = window:active_tab()
					if tab then
						for _, pane in ipairs(tab:panes()) do
							pane:send_text("_reload_prompt\n", false)
						end
					end

					-- Log for debugging
					wezterm.log_info("Set theme to " .. id .. " with nvim flavour " .. nvim_flavour)
					end
				end
			end),
			title = "Select Catppuccin Theme",
			choices = themes,
		}),
	},
}

-- Define workspace key table
config.key_tables = {
	workspace = {
		{ key = "o", action = wezterm.action.ShowLauncher },
		{ key = "d", action = wezterm.action.SwitchToWorkspace({ name = "deno-course" }) },
		{ key = "t", action = wezterm.action.SwitchToWorkspace({ name = "the-dawg-house" }) },
		{ key = "Escape", action = wezterm.action.PopKeyTable },
	},
}

-- Apply stored theme to new windows when they are created
-- Skip for the first window since config already handles it
local is_first_window = true
wezterm.on("window-created", function(window)
	if is_first_window then
		is_first_window = false
		return
	end

	-- Read the theme file fresh for subsequent windows
	local home = os.getenv("HOME")
	local theme = "mocha" -- default
	if home then
		local theme_file = home .. "/.config/catppuccin-theme"
		local f = io.open(theme_file, "r")
		if f then
			theme = f:read("*a"):gsub("%s+", "")
			f:close()
		end
	end

	-- Map theme to WezTerm color scheme
	local theme_map = {
		latte = "Catppuccin Latte",
		frappe = "Catppuccin Frappe",
		macchiato = "Catppuccin Macchiato",
		mocha = "Catppuccin Mocha",
	}
	local wezterm_theme = theme_map[theme] or "Catppuccin Mocha"

	-- Apply the theme to this window
	local overrides = {}
	overrides.color_scheme = wezterm_theme
	overrides.colors = {
		tab_bar = get_tab_bar_colors(wezterm_theme),
	}
	local frame_colors = get_window_frame_colors(wezterm_theme)
	if frame_colors then
		overrides.window_frame = {
			font = wezterm.font({ family = "Roboto", weight = "Bold" }),
			font_size = 12.0,
			active_titlebar_bg = frame_colors.active_titlebar_bg,
			inactive_titlebar_bg = frame_colors.inactive_titlebar_bg,
		}
	end
	overrides.set_environment_variables = {
		CATPPUCCIN_FLAVOUR = theme,
	}
	window:set_config_overrides(overrides)
end)

-- Set up workspaces on startup
wezterm.on("gui-startup", function()
	local mux = wezterm.mux

	-- Create deno-course workspace
	mux.spawn_window({
		workspace = "deno-course",
		cwd = "/Users/brucemcelroy/Code/Learning/Deno/deno-course",
	})

	-- Create the-dawg-house workspace
	mux.spawn_window({
		workspace = "the-dawg-house",
		cwd = "/Users/brucemcelroy/Code/Freelance/the-dawg-house",
	})
end)

-- Helper function to update status bar
-- Helper function to update status bar
local function update_status(window)
	-- Get the current workspace name
	local workspace = window:active_workspace()
	if not workspace or workspace == "" then
		workspace = "default"
	end

	-- Get current date and time in Eastern timezone
	local date = wezterm.strftime("%a %b %-d")
	-- Get time in 12-hour format with AM/PM (10:46 AM style)
	local time = os.date("%I:%M %p")

	-- Get battery info
	local battery = ""
	local battery_icon = ""
	for _, b in ipairs(wezterm.battery_info()) do
		if b.state == "Charging" then
			battery_icon = "󰂄"
		elseif b.state == "Discharging" then
			battery_icon = "󰁹"
		else
			battery_icon = "󰚥"
		end
		battery = string.format("%s %d%%", battery_icon, math.floor(b.state_of_charge * 100))
	end

	-- Separator character with more spacing
	local sep = "   •   "

	-- Determine text color based on current theme
	local overrides = window:get_config_overrides() or {}
	local effective_config = window:effective_config()
	local current_scheme = effective_config.color_scheme or "Catppuccin Mocha"

	-- Use dark text for light theme, light text for dark themes
	local text_color
	if current_scheme == "Catppuccin Latte" then
		-- Light theme - use dark text for contrast
		text_color = { Color = "#4c4f69" }
	else
		-- Dark themes - use light text
		text_color = { Foreground = { AnsiColor = "White" } }
	end

	-- Build the unified status bar with theme-appropriate color
	local status = wezterm.format({
		text_color,
		{ Text = "  󰠱  " .. workspace .. sep .. "󰃭  " .. date .. sep .. "󰥔  " .. time },
	})

	-- Add battery if available
	if battery ~= "" then
		status = status .. wezterm.format({
			text_color,
			{ Text = sep .. battery },
		})
	end

	-- Add trailing space
	status = status .. wezterm.format({
		text_color,
		{ Text = "  " },
	})

	window:set_right_status(status)
end

-- Update status bar on the update-right-status event
wezterm.on("update-right-status", function(window, pane)
	update_status(window)
end)

-- Also update on key/activity
wezterm.on("update-status", function(window, pane)
	update_status(window)
end)

-- Ensure new windows pick up the latest theme from the stored theme file
wezterm.on("window-config-reloaded", function(window, pane)
	local home = os.getenv("HOME")
	if home then
		local theme_file = home .. "/.config/catppuccin-theme"
		local f = io.open(theme_file, "r")
		if f then
			local theme = f:read("*a"):gsub("%s+", "")
			f:close()
			
			local overrides = window:get_config_overrides() or {}
			overrides.color_scheme = theme_to_wezterm[theme] or "Catppuccin Mocha"
			
			-- Set environment variable for the shell
			local nvim_flavour = theme_to_nvim_flavour[theme_to_wezterm[theme]]
			if nvim_flavour then
				overrides.set_environment_variables = {
					CATPPUCCIN_FLAVOUR = nvim_flavour,
				}
			end
			
			window:set_config_overrides(overrides)
		end
	end
end)

return config


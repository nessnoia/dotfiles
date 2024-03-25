-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = {}

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'One Half Black (Gogh)'
config.font = wezterm.font 'Menlo'
config.font_size = 13

-- and finally, return the configuration to wezterm
return config


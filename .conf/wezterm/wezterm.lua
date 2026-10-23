local wezterm = require("wezterm")
local config = {}

-- OS check
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_mac = wezterm.target_triple:find("apple") ~= nil

-- OS specific configs
-- Windows
if is_windows then

    -- set portable path base from wezterm
    local current_dir = wezterm.config_dir
    local username_dir = current_dir .. "/../../"

    -- set git path
    local git_bash_path = username_dir .. "tools/git/bin/bash.exe"

    -- set default program using git & working dir to <USERNAME> folder
    config.default_prog = { git_bash_path, '--login' }
    config.default_cwd = username_dir

    -- force git to use <USERNAME> as $HOME
    config.set_environment_variables = {
        HOME = username_dir,
        XDG_CONFIG_HOME = username_dir .. ".config",
        XDG_DATA_HOME = username_dir .. ".local/share",
        XDG_STATE_HOME = username_dir .. ".local/state",
        XDG_CACHE_HOME = username_dir .. ".cache",
    }

    -- fonts
    config.font_dirs = { username_dir .. "tools/fonts" }

-- Mac
elseif is_mac then
    config.default_prog = { "/bin/zsh", "--login" }
-- Linux
else
    config.default_prog = { "/bin/bash", "--login" }
end

-- Global configs
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font_with_fallback({
    'JetBrainsMonoNL Nerd Font Mono',
    'DejaVu Sans Mono',
    'Monospace',
})
config.font_size = 12.0
config.audible_bell = "Disabled"

-- Custom keyboard shortcuts
config.keys = {}

-- Windows only
if is_windows then
    config.keys = {
        {
            key = 'c',
            mods = 'CTRL|SHIFT|ALT',
            action = wezterm.action.SpawnCommandInNewTab {
                args = { 'cmd.exe' },
            },
        },

        {
            key = 'p',
            mods = 'CTRL|SHIFT|ALT',
            action = wezterm.action.SpawnCommandInNewTab {
                args = { 'pwsh.exe' },
            },
        }
    }
end

-- Custom mouse bindings
config.mouse_bindings = {
    {
        event = { Down = { streak = 1, button = "Left" } },
        mods = "ALT",
        action = wezterm.action.SelectTextAtMouseCursor("Block"),
    }, 

    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "ALT",
        action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
    },

    {
        event = { Up = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action.PasteFrom("Clipboard"),
    }
}

config.scrollback_lines = 50000

return config

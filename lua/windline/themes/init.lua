local wind_theme = require('windline.themes.wind')
local M = {}

local cache_theme = {}

M.default_theme = nil

local get_default_theme = function()
    return vim.deepcopy(M.default_theme or wind_theme)
end

M.load_theme = function(name)
    name = name or vim.g.colors_name
    if not name then return get_default_theme() end
    local cache_name = name .. '_' .. (vim.o.background or '')
    if cache_theme[cache_name] then
        return cache_theme[cache_name]
    end
    local ok, colors = pcall(require, 'windline.themes.' .. name)
    if not ok then
        ok, colors = pcall(M.generate_theme)
        if not ok then colors = get_default_theme() end
    else
        colors = vim.deepcopy(colors)
    end
    cache_theme[cache_name] = colors
    return colors
end

M.clear_cache = function()
    cache_theme = {}
end

M.get_hl_color = function(hl)
    local cmd = vim.api.nvim_exec('highlight ' .. hl, true)
    local _, _, bg = string.find(cmd, 'guibg%=(%#%w*)')
    local _, _, fg = string.find(cmd, 'guifg%=(%#%w*)')
    if string.match(cmd, 'gui%=reverse') then
        return bg, fg
    end
    return fg, bg
end

M.generate_theme = function()
    local default = get_default_theme()
    local colors = {
        black                  = vim.g.terminal_color_0,
        red                    = vim.g.terminal_color_1,
        green                  = vim.g.terminal_color_2,
        yellow                 = vim.g.terminal_color_3,
        blue                   = vim.g.terminal_color_4,
        magenta                = vim.g.terminal_color_5,
        cyan                   = vim.g.terminal_color_6,
        white                  = vim.g.terminal_color_7,
        black_light            = vim.g.terminal_color_8,
        red_light              = vim.g.terminal_color_9,
        green_light            = vim.g.terminal_color_10,
        yellow_light           = vim.g.terminal_color_11,
        blue_light             = vim.g.terminal_color_12,
        magenta_light          = vim.g.terminal_color_13,
        cyan_light             = vim.g.terminal_color_14,
        white_light            = vim.g.terminal_color_15,
    }

    local fgNormal, bgNormal = M.get_hl_color('Normal')
    colors.NormalFg = fgNormal or colors.white_light
    colors.NormalBg = bgNormal or colors.black_light

    local fgInactive, bgInactive = M.get_hl_color('StatusLineNC')
    colors.InactiveFg = fgInactive or colors.white_light
    colors.InactiveBg = bgInactive or colors.black_light

    local fgActive, bgActive = M.get_hl_color('StatusLine')
    colors.ActiveFg = fgActive or colors.white
    colors.ActiveBg = bgActive or colors.black

    return vim.tbl_extend('keep', colors, default)
end

return M

local windline = require('windline')
local state = windline.state
local M = {}

M.git_changes = function()
    return function()
        return vim.b.gitsigns_status or ''
    end
end
M.is_git = function()
    local git_dict = vim.b.gitsigns_status_dict
    if git_dict and git_dict.head and #git_dict.head > 0 then
        return true
    end
    return false
end

M.git_branch = function(opt)
    opt = opt or{}
    return function()
        local git_dict = vim.b.gitsigns_status_dict
        if git_dict and git_dict.head and #git_dict.head > 0 then
            state.git_branch = git_dict.head
            local icon = opt.icon or '  '
            return icon .. git_dict.head
        end
        return ''
    end
end

M.diff_added = function(opt)
    opt = opt or {}
    local format = opt.format or '%s'
    return function()
        local git_dict = vim.b.gitsigns_status_dict
        if git_dict and git_dict.head and #git_dict.head > 0 then
            local value = git_dict.added or 0
            if value > 0 or value == 0 and opt.show_zero == true then
                return string.format(format, value)
            end
            return ''
        end
        return ''
    end
end

M.diff_removed = function(opt)
    opt = opt or {}
    local format = opt.format or '%s'
    return function()
        local git_dict = vim.b.gitsigns_status_dict
        if git_dict and git_dict.head and #git_dict.head > 0 then
            local value = git_dict.removed or 0
            if value > 0 or value == 0 and opt.show_zero == true then
                return string.format(format, value)
            end
        end
        return ''
    end
end

M.diff_changed = function(opt)
    opt = opt or {}
    local format = opt.format or '%s'
    return function()
        local git_dict = vim.b.gitsigns_status_dict
        if git_dict and git_dict.head and #git_dict.head > 0 then
            local value = git_dict.changed or 0
            if value > 0 or value == 0 and opt.show_zero == true then
                return string.format(format, value)
            end
        end
        return ''
    end
end

M.git_changes = function()
    return function()
        return vim.b.gitsigns_status or ''
    end
end

return M
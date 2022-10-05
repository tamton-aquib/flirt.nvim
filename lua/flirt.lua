local F = {}
F.opts = {
    override_open = true,
    close_command = 'Q',
    default_resize_mappings = true,
    default_move_mappings = true,
    exclude_fts = { 'cmp_menu', 'TelescopePrompt', 'prompt', 'hydra_hint' },
    custom_filter = function(buf, cfg) end,
}
local _open_win

F.open = function(buf, enter, ...)
    local cfg = ({...})[1]
    local cfg_bak = vim.deepcopy(cfg)

    local done = {h=false, w=false}

    cfg_bak["height"], cfg_bak["width"]= 1, 1
    local win

    if vim.tbl_contains(F.opts.exclude_fts, vim.bo[buf].ft)
        or F.opts.custom_filter(buf, cfg) then

        return _open_win(buf, enter, cfg)
    else
        win = _open_win(buf, enter, cfg_bak)
    end

    local timer = vim.loop.new_timer()
    timer:start(50, 10, vim.schedule_wrap(function()
        if done.w and done.h then
            timer:stop()
            return
        end

        if not vim.api.nvim_win_is_valid(win) then return end
        local config = vim.api.nvim_win_get_config(win)

        if config["height"] >= cfg.height then
            done.h = true
        else
            config["height"] = config["height"] + 1
        end

        if config["width"] >= cfg.width then
            done.w = true
        else
            config["width"] = config["width"] + 1
        end

        vim.api.nvim_win_set_config(win, config)
    end))
    return win
end

F.close = function()
    local conf = vim.api.nvim_win_get_config(0)
    local done = {w=false, h=false}
    if conf.relative == "" then return end

    local timer = vim.loop.new_timer()
    timer:start(100, 10, vim.schedule_wrap(function()
        if done.h and done.w then
            vim.api.nvim_win_close(0, {force=true})
            timer:stop()
            return
        end
        conf = vim.api.nvim_win_get_config(0)
        if conf["height"] <= 1 then
            done.h = true
        else
            conf["height"] = conf["height"] - 1
            vim.api.nvim_win_set_config(0, conf)
        end
        if conf["width"] <= 1 then
            done.w = true
        else
            conf["width"] = conf["width"] - 1
            vim.api.nvim_win_set_config(0, conf)
        end
    end))
end

F.move = function(dir)
    local conf = vim.api.nvim_win_get_config(0)
    if conf.relative == "" then return end
    local row, col = conf["row"][false], conf["col"][false]

	if dir == "down" and (row + conf.height) < vim.o.lines then
		row = row + 1
	elseif dir == "up" and row > 0 then
		row = row - 1
	elseif dir == "left" and col > 0 then
		col = col - 1
	elseif dir == "right" and (col+conf.width) < vim.o.columns then
		col = col + 1
	end

    conf["row"][false], conf["col"][false] = row, col
    vim.api.nvim_win_set_config(0, conf)
end

F.setup = function(opts)
    F.opts = vim.tbl_deep_extend("force", F.opts, opts or {})
    _open_win = vim.api.nvim_open_win

    if F.opts.override_open then
        vim.api.nvim_open_win = F.open
    end

    vim.api.nvim_create_user_command(F.opts.close_command or 'Q', F.close, {})

    if opts.default_move_mappings then
        vim.keymap.set('n', '<C-down>', function() F.move("down") end, {})
        vim.keymap.set('n', '<C-up>', function()  F.move("up") end, {})
        vim.keymap.set('n', '<C-left>', function() F.move("left") end, {})
        vim.keymap.set('n', '<C-right>', function()  F.move("right") end, {})
    end

    if opts.default_resize_mappings then
        vim.keymap.set('n', '<A-up>', '<cmd>res -1<cr>', {})
        vim.keymap.set('n', '<A-down>', '<cmd>res +1<cr>', {})
        vim.keymap.set('n', '<A-left>', '<cmd>vert res -1<cr>', {})
        vim.keymap.set('n', '<A-right>', '<cmd>vert res +1<cr>', {})
    end
end

return F

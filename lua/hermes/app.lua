local Popup = require("nui.popup")
local request = require("hermes.request")
local Layout = require("nui.layout")
local M = {}

M._state = {
    authorization = nil,
    output_bufnr = nil,
    layout = nil,
}

--- @param bearer string|nil
M.set_bearer_token = function(bearer)
    M._state.authorization = { bearer = bearer }
end

M.init = function()
    local input = Popup({
        border = "rounded",
        enter = true,
    })

    input:map("n", "<CR>", function()
        local text = vim.api.nvim_buf_get_lines(
            vim.api.nvim_get_current_buf(),
            0,
            -1,
            true
        )[1]

        local request_data = vim.split(text, " ")
        M.send_request({
            method = request_data[1],
            url = request_data[2],
        })
    end, { noremap = true })

    local output = Popup({
        border = "rounded",
    })

    M._state.output_bufnr = output.bufnr

    local layout = Layout(
        {
            position = "50%",
            size = {
                width = "50%",
                height = "50%",
            },
        },
        Layout.Box({
            Layout.Box(input, { size = "10%" }),
            Layout.Box(output, { size = "90%" }),
        }, { dir = "col" })
    )

    layout:mount()
    M._state.layout = { state = "show", layout = layout }
    -- set line numbers for the response
    vim.api.nvim_win_set_option(output.winid, "number", true)
end

M.hide = function()
    if M._state.layout == nil then
        return
    end
    M._state.layout.layout:unmount()
    M._state.layout = nil
end

-- TODO: set auth token
--- TODO: support post put and patch
M.send_request = function(opts)
    if opts.method == nil then
        vim.notify("Request method is required", vim.log.levels.ERROR)
        return
    end

    if opts.url == nil then
        vim.notify("Request url is required", vim.log.levels.ERROR)
        return
    end

    if opts.method == "GET" then
        local response = request.get(opts.url, opts)
        vim.api.nvim_buf_set_lines(
            M._state.output_bufnr,
            0,
            -1,
            true,
            vim.split(response or "", "\n")
        )
    end

    if opts.method == "POST" then
        local response = request.post(opts.url, opts)
        vim.api.nvim_buf_set_lines(
            M._state.output_bufnr,
            0,
            -1,
            true,
            vim.split(response or "", "\n")
        )
    end

    if opts.method == "PUT" then
        local response = request.put(opts.url, opts)
        vim.api.nvim_buf_set_lines(
            M._state.output_bufnr,
            0,
            -1,
            true,
            vim.split(response or "", "\n")
        )
    end

    if opts.method == "PATCH" then
        local response = request.put(opts.url, opts)
        vim.api.nvim_buf_set_lines(
            M._state.output_bufnr,
            0,
            -1,
            true,
            vim.split(response or "", "\n")
        )
    end
end

return M

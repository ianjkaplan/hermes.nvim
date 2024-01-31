local M = {}
local curl = require("plenary.curl")

--- @param url string
--- @param opts table
function M.get(url, opts)
    local response =
        curl.get(url, { accept = "application/json", query = opts.query or {} })
    if response.status >= 400 then
        vim.notify(
            "Request failed with status " .. response.status,
            vim.log.levels.ERROR
        )
        return
    end

    return response.body
end

--- @param url string
--- @param opts table
function M.post(url, opts)
    local response =
        curl.post(url, { accept = "application/json", body = opts.body or {} })
    if response.status >= 400 then
        vim.notify(
            "Request failed with status " .. response.status,
            vim.log.levels.ERROR
        )
        return
    end

    return response.body
end

--- @param url string
--- @param opts table
function M.put(url, opts)
    local response =
        curl.put(url, { accept = "application/json", body = opts.body or {} })
    if response.status >= 400 then
        vim.notify(
            "Request failed with status " .. response.status,
            vim.log.levels.ERROR
        )
        return
    end

    return response.body
end

--- @param url string
--- @param opts table
function M.patch(url, opts)
    local response =
        curl.patch(url, { accept = "application/json", body = opts.body or {} })
    if response.status >= 400 then
        vim.notify(
            "Request failed with status " .. response.status,
            vim.log.levels.ERROR
        )
        return
    end

    return response.body
end

return M

local app = require("hermes.app")
local M = {}

function M.setup()
    vim.api.nvim_create_user_command("HermesShowUI", function()
        app.init()
    end, {
        desc = "Show Hermes UI",
        nargs = 0,
    })
    vim.api.nvim_create_user_command("HermesHideUi", function()
        app.hide()
    end, {

        desc = "Hide Hermes Ui ",
        nargs = 0,
    })
    vim.api.nvim_create_user_command("HermesSetBearerToken", function(opts)
        if #opts.fargs ~= 1 then
            vim.notify(
                "SetBearerToken requires 1 argument",
                vim.log.levels.ERROR
            )
            return
        end

        app.set_bearer_token(opts.fargs[1])
    end, {
        desc = "Set authorization token",
        nargs = 1,
    })

    vim.api.nvim_create_user_command("HermesClearBearerToken", function()
        app.set_bearer_token(nil)
    end, {
        desc = "Clear authorization token",
        nargs = 0,
    })
end

return M

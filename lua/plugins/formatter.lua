return {
  "mhartington/formatter.nvim",
  config = function()
    local util = require("formatter.util")

    local settings = {
      lua = {
        require("formatter.filetypes.lua").stylua,
      },
      typescriptreact = {
        require("formatter.filetypes.typescript").prettier,
      },
      vue = {
        require("formatter.filetypes.typescript").prettier,
      },
      cpp = {
        require("formatter.filetypes.cpp").clangformat,
      },
      typescript = {
        require("formatter.filetypes.typescript").prettier,
      },
      css = {
        require("formatter.filetypes.css").prettier,
      },
      graphql = {
        require("formatter.filetypes.graphql").prettier,
      },
      dart = {
        require("formatter.filetypes.dart").dartformat({
          line_length = 120,  -- uprav podle potřeby na 160, 120, atp.
        }),
      },
      ["*"] = {
        require("formatter.filetypes.any").remove_trailing_whitespace,
      },
    }

    require("formatter").setup({
      logging    = true,
      log_level  = vim.log.levels.WARN,
      filetype   = settings,
    })

    vim.keymap.set("n", "<leader>f", function()
      local ft = vim.bo.filetype
      if settings[ft] then
        -- použij formatter.nvim, který pro Dart vrací výstup na stdout
        vim.cmd("Format")
      else
        -- fallback na LSP formatting
        vim.lsp.buf.format({
          filter = function(client)
            if client.name == "dartls" then
              for _, c in ipairs(vim.lsp.get_active_clients()) do
                if c.name == "dcmls" then
                  return false
                end
              end
            end
            return true
          end,
        })
      end
    end, { noremap = true, silent = true, desc = "Format buffer" })
  end,
}

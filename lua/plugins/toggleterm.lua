return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 12,
      open_mapping = [[<C-\>]],   -- Ctrl+\ pour ouvrir/fermer le terminal
      direction = "horizontal",
      shade_terminals = true,
    })

    local Terminal = require("toggleterm.terminal").Terminal
    local runner = Terminal:new({
      direction = "horizontal",
      close_on_exit = false,
      hidden = true,
    })

    local function run_current_file()
      local ft = vim.bo.filetype
      local file = vim.fn.expand("%")
      if file == "" then
        vim.notify("Pas de fichier à exécuter (buffer sans nom)", vim.log.levels.WARN)
        return
      end

      local cmd
      if ft == "python" then
        cmd = "python " .. file
      elseif ft == "sh" or ft == "bash" then
        cmd = "bash " .. file
      else
        vim.notify("Aucune commande définie pour le filetype: " .. ft, vim.log.levels.WARN)
        return
      end

      vim.cmd("write")           -- sauvegarde avant exécution
      runner:toggle()            -- ouvre le terminal si fermé
      runner:send(cmd .. "\r")   -- envoie la commande
    end

    -- vim.keymap.set("n", "<leader>r", run_current_file, { desc = "Run current file" })
  end,
}


-- On définit notre touche leader sur espace
vim.g.mapleader = " "

-- Raccourci pour la fonction set
local keymap = vim.keymap.set

-- on utilise ;; pour sortir du monde insertion
keymap("i", ";;", "<ESC>", { desc = "Sortir du mode insertion avec ;;" })

-- on efface le surlignage de la recherche
keymap("n", "<leader>nh", ":nohl<CR>", { desc = "Effacer le surlignage de la recherche" })

-- I déplace le texte sélectionné vers le haut en mode visuel (activé avec v)
keymap("v", "<S-i>", ":m .-2<CR>==", { desc = "Déplace le texte sélectionné vers le haut en mode visuel" })
-- K déplace le texte sélectionné vers le bas en mode visuel (activé avec v)
keymap("v", "<S-k>", ":m .+1<CR>==", { desc = "Déplace le texte sélectionné vers le bas en mode visuel" })

-- I déplace le texte sélectionné vers le haut en mode visuel bloc (activé avec V)
keymap(
	"x",
	"<S-i>",
	":move '<-2<CR>gv-gv",
	{ desc = "Déplace le texte sélectionné vers le haut en mode visuel bloc" }
)
-- K déplace le texte sélectionné vers le bas en mode visuel (activé avec V)
keymap(
	"x",
	"<S-k>",
	":move '>+1<CR>gv-gv",
	{ desc = "Déplace le texte sélectionné vers le bas en mode visuel bloc" }
)

-- Changement de fenêtre avec Ctrl + déplacement uniquement au lieu de Ctrl-w + déplacement
keymap("n", "<C-h>", "<C-w>h", { desc = "Déplace le curseur dans la fenêtre de gauche" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Déplace le curseur dans la fenêtre du bas" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Déplace le curseur dans la fenêtre du haut" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Déplace le curseur dans la fenêtre droite" })


-- Navigation entre les buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

vim.keymap.set("n", "<leader>r", function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:p")   -- chemin absolu
  if file == "" then
    vim.notify("Pas de fichier à exécuter (buffer sans nom)", vim.log.levels.WARN)
    return
  end

  -- Commande sous forme de liste => pas de problème avec les espaces, /, \
  local cmd

  if ft == "python" then
    cmd = { "python", file }
  elseif ft == "sh" or ft == "bash" then
    cmd = { "bash", file }
  else
    vim.notify("Aucune commande définie pour le type de fichier: " .. ft, vim.log.levels.WARN)
    return
  end

  vim.cmd("write")

  -- split en bas + terminal
  vim.cmd("botright 12new")
  -- On lance la commande dans ce nouveau buffer terminal
  local term_buf = vim.api.nvim_get_current_buf()
  vim.fn.termopen(cmd, {
    cwd = vim.fn.fnamemodify(file, ":h"), -- répertoire du fichier
  })
   -- On évite de polluer la liste de buffers
  vim.bo[term_buf].buflisted = false
  vim.cmd("startinsert")
end, { desc = "Exécuter le fichier courant" })


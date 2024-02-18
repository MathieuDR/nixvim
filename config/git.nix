{
  config.plugins = {
    fugitive.enable = true;
    gitsigns = {
      enable = true;
      signs = {
        add.text = "+";
        change.text = "~";
        delete.text = "_";
        topdelete.text = "‾";
        changedelete.text = "~";
      };
      onAttach.function = ''
        function(bufnr)
        	vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
        		{ buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        	vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        	vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
        end
      '';
    };
  };
}

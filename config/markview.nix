{
  config.plugins.markview = {
    enable = true;
    settings = {
      mode = ["n" "no" "c"];

      callback = {
        on_disable = ''
          function(buf, win)
              vim.wo[window].conceallevel = 0;
              vim.wo[window].concealcursor = "";
          end
        '';
        on_enable = ''
          function(buf, win)
            vim.wo[window].conceallevel = 2;
            vim.wo[window].concealcursor = "nc";
          end
        '';
      };
    };
  };

  config.keymaps = [
    {
      mode = "n";
      key = "<leader>mt";
      action = ":Markview toggle<CR>";
      options = {
        desc = "[M]arkview [T]oggle";
      };
    }
  ];
}

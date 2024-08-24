{
  config.plugins.markview = {
    enable = true;
    settings = {
      hybrid_modes = ["i"];
      mode = ["n" "no" "i"];
    };
  };

  config.keymaps = [
    {
      mode = "n";
      key = "<leader>mt";
      action = ":Markview toggleAll<CR>";
      options = {
        desc = "[M]arkview [T]oggle all";
      };
    }
  ];
}

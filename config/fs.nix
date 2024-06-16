{
  config.plugins = {
    oil.settings.enable = true;
    neo-tree = {
      enable = true;
      eventHandlers = {
        file_opened = ''
          function()
          	require("neo-tree").close_all()
          end
        '';
      };
    };
  };
  config.keymaps = [
    {
      mode = "n";
      key = "-";
      action = ":Neotree reveal toggle=true position=current<CR>";
      options = {
        desc = "Toggle Neotree";
      };
    }
  ];
}

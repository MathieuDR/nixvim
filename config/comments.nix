{
  config.plugins = {
    comment-nvim.enable = true;
    todo-comments = {
      enable = true;
      keywords = {
        FIX = {
          icon = " ";
          color = "error";
          alt = [ "FIXME" "BUG" "fixme" "fixdocs" "ISSUE" ];
        };
      };
    };
  };

  config.keymaps = [
    {
      mode = "n";
      key = "]t";
      action.__raw = ''
        			function()
        				require("todo-comments").jump_next()
        			end
        			'';
      options = {
        desc = "Next todo comment";
      };
    }
    {
      mode = "n";
      key = "[t";
      action.__raw = ''
        			function()
        				require("todo-comments").jump_prev()
        			end
        			'';
      options = {
        desc = "Previous todo comment";
      };
    }
    {
      mode = "n";
      key = "<leader>tc";
      action = ":TodoTrouble<CR>";
      options = {
        desc = "[T]rouble [C]omments";
      };
    }
    {
      mode = "n";
      key = "<leader>sc";
      action = ":TodoTelescope<CR>";
      options = {
        desc = "[T]elescope [C]omments";
      };
    }

  ];
}

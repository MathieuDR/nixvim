{
  config.plugins = {
    trouble = {
      enable = true;
      settings = {
        # icons = true;
        signs = {
          error = "";
          warning = "";
          hint = "";
          information = "";
          other = "";
        };
      };
    };
  };

  config.keymaps = [
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>trouble diagnostics toggle focus=false filter.buf=0<CR>";
      options = {
        desc = "[T]rouble [T]oggle Diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>td";
      action = "<cmd>trouble symbols toggle<CR>";
      options = {
        desc = "[T]rouble [D]ocument Symbols";
      };
    }
    {
      mode = "n";
      key = "<leader>tf";
      action = "<cmd>trouble fuzzy toggle<CR>";
      options = {
        desc = "[T]rouble Tele[S]cope";
      };
    }
    {
      mode = "n";
      key = "<leader>ts";
      action = "<cmd>trouble telescope toggle<CR>";
      options = {
        desc = "[T]rouble Tele[S]cope";
      };
    }
    {
      mode = "n";
      key = "<leader>tv";
      action = "<cmd>trouble lsp toggle focus=false filter.buf=0<CR>";
      options = {
        desc = "[T]rouble Lsp, current buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>tl";
      action = "<cmd>trouble lsp toggle focus=false<CR>";
      options = {
        desc = "[T]rouble [L]sp";
      };
    }
    {
      mode = "n";
      key = "<leader>tq";
      action = "<cmd>trouble qflist toggle focus=false<CR>";
      options = {
        desc = "[T]rouble [Q]uickfix";
      };
    }
  ];
}

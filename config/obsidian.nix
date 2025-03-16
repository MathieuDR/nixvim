{...}: {
  config = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>ot";
        action = ":ObsidianNewFromTemplate<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [T]emplate";
        };
      }

      {
        mode = "n";
        key = "<leader>oo";
        action = ":ObsidianOpen<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [O]pen";
        };
      }
      {
        mode = "n";
        key = "<leader>ob";
        action = ":ObsidianBacklinks<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [B]acklinks";
        };
      }
      {
        mode = "n";
        key = "<leader>oq";
        action = ":ObsidianQuickSwitch<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [Q]uickswitch";
        };
      }
      {
        mode = "n";
        key = "<leader>ov";
        action = ":ObsidianExtract<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [E]xtract";
        };
      }
      {
        mode = "n";
        key = "<leader>oi";
        action = ":ObsidianPasteImg<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [I]nsert image";
        };
      }
      {
        mode = "n";
        key = "<leader>or";
        action = ":ObsidianRename<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [O]pen";
        };
      }
    ];

    plugins = {
      image = {
        enable = false;
        backend = "kitty";
      };

      which-key.settings.spec = [
        {
          __unkeyed = "<leader>o";
          group = "Obsidian";
        }
      ];

      obsidian = {
        enable = true;
        settings = {
          attachments = {
            img_folder = "assets/img";
          };

          # Generate Zettelkasten-style IDs (YYMMDD-title format)
          note_id_func = ''
            function(title)
              local suffix = ""
              if title ~= nil then
                -- Transform title into valid file name, matching your JS function
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
              else
                -- Add 4 random uppercase letters if no title
                for _ = 1, 4 do
                  suffix = suffix .. string.char(math.random(65, 90))
                end
              end
              return tostring(os.time()) .. "-" .. suffix
            end
          '';

          note_frontmatter_func = ''
            function(note)
              if note.title then
                note:add_alias(note.title)
              end

              local out = {
                id = note.id,
                title = note.title,
                created = os.date("%Y-%m-%d %H:%M"),
                modified = os.date("%Y-%m-%d %H:%M"),
                aliases = note.aliases,
                tags = note.tags
              }

              -- Preserve any existing metadata
              if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                for k, v in pairs(note.metadata) do
                  if k ~= "path" and k ~="modified" then  -- Skip the path since we already handled it
                    out[k] = v
                  end
                end
              end

              return out
            end
          '';

          #Register callbacks for note organization
          callbacks.pre_write_note = ''
            function(client, note)
              -- Skip if no metadata or path
              if not note.metadata or not note.metadata.path then
                return
              end

              -- Get the specified path from metadata
              local target_dir = note.metadata.path

              -- Construct the new path
              local new_path = client.dir / target_dir / note.path.name

              if note.path:exists() then
                note.path:rename(new_path)
              end

              -- Update the note's path
              note.path = new_path

              -- Remove path from metadata
              note.metadata.path = nil
            end
          '';

          templates = {
            date_format = "%Y-%m-%d";
            subdir = "assets/templates/nvim";
            substitutions = {
              datetime = ''
                function()
                  return os.date("%Y-%m-%d %H:%M")
                end
              '';
            };
          };

          ui.enable = false;
          workspaces = [
            {
              name = "personal";
              path = "~/notes/Obsidian";
            }
          ];
        };
      };
    };
  };
}

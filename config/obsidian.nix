{...}: {
  config = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>ot";
        action = ":Obsidian new_from_template<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [T]emplate";
        };
      }
      {
        mode = "n";
        key = "<leader>oo";
        action = ":Obsidian open<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [O]pen";
        };
      }
      {
        mode = "n";
        key = "<leader>ob";
        action = ":Obsidian backlinks<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [B]acklinks";
        };
      }
      {
        mode = "n";
        key = "<leader>oq";
        action = ":Obsidian quick_switch<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [Q]uickswitch";
        };
      }
      {
        mode = "n";
        key = "<leader>oi";
        action = ":Obsidian paste_img<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [I]nsert image";
        };
      }
      {
        mode = "n";
        key = "<leader>or";
        action = ":Obsidian rename<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [R]ename";
        };
      }
      {
        mode = "n";
        key = "<leader>ow";
        action = ":Obsidian workspace<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [W]orkspace";
        };
      }
      {
        mode = "n";
        key = "<leader>of";
        action = ":Obsidian follow_link<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [F]ollow";
        };
      }
      # Step 1 of extract workflow: extract selection to new note (prompts for title → uses your id func)
      {
        mode = "v";
        key = "<leader>oe";
        action = ":Obsidian extract_note<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian [E]xtract";
        };
      }
      # Step 2: once in the new note, apply a template (thought/distilled → routes to slips/ via customizations)
      {
        mode = "n";
        key = "<leader>oT";
        action = ":Obsidian template<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "[O]bsidian insert [T]emplate";
        };
      }
    ];

    plugins = {
      image = {
        enable = false;
        settings.backend = "kitty";
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
          legacy_commands = false;

          attachments.folder = "assets/img";

          note_id_func.__raw = ''
            function(title)
              local suffix = ""
              if title ~= nil then
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
              else
                for _ = 1, 4 do
                  suffix = suffix .. string.char(math.random(65, 90))
                end
              end
              return tostring(os.time()) .. "-" .. suffix
            end
          '';

          frontmatter = {
            sort = ["id" "title" "aliases" "tags" "created" "modified"];
            func.__raw = ''
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
                  tags = note.tags,
                }

                if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                  for k, v in pairs(note.metadata) do
                    if k ~= "path" and k ~= "modified" then
                      out[k] = v
                    end
                  end
                end

                return out
              end
            '';
          };

          templates = {
            date_format = "%Y-%m-%d";
            folder = "assets/templates/nvim";
            substitutions = {
              datetime.__raw = ''
                function()
                  return os.date("%Y-%m-%d %H:%M")
                end
              '';
            };
            customizations = {
              fleeting = {
                notes_subdir = "fleeting";
              };
              thought = {
                notes_subdir = "slips";
              };
              distilled = {
                notes_subdir = "slips";
              };
            };
          };

          ui.enable = false;

          workspaces = [
            {
              name = "personal";
              path = "~/notes/obsidian";
            }
            {
              name = "drakkenheim";
              path = "~/notes/drakkenheim";
            }
            {
              name = "no-vault";
              path.__raw = ''
                function()
                  return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
                end
              '';
              overrides = {
                notes_subdir.__raw = "vim.NIL";
                new_notes_location = "current_dir";
                templates.folder.__raw = "vim.NIL";
                frontmatter.enabled = false;
              };
            }
          ];
        };
      };
    };
  };
}

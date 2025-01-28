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

          note_path_func = ''
            function(spec)
              -- Check if there's a path specified in the metadata
              local template_path = spec.metadata and spec.metadata.path

              local target_dir
              if template_path then
                -- If template specified a path, use it
                target_dir = vim.fn.expand(spec.dir / template_path)
                -- Remove the path from metadata since we don't want it in the final note
                spec.metadata.path = nil
              else
                -- Default to root directory if no path specified
                target_dir = spec.dir
              end

              -- Return the full path with the note ID
              return target_dir / (spec.id .. ".md")
            end
          '';

          note_frontmatter_func = ''
            function(note)
              if note.title then
                note:add_alias(note.title)
              end

              local out = {
                id = note.id,
                created = os.date("%Y-%m-%d %H:%M"),
                aliases = note.aliases,
                tags = note.tags or {},
              }

              -- Keep any additional metadata except 'path'
              if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                for k, v in pairs(note.metadata) do
                  if k ~= "path" then  -- Skip the path since we already handled it
                    out[k] = v
                  end
                end
              end

              return out
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

          ui = {
            enable = true;
            update_debounce = 200;
            max_file_length = 5000;
            checkboxes = {
              "?" = {
                char = "";
                hl_group = "ObsidianQuestion";
              };
              "-" = {
                char = "";
                hl_group = "ObsidianCancelled";
              };
              "" = {
                char = "󰝣";
                hl_group = "ObsidianTodo";
              };
              " " = {
                char = "󰄱";
                hl_group = "ObsidianTodo";
              };
              "x" = {
                char = "";
                hl_group = "ObsidianDone";
              };
              "X" = {
                char = "";
                hl_group = "ObsidianDone";
              };
              ">" = {
                char = "󰃰";
                hl_group = "ObsidianRightArrow";
              };
              "~" = {
                char = "󰜥";
                hl_group = "ObsidianTilde";
              };
              "!" = {
                char = "󱈸";
                hl_group = "ObsidianImportant";
              };
            };
            bullets = {
              char = "";
              hl_group = "ObsidianBullet";
            };
            external_link_icon = {
              char = "";
              hl_group = "ObsidianExtLinkIcon";
            };
            reference_text = {hl_group = "ObsidianRefText";};
            highlight_text = {hl_group = "ObsidianHighlightText";};
            tags = {hl_group = "ObsidianTag";};
            block_ids = {hl_group = "ObsidianBlockID";};
            hl_groups = {
              # Teal
              ObsidianTodo = {
                bold = true;
                fg = "#94e2d5";
              };

              # Green
              ObsidianDone = {
                bold = true;
                fg = "#a6e3a1";
              };

              # Pink
              ObsidianRightArrow = {
                bold = true;
                fg = "#f5c2e7";
              };

              # Red
              ObsidianTilde = {
                bold = true;
                fg = "#f38ba8";
              };

              # Maroon
              ObsidianCancelled = {
                bold = true;
                fg = "#eba0ac";
              };

              # Red
              ObsidianImportant = {
                bold = true;
                fg = "#f38ba8";
              };

              # Blue
              ObsidianBullet = {
                bold = true;
                fg = "#89b4fa";
              };

              # Mauve
              ObsidianRefText = {
                underline = true;
                fg = "#cba6f7";
              };

              # Mauve
              ObsidianExtLinkIcon = {
                fg = "#cba6f7";
              };

              # Sky
              ObsidianTag = {
                italic = true;
                fg = "#89dceb";
              };

              # Sapphire
              ObsidianBlockID = {
                italic = true;
                fg = "#74c7ec";
              };

              # Surface1
              ObsidianHighlightText = {
                bg = "#45475a";
              };

              # Peach
              ObsidianQuestion = {
                bold = true;
                fg = "#fab387";
              };
            };
          };
          workspaces = [
            {
              name = "personal";
              path = "~/notes/Obsidian";
              overrides = {
                notes_subdir = "slips";
              };
            }
          ];
        };
      };
    };
  };
}

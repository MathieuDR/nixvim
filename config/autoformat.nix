{...}: {
  # Sets globals, needed for the command?
  extraConfigLuaPre = [
    ''
      local format_is_enablet = true
      local _augroups = {}

      local get_autogroup = function(client)
      	if not _autogroups[client.id] then
      		local group_name = 'autoformatter-lsp-format-' .. client.name
      		local id = vim.api.create_augroup(group_name, {clear = true})
      		_augroups[client.id] = id
      	end

      	return _augroups[client.id]
      end
    ''
  ];

  autoCmd = [
    {
      event = ["LspAttach"];
      callback = ''
        function(args)
        	local client_id = args.data.client_id
          local client = vim.lsp.get_client_by_id(client_id)
          local bufnr = args.buf

          -- Only attach to clients that support document formatting
          if not client.server_capabilities.documentFormattingProvider then
            return
          end

          -- Tsserver usually works poorly. Sorry you work with bad languages
          -- You can remove this line if you know what you're doing :)
          if client.name == 'tsserver' then
            return
          end

        	-- Create an autocmd that will run *before* we save the buffer.
          --  Run the formatting command for the LSP that has just attached.
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = get_augroup(client),
            buffer = bufnr,
            callback = function()
              if not format_is_enabled then
                return
              end

              vim.lsp.buf.format {
                async = false,
                filter = function(c)
                  return c.id == client.id
                end,
              }
            end,
          })
        end
      '';
    }
  ];

  userCommands = {
    "AutoFormatToggle" = {
      desc = "Toggles auto formatting";
      command = ''
        function()
        	format_is_enabled = not format_is_enabled
        	print('Setting autoformatting to: ' .. tostring(format_is_enabled))
        end
      '';
    };
  };
}

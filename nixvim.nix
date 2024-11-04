{
  config,
  pkgs,
  ...
}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    opts = {
      updatetime = 100;
      number = true; # show line numbers
      relativenumber = true; # relative line numbers
      shiftwidth = 2; #tab width
      clipboard = "unnamedplus";
      expandtab = true;
      smartindent = true;
      swapfile = false;
      undofile = true;
      conceallevel = 2;
    };
    colorschemes.gruvbox.enable = true;
    # PLUGINS
    plugins = {
      #LUALINE
      lualine.enable = true;
      #LSP
      lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true;
          lua_ls.enable = true;
          texlab.enable = true;
          nixd = {
            enable = true;
            settings = {
              nixpkgs = {
                expr = ''
                  import <nixpkgs> {}
                  import (builtins.getFlake \"/home/lorev/nixos-config\").inputs.nixpkgs { }
                '';
              };
              formatting = {
                command = ["alejandra"];
              };
              options = {
                nixos = {
                  expr = "'(builtins.getFlake \"/home/lorev/nixos-config\").nixosConfigurations.XPSnixos.options'";
                };
                home_manager = {
                  expr = "'(builtins.getFlake \"/home/lorev/nixos-config\").homeConfigurations.lorev.options'";
                };
              };
            };
          };
        };
      };
      #CMP
      cmp = {
        enable = true;
        settings = {
          completion = {
            completeopt = "menu,menuone,noinsert";
          };
          autoEnableSources = true;
          experimental = {ghost_text = true;};
          performance = {
            debounce = 60;
            fetchingTimeout = 200;
            maxViewEntries = 30;
          };
          snippet = {
            expand = ''
              function(args)
                require('luasnip').lsp_expand(args.body)
              end
            '';
          };
          formatting = {fields = ["kind" "abbr" "menu"];};
          sources = [
            {name = "nvim_lsp";}
            {
              name = "buffer"; # text within current buffer
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
              keywordLength = 3;
            }
            {
              name = "path"; # file system paths
              keywordLength = 3;
            }
            {
              name = "luasnip"; # snippets
              keywordLength = 3;
            }
          ];

          window = {
            completion = {border = "solid";};
            documentation = {border = "solid";};
          };

          mapping = {
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-e>" = "cmp.mapping.abort()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
            "<C-l>" = ''
              cmp.mapping(function()
                if luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                end
              end, { 'i', 's' })
            '';
            "<C-h>" = ''
              cmp.mapping(function()
                if luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                end
              end, { 'i', 's' })
            '';
          };
        };
      };
      #LUASNIP
      luasnip = {
        enable = true;
        fromLua = [{} {paths = ./config/nvim/LuaSnip;}];
        settings = {
          enable_autosnippets = true;
          store_selection_keys = "<Tab>";
        };
      };
      #VIMTEX
      vimtex = {
        enable = true;
        settings = {
          view_method = "zathura";
        };
      };
      #TELESCOPE
      telescope = {
        enable = true;
      };
      #OBSIDIAN
      obsidian = {
        enable = true;
        settings = {
          completion = {
            min_chars = 2;
            nvim_cmp = true;
          };
          new_notes_location = "current_dir";
          workspaces = [
            {
              name = "zettelkasten";
              path = "~/Dropbox/obsidian/zettelkasten";
            }
          ];
          templates = {
            folder = "templates";
            date_format = "%Y-%m-%d";
            time_format = "%H:%M";
            substitutions = {};
          };
        };
      };
      #OIL
      oil.enable = true;
      #TREESITTER
      treesitter = {
        enable = true;
        nixvimInjections = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      treesitter-refactor = {
        enable = true;
        highlightDefinitions = {
          enable = true;
          # Set to false if you have an `updatetime` of ~100.
          clearOnCursorMove = false;
        };
      };
      #WEB-DEVICONS
      web-devicons.enable = true;
    }; #end of plugins

    globals.mapleader = " ";
    keymaps = [
      {
        key = "ò";
        action = ":";
      }
      {
        mode = "n";
        key = "<leader>pv";
        action = "<cmd>Ex<CR>";
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
      }
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
      }
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
      }
      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<leader>g";
      }
    ]; #end of remap
    extraConfigVim = ''
      imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
      smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'
      imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
      smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
      nmap <leader>c <Plug>(vimtex-compile)
      nmap <leader>ii <Plug>(vimtex-toc-toggle)

    '';
    extraConfigLua = ''
      local tlsc = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', tlsc.find_files, {})
        vim.keymap.set('n', '<C-p>', tlsc.git_files, {})

        vim.keymap.set('n', '<leader>ps', function()
          tlsc.grep_string({ search = vim.fn.input("Grep > ")})
        end)
    '';
  };
}

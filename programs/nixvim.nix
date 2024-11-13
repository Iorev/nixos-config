{
  config,
  pkgs,
  ...
}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    vimAlias = true;
    viAlias = true;
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
    #colorschemes.gruvbox.enable = true;
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
          sourcekit.enable = true;
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
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
                nixvim = {
                  expr = ''(builtins.getFlake "/home/lorev/nixos-config").packages.x86_64-linux.neovimNixvim.options'';
                };
                nixos = {
                  expr = ''(builtins.getFlake "/home/lorev/nixos-config").nixosConfigurations.XPSnixos.options'';
                };
                home_manager = {
                  expr = ''(builtins.getFlake "/home/lorev/nixos-config").homeConfigurations.lorev.options'';
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
            #{name = "neorg";}
            {
              name = "buffer"; # text within current buffer
              #option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
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
        fromLua = [{} {paths = ../config/nvim/LuaSnip;}];
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
        enable = false;
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
            folder = "5 - templates";
            date_format = "%Y-%m-%d";
            time_format = "%H:%M";
            substitutions = {};
          };
        };
      };
      #HELPVIEW
      helpview.enable = true;
      #OIL
      oil = {
        enable = true;
        settings = {
          columns = [
            "icon"
          ];
          keymaps = {
            "<C-c>" = false;
            "<C-l>" = false;
            "<C-r>" = "actions.refresh";
            "<leader>qq" = "actions.close";
            "y." = "actions.copy_entry_path";
            "g?" = "actions.show_help";
            "<CR>" = "actions.select";
            "-" = "actions.parent";
            "gs" = "actions.change_sort";
            "gx" = "actions.open_external";
            "g." = "actions.toggle_hidden";
            "g\\" = "actions.toggle_trash";
          };
          skip_confirm_for_simple_edits = true;
          view_options = {
            show_hidden = true;
          };
          win_options = {
            concealcursor = "ncv";
            conceallevel = 3;
            cursorcolumn = false;
            foldcolumn = "0";
            list = false;
            signcolumn = "no";
            spell = false;
            wrap = false;
          };
        };
      };
      #AUTOCLOSE
      autoclose = {
        enable = true;
        keys = {
          "`" = {
            escape = false;
            close = false;
            pair = "``";
          };
          "'" = {
            escape = false;
            close = false;
            pair = "''";
          };
        };
        options = {
          autoIndent = true;
        };
      };
      #TREESITTER
      treesitter = {
        enable = true;
        nixvimInjections = true;
        languageRegister = {
          markdown = [
            "telekasten"
          ];
        };
        settings = {
          highlight.enable = true;
          indent.enable = true;
          auto_install = true;
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = false;
              node_decremental = "grm";
              node_incremental = "grn";
              scope_incremental = "grc";
            };
          };
        };
      };
      treesitter-context = {
        enable = true;
        settings = {
          line_numbers = true;
          max_lines = 0;
          min_window_height = 0;
          mode = "cursor";
          multiline_threshold = 0;
          separator = "-";
          trim_scope = "inner";
          zindex = 10;
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
      #TELECASTEN
      telekasten = {
        enable = true;
        settings.home = {
          __raw = "vim.fn.expand(\"~/zettelkasten\")";
        };
      };
      #RENDER-MARKDOWN
      render-markdown = {
        enable = true;
        settings = {
          bullet = {
            icons = [
              " "
            ];
            right_pad = 1;
          };
          code = {
            above = " ";
            below = " ";
            border = "thick";
            language_pad = 2;
            left_pad = 2;
            position = "right";
            right_pad = 2;
            sign = false;
            width = "block";
          };
          heading = {
            border = true;
            icons = [
              "1 "
              "2 "
              "3 "
              "4 "
              "5 "
              "6 "
            ];
            position = "inline";
            sign = false;
            width = "full";
          };
          render_modes = true;
          signs = {
            enabled = false;
          };
        };
      };
      #NVIM-UFO
      nvim-ufo = {
        enable = false;
        settings = {
          provider_selector = ''
            treesitter
          '';
        };
      };
      image.enable = true;
      neorg = {
        enable = true;
        modules = {
          "core.defaults" = {__empty = null;};
          "core.summary" = {__empty = null;};
          #"core.completion" = {engine = "[nvim-cmp]";};
          "core.concealer" = {__empty = null;};
          "core.latex.renderer" = {__empty = null;};
          "core.dirman" = {
            config = {
              workspaces = {
                notes = "~/notes/";
                current_course = "~/current_course/neorg_notes/";
              };
              default_workspace = "current_course";
            };
          };
        };
      };
    }; #end of plugins

    globals.mapleader = " ";
    keymaps = [
      {
        key = "ò";
        action = ":";
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
      let maplocalleader = ","
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
              vim.keymap.set('n', '<leader>fb', tlsc.buffers, {})
              vim.keymap.set('n', '<C-p>', tlsc.git_files, {})

              vim.keymap.set('n', '<leader>ps', function()
                tlsc.grep_string({ search = vim.fn.input("Grep > ")})
              end)
            -- Launch panel if nothing is typed after <leader>z
      vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")

      -- Most used functions
      vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
      vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>")
      vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
      vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>")
      vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
      vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>")
      vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
      vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")
      vim.keymap.set("n", "<leader>zx", "<cmd>Telekasten toggle_todo<CR>")

      -- Call insert link automatically when we start typing a link
      vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")
      vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
    '';
  };
}

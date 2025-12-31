--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.termguicolors = true

-- Set the shell for WSL environment
vim.opt.shell = '/bin/zsh'
vim.opt.shellcmdflag = '-c'
vim.opt.shellquote = ''
vim.opt.shellxquote = ''

-- Set tab width to 4 spaces
vim.opt.tabstop = 4
-- Set the number of spaces for indentation
vim.opt.shiftwidth = 4
-- Use spaces instead of tabs
vim.opt.expandtab = true
-- Make backspace delete 4 spaces at once
vim.opt.softtabstop = 4

-- Enable folding and set the fold method
vim.opt.foldenable = true
vim.opt.foldmethod = 'indent' -- Options: 'manual', 'indent', 'syntax', 'expr', 'marker'
vim.opt.foldlevel = 99 -- Start with all folds open

-- Read Catppuccin flavour from environment variable (set by Wezterm) or default to 'mocha'
-- This will be used in the catppuccin plugin setup below

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Auto-reload files when changed externally
vim.opt.autoread = true

-- Check for file changes when focus is gained or buffer is entered
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  pattern = '*',
  callback = function()
    vim.cmd 'checktime'
  end,
})

-- Auto-reload without prompting if buffer hasn't been modified
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  pattern = '*',
  callback = function()
    vim.notify('File reloaded from disk', vim.log.levels.INFO)
  end,
})

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  These are configured below with smart-splits plugin
--
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank {
      higroup = 'IncSearch',
      timeout = 150,
    }
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*',
  callback = function()
    if vim.bo.modifiable then
      vim.opt.expandtab = true

      vim.cmd 'retab'
    end
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      current_line_blame = true,
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Custom Plugins
  -- { 'terryma/vim-expand-region' },

  { 'nvim-tree/nvim-web-devicons', opts = {} },

  {
    'MagicDuck/grug-far.nvim',
    cmd = { 'GrugFar', 'GrugFarResume' },
    opts = {
      engines = {
        ripgrep = {
          extraArgs = '--glob=!*.min.* --glob=!*.map --glob=!main.js',
        },
      },
    },
  },

  {
    'mistweaverco/kulala.nvim',
    ft = { 'http', 'rest' },
    keys = {
      { '<leader>Rs', "<cmd>lua require('kulala').run()<cr>", desc = 'Send the request' },
      { '<leader>Rt', "<cmd>lua require('kulala').toggle_view()<cr>", desc = 'Toggle headers/body' },
      { '<leader>Rp', "<cmd>lua require('kulala').jump_prev()<cr>", desc = 'Jump to previous request' },
      { '<leader>Rn', "<cmd>lua require('kulala').jump_next()<cr>", desc = 'Jump to next request' },
    },
    opts = {
      formatters = {
        json = { 'jq', '.' },
        xml = { 'xmllint', '--format', '-' },
        html = { 'xmllint', '--format', '--html', '-' },
      },
    },
  },

   {
     'sudo-tee/opencode.nvim',
     config = function()
       require('opencode').setup {
         keymap = {
            input_window = {
              ['<cr>'] = { 'submit_input_prompt', mode = { 'n', 'i' } },
              ['<esc>'] = { function() end }, -- Disable ESC closing the pane
              ['<C-c>'] = { 'cancel' },
              ['~'] = { 'mention_file', mode = 'i' },
              ['@'] = { 'mention', mode = 'i' },
              ['/'] = { 'slash_commands', mode = 'i' },
              ['#'] = { 'context_items', mode = 'i' },
              ['<M-v>'] = { 'paste_image', mode = 'i' },
              ['<C-i>'] = { 'focus_input', mode = { 'n', 'i' } },
              ['<tab>'] = { 'toggle_pane', mode = { 'n', 'i' } },
              ['<up>'] = { 'prev_prompt_history', mode = { 'n', 'i' } },
              ['<down>'] = { 'next_prompt_history', mode = { 'n', 'i' } },
              ['<M-m>'] = { 'switch_mode' },
            },
            output_window = {
              ['<esc>'] = { function() end }, -- Disable ESC closing the pane
              ['<C-c>'] = { 'cancel' },
              [']]'] = { 'next_message' },
              ['[['] = { 'prev_message' },
              ['<tab>'] = { 'toggle_pane', mode = { 'n', 'i' } },
              ['i'] = { 'focus_input', 'n' },
              ['<leader>oS'] = { 'select_child_session' },
              ['<leader>oD'] = { 'debug_message' },
              ['<leader>oO'] = { 'debug_output' },
              ['<leader>ods'] = { 'debug_session' },
            },
         },
       }
     end,
     dependencies = {
       'nvim-lua/plenary.nvim',
       {
         'MeanderingProgrammer/render-markdown.nvim',
         opts = {
           anti_conceal = { enabled = false },
           file_types = { 'markdown', 'opencode_output' },
         },
         ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
       },
       -- Optional, for file mentions and commands completion, pick only one
       'saghen/blink.cmp',
       -- 'hrsh7th/nvim-cmp',

       -- Optional, for file mentions picker, pick only one
       'folke/snacks.nvim',
       -- 'nvim-telescope/telescope.nvim',
       -- 'ibhagwan/fzf-lua',
       -- 'nvim_mini/mini.nvim',
     },
   },

  {
    'obsidian-nvim/obsidian.nvim',
    version = '*', -- Use latest release instead of latest commit
    lazy = true,
    ft = 'markdown',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      -- Use modern command structure (community fork enhancement)
      legacy_commands = false,

      workspaces = {
        {
          name = 'personal',
          path = '~/vaults/personal',
        },
        {
          name = 'work',
          path = '~/vaults/work',
        },
      },

      -- Completion configuration for community fork
      completion = {
        nvim_cmp = false, -- Using blink.cmp instead
        blink = true, -- Enable blink.cmp integration
        min_chars = 2,
        match_case = true,
        create_new = true,
      },

      -- Note ID generation using hybrid date + title approach
      note_id_func = function(title)
        local date_prefix = os.date '%Y%m%d-'
        if title then
          local clean_title = title:gsub('[^%w%s-]', ''):gsub('%s+', '-'):lower()
          return date_prefix .. clean_title
        else
          return date_prefix .. 'untitled'
        end
      end,

      -- Link formatting using community fork builtins
      wiki_link_func = function(text)
        return require('obsidian.builtin').wiki_link_id_prefix(text)
      end,

      markdown_link_func = function(text)
        return require('obsidian.builtin').markdown_link(text)
      end,

      -- Either 'wiki' or 'markdown'.
      preferred_link_style = 'wiki',

      -- Modern frontmatter configuration
      frontmatter = {
        -- Enable frontmatter (replaces disable_frontmatter = false)
        enable = true,

        -- Custom frontmatter function (replaces note_frontmatter_func)
        func = function(note)
          -- Add the title of the note as an alias.
          if note.title then
            note:add_alias(note.title)
          end

          local out = { id = note.id, aliases = note.aliases, tags = note.tags }

          -- `note.metadata` contains any manually added fields in the frontmatter.
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end

          return out
        end,
      },

      -- Optional, for templates (see below).
      templates = {
        folder = 'templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },

      -- Modern open configuration (replaces open_app_foreground and use_advanced_uri)
      open = {
        func = function(url)
          -- Open the URL in the default web browser or Obsidian app
          vim.fn.jobstart { 'cmd', '/c', 'start', url } -- Windows
          -- vim.fn.jobstart({"open", url})  -- macOS
          -- vim.fn.jobstart({"xdg-open", url})  -- Linux
        end,
      },

      picker = {
        -- Use snacks.picker (available in current setup)
        name = 'snacks.pick',
        -- Optional, configure key mappings for the picker. These are the defaults.
        note_mappings = {
          -- Create a new note from your query.
          new = '<C-x>',
          -- Insert a link to the selected note.
          insert_link = '<C-l>',
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = '<C-x>',
          -- Insert a tag at the current location.
          insert_tag = '<C-l>',
        },
      },

      -- 1. "current" (the default) - to always open in the current window
      -- 2. "vsplit" - to open in a vertical split if there is not already a vertical split
      -- 3. "hsplit" - to open in a horizontal split if there is not already a horizontal split
      open_notes_in = 'current',

      -- Optional, define your own callbacks to further customize behavior.
      callbacks = {
        -- Runs at the end of `require("obsidian").setup()`.
        post_setup = function(client) end,

        -- Runs anytime you enter the buffer for a note.
        enter_note = function(client, note) end,

        -- Runs anytime you leave the buffer for a note.
        leave_note = function(client, note) end,

        -- Runs right before writing the buffer for a note.
        pre_write_note = function(client, note) end,

        -- Runs anytime the workspace is set/changed.
        post_set_workspace = function(client, workspace) end,
      },

      -- Modern checkbox configuration (replaces ui.checkboxes)
      checkbox = {
        -- Define checkbox order for toggling
        order = { ' ', 'x', '>', '~', '!' },
        -- Define how various check-boxes are displayed
        [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
        ['x'] = { char = '', hl_group = 'ObsidianDone' },
        ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
        ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
        ['!'] = { char = '', hl_group = 'ObsidianImportant' },
        -- Replace the above with this if you don't have a patched font:
        -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },
      },

      -- Optional, configure additional syntax highlighting / extmarks.
      ui = {
        enable = true, -- set to false to disable all additional syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        -- Use bullet marks for non-checkbox lists.
        bullets = { char = '•', hl_group = 'ObsidianBullet' },
        external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
        -- Replace the above with this if you don't have a patched font:
        -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = 'ObsidianRefText' },
        highlight_text = { hl_group = 'ObsidianHighlightText' },
        tags = { hl_group = 'ObsidianTag' },
        block_ids = { hl_group = 'ObsidianBlockID' },
        hl_groups = {
          -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
          ObsidianTodo = { bold = true, fg = '#f78c6c' },
          ObsidianDone = { bold = true, fg = '#89ddff' },
          ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
          ObsidianTilde = { bold = true, fg = '#ff5370' },
          ObsidianImportant = { bold = true, fg = '#d73128' },
          ObsidianBullet = { bold = true, fg = '#89ddff' },
          ObsidianRefText = { underline = true, fg = '#c792ea' },
          ObsidianExtLinkIcon = { fg = '#c792ea' },
          ObsidianTag = { italic = true, fg = '#89ddff' },
          ObsidianBlockID = { italic = true, fg = '#89ddff' },
          ObsidianHighlightText = { bg = '#75662e' },
        },
      },

      -- Specify how to handle attachments.
      attachments = {
        -- The default folder to place images in via `:ObsidianPasteImg`.
        img_folder = 'assets/imgs', -- This is the default
        -- A function that determines the text to insert in the note when pasting an image.
        img_text_func = function(client, path)
          local link_path
          local vault_relative_path = client:vault_relative_path(path)
          if vault_relative_path ~= nil then
            -- Use relative path if the image is saved in the vault dir.
            link_path = vault_relative_path
          else
            -- Otherwise use the absolute path.
            link_path = tostring(path)
          end
          local display_name = vim.fs.basename(link_path)
          return string.format('![%s](%s)', display_name, link_path)
        end,
      },
    },
    keys = {
      -- Note management keymaps using modern command structure
      { '<leader>nn', '<cmd>Obsidian new<cr>', desc = 'New Note' },
      { '<leader>no', '<cmd>Obsidian search<cr>', desc = 'Search Notes' },
      { '<leader>nq', '<cmd>Obsidian quick-switch<cr>', desc = 'Quick Switch Notes' },
      { '<leader>nb', '<cmd>Obsidian backlinks<cr>', desc = 'Note Backlinks' },
      { '<leader>nt', '<cmd>Obsidian today<cr>', desc = "Today's Note" },
      { '<leader>ny', '<cmd>Obsidian yesterday<cr>', desc = "Yesterday's Note" },
      { '<leader>nw', '<cmd>Obsidian workspace<cr>', desc = 'Select Workspace' },
      { '<leader>nf', '<cmd>Obsidian follow<cr>', desc = 'Follow Link' },
      { '<leader>nl', '<cmd>Obsidian links<cr>', desc = 'Note Links' },
      { '<leader>nt', '<cmd>Obsidian tags<cr>', desc = 'Note Tags' },
      { '<leader>ni', '<cmd>Obsidian paste-img<cr>', desc = 'Paste Image' },
      { '<leader>nr', '<cmd>Obsidian rename<cr>', desc = 'Rename Note' },
      {
        '<leader>nd',
        function()
          local current_file = vim.api.nvim_buf_get_name(0)
          if current_file == '' or not vim.endswith(current_file, '.md') then
            vim.notify('Not a markdown note file', vim.log.levels.WARN)
            return
          end

          local filename = vim.fn.fnamemodify(current_file, ':t')
          local confirm = vim.fn.confirm('Delete note "' .. filename .. '"?', '&Yes\n&No', 2)

          if confirm == 1 then
            -- Close the buffer first
            vim.cmd 'bdelete!'
            -- Delete the file
            local success, err = os.remove(current_file)
            if success then
              vim.notify('Deleted: ' .. filename, vim.log.levels.INFO)
            else
              vim.notify('Failed to delete: ' .. (err or 'unknown error'), vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Delete Current Note',
      },
      -- Visual mode mappings
      { '<leader>nl', ':<C-u>Obsidian link<cr>', mode = 'v', desc = 'Link Selection' },
      { '<leader>nL', ':<C-u>Obsidian link-new<cr>', mode = 'v', desc = 'Link New Note' },

      -- Note picker keymaps using current workspace
      {
        '<leader>ns',
        function()
          local obsidian = require 'obsidian'
          local client = obsidian.get_client()
          local workspace_path = client.current_workspace.path

          local snacks = require 'snacks'
          if snacks and snacks.picker then
            snacks.picker.files {
              cwd = tostring(workspace_path),
              layout = 'sidebar',
            }
          else
            print 'Snacks picker not available'
          end
        end,
        desc = 'Current Workspace Notes (Sidebar)',
      },

      {
        '<leader>np',
        function()
          local obsidian = require 'obsidian'
          local client = obsidian.get_client()
          local workspace_path = client.current_workspace.path

          local snacks = require 'snacks'
          if snacks and snacks.picker then
            snacks.picker.files {
              cwd = tostring(workspace_path),
            }
          else
            print 'Snacks picker not available'
          end
        end,
        desc = 'Current Workspace Notes (Picker)',
      },

      -- For searching note content (not just filenames)
      {
        '<leader>ng',
        function()
          local obsidian = require 'obsidian'
          local client = obsidian.get_client()
          local workspace_path = client.current_workspace.path

          local snacks = require 'snacks'
          if snacks and snacks.picker then
            snacks.picker.grep {
              cwd = tostring(workspace_path),
              layout = 'vertical',
            }
          else
            print 'Snacks picker not available'
          end
        end,
        desc = 'Search in Current Workspace Notes',
      },

      -- Git management for current workspace
      {
        '<leader>gn',
        function()
          local obsidian = require 'obsidian'
          local client = obsidian.get_client()
          local workspace_path = client.current_workspace.path

          require('neogit').open { cwd = tostring(workspace_path) }
        end,
        desc = 'Git: Current workspace notes',
      },
    },
  },

  {
    -- Neogit: Interactive Git UI (Magit-like)
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- Required
      'sindrets/diffview.nvim', -- Optional but recommended for diff integration
    },
    cmd = 'Neogit',
    config = function()
      local neogit = require 'neogit'
      neogit.setup {
        auto_refresh = true,
        branches = true,
        filewatcher = {
          interval = 1000,
          enabled = true,
        },
        disable_hint = false, -- Show hints in status buffer
        disable_context_highlighting = false, -- Highlight based on cursor position
        disable_signs = false, -- Show signs for sections/hunks
        prompt_force_push = true, -- Warn on force push
        commit_editor = { auto_close = true }, -- Auto-close commit editor
        integrations = {
          diffview = true, -- Enable diff popup integration with Diffview
          telescope = false, -- Disabled - using snacks.picker instead
        },
      }
    end,
  },
  {
    -- Diffview: Tabpage interface for diffs across files/commits
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    config = function()
      local actions = require 'diffview.actions'
      require('diffview').setup {
        watch_index = true,
        diff_binaries = false, -- Skip binary files in diffs
        enhanced_diff_hl = true, -- Better hunk highlighting
        use_icons = true, -- Requires nvim-web-devicons (Kickstart has it)
        hooks = {
          diff_buf_read = function()
            vim.opt_local.swapfile = false
            vim.opt_local.backup = false
            vim.opt_local.writebackup = false
          end,
        },
        icons = {
          folder_closed = '󰉋',
          folder_open = '󰝰',
        },
        signs = {
          fold_closed = '',
          fold_open = '',
          done = '',
        },
        view = {
          default = {
            layout = 'diff2_horizontal', -- Side-by-side horizontal diffs
            winbar_info = true, -- Show file info in winbar
          },
          merge_tool = {
            layout = 'diff3_mixed', -- 3-way merge layout for conflicts
            disable_diagnostics = true, -- No LSP in merge views
          },
          file_history = {
            -- layout = 'diff2_vertical', -- Vertical for history
          },
        },
        file_panel = {
          listing_style = 'tree', -- Tree view for files
          tree_options = { dir_opened = '?', dir_closed = '?' },
        },
        keymaps = {
          disable_defaults = false, -- Keep defaults
          view = {
            { 'n', '<C-n>', actions.next_entry, { desc = 'Next entry' } },
            { 'n', '<C-p>', actions.prev_entry, { desc = 'Prev entry' } },
          },
          file_panel = {
            { 'n', 's', actions.toggle_stage_entry, { desc = 'Stage/unstage' } },
            { 'n', 'u', actions.unstage_all, { desc = 'Unstage all' } },
          },
        },
      }
    end,
  },

  {
    'FabijanZulj/blame.nvim',
    lazy = false,
    config = function()
      require('blame').setup {}
    end,
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        progress = {
          enabled = false,
          format = 'lsp_progress',
          format_done = 'lsp_progress_done',
          view = 'notify', -- Use nvim-notify for LSP progress,
        },
        hover = {
          enabled = true,
          opts = { border = 'single' },
        },
        signature = {
          enabled = true,
          auto_open = { enabled = true },
          opts = { border = 'single' },
        },
      },
      notify = {
        enabled = true,
        view = 'notify', -- Use nvim-notify
      },
      messages = {
        enabled = true,
        view = 'notify',
        view_error = 'notify',
        view_warn = 'notify',
        view_history = 'messages',
        view_search = 'virtualtext',
      },
      cmdline = {
        enabled = true,
        view = 'cmdline_popup',
        opts = { border = 'single' },
        format = {
          cmdline = { pattern = '^:', icon = '', lang = 'vim' },
          search_down = { kind = 'search', pattern = '^/', icon = '', lang = 'regex' },
          search_up = { kind = 'search', pattern = '^%?', icon = '', lang = 'regex' },
          filter = { pattern = '^:%s*!', icon = '󱆃', lang = 'bash' },
          lua = { pattern = '^:%s*lua%s+', icon = '', lang = 'lua' },
        },
      },
      popupmenu = {
        enabled = true,
        backend = 'nui',
        opts = { border = 'single' },
      },
      routes = {
        { filter = { event = 'msg_show', min_height = 10 }, view = 'split' },
        { filter = { event = 'msg_show', find = '%d+ lines? written' }, view = 'notify', opts = { timeout = 2000 } },
        { filter = { event = 'msg_show', find = 'written' }, opts = { skip = true } },
      },
      presets = {
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      views = {
        cmdline_popup = {
          position = { row = '40%', col = '50%' },
          size = { width = '60%', height = 'auto' },
          border = { style = 'single', padding = { 0, 1 } },
        },
        notify = {
          timeout = 3000,
          render = 'default',

          max_width = 60,
        },
        mini = {
          timeout = 2000,
          position = { row = -2, col = -2 },
          max_width = 50,
        },
      },
    },
    config = function(_, opts)
      require('noice').setup(opts)
      require('notify').setup {
        stages = 'fade_in_slide_out',
        timeout = 3000,
        max_width = 60,
        max_height = 10,
        background_colour = '#000000',
        render = 'default',
      }
    end,
  },

  {
    'seblyng/roslyn.nvim',
    dependencies = { 'saghen/blink.cmp' },
    ft = { 'cs', 'razor' },
    config = function()
      require('roslyn').setup {
        config = {
          -- Enhanced settings for better IntelliSense and LINQ support
          settings = {
            ['csharp|inlay_hints'] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
              csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              csharp_enable_inlay_hints_for_types = true,
              dotnet_enable_inlay_hints_for_indexer_parameters = true,
              dotnet_enable_inlay_hints_for_literal_parameters = true,
              dotnet_enable_inlay_hints_for_object_creation_parameters = true,
              dotnet_enable_inlay_hints_for_other_parameters = true,
              dotnet_enable_inlay_hints_for_parameters = true,
              dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ['csharp|completion'] = {
              dotnet_provide_regex_completions = true,
              dotnet_show_completion_items_from_unimported_namespaces = true,
              dotnet_show_name_completion_suggestions = true,
            },
            ['csharp|background_analysis'] = {
              dotnet_analyzer_diagnostics_scope = 'fullSolution',
              dotnet_compiler_diagnostics_scope = 'fullSolution',
            },
            ['csharp|code_lens'] = {
              dotnet_enable_references_code_lens = true,
              dotnet_enable_tests_code_lens = true,
            },
            ['csharp|symbol_search'] = {
              dotnet_search_reference_assemblies = true,
            },
          },
          -- Ensure proper initialization
          on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Key mappings specifically for C# development
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>f', function()
              vim.lsp.buf.format { async = true }
            end, opts)
          end,
          capabilities = require('blink.cmp').get_lsp_capabilities(),
        },
        exe = 'Microsoft.CodeAnalysis.LanguageServer',
      }
    end,
  },

  {
    'Everduin94/nvim-quick-switcher',
    config = function()
      -- Keymaps for nvim-quick-switcher
      local opts = { noremap = true, silent = true }

      -- Helper function for find (used for SCSS/CSS)
      local function find(file_regex, find_opts)
        return function()
          require('nvim-quick-switcher').find(file_regex, find_opts)
        end
      end

      -- Toggle between HTML and TypeScript
      vim.keymap.set('n', '<leader>aa', function()
        require('nvim-quick-switcher').toggle('component.html', 'component.ts')
      end, opts)

      -- Switch to TypeScript
      vim.keymap.set('n', '<leader>ag', function()
        require('nvim-quick-switcher').switch 'component.ts'
      end, opts)

      -- Switch to HTML
      vim.keymap.set('n', '<leader>af', function()
        require('nvim-quick-switcher').switch 'component.html'
      end, opts)

      -- Switch to SCSS or CSS
      vim.keymap.set('n', '<leader>ad', find('.+css|.+scss', { regex = true, prefix = 'full' }), opts)
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
      enable = true,
      max_lines = 3, -- How many lines the context will take up
      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded
      mode = 'cursor', -- Line used to calculate context. 'cursor' or 'topline'
    },
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      -- Custom leaf parser
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.leaf = {
        install_info = {
          url = 'https://github.com/visualbam/tree-sitter-leaf',
          files = { 'src/parser.c' },
          branch = 'playground',
          -- This is key - it tells nvim-treesitter to copy query files
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
        },
        filetype = 'leaf',
        -- This ensures nvim-treesitter knows about your query files
        used_by = { 'leaf' },
      }

      -- Filetype detection and registration
      vim.treesitter.language.register('leaf', 'leaf')
      vim.filetype.add { extension = { leaf = 'leaf' } }

      -- Standard setup
      require('nvim-treesitter.configs').setup {
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '+', -- Start selection
            node_incremental = '+', -- Expand selection
            node_decremental = '-', -- Shrink selection
            scope_incremental = false, -- Optional, or set to another key
          },
        },
        ensure_installed = {
          'angular',
          'bash',
          'c',
          'diff',
          'html',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'query',
          'vim',
          'vimdoc',
          'typescript',
          'javascript',
          'tsx',
          'json',
          'css',
          'scss',
          'yaml',
          'java',
          'c_sharp',
          'leaf',
          'dockerfile',
          'yaml',
        },
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = { enable = true },
        inject = { enable = true },
      }
    end,
  },

  {
    'nvim-treesitter/playground',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  {
    'echasnovski/mini.nvim',
    version = false, -- Use latest
    config = function()
      require('mini.files').setup {
        windows = {
          max_number = 3,
          preview = false,
          width_focus = 30,
          width_nofocus = 15,
          width_preview = 50,
        },
      }
      require('mini.comment').setup()
      require('mini.pairs').setup()
      require('mini.surround').setup {
        mappings = {
          add = 'gza', -- Add surrounding in Normal and Visual modes
          delete = 'gzd', -- Delete surrounding
          find = 'gzf', -- Find surrounding (to the right)
          find_left = 'gzF', -- Find surrounding (to the left)
          highlight = 'gzh', -- Highlight surrounding
          replace = 'gzr', -- Replace surrounding
          update_n_lines = 'gzn', -- Update `n_lines`
        },
      }
      -- Add other modules as needed
      vim.keymap.set('n', '<leader>e', function()
        require('mini.files').open(vim.api.nvim_buf_get_name(0)) -- Open at current file's directory
      end, { desc = 'Open mini.files' })
    end,
  },

  {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      -- Minimal setup - keep most defaults but customize key ones
      -- NOTE: Using <leader>j/k for cursor movement to avoid conflict with
      -- smart-splits.nvim's <C-j>/<C-k> pane navigation
      vim.g.VM_maps = {
        ['Find Under'] = '<C-n>',
        ['Find Subword Under'] = '<C-n>',
        ['Skip Region'] = '<C-x>', -- Skip current and go to next
        ['Remove Region'] = '<C-p>', -- Remove current selection (go back)
        ['Add Cursor Down'] = '<leader>j',
        ['Add Cursor Up'] = '<leader>k',
        ['Select All'] = '<leader>A',
        ['Start Regex Search'] = '<leader>/',
      }
    end,
  },

  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup {
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
        performance_mode = false, -- Disable "Performance Mode" on all buffers.
      }
    end,
  },

  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      require('smart-splits').setup {
        -- Ignored buffer types (only while resizing)
        ignored_buftypes = {
          'nofile',
          'quickfix',
          'prompt',
        },
        -- Ignored filetypes (only while resizing)
        ignored_filetypes = { 'NvimTree' },
        -- the default number of lines/columns to resize by at a time
        default_amount = 3,
        -- whether to wrap to opposite side when cursor is at an edge
        -- e.g. by default, moving left at the left edge will jump to the right edge
        at_edge = 'wrap',
        -- when moving cursor between splits left or right,
        -- place the cursor on the same row of the *screen*
        -- regardless of line numbers. False by default.
        -- Can be overridden via function parameter, see Usage.
        move_cursor_same_row = false,
        -- resize mode options
        resize_mode = {
          -- key to exit persistent resize mode
          quit_key = '<ESC>',
          -- keys to use for moving in resize mode
          -- in order of left, down, up, right
          resize_keys = { 'h', 'j', 'k', 'l' },
          -- set to true to silence the notifications
          -- when entering/exiting persistent resize mode
          silent = false,
          -- must be functions, they will be executed when
          -- entering or exiting the resize mode
          hooks = {
            on_enter = nil,
            on_leave = nil,
          },
        },
        -- ignore these autocmd events (via :h eventignore) while processing
        -- smart-splits.nvim computations, which involve visiting different
        -- buffers and windows. These events will be ignored during processing,
        -- and un-ignored on completed. This only applies to resize events,
        -- not cursor movement events.
        ignored_events = {
          'BufEnter',
          'WinEnter',
        },
         -- enable or disable the tmux integration
         multiplexer_integration = 'tmux',
         -- disable multiplexer navigation if current multiplexer pane is zoomed
         disable_multiplexer_nav_when_zoomed = true,
         -- Explicitly set wezterm executable path to avoid PATH issues in new pane contexts
         -- This prevents "wezterm is not executable" errors when smart-splits tries to detect
         -- the multiplexer in non-interactive shell contexts (e.g., new panes)
         wezterm_executable = '/Applications/WezTerm.app/Contents/MacOS/wezterm',
      }

      -- Recommended keymaps
      -- resizing splits
      vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
      vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
      vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
      vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
      -- moving between splits
      vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
      vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
      vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
      vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
      vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
      -- swapping buffers between windows
      vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
      vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
      vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
      vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)
    end,
  },

  -- {
  --   'sphamba/smear-cursor.nvim',
  --   event = { 'BufReadPost', 'BufNewFile' }, -- Lazy-load after VimEnter for faster startup
  --   opts = {
  --     -- Core animation speed (lower = faster, but choppier)
  --     duration = 200, -- Default: 300ms; try 100-150 for snappier feel
  --     fps = 60, -- Default: 60; drop to 30 if your terminal struggles
  --
  --     -- Limit smear length to reduce rendering load
  --     max_length = 20, -- Default: 30; shorter trail = less CPU
  --     min_length = 5, -- Default: 10
  --
  --     -- Finer control: Only smear on larger movements (ignores tiny j/k/h/l)
  --     min_horizontal_distance_smear = 3, -- Default: 1; e.g., smear only after 3+ chars horizontally
  --     min_vertical_distance_smear = 2, -- Default: 1; similar for up/down
  --
  --     -- Disable for scrolling (huge perf win if you scroll a lot)
  --     smear_between_neighbor_lines = false, -- Default: true; keeps it buffer-focused
  --     scroll_buffer_space = false, -- Default: true; screen-space is lighter
  --
  --     -- Other tweaks for edge cases
  --     color = { r = 255, g = 255, b = 255, a = 0.3 }, -- Lower alpha for less blending overhead
  --     use_legacy_symbols = true, -- If your font supports it; can be faster than Unicode blocks
  --   },
  -- },

  {
    'sphamba/smear-cursor.nvim',
    opts = {
      -- Smear cursor when switching buffers or windows.
      smear_between_buffers = true,
      -- Smear cursor when moving within line or to neighbor lines.
      smear_between_neighbor_lines = true,
      -- Draw the smear in buffer space instead of screen space when scrolling
      scroll_buffer_space = true,
      -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
      -- Smears will blend better on all backgrounds.
      legacy_computing_symbols_support = false,
    },
  },

  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup {
        ui = {
          border = 'rounded',
        },
      }
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'catppuccin/nvim' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'catppuccin', -- Sets lualine to use the Catppuccin theme
          section_separators = '',
          component_separators = '',
        },
        sections = {
          lualine_a = {
            { 'mode', separator = { left = ' ', right = '' }, icon = '' },
          },
          lualine_b = {
            {
              'filetype',
              icon_only = true,
              padding = { left = 1, right = 0 },
            },
            'filename',
          },
          lualine_c = {
            {
              'branch',
              icon = '',
            },
            {
              'diff',
              symbols = { added = ' ', modified = ' ', removed = ' ' },
              colored = false,
            },
          },
          lualine_x = {
            {
              'diagnostics',
              symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
              update_in_insert = true,
            },
          },
          lualine_z = {
            { 'location', separator = { left = '', right = ' ' }, icon = '' },
          },
        },
      }
    end,
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = (function()
          -- Try to read theme from file written by Wezterm
          local theme_file = vim.fn.expand('~/.config/catppuccin-theme')
          if vim.fn.filereadable(theme_file) == 1 then
            local theme = vim.fn.readfile(theme_file)[1]
            if theme and theme ~= '' then
              return theme
            end
          end
          -- Fall back to environment variable or default
          return vim.env.CATPPUCCIN_FLAVOUR or 'mocha'
        end)(),
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = 'dark',
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:help highlight-args`):
          comments = { 'italic' }, -- Change the style of comments
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
          indent_blankline = {
            enabled = true,
            scope_color = 'lavender', -- or 'sapphire', 'sky', 'teal', 'green', 'yellow', 'peach', 'maroon', 'red', 'mauve', 'pink', 'flamingo', 'rosewater'
            colored_indent_levels = true,
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  -- {
  --   'rose-pine/neovim',
  --   name = 'rose-pine',
  --   config = function()
  --     vim.cmd 'colorscheme rose-pine'
  --   end,
  -- },

  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    cond = function()
      -- Only load if we find package.json AND no deno.json in the tree
      local util = require 'lspconfig.util'
      local current_file = vim.fn.expand '%:p'

      local has_package_json = util.root_pattern 'package.json'(current_file) ~= nil
      local has_deno_json = util.root_pattern('deno.json', 'deno.jsonc')(current_file) ~= nil

      return has_package_json and not has_deno_json
    end,

    opts = {
      -- LSP server settings
      settings = {
        -- Enable separate diagnostic server for better caching and performance
        separate_diagnostic_server = true,
        -- Set memory limit to prevent crashes that cause reloads
        tsserver_max_memory = 4096, -- 4GB instead of "auto"
        -- Only check diagnostics when you stop typing (better performance)
        publish_diagnostic_on = 'insert_leave',
        -- Enable inlay hints
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          -- Angular-specific settings
          preferences = {
            includePackageJsonAutoImports = 'on',
            importModuleSpecifier = 'relative',
            -- Enable project-wide caching
            includeCompletionsForModuleExports = true,
            -- Exclude heavy directories from watching
            excludeLibs = true,
            -- Performance optimizations
            excludeDirectories = { '**/node_modules', '**/.git' },
          },
          -- Performance settings
          watchOptions = {
            watchFile = 'useFsEvents',
            watchDirectory = 'useFsEvents',
            excludeDirectories = { '**/node_modules/**/*' },
          },
          -- Enable strict mode features
          suggest = {
            autoImports = true,
            completeFunctionCalls = true,
            -- Don't auto-import from deep node_modules for performance
            includeCompletionsForModuleExports = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
      -- Custom handlers
      handlers = {
        -- Better error handling for Angular projects
        ['textDocument/publishDiagnostics'] = function(...)
          vim.lsp.handlers['textDocument/publishDiagnostics'](...)
        end,
      },
      -- Expose additional commands
      expose_as_code_action = 'all',
    },
    config = function(_, opts)
      require('typescript-tools').setup(opts)
    end,
  },

  {
    'prisma/vim-prisma',
    ft = 'prisma',
  },

  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup {
        -- Automatically change the working directory to the project root
        detection_methods = { 'pattern', 'lsp' },
        patterns = { '.git', 'Makefile', 'package.json', 'pyproject.toml', '.nvimrc' },
        silent_chdir = false, -- Show messages when changing directories
      }

      -- Note: project.nvim will work with snacks.picker automatically
    end,
  },

  --

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>n', group = '[N]otes' },
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  -- Fuzzy Finder using snacks.picker (replacing telescope)
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        enabled = true,
        win = {
          input = {
            keys = {
              ['<C-c>'] = { 'close', mode = { 'n', 'i' } },
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            },
          },
        },
        sources = {
          files = {
            -- Use standard fd/ripgrep ignore behavior
            hidden = false,
            no_ignore = false,
          },
        },
      },
      input = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = '󰈞 ', key = 'f', desc = 'Find File', action = ':lua Snacks.picker.files()' },
            { icon = '󰈔 ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { icon = '󰊄 ', key = 'g', desc = 'Find Text', action = ':lua Snacks.picker.grep()' },
            { icon = '󰋚 ', key = 'r', desc = 'Recent Files', action = ':lua Snacks.picker.recent()' },
            { icon = '󰒓 ', key = 'c', desc = 'Config', action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
            { icon = '󰁯 ', key = 's', desc = 'Restore Session', section = 'session' },
            { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { icon = '󰩈 ', key = 'q', desc = 'Quit', action = ':qa' },
          },
          header = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
        },
      },
    },
    config = function(_, opts)
      require('snacks').setup(opts)

      -- Setup keymaps for snacks.picker
      local picker = Snacks.picker

      -- Helper pickers (sidebar layout for reference material)
      vim.keymap.set('n', '<leader>sh', function()
        picker.help { layout = 'sidebar' }
      end, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', function()
        picker.keymaps { layout = 'sidebar' }
      end, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sd', function()
        picker.diagnostics { layout = 'ivy' }
      end, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>ss', function()
        picker.pickers { layout = 'ivy' }
      end, { desc = '[S]earch [S]elect Picker' })

      -- File searches (telescope layout for wide path visibility)
      vim.keymap.set('n', '<leader>sf', function()
        picker.files { layout = 'default' }
      end, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>s.', function()
        picker.recent { layout = 'default' }
      end, { desc = '[S]earch Recent Files ("." for repeat)' })

      -- Grep searches (vertical layout for content preview)
      vim.keymap.set('n', '<leader>sw', function()
        picker.grep_word { layout = 'vertical' }
      end, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', function()
        picker.grep { layout = 'vertical' }
      end, { desc = '[S]earch by [G]rep' })

      -- Buffer searches (dropdown layout for quick access)
      vim.keymap.set('n', '<leader><leader>', function()
        picker.buffers { layout = 'dropdown' }
      end, { desc = '[ ] Find existing buffers' })

      -- Buffer search (dropdown layout for quick access)
      vim.keymap.set('n', '<leader>/', function()
        picker.lines { layout = 'dropdown' }
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- Live grep in open files (vertical layout for content preview)
      vim.keymap.set('n', '<leader>s/', function()
        picker.grep { open_files_only = true, layout = 'vertical' }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Search Neovim configuration files (telescope layout for wide path visibility)
      vim.keymap.set('n', '<leader>sn', function()
        picker.files { cwd = vim.fn.stdpath 'config', layout = 'default' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- Completion framework
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',
    opts = {
      keymap = {
        preset = 'default',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<C-e>'] = { 'cancel', 'fallback' },
        ['<C-y>'] = { 'accept', 'fallback' },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
        kind_icons = {
          Text = '󰉿',
          Method = '󰆧',
          Function = '󰊕',
          Constructor = '',
          Field = '󰜢',
          Variable = '󰀫',
          Class = '󰠱',
          Interface = '',
          Module = '',
          Property = '󰜢',
          Unit = '󰑭',
          Value = '󰎠',
          Enum = '',
          Keyword = '󰌋',
          Snippet = '',
          Color = '󰏘',
          File = '󰈙',
          Reference = '󰈇',
          Folder = '󰉋',
          EnumMember = '',
          Constant = '󰏿',
          Struct = '󰙅',
          Event = '',
          Operator = '󰆕',
          TypeParameter = '',
        },
      },

      completion = {
        trigger = {
          prefetch_on_insert = true,
          show_on_insert_on_trigger_character = false,
        },
        accept = {
          create_undo_point = true,
          auto_brackets = {
            enabled = true,
            default_brackets = { '(', ')' },
            kind_resolution = {
              enabled = true,
              -- blocked_filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
            },
          },
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
          cycle = {
            from_bottom = true,
            from_top = true,
          },
        },
        menu = {
          enabled = true,
          min_width = 15,
          max_height = 10,
          border = 'single',
          winblend = 0,
          scrolloff = 2,
          scrollbar = true,
          auto_show = true,
          draw = {
            treesitter = { 'lsp' },
            columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          update_delay_ms = 50,
          treesitter_highlighting = true,
          window = {
            min_width = 10,
            max_width = 60,
            max_height = 20,
            border = 'single',
            winblend = 0,
            scrollbar = true,
          },
        },
        ghost_text = {
          enabled = false,
        },
      },

      fuzzy = {
        frecency = {
          enabled = true,
        },
        use_proximity = true,
        sorts = { 'label', 'kind', 'score' },
      },

      sources = {
        default = { 'lsp', 'lazydev' },
        providers = {
          lsp = {
            name = 'LSP',
            module = 'blink.cmp.sources.lsp',
            enabled = true,
            opts = {
              -- C# specific completion options
              completionItem = {
                commitCharactersSupport = true,
                documentationFormat = { 'markdown', 'plaintext' },
                snippetSupport = true,
              },
            },
          },
          path = {
            name = 'Path',
            module = 'blink.cmp.sources.path',
            score_offset = 3,
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              show_hidden_files_by_default = false,
            },
          },
          snippets = {
            name = 'Snippets',
            module = 'blink.cmp.sources.snippets',
            score_offset = -3,
            opts = {
              friendly_snippets = true,
              search_paths = { vim.fn.stdpath 'config' .. '/snippets' },
              global_snippets = { 'all' },
              extended_filetypes = {
                typescript = { 'javascript' },
                javascriptreact = { 'javascript' },
                typescriptreact = { 'javascript', 'typescript' },
                leaf = { 'html' },
                cs = { 'csharp' },
              },
            },
          },
          buffer = {
            name = 'Buffer',
            module = 'blink.cmp.sources.buffer',
            score_offset = -3,
          },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },

      cmdline = {
        enabled = true,
        sources = { 'cmdline' },
      },

      signature = {
        enabled = false,
        trigger = {
          blocked_trigger_characters = {},
          blocked_retrigger_characters = {},
          show_on_insert_on_trigger_character = false,
        },
        window = {
          min_width = 1,
          max_width = 100,
          max_height = 10,
          border = 'single',
          winblend = 0,
          scrollbar = false,
        },
      },
    },
    opts_extend = { 'sources.default' },
  },

  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      {
        'williamboman/mason.nvim',
        opts = {
          registries = {
            'github:mason-org/mason-registry',
            'github:crashdummyy/mason-registry',
          },
          ensure_installed = {
            'roslyn',
          },
        },
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function(_, opts)
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          -- LSP pickers (ivy layout for quick navigation without disrupting view)
          map('grr', function()
            Snacks.picker.lsp_references { layout = 'ivy' }
          end, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', function()
            Snacks.picker.lsp_implementations { layout = 'ivy' }
          end, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', function()
            Snacks.picker.lsp_definitions { layout = 'ivy' }
          end, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', function()
            Snacks.picker.lsp_symbols { layout = 'ivy' }
          end, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', function()
            Snacks.picker.lsp_workspace_symbols { layout = 'ivy' }
          end, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', function()
            Snacks.picker.lsp_type_definitions { layout = 'ivy' }
          end, '[G]oto [T]ype Definition')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method('textDocument/documentHighlight', { bufnr = event.buf }) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method('textDocument/inlayHint', { bufnr = event.buf }) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          -- Override default keymaps with lspsaga versions (buffer-local)
          vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', { buffer = event.buf, desc = 'LSP: Hover Documentation' })
          vim.keymap.set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', { buffer = event.buf, desc = 'LSP: Goto Definition' })
          vim.keymap.set('n', 'gp', '<cmd>Lspsaga peek_definition<CR>', { buffer = event.buf, desc = 'LSP: Peek Definition' })
          vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder<CR>', { buffer = event.buf, desc = 'LSP: Find References' })
          vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', { buffer = event.buf, desc = 'LSP: Code Action' })
          vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', { buffer = event.buf, desc = 'LSP: Rename' })
          -- vim.keymap.set('n', '<leader>o', '<cmd>Lspsaga outline<CR>', { buffer = event.buf, desc = 'LSP: Outline' })
          vim.keymap.set('n', 'gt', '<cmd>Lspsaga goto_type_definition<CR>', { buffer = event.buf, desc = 'LSP: Goto Type Definition' })

          -- Diagnostic navigation
          vim.keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { buffer = event.buf, desc = 'LSP: Previous Diagnostic' })
          vim.keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', { buffer = event.buf, desc = 'LSP: Next Diagnostic' })
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim-cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        -- vtsls = {},
        html = {},
        denols = {
          filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
        },

        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
                validProperties = {},
                unknownProperties = 'ignore',
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
                validProperties = {},
                unknownProperties = 'ignore',
              },
            },
          },
        },

        tailwindcss = {
          filetypes = {
            'html',
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
            'css',
            'scss',
            'sass',
            'vue',
            'svelte',
          },
          init_options = {
            userLanguages = {
              scss = 'css', -- Treat SCSS files as CSS for Tailwind processing
            },
          },
          settings = {
            tailwindCSS = {
              lint = {
                cssConflict = 'warning',
                invalidApply = 'ignore', -- Changed from "error" to "ignore"
                invalidConfigPath = 'error',
                invalidScreen = 'error',
                invalidTailwindDirective = 'error',
                invalidVariant = 'error',
                recommendedVariantOrder = 'warning',
              },
              experimental = {
                classRegex = {
                  'tw`([^`]*)`', -- For twin.macro or similar
                  'tw="([^"]*)"',
                  'clsx\\(([^)]*)\\)',
                  'cva\\(([^)]*)\\)',
                  'theme\\(([^)]*)\\)',
                },

                cmdline = {
                  enabled = true,
                  sources = { 'cmdline' },
                },
              },
            },
          },
        },
        emmet_language_server = {},
        --

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers are installed
      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'netcoredbg',
        'stylua', -- Used to format Lua code
        'html-lsp',
        'css-lsp',
        'tailwindcss-language-server',
        'emmet-language-server',
        'lua-language-server',
        -- 'typescript-language-server',
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- Manually configure SourceKit-LSP (outside of Mason)
      vim.lsp.config('sourcekit', {
        cmd = { '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp' },
        filetypes = { 'swift', 'c', 'cpp', 'objective-c', 'objective-cpp' },
        root_dir = function(fname)
          local util = require 'lspconfig.util'
          return util.root_pattern 'buildServer.json'(fname)
            or util.root_pattern('*.xcodeproj', '*.xcworkspace')(fname)
            or util.root_pattern 'Package.swift'(fname)
            or util.find_git_ancestor(fname)
            or util.path.dirname(fname)
        end,
        single_file_support = true,
      })

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- Fix for Mason v2: explicitly configure servers with custom settings
      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
      end
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end

        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        dockerfile = { 'dockerls' },
        typescript = function()
          if vim.fn.filereadable(vim.fn.getcwd() .. '/deno.json') == 1 or vim.fn.filereadable(vim.fn.getcwd() .. '/deno.jsonc') == 1 then
            return { 'deno' }
          else
            return { 'prettier' }
          end
        end,
        javascript = function()
          if vim.fn.filereadable(vim.fn.getcwd() .. '/deno.json') == 1 or vim.fn.filereadable(vim.fn.getcwd() .. '/deno.jsonc') == 1 then
            return { 'deno' }
          else
            return { 'prettier' }
          end
        end,
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/kickstart/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/kickstart/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`

  { import = 'kickstart.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Enhanced file type detection for Angular component SCSS files
vim.filetype.add {
  pattern = {
    ['.*%.component%.scss$'] = 'scss',
    ['.*%.component%.sass$'] = 'sass',
    ['.*%.component%.css$'] = 'css',
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'leaf',
  callback = function()
    vim.bo.commentstring = '<!-- %s -->'
    -- Start emmet_language_server with correct config
    vim.lsp.start {
      name = 'emmet_language_server',
      cmd = { 'emmet-language-server', '--stdio' },
      filetypes = { 'html', 'css', 'scss', 'javascript', 'typescript', 'leaf' },
      init_options = {
        includeLanguages = {
          leaf = 'html',
        },
      },
      capabilities = require('blink.cmp').get_lsp_capabilities(),
    }
  end,
})

-- vim.g.clipboard = {
--   name = 'WslClipboard',
--   copy = {
--     ['+'] = 'clip.exe',
--     ['*'] = 'clip.exe',
--   },
--   paste = {
--     ['+'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--     ['*'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--   },
--   cache_enabled = 0,
-- }

-- GrugFar helper functions (word, selection, replace, git root, project root)
local grug_ok, grug = pcall(require, 'grug-far')
if grug_ok then
  local function get_visual_selection()
    -- Use the unnamed register to yank the current visual selection without clobbering registers
    local save_reg = vim.fn.getreg '"'
    local save_type = vim.fn.getregtype '"'
    vim.cmd 'silent! normal! "vy'
    local text = vim.fn.getreg '"'
    vim.fn.setreg('"', save_reg, save_type)
    return text
  end

  _G.GrugFarSearchWord = function()
    local w = vim.fn.expand '<cword>'
    grug.open { prefills = { search = w } }
  end

  _G.GrugFarSearchSelection = function()
    local sel = get_visual_selection()
    if not sel or sel == '' then
      sel = vim.fn.expand '<cword>'
    end
    grug.open { prefills = { search = sel } }
  end

  _G.GrugFarSearchReplace = function()
    local w = vim.fn.expand '<cword>'
    grug.open { prefills = { search = w } }
  end

  _G.GrugFarGitRoot = function()
    local root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
    if root and root ~= '' then
      grug.open { cwd = root }
    else
      grug.open()
    end
  end

  _G.GrugFarProjectRoot = function()
    local ok_proj, project = pcall(require, 'project_nvim.project')
    local root = (ok_proj and project.get_project_root()) or vim.loop.cwd()
    grug.open { cwd = root }
  end
end

-- Git Related Extensions

-- Git keymaps (add to the keymap section)
local wk = require 'which-key'
wk.add {
  { '<leader>g', group = 'Git' },
  { '<leader>gs', '<cmd>Neogit<cr>', desc = 'Neogit Status' },
  { '<leader>gc', '<cmd>Neogit commit<cr>', desc = 'Neogit Commit' },
  { '<leader>gp', '<cmd>Neogit push<cr>', desc = 'Neogit Push' },
  { '<leader>gl', '<cmd>Neogit log<cr>', desc = 'Neogit Log' },
  { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diffview: Current Changes' },
  { '<leader>gD', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diffview: File History' },
  { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Close Diffview' },
  { '<leader>gb', '<cmd>BlameToggle<cr>', desc = 'Toggle Git Blame' },
  { '<leader>gB', '<cmd>BlameToggle window<cr>', desc = 'Open Git Blame Window' },
  { '<leader>R', group = 'REST Client' },
  { '<leader>Rs', "<cmd>lua require('kulala').run()<cr>", desc = 'Send Request' },
  { '<leader>Rt', "<cmd>lua require('kulala').toggle_view()<cr>", desc = 'Toggle Headers/Body' },
  { '<leader>Rp', "<cmd>lua require('kulala').jump_prev()<cr>", desc = 'Previous Request' },
  { '<leader>Rn', "<cmd>lua require('kulala').jump_next()<cr>", desc = 'Next Request' },
  { '<leader>a', group = 'Quick Switcher' },
  { '<leader>aa', desc = 'Toggle HTML  TypeScript' },
  { '<leader>ag', desc = 'Switch to TypeScript' },
  { '<leader>af', desc = 'Switch to HTML' },
  { '<leader>ad', desc = 'Find CSS/SCSS files' },
  { '<leader>sr', '<cmd>GrugFarResume<cr>', desc = 'GrugFar Resume Last' },
  { '<leader>sS', GrugFarSearchWord, desc = 'GrugFar Search (word)' },
  { '<leader>sS', GrugFarSearchSelection, mode = 'v', desc = 'GrugFar Search (selection)' },
  { '<leader>sR', GrugFarSearchReplace, desc = 'GrugFar Search & Replace' },
  { '<leader>sF', GrugFarGitRoot, desc = 'GrugFar Git Root' },
  { '<leader>sP', GrugFarProjectRoot, desc = 'GrugFar Project Root' },
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- Command to reload Catppuccin theme from file
vim.api.nvim_create_user_command('CatppuccinReload', function()
  local theme_file = vim.fn.expand('~/.config/catppuccin-theme')
  if vim.fn.filereadable(theme_file) == 1 then
    local theme = vim.fn.readfile(theme_file)[1]
    if theme and theme ~= '' then
      require('catppuccin').setup({ flavour = theme })
      vim.cmd.colorscheme 'catppuccin'
      print('Reloaded Catppuccin theme: ' .. theme)
    end
  end
end, { desc = 'Reload Catppuccin theme from config file' })

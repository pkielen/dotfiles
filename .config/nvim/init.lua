-------------------- HELPERS -------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options
local api = vim.api  -- to set options

-------------------- PLUGINS -------------------------------
cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself

-- Hihglighting and more
paq {'nvim-treesitter/nvim-treesitter'}

-- Lsp stuff
paq {'neovim/nvim-lspconfig'}

-- Lightbulb emoji
paq {'kosayoda/nvim-lightbulb'}

-- Autocompletion
paq {'hrsh7th/nvim-compe'}

-- Colorscheme
paq {'shaunsingh/nord.nvim'}

-- Fuzzy finding
paq {'junegunn/fzf', run = fn['fzf#install']}
paq {'junegunn/fzf.vim'}
paq {'nvim-lua/popup.nvim'}
paq {'nvim-lua/plenary.nvim'}
paq {'nvim-telescope/telescope.nvim'}
paq {'ojroques/nvim-lspfuzzy'}

-- Snippets
--paq {'SirVer/ultisnips'}
paq {'hrsh7th/vim-vsnip'}
paq {'hrsh7th/vim-vsnip-integ'}
paq {'rafamadriz/friendly-snippets'}
--paq {'honza/vim-snippets'}

-- Status line
paq {'hoob3rt/lualine.nvim'}
paq {'ryanoasis/vim-devicons'}

-- File explorer
paq {'kyazdani42/nvim-web-devicons'} -- for the icons
paq {'kyazdani42/nvim-tree.lua'}

--Sessions
paq {'tpope/vim-obsession'}

-- Multiline comments
paq {'terrortylor/nvim-comment'}

-- Git integration
-- paq {'mhinz/vim-signify'}
paq {'nvim-lua/plenary.nvim'}
paq {'tanvirtin/vgit.nvim'}

-- Note taking
paq {'vimwiki/vimwiki'}
paq {'michal-h21/vim-zettel'}

-- General settings
opt.number = true
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.shortmess = 'A'
opt.mouse = 'a'
opt.undofile = true
opt.undodir= os.getenv("HOME") .. "/.vim/undo"
opt.exrc = true
opt.secure = true
opt.list = true

-- Show special characters for trailing whitespace and such
opt.listchars:append({ trail = "○" })

-- General mappings
g.mapleader = " "
api.nvim_set_keymap("i", "jk", "<Esc>", {})
api.nvim_set_keymap("n", "<Leader>h", "<C-w>h", {})
api.nvim_set_keymap("n", "<Leader>j", "<C-w>j", {})
api.nvim_set_keymap("n", "<Leader>k", "<C-w>k", {})
api.nvim_set_keymap("n", "<Leader>l", "<C-w>l", {})
api.nvim_set_keymap("n", "<Leader>t", ":ClangdSwitchSourceHeader<Enter>", {})
api.nvim_set_keymap("n", "<C-u>", "}", {})
api.nvim_set_keymap("n", "<C-i>", "{", {})

-- Map tab
local t = function(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end
-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

--============ Plugin settings ============--
--
--== fzf ==--
api.nvim_set_keymap("n", "<Leader>b", ":Buffers<Enter>", {})
api.nvim_set_keymap("n", "<Leader>f", ":Files<Enter>", {})

--== nvim-tree ==--
require'nvim-tree'.setup {
    view = { 
        width = 60 
    }
}
api.nvim_set_keymap("n", "<Leader>d", ":NvimTreeFindFile<Enter>", {})
api.nvim_set_keymap("n", "<Leader>e", ":NvimTreeClose<Enter>", {})

--== nvim-lspconfig ==--
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) api.nvim_buf_set_keymap(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}


-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
nvim_lsp["clangd"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "clangd-12", "--background-index" },
  flags = {
    debounce_text_changes = 150,
  }
}


nvim_lsp["pylsp"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  }
}


--== nvim-treesitter ==--
require'nvim-treesitter.configs'.setup {
  highlight = {
    ensure_installed = 'maintained',
    enable = true,
  }
}

--== nvim-compe ==--
opt.completeopt = 'menuone,noinsert,noselect'

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
    treesitter = true;
  };
}
  api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", { noremap = true, silent = true, expr = true })
  api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", { noremap = true, silent = true, expr = true })
  api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", { noremap = true, silent = true, expr = true })
  api.nvim_set_keymap("i", "<C-f>", "compe#scroll({ 'delta': +4 })", { noremap = true, silent = true, expr = true })
  api.nvim_set_keymap("i", "<C-d>", "compe#scroll({ 'delta': -4 })", { noremap = true, silent = true, expr = true })

--== vim-vsnip ==-- 

--== nord-vim ==--
vim.g.nord_contrast = true
vim.g.nord_borders = true
vim.g.nord_disable_background = true
vim.g.nord_italic = false
require('nord').set()

--== lualine ==--
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'nord',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {{ 'filename', path = 1}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

--== lightbulb ==--
cmd [[autocmd InsertLeave * lua require'nvim-lightbulb'.update_lightbulb()]]
require'nvim-lightbulb'.update_lightbulb {
    sign = {
        enabled = true,
        -- Priority of the gutter sign
        priority = 1,
    }
}

--== nvim-comment ==--
require('nvim_comment').setup()
-- when you enter a (new) buffer
cmd [[augroup set-commentstring-ag]]
cmd [[autocmd!]]
cmd [[autocmd BufEnter *.cpp,*.h :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")]]
-- when you've changed the name of a file opened in a buffer, the file type may have changed
cmd[[autocmd BufFilePost *.cpp,*.h :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")]]

api.nvim_set_keymap("n", "<Leader>c", ":CommentToggle<Enter>", {})
api.nvim_set_keymap("v", "<Leader>c", ":CommentToggle<Enter>", {})

--== vgit ==--
opt.updatetime = 50
local vgit = require('vgit')
vgit.setup({
    debug = false,
    keymaps = {
        ['n <C-k>'] = 'hunk_up',
        ['n <C-j>'] = 'hunk_down',
        ['n <leader>g'] = 'actions',
        ['n <leader>gs'] = 'buffer_hunk_stage',
        ['n <leader>gr'] = 'buffer_hunk_reset',
        ['n <leader>gp'] = 'buffer_hunk_preview',
        ['n <leader>gb'] = 'buffer_blame_preview',
        ['n <leader>gf'] = 'buffer_diff_preview',
        ['n <leader>gh'] = 'buffer_history_preview',
        ['n <leader>gu'] = 'buffer_reset',
        ['n <leader>gg'] = 'buffer_gutter_blame_preview',
        ['n <leader>gj'] = 'buffer_unstage',
        ['n <leader>gk'] = 'buffer_stage',
        ['n <leader>gd'] = 'project_diff_preview',
        ['n <leader>gq'] = 'project',
        ['n <leader>gx'] = 'toggle_diff_preference',
    },
    controller = {
        hunks_enabled = true,
        blames_enabled = true,
        diff_strategy = 'index',
        diff_preference = 'horizontal',
        predict_hunk_signs = true,
        predict_hunk_throttle_ms = 300,
        predict_hunk_max_lines = 50000,
        blame_line_throttle_ms = 150,
        action_delay_ms = 300,
    },
    hls = vgit.themes.tokyonight,
    sign = {
        VGitViewSignAdd = {
            name = 'DiffAdd',
            line_hl = 'DiffAdd',
            text_hl = nil,
            num_hl = nil,
            icon = nil,
            text = '',
        },
        VGitViewSignRemove = {
            name = 'DiffDelete',
            line_hl = 'DiffDelete',
            text_hl = nil,
            num_hl = nil,
            icon = nil,
            text = '',
        },
        VGitSignAdd = {
            name = 'VGitSignAdd',
            text_hl = 'VGitSignAdd',
            num_hl = nil,
            icon = nil,
            line_hl = nil,
            text = '┃',
        },
        VGitSignRemove = {
            name = 'VGitSignRemove',
            text_hl = 'VGitSignRemove',
            num_hl = nil,
            icon = nil,
            line_hl = nil,
            text = '┃',
        },
        VGitSignChange = {
            name = 'VGitSignChange',
            text_hl = 'VGitSignChange',
            num_hl = nil,
            icon = nil,
            line_hl = nil,
            text = '┃',
        },
    },
})

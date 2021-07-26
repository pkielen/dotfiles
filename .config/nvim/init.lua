-------------------- HELPERS -------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

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
paq {'arcticicestudio/nord-vim'}

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
--paq {'honza/vim-snippets'}

-- Status line
paq {'hoob3rt/lualine.nvim'}
paq {'ryanoasis/vim-devicons'}

-- General settings
opt.number = true
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4

-- General mappings
g.mapleader = " "
vim.api.nvim_set_keymap("i", "jk", "<Esc>", {})
vim.api.nvim_set_keymap("n", "<Leader>b", ":Buffers<Enter>", {})
vim.api.nvim_set_keymap("n", "<Leader>f", ":Files<Enter>", {})
vim.api.nvim_set_keymap("n", "<Leader>h", "<C-w>h", {})
vim.api.nvim_set_keymap("n", "<Leader>j", "<C-w>j", {})
vim.api.nvim_set_keymap("n", "<Leader>k", "<C-w>k", {})
vim.api.nvim_set_keymap("n", "<Leader>l", "<C-w>l", {})

-- Map tab
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
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

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

--============ Plugin settings ============--
--
--== nvim-lspconfig ==--
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

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
local servers = { "pyls", "clangd"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

--== nvim-treesitter ==--
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  }
}

--== nvim-compe ==--
vim.opt.completeopt = 'menuone,noinsert,noselect'

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
  vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", { noremap = true, silent = true, expr = true })
  vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", { noremap = true, silent = true, expr = true })
  vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", { noremap = true, silent = true, expr = true })
  vim.api.nvim_set_keymap("i", "<C-f>", "compe#scroll({ 'delta': +4 })", { noremap = true, silent = true, expr = true })
  vim.api.nvim_set_keymap("i", "<C-d>", "compe#scroll({ 'delta': -4 })", { noremap = true, silent = true, expr = true })

--== vim-vsnip ==-- 

--== nord-vim ==--
vim.api.nvim_command('colorscheme nord')

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
    lualine_c = {{ 'filename', path = 2}},
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
vim.cmd [[autocmd InsertLeave * lua require'nvim-lightbulb'.update_lightbulb()]]
require'nvim-lightbulb'.update_lightbulb {
    sign = {
        enabled = true,
        -- Priority of the gutter sign
        priority = 1,
    }
}

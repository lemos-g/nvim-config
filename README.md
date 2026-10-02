# nvim

Config do Neovim para **ler e revisar** código, diffs e testes gerados por IA —
não para editar à mão. Construída em camadas:

1. estrutura base + [lazy.nvim](https://github.com/folke/lazy.nvim) +
   [snacks.nvim](https://github.com/folke/snacks.nvim)
2. aparência e UX: mini.icons, lualine, noice, which-key e quatro temas com
   seletor

Sem LSP ou treesitter por enquanto.

```
init.lua                 options → keymaps → lazy → tema
lua/config/options.lua   leader e opções do editor
lua/config/keymaps.lua   atalhos sem plugin (alternar teste ↔ fonte)
lua/config/lazy.lua      bootstrap do lazy.nvim
lua/config/theme.lua     tema ativo, seletor e persistência da escolha
lua/plugins/snacks.lua   snacks.nvim: módulos, estilos e atalhos
lua/plugins/kanagawa.lua, catppuccin.lua, tokyonight.lua, everforest.lua
                         temas (um arquivo por tema)
colors/everforest-*.lua  everforest claro/escuro como colorschemes próprios
lua/plugins/mini-icons.lua ícones (emula nvim-web-devicons)
lua/plugins/lualine.lua  statusline
lua/plugins/noice.lua    cmdline, busca e mensagens
lua/plugins/which-key.lua popup de atalhos e nomes dos grupos
lazy-lock.json           versões fixadas (versionado)
```

## snacks.nvim

Ligados:

| Módulo | Por quê |
| --- | --- |
| picker | busca de arquivos, grep, git, LSP e help num só lugar |
| explorer | árvore de arquivos lateral; substitui o netrw (`nvim .`) |
| words | destaca referências do símbolo sob o cursor e navega com `]]`/`[[` |
| indent | guias de indentação para ler blocos longos |
| scope | detecta o escopo atual (usado pelo indent) |
| statuscolumn | coluna com números, sinais e folds organizados |
| lazygit | lazygit em janela flutuante para revisar commits e diffs |
| gh | PRs e issues do GitHub pelo picker |
| dashboard | tela inicial com atalhos, recentes e projetos |
| scroll | rolagem suave, ajuda a não perder o contexto |
| animate | base das animações (scroll, dim) |
| dim | escurece o que está fora do escopo atual |
| zen | modo foco e zoom de janela |
| notifier | notificações flutuantes com histórico |
| input | `vim.ui.input` bonito |
| image | imagens inline via protocolo Kitty |
| bigfile | desliga recursos pesados em arquivos grandes |
| quickfile | abre o arquivo passado na linha de comando antes de carregar tudo |
| terminal | terminal flutuante/split com toggle |

Bibliotecas usadas via atalho: `toggle`, `bufdelete`.

Desligados: `gitbrowse`, `scratch`, `rename`, `debug`, `profiler`.

Bordas: a fonte única é `vim.o.winborder = "rounded"`. No snacks,
`border = true` significa "usar winborder"; só `lazygit`, `terminal` e `zen`
precisaram disso explicitamente — o resto já vem assim.

## Aparência e UX

| Plugin | Por quê |
| --- | --- |
| [mini.icons](https://github.com/nvim-mini/mini.icons) | ícones para snacks (picker, explorer, dashboard) e, via mock de nvim-web-devicons, para o lualine |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | statusline global (`theme = "auto"`, acompanha o tema): modo · branch · diagnósticos, ícone e caminho relativo à raiz do repo · status do noice e diff · progresso e posição |
| [noice.nvim](https://github.com/folke/noice.nvim) | `:` flutuante, `/` embaixo, mensagens longas em split, escrita/undo discretos na view mini, hover de LSP em markdown com borda |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | popup com os atalhos após um prefixo, grupos nomeados e estado ligado/desligado dos toggles de `<leader>u` |

O `vim.notify` continua sendo o notifier do snacks: o noice está com
`notify.enabled = false`, e a view `notify` dele usa o snacks como backend.

Fora de propósito: bufferline (a navegação é pelo picker de buffers),
nvim-notify (o snacks já faz isso), nvim-web-devicons (o mini.icons emula).

## Temas

| Tema | Variantes |
| --- | --- |
| [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | wave (padrão), dragon, lotus (clara) |
| [catppuccin](https://github.com/catppuccin/nvim) | mocha, macchiato, frappe, latte (clara) |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | night, storm, moon, day (clara) |
| [everforest-nvim](https://github.com/neanias/everforest-nvim) | dark, light (clara) |

- `<leader>uC` abre o seletor (picker de colorschemes do snacks) com preview
  ao vivo. A lista mostra só essas 13 variantes; `Esc` volta ao tema anterior.
- A escolha fica salva em `~/.local/state/nvim/theme` (`stdpath("state")`),
  fora do repositório, e é aplicada na inicialização antes do dashboard. Sem
  arquivo, ou com um tema que não existe mais, abre em `kanagawa-wave`.
- Everforest: escolhido o neanias/everforest-nvim em vez do
  sainnhe/everforest por ter grupos para snacks, noice, which-key e
  mini.icons (o do sainnhe não cobre o noice). Ele alterna claro/escuro por
  `vim.o.background`; `colors/everforest-dark.lua` e `everforest-light.lua`
  viram dois colorschemes selecionáveis.
- `background` é acertado por `lua/config/theme.lua` a cada troca, porque o
  kanagawa não o ajusta sozinho.
- Integrações: catppuccin e tokyonight têm snacks, noice, which-key e
  mini.icons ligados explicitamente (e a detecção automática pelo lazy.nvim
  continua ligada para camadas futuras); kanagawa e everforest não têm opções
  — os grupos vêm sempre. Todos trazem tema para o lualine.
- Sem overrides de highlight: snacks e noice linkam seus grupos para
  `NormalFloat`/`FloatBorder`/`FloatTitle`, que os quatro temas definem.

## Atalhos

Leader = `espaço`. Apertar o leader e esperar mostra o popup do which-key;
`<leader>?` mostra só os atalhos locais do buffer atual.

**encontrar** (`<leader>f`)
`ff` arquivos · `fg` grep · `fw` grep da palavra/seleção · `fb` buffers ·
`fr` recentes · `fh` help · `fk` keymaps · `f/` linhas do buffer ·
`fp` retomar último picker

**git** (`<leader>g`)
`gg` lazygit · `gs` status · `gl` log · `gf` log do arquivo ·
`gL` lazygit log · `gd` diff (hunks) · `gp` PRs (gh) · `gi` issues (gh)

**código** (`<leader>c`; os de LSP ficam inertes até a camada LSP)
`cr` referências · `cd` definição · `cD` declaração · `ci` implementações ·
`cy` type definition · `cs` símbolos do arquivo · `cS` símbolos do workspace ·
`cc` chamadas recebidas · `cC` chamadas feitas ·
`ct` alterna `nome.ts` ↔ `nome.test.ts` em vsplit

**interface** (`<leader>u`)
`uw` wrap · `ul` número · `uL` número relativo · `ud` diagnósticos ·
`uh` inlay hints · `ug` guias de indentação · `us` scroll suave ·
`ua` animações · `uD` dim · `uz` zen · `uZ` zoom ·
`un` histórico de notificações · `uN` descartar notificações · `uC` temas

**buffer** (`<leader>b`)
`bd` fechar buffer

**Geral**
`<leader>e` explorer · `<leader>?` atalhos locais do buffer ·
`<C-/>` terminal · `]]` / `[[` próxima/anterior referência

## Dependências externas

- Neovim ≥ 0.11 (usa `winborder`); a UI experimental de mensagens do 0.12
  (`ui2`) deve ficar desligada, pois o noice usa `vim.ui_attach`
- git, ripgrep (`rg`), fd
- lazygit
- gh, autenticado (`gh auth login`)
- ImageMagick (`magick`)
- wl-clipboard (clipboard no Wayland)
- Nerd Font (JetBrainsMono Nerd Font)
- Terminal com protocolo de imagem do Kitty (Ghostty, Kitty, WezTerm)

Opcionais para o módulo image: ghostscript (PDF), tectonic ou pdflatex
(LaTeX), mmdc (Mermaid).

# nvim

Config do Neovim para **ler e revisar** código, diffs e testes gerados por IA —
não para editar à mão. Construída em camadas:

1. estrutura base + [lazy.nvim](https://github.com/folke/lazy.nvim) +
   [snacks.nvim](https://github.com/folke/snacks.nvim)
2. aparência e UX: mini.icons, lualine, noice, which-key e quatro temas com
   seletor
3. git: diffview (revisar) e gitsigns (ler), ao lado do lazygit (agir)

Sem LSP ou treesitter por enquanto.

```
init.lua                 options → keymaps → lazy → tema
lua/config/options.lua   leader e opções do editor (inclui diffopt)
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
lua/plugins/diffview.lua diff lado a lado para revisar
lua/plugins/gitsigns.lua mudanças na lateral, preview e blame
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
| [noice.nvim](https://github.com/folke/noice.nvim) | `:` flutuante, `/` embaixo, mensagens longas em split, escrita, undo e "Hunk X of Y" do gitsigns discretos na view mini, hover de LSP em markdown com borda |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | popup com os atalhos após um prefixo, grupos nomeados e estado ligado/desligado dos toggles de `<leader>u` |

O `vim.notify` continua sendo o notifier do snacks: o noice está com
`notify.enabled = false`, e a view `notify` dele usa o snacks como backend.

Fora de propósito: bufferline (a navegação é pelo picker de buffers),
nvim-notify (o snacks já faz isso), nvim-web-devicons (o mini.icons emula).

## Git

Cada ferramenta tem um papel, e só o lazygit muda o repositório:

| Ferramenta | Papel |
| --- | --- |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | **revisar**: diff lado a lado (antes à esquerda, depois à direita), painel de arquivos em árvore, histórico |
| lazygit (snacks) | **agir**: stage, commit, branch, rebase |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | **mostrar durante a leitura**: sinais na lateral, preview do trecho, blame |

- Sem atalhos de ação no diffview nem no gitsigns. Os padrões do diffview que
  fazem stage/restore (`-`, `s`, `S`, `U`, `X`), resolvem conflito
  (`<leader>c*`, `dx`, `dX`, `1do`/`2do`/`3do`) ou sombreiam `<leader>e` e
  `<leader>b` estão desligados.
- Diff: `diffopt` com `algorithm:histogram` e `linematch:60` alinha lado a
  lado as linhas que mudaram pouco; linhas sem par do outro lado aparecem
  hachuradas (`fillchars` `diff:╱`). `enhanced_diff_hl` ligado.
- Diff da branch: `main...HEAD` (desde o merge-base, como o diff do PR); usa
  `master` se não houver `main`.
- Sinais: a statuscolumn do snacks reconhece os sinais `GitSigns*` e os põe
  no espaço de git dela — não há coluna extra.
- O componente de diff do lualine lê os números do gitsigns.
- Blame inline (texto discreto no fim da linha) começa desligado; `<leader>ub`
  alterna.

Dentro do diffview: `q` fecha (de qualquer tela), `Tab`/`Shift-Tab` próximo/
anterior arquivo, `<C-e>` mostra/esconde o painel de arquivos, `g?` ajuda.

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
- Integrações: catppuccin e tokyonight têm snacks, noice, which-key,
  mini.icons e gitsigns ligados explicitamente, e o catppuccin também o
  diffview (o tokyonight não tem grupo próprio para ele; usa os `Diff*` do
  tema). A detecção automática pelo lazy.nvim continua ligada. kanagawa e
  everforest não têm opções — os grupos (inclusive `Diff*` e `GitSigns*`)
  vêm sempre. Todos trazem tema para o lualine.
- snacks e noice linkam seus grupos para `NormalFloat`/`FloatBorder`/
  `FloatTitle`, que os quatro temas definem.
- Ajustes de highlight, só onde o texto do diff ficava ilegível:
  - kanagawa: o `DiffDelete` tem texto vermelho, e o diffview o copia para o
    texto removido (vermelho sobre fundo avermelhado). Fica só o fundo
    (`lua/plugins/diffview.lua`).
  - tokyonight-day: `DiffText` mais claro (contraste do texto 2.4 → 3.4).
  - everforest-light: `DiffText` com texto normal sobre azul claro, em vez
    de invertido (3.1 → 3.8).

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
diffview: `gv` não commitado · `gr` branch vs main (PR) ·
`gt` testes alterados na branch (`*.test.ts`, `*.test.tsx`) ·
`gF` histórico do arquivo · `gH` histórico do repo
gitsigns: `gh` preview do trecho alterado · `gb` blame da linha

**código** (`<leader>c`; os de LSP ficam inertes até a camada LSP)
`cr` referências · `cd` definição · `cD` declaração · `ci` implementações ·
`cy` type definition · `cs` símbolos do arquivo · `cS` símbolos do workspace ·
`cc` chamadas recebidas · `cC` chamadas feitas ·
`ct` alterna `nome.ts` ↔ `nome.test.ts` em vsplit

**interface** (`<leader>u`)
`uw` wrap · `ul` número · `uL` número relativo · `ud` diagnósticos ·
`uh` inlay hints · `ug` guias de indentação · `us` scroll suave ·
`ua` animações · `uD` dim · `uz` zen · `uZ` zoom ·
`un` histórico de notificações · `uN` descartar notificações · `uC` temas ·
`ub` blame inline

**buffer** (`<leader>b`)
`bd` fechar buffer

**Geral**
`<leader>e` explorer · `<leader>?` atalhos locais do buffer ·
`<C-/>` terminal · `]]` / `[[` próxima/anterior referência ·
`]h` / `[h` próximo/anterior trecho alterado (no diff, mesmo que `]c`/`[c`)

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

# nvim

Config do Neovim para **ler e revisar** código, diffs e testes gerados por IA —
não para editar à mão. Construída em camadas; esta é a camada 1:
estrutura base + [lazy.nvim](https://github.com/folke/lazy.nvim) +
[snacks.nvim](https://github.com/folke/snacks.nvim). Sem tema, LSP ou
treesitter por enquanto.

```
init.lua                 options → keymaps → lazy
lua/config/options.lua   leader e opções do editor
lua/config/keymaps.lua   atalhos sem plugin (alternar teste ↔ fonte)
lua/config/lazy.lua      bootstrap do lazy.nvim
lua/plugins/snacks.lua   snacks.nvim: módulos, estilos e atalhos
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

## Atalhos

Leader = `espaço`.

**Encontrar** (`<leader>f`)
`ff` arquivos · `fg` grep · `fw` grep da palavra/seleção · `fb` buffers ·
`fr` recentes · `fh` help · `fk` keymaps · `f/` linhas do buffer ·
`fp` retomar último picker

**Git** (`<leader>g`)
`gg` lazygit · `gs` status · `gl` log · `gf` log do arquivo ·
`gL` lazygit log · `gd` diff (hunks) · `gp` PRs (gh) · `gi` issues (gh)

**Código** (`<leader>c`; os de LSP ficam inertes até a camada LSP)
`cr` referências · `cd` definição · `cD` declaração · `ci` implementações ·
`cy` type definition · `cs` símbolos do arquivo · `cS` símbolos do workspace ·
`cc` chamadas recebidas · `cC` chamadas feitas ·
`ct` alterna `nome.ts` ↔ `nome.test.ts` em vsplit

**Interface** (`<leader>u`)
`uw` wrap · `ul` número · `uL` número relativo · `ud` diagnósticos ·
`uh` inlay hints · `ug` guias de indentação · `us` scroll suave ·
`ua` animações · `uD` dim · `uz` zen · `uZ` zoom ·
`un` histórico de notificações · `uN` descartar notificações

**Geral**
`<leader>e` explorer · `<leader>bd` fechar buffer ·
`<C-/>` terminal · `]]` / `[[` próxima/anterior referência

## Dependências externas

- Neovim ≥ 0.11 (usa `winborder`)
- git, ripgrep (`rg`), fd
- lazygit
- gh, autenticado (`gh auth login`)
- ImageMagick (`magick`)
- wl-clipboard (clipboard no Wayland)
- Nerd Font (JetBrainsMono Nerd Font)
- Terminal com protocolo de imagem do Kitty (Ghostty, Kitty, WezTerm)

Opcionais para o módulo image: ghostscript (PDF), tectonic ou pdflatex
(LaTeX), mmdc (Mermaid).

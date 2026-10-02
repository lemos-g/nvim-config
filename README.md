# nvim

Configuração pessoal do Neovim (≥ 0.11, testada na 0.12) para **explorar código,
revisar o que o agente fez (diffs, testes) e editar à mão**. Nada de IA aqui — o
Claude Code roda em outra aba do terminal.

Stack-alvo: monorepo pnpm com Next.js, TypeScript strict, Tailwind, Vitest
(testes colocalizados `*.test.ts`) e Supabase (SQL). Só Linux (Fedora, Wayland).

## Dependências

```sh
sudo dnf install git make gcc ripgrep fd-find nodejs wl-clipboard tree-sitter-cli
```

- `git`, `make`, `gcc`: lazy.nvim e a compilação do `telescope-fzf-native`.
- `tree-sitter-cli`: o nvim-treesitter (branch `main`) compila os parsers com ele.
- `ripgrep` / `fd-find`: busca de texto e de arquivos no Telescope.
- `nodejs`: os servidores LSP instalados pelo Mason (ts_ls, eslint, tailwind, json).
- `wl-clipboard`: integra o `y`/`p` com o clipboard do sistema.

### Nerd Font (para os ícones)

```sh
mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd && cd $_
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
tar xf JetBrainsMono.tar.xz && rm JetBrainsMono.tar.xz
fc-cache -f
```

Depois selecione **JetBrainsMono Nerd Font** nas preferências do terminal
(Ghostty: `font-family = "JetBrainsMono Nerd Font"`; Kitty: `font_family JetBrainsMono Nerd Font`).

## Instalação numa máquina nova

```sh
# se já houver uma config, guarde antes:
for d in ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim; do
  [ -e "$d" ] && mv "$d" "$d.bak"
done

git clone git@github.com:lemos-g/nvim-config.git ~/.config/nvim
nvim
```

Na primeira abertura o lazy.nvim se instala, baixa os plugins nas versões do
`lazy-lock.json`, o nvim-treesitter compila os parsers e o Mason instala os
servidores LSP (acompanhe com `:Lazy` e `:Mason`; leva 1–2 minutos). Depois
reinicie o nvim uma vez.

Atualizar plugins: `:Lazy update` e commitar o `lazy-lock.json` novo.

## Estrutura

```
init.lua                 leader + carrega lua/config/*
lua/config/options.lua   opções do editor
lua/config/keymaps.lua   atalhos sem plugin
lua/config/autocmds.lua  recarga automática de arquivos alterados por fora
lua/config/lazy.lua      bootstrap do lazy.nvim
lua/config/theme.lua     temas: seletor + persistência
lua/config/typecheck.lua :Typecheck (tsc --noEmit → quickfix)
lua/plugins/*.lua        um arquivo por área
```

## Plugins

| Plugin | Para que serve |
| --- | --- |
| lazy.nvim | Gerenciador de plugins, com versões fixadas no `lazy-lock.json`. |
| nvim-treesitter | Realce e indentação por árvore sintática (TS, TSX, JS, JSON, Lua, SQL, Markdown, CSS, HTML, Bash). |
| nvim-lspconfig | Configurações prontas dos servidores LSP. |
| mason + mason-lspconfig | Instala e habilita sozinho ts_ls, eslint, tailwindcss, jsonls e lua_ls. |
| blink.cmp | Autocompletar. |
| telescope (+ fzf-native) | Busca difusa: arquivos, texto (ripgrep), símbolos, referências. |
| oil.nvim | Navegar e manipular arquivos editando o diretório como um buffer. |
| mini.nvim | Só `surround`, `comment`, `pairs` e `statusline`. |
| which-key | Mostra os atalhos ao apertar o leader. |
| nvim-web-devicons | Ícones por tipo de arquivo. |
| conform.nvim | Formatar com o Prettier do projeto, só por atalho (nunca ao salvar). |
| diffview.nvim | Diff da branch contra a main, histórico de arquivo, merge de conflitos. |
| gitsigns | Marcas de linhas alteradas, navegar/stage/reset de hunks, blame. |
| neotest + neotest-vitest | Rodar testes do Vitest (sob o cursor, arquivo, suíte do app). |
| trouble.nvim | Painel de diagnósticos, quickfix e TODOs. |
| todo-comments.nvim | Destaca e lista TODO/FIXME/HACK/NOTE. |
| aerial.nvim | Painel com a estrutura do arquivo. |
| catppuccin, kanagawa, everforest | Temas (padrão: Kanagawa wave). |

## Atalhos

Leader = **espaço**. Aperte espaço e espere para o which-key mostrar as opções.

### Sem leader

| Atalho | Ação |
| --- | --- |
| `-` | Abrir a pasta do arquivo (oil); `-` de novo sobe um nível |
| `gd` | Ir para definição |
| `grr` | Referências |
| `gri` | Implementações |
| `grt` | Definição do tipo |
| `grn` / `gra` | Renomear / code action (padrões do Neovim) |
| `K` | Documentação (hover) |
| `[d` / `]d` | Diagnóstico anterior / próximo |
| `[h` / `]h` | Mudança (hunk do git) anterior / próxima |
| `[t` / `]t` | TODO anterior / próximo |
| `[q` / `]q` | Item anterior / próximo da quickfix |
| `<C-h/j/k/l>` | Mudar de janela |
| `<Esc>` | Limpar destaque da busca |
| `gc{mov}` / `gcc` | Comentar (mini.comment) |
| `sa` / `sd` / `sr` | Adicionar / apagar / trocar delimitador (mini.surround), ex.: `saiw"` |

### `<leader>f` — find

| Atalho | Ação |
| --- | --- |
| `ff` | Arquivos |
| `fg` | Texto no projeto (ripgrep) |
| `fw` | Palavra sob o cursor / seleção |
| `fb` | Buffers abertos |
| `fr` | Arquivos recentes (do projeto) |
| `f/` | Buscar no buffer atual |
| `fs` | Símbolos do arquivo (LSP) |
| `fS` | Símbolos do projeto (LSP) |
| `fd` | Diagnósticos |
| `ft` | TODOs |
| `fh` | Ajuda do Neovim |
| `fk` | Atalhos |
| `fR` | Retomar a última busca |

### `<leader>g` — git

| Atalho | Ação |
| --- | --- |
| `gd` | Diffview: mudanças não commitadas |
| `gm` | Diffview: branch atual vs main (`main...HEAD`) |
| `gh` | Histórico do arquivo atual |
| `gH` | Histórico da branch |
| `gq` | Fechar o diffview |
| `gb` | Blame da linha |
| `gB` | Blame inline (liga/desliga) |
| `gp` | Prévia do hunk |
| `gs` | Stage/unstage do hunk (ou da seleção) |
| `gr` | Reset do hunk (ou da seleção) |
| `gS` | Stage do arquivo |
| `gR` | Reset do arquivo |

Conflitos de merge: com um merge/rebase em andamento, `<leader>gd` abre o
diffview em modo de 3 vias. Dentro dele: `]x`/`[x` navegam entre conflitos,
`<leader>co` / `<leader>ct` / `<leader>cb` / `<leader>ca` escolhem
ours / theirs / base / todos (atalhos do próprio diffview, só valem lá dentro).

### `<leader>t` — testes / tema

| Atalho | Ação |
| --- | --- |
| `tn` | Teste sob o cursor |
| `tf` | Testes do arquivo |
| `ta` | Suíte do app atual |
| `tl` | Repetir o último |
| `ts` | Painel de resumo |
| `to` | Saída do teste (janela flutuante) |
| `tO` | Painel de saída |
| `tw` | Watch do arquivo (roda de novo ao salvar) |
| `tx` | Parar |
| `tt` | Escolher tema |

### `<leader>x` — diagnósticos

| Atalho | Ação |
| --- | --- |
| `xx` | Diagnósticos do projeto (Trouble) |
| `xX` | Diagnósticos do arquivo |
| `xq` | Quickfix |
| `xl` | Location list |
| `xt` | TODOs |

### `<leader>c` — código / LSP

| Atalho | Ação |
| --- | --- |
| `ca` | Code action |
| `cr` | Renomear símbolo |
| `cf` | Formatar com Prettier (arquivo ou seleção) |
| `cs` | Estrutura do arquivo (aerial) |
| `cd` | Diagnóstico da linha |
| `ct` | Typecheck do projeto (`tsc --noEmit`) |

## Convivência com o Claude Code

**Recarga automática.** Arquivos que o agente altera são recarregados sozinhos:
`autoread` + `:checktime` ao ganhar foco / entrar no buffer + um vigia que
confere os buffers abertos a cada 1,5 s. Se o buffer tiver alterações **não
salvas**, nada é sobrescrito: aparece um aviso e você decide (`:e!` descarta as
suas, `:w!` sobrescreve o disco). O swapfile está desligado para evitar os
avisos de "swap file exists" com dois editores no mesmo arquivo (o histórico de
desfazer continua salvo com `undofile`).

**Testes em watch.** O watch do neotest (`<leader>tw`) só dispara quando *o
nvim* salva o arquivo (`BufWritePost`); quando o agente altera um arquivo por
fora, o buffer recarrega mas **o teste não roda de novo** (verificado). Para
acompanhar os testes enquanto o agente trabalha, deixe o Vitest em watch numa
aba separada do terminal:

```sh
pnpm --filter <app> test:watch   # ou: cd apps/<app> && pnpm vitest
```

e use o neotest para rodar sob demanda (`<leader>tn`, `tf`, `tl`).

**Monorepo.** O neotest usa o `vitest.config.*` mais próximo do arquivo e o
`node_modules/.bin/vitest` desse app — cada app roda com a própria config.

**Typecheck do projeto.** O LSP do TypeScript só reporta erros dos arquivos
abertos. `<leader>ct` (ou `:Typecheck`) roda o `tsc --noEmit` do `tsconfig.json`
mais próximo (o app atual) e joga os erros na quickfix, aberta no Trouble.

**Formatação.** Nunca ao salvar (para não brigar com o diff do agente). Use
`<leader>cf`; só funciona em projetos com config do Prettier e usa o Prettier
instalado no próprio projeto.

## Temas

`<leader>tt` abre o seletor: mover a seleção (ou digitar) já aplica o tema;
`<Enter>` confirma, `<Esc>` volta ao anterior. Variações: catppuccin
latte/frappe/macchiato/mocha, kanagawa wave/dragon/lotus e everforest dark/light
com contraste soft/medium/hard.

A escolha fica em `~/.local/share/nvim/theme` (fora do git), então cada máquina
lembra a sua. Apagar esse arquivo volta ao padrão (Kanagawa wave).

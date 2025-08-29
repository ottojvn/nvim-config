# Mason Healthcheck - Entendendo os Warnings

## Sobre os Warnings do Mason

O comando `:checkhealth mason` pode mostrar warnings sobre ferramentas de linguagem não instaladas. **Estes warnings são informativos e não indicam problemas reais** na sua configuração.

### Warnings Comuns e Suas Explicações

#### ⚠️ `luarocks: not available`
- **O que é**: Sistema de pacotes para Lua
- **Por que o warning**: Mason pode usar luarocks para instalar algumas ferramentas Lua
- **Você precisa?**: **NÃO** - Sua configuração já desabilitou luarocks no lazy.nvim
- **Ação**: Nenhuma - este warning é esperado e normal

#### ⚠️ `Ruby/RubyGem: not available`
- **O que é**: Linguagem Ruby e seu gerenciador de gems
- **Por que o warning**: Mason pode usar Ruby para algumas ferramentas (ex: solargraph)
- **Você precisa?**: **NÃO** - Nenhum LSP server Ruby está configurado
- **Ação**: Instalar apenas se você desenvolver em Ruby

#### ⚠️ `Composer/PHP: not available`
- **O que é**: Gerenciador de dependências PHP e a linguagem PHP
- **Por que o warning**: Mason pode usar para ferramentas PHP (ex: phpactor, psalm)
- **Você precisa?**: **NÃO** - Nenhum LSP server PHP está configurado
- **Ação**: Instalar apenas se você desenvolver em PHP

#### ⚠️ `cargo: not available`
- **O que é**: Gerenciador de pacotes Rust
- **Por que o warning**: Necessário para rust_analyzer
- **Você precisa?**: **SIM** se quiser usar Rust
- **Ação**: Execute `:MasonInstallRustDeps` no Neovim ou `rustup default stable` no terminal

#### ⚠️ `julia: not available`
- **O que é**: Linguagem Julia
- **Por que o warning**: Mason pode usar para ferramentas Julia
- **Você precisa?**: **NÃO** - Nenhum LSP server Julia está configurado
- **Ação**: Instalar apenas se você desenvolver em Julia

## Como Resolver Warnings Específicos

### Para Desenvolvimento Rust (cargo)
```bash
# No terminal
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup default stable

# Ou no Neovim
:MasonInstallRustDeps
:MasonInstall rust_analyzer
```

### Para Desenvolvimento PHP
```bash
# Ubuntu/Debian
sudo apt install php php-cli composer

# Depois no Neovim
:MasonInstall phpactor
```

### Para Desenvolvimento Ruby
```bash
# Ubuntu/Debian
sudo apt install ruby ruby-dev

# Depois no Neovim
:MasonInstall solargraph
```

### Para Desenvolvimento Julia
```bash
# Instalar Julia conforme instruções em https://julialang.org/downloads/
# Depois no Neovim
:MasonInstall julials
```

## Resumo

- ✅ **Warnings são normais** - Mason mostra todas as ferramentas disponíveis
- ✅ **Sua configuração está funcionando** - Os LSP servers configurados funcionam perfeitamente
- ✅ **Instale apenas o que usar** - Não há necessidade de instalar todas as linguagens
- ✅ **Rust precisa de configuração especial** - Use `:MasonInstallRustDeps` se necessário

Os warnings do mason são apenas informativos sobre quais ecosistemas de linguagem estão disponíveis para uso opcional.
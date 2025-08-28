#!/bin/bash

# Script para criar links simbólicos e estrutura de diretórios
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

NVIM_CONFIG="/home/ottojvn/.config/nvim"
NVIM_LUA="$NVIM_CONFIG/lua"

echo -e "${BLUE}=== Verificando a estrutura de diretórios ===${NC}"

# Verificar se o diretório lua existe
if [ ! -d "$NVIM_LUA" ]; then
    echo -e "${YELLOW}[CRIANDO]${NC} Diretório lua não encontrado, criando: $NVIM_LUA"
    mkdir -p "$NVIM_LUA"
else
    echo -e "${GREEN}[ENCONTRADO]${NC} Diretório lua: $NVIM_LUA"
fi

# Verificar os arquivos básicos de configuração
CONFIG_FILES=("options.lua" "keymaps.lua" "autocmds.lua")
for file in "${CONFIG_FILES[@]}"; do
    # Verificar no diretório raiz
    if [ -f "$NVIM_CONFIG/$file" ]; then
        echo -e "${GREEN}[ENCONTRADO]${NC} Arquivo na raiz: $NVIM_CONFIG/$file"
        # Verificar se já existe no diretório lua
        if [ -f "$NVIM_LUA/$file" ]; then
            echo -e "${YELLOW}[EXISTE]${NC} Arquivo já existe em lua/: $NVIM_LUA/$file"
        else
            # Mover para o diretório lua
            echo -e "${BLUE}[MOVENDO]${NC} Movendo arquivo para lua/: $file"
            cp "$NVIM_CONFIG/$file" "$NVIM_LUA/$file"
            echo -e "${GREEN}[OK]${NC} Arquivo copiado para: $NVIM_LUA/$file"
        fi
    elif [ -f "$NVIM_LUA/$file" ]; then
        echo -e "${GREEN}[ENCONTRADO]${NC} Arquivo em lua/: $NVIM_LUA/$file"
    else
        echo -e "${RED}[AUSENTE]${NC} Arquivo não encontrado: $file"
    fi
done

echo -e "\n${BLUE}=== Ajustando arquivo init.lua ===${NC}"

# Backup do arquivo init.lua
if [ ! -f "$NVIM_CONFIG/init.lua.bak" ]; then
    cp "$NVIM_CONFIG/init.lua" "$NVIM_CONFIG/init.lua.bak"
    echo -e "${GREEN}[BACKUP]${NC} Backup criado: $NVIM_CONFIG/init.lua.bak"
fi

# Atualizar o arquivo init.lua para usar os módulos do diretório lua
cat > "$NVIM_CONFIG/init.lua" << 'EOF'
-- Carregar configurações básicas do diretório lua
require("lua.options")
require("lua.keymaps")
require("lua.autocmds")

-- Instalar e configurar gerenciador de plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- IMPORTANTE: Para evitar o erro "Re-sourcing your config is not supported with lazy.nvim",
-- é recomendado não recarregar este arquivo diretamente após fazer alterações.
-- Em vez disso, saia do Neovim e inicie-o novamente.
-- Ou use o comando :Lazy sync para atualizar os plugins.

-- Carregar plugins
require("lazy").setup("plugins", {
  checker = {
    enabled = true,
    notify = false,
    frequency = 3600, -- verificar a cada hora
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = "rounded",
  },
})
EOF

echo -e "${GREEN}[ATUALIZADO]${NC} Arquivo init.lua atualizado"
echo -e "${YELLOW}[IMPORTANTE]${NC} Reinicie o Neovim completamente para aplicar as alterações"
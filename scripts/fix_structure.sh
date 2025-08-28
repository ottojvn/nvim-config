#!/bin/bash

# Script para corrigir a estrutura de diretórios e arquivos
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

NVIM_CONFIG="/home/ottojvn/.config/nvim"
NVIM_LUA="$NVIM_CONFIG/lua"

echo -e "${BLUE}=== Corrigindo estrutura de diretórios Neovim ===${NC}"

# Verificar se o diretório lua existe
if [ ! -d "$NVIM_LUA" ]; then
  echo -e "${YELLOW}[CRIANDO]${NC} Diretório lua: $NVIM_LUA"
  mkdir -p "$NVIM_LUA"
else
  echo -e "${GREEN}[EXISTE]${NC} Diretório lua: $NVIM_LUA"
fi

# Arquivos de configuração essenciais
CONFIG_FILES=("options.lua" "keymaps.lua" "autocmds.lua")

# Verificar e criar arquivos de configuração vazios caso não existam
for file in "${CONFIG_FILES[@]}"; do
  # Verificar se o arquivo existe na raiz
  ROOT_FILE="$NVIM_CONFIG/$file"
  LUA_FILE="$NVIM_LUA/$file"
  
  if [ -f "$ROOT_FILE" ]; then
    echo -e "${GREEN}[ENCONTRADO NA RAIZ]${NC} $ROOT_FILE"
    
    # Verificar se também existe no diretório lua
    if [ -f "$LUA_FILE" ]; then
      echo -e "${YELLOW}[DUPLICADO]${NC} O arquivo existe tanto na raiz quanto no diretório lua"
      echo -e "${YELLOW}[AÇÃO]${NC} Mantendo ambos por enquanto"
    else
      # Copiar para o diretório lua
      echo -e "${BLUE}[COPIANDO]${NC} $ROOT_FILE -> $LUA_FILE"
      cp "$ROOT_FILE" "$LUA_FILE"
    fi
  elif [ -f "$LUA_FILE" ]; then
    echo -e "${GREEN}[ENCONTRADO EM LUA]${NC} $LUA_FILE"
  else
    # Criar arquivo vazio no diretório lua
    echo -e "${YELLOW}[CRIANDO]${NC} Arquivo vazio: $LUA_FILE"
    echo "-- Arquivo $file criado automaticamente" > "$LUA_FILE"
    echo "-- Adicione suas configurações aqui" >> "$LUA_FILE"
    echo "" >> "$LUA_FILE"
  fi
done

# Corrigir o arquivo init.lua
echo -e "\n${BLUE}[ATUALIZANDO]${NC} Arquivo init.lua"

# Fazer backup do arquivo original
if [ ! -f "$NVIM_CONFIG/init.lua.bak" ]; then
  cp "$NVIM_CONFIG/init.lua" "$NVIM_CONFIG/init.lua.bak"
  echo -e "${GREEN}[BACKUP]${NC} Backup criado: $NVIM_CONFIG/init.lua.bak"
fi

# Atualizar o arquivo init.lua
cat > "$NVIM_CONFIG/init.lua" << 'EOF'
-- Carregar configurações básicas
local function safe_require(module)
  local success, result = pcall(require, module)
  if not success then
    -- Tentar com prefixo "lua."
    success, result = pcall(require, "lua." .. module)
    if not success then
      print("Erro ao carregar módulo: " .. module)
    end
  end
  return success
end

-- Carregar módulos essenciais
safe_require("options")
safe_require("keymaps")
safe_require("autocmds")

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

echo -e "${GREEN}[ATUALIZADO]${NC} Arquivo init.lua"
echo -e "${YELLOW}[IMPORTANTE]${NC} Reinicie o Neovim completamente para aplicar as alterações"
echo -e "${BLUE}=== Correção concluída ===${NC}"
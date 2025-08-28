#!/bin/bash

# Script para verificar a estrutura de diretórios e módulos core
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
CORE_DIR="$NVIM_CONFIG/lua/core"

echo -e "${BLUE}=== Verificando estrutura de diretórios do Neovim ===${NC}"

# Verificar diretórios importantes
echo -e "\n${BLUE}[DIRETÓRIOS]${NC}"
for dir in "$NVIM_CONFIG" "$NVIM_CONFIG/lua" "$CORE_DIR" "$NVIM_CONFIG/lua/plugins"; do
  if [ -d "$dir" ]; then
    echo -e "${GREEN}[EXISTE]${NC} $dir"
  else
    echo -e "${RED}[AUSENTE]${NC} $dir"
  fi
done

# Verificar arquivos de configuração core
echo -e "\n${BLUE}[ARQUIVOS CORE]${NC}"
for file in "options.lua" "keymaps.lua" "autocmds.lua"; do
  CORE_FILE="$CORE_DIR/$file"
  if [ -f "$CORE_FILE" ]; then
    echo -e "${GREEN}[EXISTE]${NC} $CORE_FILE"
  else
    echo -e "${RED}[AUSENTE]${NC} $CORE_FILE"
  fi
done

# Verificar arquivo init.lua
echo -e "\n${BLUE}[INIT.LUA]${NC}"
if [ -f "$NVIM_CONFIG/init.lua" ]; then
  echo -e "${GREEN}[EXISTE]${NC} $NVIM_CONFIG/init.lua"
  
  # Verificar como os requires são feitos
  echo -e "\n${BLUE}[REQUIRES NO INIT.LUA]${NC}"
  grep -i "require" "$NVIM_CONFIG/init.lua" | head -n 10
else
  echo -e "${RED}[AUSENTE]${NC} $NVIM_CONFIG/init.lua"
fi

# Verificar arquivo de configuração LSP
echo -e "\n${BLUE}[LSP CONFIG]${NC}"
LSP_CONFIG="$NVIM_CONFIG/lua/plugins/configs/lsp.lua"
if [ -f "$LSP_CONFIG" ]; then
  echo -e "${GREEN}[EXISTE]${NC} $LSP_CONFIG"
  
  # Verificar uso do setup_handlers
  echo -e "\n${BLUE}[SETUP_HANDLERS NO LSP.LUA]${NC}"
  grep -i "setup_handlers" "$LSP_CONFIG" | head -n 5
else
  echo -e "${RED}[AUSENTE]${NC} $LSP_CONFIG"
fi

# Criar diretórios e arquivos ausentes
echo -e "\n${BLUE}[VERIFICANDO ARQUIVOS AUSENTES]${NC}"
if [ ! -d "$CORE_DIR" ]; then
  echo -e "${YELLOW}[CRIANDO]${NC} Diretório core: $CORE_DIR"
  mkdir -p "$CORE_DIR"
fi

# Criar arquivos core vazios caso não existam
for file in "options.lua" "keymaps.lua" "autocmds.lua"; do
  CORE_FILE="$CORE_DIR/$file"
  if [ ! -f "$CORE_FILE" ]; then
    echo -e "${YELLOW}[CRIANDO]${NC} Arquivo core vazio: $CORE_FILE"
    echo "-- Arquivo $file criado automaticamente" > "$CORE_FILE"
    echo "-- Adicione suas configurações aqui" >> "$CORE_FILE"
    echo "" >> "$CORE_FILE"
  fi
done

echo -e "\n${GREEN}=== Verificação concluída! ===${NC}"
echo -e "${YELLOW}[IMPORTANTE]${NC} Reinicie o Neovim completamente para aplicar as alterações"
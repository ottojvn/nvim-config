#!/bin/bash

# Script para verificar a estrutura real de diretórios e arquivos
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

NVIM_CONFIG="/home/ottojvn/.config/nvim"

echo -e "${BLUE}=== Verificando estrutura de diretórios do Neovim ===${NC}"

# Verificar existência de diretórios importantes
echo -e "\n${BLUE}[DIRETÓRIOS]${NC}"
for dir in "$NVIM_CONFIG" "$NVIM_CONFIG/lua"; do
  if [ -d "$dir" ]; then
    echo -e "${GREEN}[EXISTE]${NC} $dir"
  else
    echo -e "${RED}[AUSENTE]${NC} $dir"
  fi
done

# Verificar arquivos de configuração
echo -e "\n${BLUE}[ARQUIVOS DE CONFIGURAÇÃO]${NC}"
for file in "options.lua" "keymaps.lua" "autocmds.lua"; do
  # Verificar na raiz
  if [ -f "$NVIM_CONFIG/$file" ]; then
    echo -e "${GREEN}[RAIZ]${NC} $NVIM_CONFIG/$file"
  else
    echo -e "${RED}[AUSENTE NA RAIZ]${NC} $NVIM_CONFIG/$file"
  fi
  
  # Verificar no diretório lua
  if [ -f "$NVIM_CONFIG/lua/$file" ]; then
    echo -e "${GREEN}[LUA]${NC} $NVIM_CONFIG/lua/$file"
  else
    echo -e "${RED}[AUSENTE EM LUA]${NC} $NVIM_CONFIG/lua/$file"
  fi
done

# Listar todos os arquivos .lua
echo -e "\n${BLUE}[TODOS OS ARQUIVOS LUA]${NC}"
find "$NVIM_CONFIG" -name "*.lua" | sort

echo -e "\n${BLUE}=== Verificação concluída ===${NC}"
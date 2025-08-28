#!/bin/bash

# Script para examinar o arquivo init.lua original
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ORIGINAL_FILE="/home/ottojvn/.config/nvim/init.lua.bak"
CURRENT_FILE="/home/ottojvn/.config/nvim/init.lua"

echo -e "${BLUE}=== Examinando arquivo init.lua original ===${NC}"

# Verificar se existe um backup do arquivo original
if [ -f "$ORIGINAL_FILE" ]; then
    echo -e "${GREEN}[ENCONTRADO]${NC} Backup do arquivo init.lua: $ORIGINAL_FILE"
    echo -e "\n${BLUE}[CONTEÚDO]${NC} Primeiras 10 linhas do backup:"
    head -n 10 "$ORIGINAL_FILE"
    
    # Verificar como o require é feito no arquivo original
    echo -e "\n${BLUE}[REQUIRE]${NC} Como os módulos são requeridos no arquivo original:"
    grep -i "require" "$ORIGINAL_FILE" | head -n 5
else
    echo -e "${RED}[AUSENTE]${NC} Backup do arquivo init.lua não encontrado: $ORIGINAL_FILE"
    
    # Verificar o arquivo atual
    echo -e "\n${BLUE}[ATUAL]${NC} Primeiras 10 linhas do arquivo atual:"
    head -n 10 "$CURRENT_FILE"
    
    echo -e "\n${BLUE}[REQUIRE]${NC} Como os módulos são requeridos no arquivo atual:"
    grep -i "require" "$CURRENT_FILE" | head -n 5
fi

# Verificar se o runtimepath inclui o diretório lua
echo -e "\n${BLUE}[RUNTIMEPATH]${NC} Verificando se o diretório lua está no runtimepath:"
nvim --headless -c "lua print(vim.inspect(vim.api.nvim_list_runtime_paths()))" -c "q" 2>/dev/null | grep -i "lua"
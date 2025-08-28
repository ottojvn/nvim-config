#!/bin/bash

# Script para verificar e restaurar configurações do init.lua
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ORIGINAL_FILE="/home/ottojvn/.config/nvim/init.lua"
CHEZMOI_FILE="/home/ottojvn/.local/share/chezmoi/private_dot_config/nvim/init.lua"

echo -e "${BLUE}=== Verificando configurações no init.lua ===${NC}"

# Verificar se os arquivos existem
if [ ! -f "$ORIGINAL_FILE" ]; then
    echo -e "${RED}[ERRO]${NC} Arquivo original não encontrado: $ORIGINAL_FILE"
    exit 1
fi

if [ ! -f "$CHEZMOI_FILE" ]; then
    echo -e "${RED}[ERRO]${NC} Arquivo do chezmoi não encontrado: $CHEZMOI_FILE"
    exit 1
fi

# Contar linhas nos arquivos
ORIGINAL_LINES=$(wc -l < "$ORIGINAL_FILE")
CHEZMOI_LINES=$(wc -l < "$CHEZMOI_FILE")

echo -e "${BLUE}[INFO]${NC} Arquivo original: $ORIGINAL_LINES linhas"
echo -e "${BLUE}[INFO]${NC} Arquivo chezmoi: $CHEZMOI_LINES linhas"

# Verificar se há diferença significativa no tamanho
DIFF=$((ORIGINAL_LINES - CHEZMOI_LINES))
if [ $DIFF -gt 5 ] || [ $DIFF -lt -5 ]; then
    echo -e "${YELLOW}[AVISO]${NC} Diferença significativa no número de linhas: $DIFF"
    echo -e "${YELLOW}[AVISO]${NC} Pode haver configurações importantes que foram perdidas!"
    
    # Mostrar as últimas linhas de cada arquivo para comparação
    echo -e "\n${BLUE}=== Últimas 10 linhas do arquivo original ===${NC}"
    tail -n 10 "$ORIGINAL_FILE"
    
    echo -e "\n${BLUE}=== Últimas 10 linhas do arquivo chezmoi ===${NC}"
    tail -n 10 "$CHEZMOI_FILE"
    
    echo -e "\n${YELLOW}[AÇÃO]${NC} Recomendado verificar manualmente os arquivos"
else
    echo -e "${GREEN}[OK]${NC} Número de linhas similar, provavelmente não houve perda de configuração"
fi

# Verificar o conteúdo para garantir que as funcionalidades importantes estão presentes
echo -e "\n${BLUE}=== Verificando funcionalidades importantes ===${NC}"

FUNCTIONS=(
    "require.*options"
    "require.*keymaps"
    "require.*autocmds"
    "require.*lazy.*setup"
)

for FUNC in "${FUNCTIONS[@]}"; do
    if grep -q "$FUNC" "$CHEZMOI_FILE"; then
        echo -e "${GREEN}[OK]${NC} Encontrado: $FUNC"
    else
        echo -e "${RED}[ERRO]${NC} Não encontrado: $FUNC"
    fi
done

echo -e "\n${GREEN}=== Verificação concluída! ===${NC}"
echo -e "Se encontrou diferenças significativas, considere verificar manualmente os arquivos."
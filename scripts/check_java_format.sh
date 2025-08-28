#!/bin/bash

# Script para verificar e corrigir a formatação Java (estilo IntelliJ)
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Verificando configuração de formatação Java (IntelliJ) ===${NC}"

# Verificar diretório de formatadores
FORMAT_DIR="$HOME/.config/nvim/formatters"
STYLE_FILE="$FORMAT_DIR/eclipse-java-intellij-style.xml"

if [ ! -d "$FORMAT_DIR" ]; then
    echo -e "${YELLOW}[AVISO]${NC} Diretório de formatadores não encontrado."
    mkdir -p "$FORMAT_DIR"
    echo -e "${GREEN}[OK]${NC} Diretório de formatadores criado: $FORMAT_DIR"
fi

if [ ! -f "$STYLE_FILE" ]; then
    echo -e "${RED}[ERRO]${NC} Arquivo de estilo não encontrado: $STYLE_FILE"
    echo -e "${YELLOW}[INFO]${NC} Verifique se o arquivo foi copiado corretamente."
else
    echo -e "${GREEN}[OK]${NC} Arquivo de estilo encontrado: $STYLE_FILE"
fi

# Verificar configuração JDTLS
echo -e "${BLUE}[INFO]${NC} Verificando configuração do JDTLS..."

# Encontrar caminho do workspace atual
WORKSPACE_DIR=$(find "$HOME/.local/share/nvim/jdtls-workspace" -type d -name "*" -maxdepth 1 2>/dev/null | head -1)

if [ -n "$WORKSPACE_DIR" ]; then
    echo -e "${GREEN}[OK]${NC} Workspace JDTLS encontrado: $WORKSPACE_DIR"
    
    # Criar arquivo de configuração de formatação se não existir
    CONFIG_DIR="$WORKSPACE_DIR/.settings"
    
    if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p "$CONFIG_DIR"
    fi
    
    FORMATTER_PREFS="$CONFIG_DIR/org.eclipse.jdt.core.prefs"
    
    # Adicionar preferências de formatação
    echo "org.eclipse.jdt.core.formatter.profile=IntelliJIDEA" > "$FORMATTER_PREFS"
    echo "org.eclipse.jdt.core.formatter.importorder_groups=java;javax;org;com;" >> "$FORMATTER_PREFS"
    echo "org.eclipse.jdt.core.formatter.lineSplit=120" >> "$FORMATTER_PREFS"
    echo "org.eclipse.jdt.core.formatter.tabulation.char=space" >> "$FORMATTER_PREFS"
    echo "org.eclipse.jdt.core.formatter.tabulation.size=4" >> "$FORMATTER_PREFS"
    echo "org.eclipse.jdt.core.formatter.use_on_off_tags=true" >> "$FORMATTER_PREFS"
    
    echo -e "${GREEN}[OK]${NC} Configurações de formatação adicionadas: $FORMATTER_PREFS"
else
    echo -e "${YELLOW}[AVISO]${NC} Nenhum workspace JDTLS encontrado. Abra um arquivo Java primeiro."
fi

echo -e "\n${GREEN}=== Instruções para usar a formatação Java (IntelliJ) ===${NC}"
echo -e "1. Abra um arquivo Java no Neovim"
echo -e "2. Use ${YELLOW}<leader>jf${NC} para formatar o arquivo"
echo -e "3. Se a formatação não funcionar, tente reiniciar o Neovim"

echo -e "\n${GREEN}Verificação concluída.${NC}"
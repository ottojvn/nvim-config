#!/bin/bash

# Script para limpar logs do LSP
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Localização do arquivo de log
LOG_FILE="$HOME/.local/state/nvim/lsp.log"

if [ -f "$LOG_FILE" ]; then
    # Backup do arquivo de log antes de limpar
    LOG_BACKUP="$LOG_FILE.bak"
    cp "$LOG_FILE" "$LOG_BACKUP"
    
    # Limpar o arquivo de log
    > "$LOG_FILE"
    
    echo -e "${GREEN}[OK]${NC} Arquivo de log LSP limpo: $LOG_FILE"
    echo -e "${GREEN}[INFO]${NC} Backup criado: $LOG_BACKUP"
else
    echo -e "${RED}[ERRO]${NC} Arquivo de log LSP não encontrado: $LOG_FILE"
fi

# Verificar e limpar diretório de cache do JDTLS
JDTLS_CACHE="$HOME/.cache/jdtls"
if [ -d "$JDTLS_CACHE" ]; then
    rm -rf "$JDTLS_CACHE"/*
    echo -e "${GREEN}[OK]${NC} Cache do JDTLS limpo: $JDTLS_CACHE"
else
    echo -e "${RED}[INFO]${NC} Diretório de cache do JDTLS não encontrado: $JDTLS_CACHE"
fi

echo -e "${GREEN}[INFO]${NC} Logs limpos com sucesso."
echo -e "${GREEN}[INFO]${NC} Reinicie o Neovim para continuar com logs limpos."
#!/bin/bash

# Script para aplicar estilo de formatação IntelliJ
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Aplicando estilo de formatação IntelliJ para Java ===${NC}"

# Verificar diretório de formatadores
FORMAT_DIR="$HOME/.config/nvim/formatters"
STYLE_FILE="$FORMAT_DIR/eclipse-java-intellij-style.xml"

# Garantir que o arquivo de estilo existe
if [ ! -f "$STYLE_FILE" ]; then
    echo -e "${RED}[ERRO]${NC} Arquivo de estilo IntelliJ não encontrado: $STYLE_FILE"
    echo -e "${YELLOW}[INFO]${NC} Verifique se os arquivos foram criados corretamente."
    exit 1
fi

echo -e "${GREEN}[OK]${NC} Arquivo de estilo IntelliJ encontrado."

# Remover o diretório de workspace JDTLS para forçar recriação
WORKSPACE_DIRS="$HOME/.local/share/nvim/jdtls-workspace"
if [ -d "$WORKSPACE_DIRS" ]; then
    echo -e "${YELLOW}[INFO]${NC} Removendo workspaces JDTLS para aplicar novas configurações..."
    rm -rf "$WORKSPACE_DIRS"
    echo -e "${GREEN}[OK]${NC} Workspaces JDTLS removidos."
fi

# Limpar cache de LSP
LSP_LOG="$HOME/.local/state/nvim/lsp.log"
if [ -f "$LSP_LOG" ]; then
    > "$LSP_LOG"
    echo -e "${GREEN}[OK]${NC} Log LSP limpo."
fi

echo -e "\n${GREEN}=== Estilo IntelliJ aplicado com sucesso! ===${NC}"
echo -e "${YELLOW}[IMPORTANTE]${NC} Para aplicar as alterações:"
echo -e "1. Reinicie o Neovim"
echo -e "2. Abra um arquivo Java"
echo -e "3. Use ${BLUE}<leader>jf${NC} para formatar o arquivo"
echo -e "\nOu execute o comando: ${BLUE}:lua vim.lsp.buf.format()${NC}"
#!/bin/bash

# Script para desinstalar as extensões Java
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}[INFO]${NC} Desinstalando extensões Java..."

# Remover diretórios das extensões no lazy.nvim
LAZY_DIR="$HOME/.local/state/nvim/lazy"
NVIM_DATA_DIR="$HOME/.local/share/nvim"

# Remover extensão Java Debug
if [ -d "$LAZY_DIR/java-debug" ]; then
    echo -e "${GREEN}[INFO]${NC} Removendo java-debug do lazy.nvim..."
    rm -rf "$LAZY_DIR/java-debug"
    echo -e "${GREEN}[INFO]${NC} java-debug removido."
fi

if [ -d "$NVIM_DATA_DIR/lazy/java-debug" ]; then
    echo -e "${GREEN}[INFO]${NC} Removendo java-debug do diretório de dados..."
    rm -rf "$NVIM_DATA_DIR/lazy/java-debug"
    echo -e "${GREEN}[INFO]${NC} java-debug removido."
fi

# Remover extensão Java Test
if [ -d "$LAZY_DIR/vscode-java-test" ]; then
    echo -e "${GREEN}[INFO]${NC} Removendo vscode-java-test do lazy.nvim..."
    rm -rf "$LAZY_DIR/vscode-java-test"
    echo -e "${GREEN}[INFO]${NC} vscode-java-test removido."
fi

if [ -d "$NVIM_DATA_DIR/lazy/vscode-java-test" ]; then
    echo -e "${GREEN}[INFO]${NC} Removendo vscode-java-test do diretório de dados..."
    rm -rf "$NVIM_DATA_DIR/lazy/vscode-java-test"
    echo -e "${GREEN}[INFO]${NC} vscode-java-test removido."
fi

# Remover qualquer instalação prévia em outros locais
if [ -d "$HOME/.local/share/java-debug" ]; then
    echo -e "${GREEN}[INFO]${NC} Removendo instalação manual de java-debug..."
    rm -rf "$HOME/.local/share/java-debug"
    echo -e "${GREEN}[INFO]${NC} java-debug removido."
fi

if [ -d "$HOME/.local/share/vscode-java-test" ]; then
    echo -e "${GREEN}[INFO]${NC} Removendo instalação manual de vscode-java-test..."
    rm -rf "$HOME/.local/share/vscode-java-test"
    echo -e "${GREEN}[INFO]${NC} vscode-java-test removido."
fi

# Remover cache do lazy.nvim
if [ -f "$NVIM_DATA_DIR/lazy/cache" ]; then
    echo -e "${GREEN}[INFO]${NC} Removendo cache do lazy.nvim..."
    rm -f "$NVIM_DATA_DIR/lazy/cache"
    echo -e "${GREEN}[INFO]${NC} Cache removido."
fi

echo -e "${GREEN}[INFO]${NC} Desinstalação concluída!"
echo -e "${GREEN}[INFO]${NC} Inicie o Neovim para reinstalar as extensões automaticamente."
echo -e "${YELLOW}[DICA]${NC} Se ocorrerem erros na compilação novamente, verifique:"
echo -e "  1. Se o npm e maven (ou mvnw) estão instalados e funcionando"
echo -e "  2. Se o JDK está configurado corretamente (JAVA_HOME)"
echo -e "  3. Se há permissões de escrita nos diretórios necessários"
#!/bin/bash

# Script para aplicar todas as sugestões de correção do JDTLS
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Aplicando correções para o JDTLS ===${NC}"

# 1. Configurar JAVA_HOME temporariamente
JAVA_PATH=$(dirname $(dirname $(readlink -f $(which java))))
export JAVA_HOME=$JAVA_PATH
echo -e "${GREEN}[1]${NC} JAVA_HOME configurado temporariamente como: $JAVA_HOME"
echo -e "    Para configurar permanentemente, adicione ao seu .bashrc ou .zshrc:"
echo -e "    export JAVA_HOME=$JAVA_PATH"

# 2. Remover diretório de workspace
echo -e "${BLUE}[2] Removendo diretório de workspace JDTLS...${NC}"
WORKSPACE_DIR="$HOME/.local/share/nvim/jdtls-workspace"
if [ -d "$WORKSPACE_DIR" ]; then
    rm -rf "$WORKSPACE_DIR"
    echo -e "${GREEN}[OK]${NC} Diretório de workspace removido: $WORKSPACE_DIR"
else
    echo -e "${YELLOW}[INFO]${NC} Diretório de workspace não encontrado: $WORKSPACE_DIR"
fi

# 3. Verificar permissões
echo -e "${BLUE}[3] Verificando permissões...${NC}"
NVIM_DATA_DIR="$HOME/.local/share/nvim"
if [ -d "$NVIM_DATA_DIR" ]; then
    chmod -R u+rw "$NVIM_DATA_DIR"
    echo -e "${GREEN}[OK]${NC} Permissões corrigidas para: $NVIM_DATA_DIR"
else
    echo -e "${RED}[ERRO]${NC} Diretório não encontrado: $NVIM_DATA_DIR"
fi

# 4. Recompilar extensões Java
echo -e "${BLUE}[4] Recompilando extensões Java...${NC}"

# Verificar e tornar os scripts executáveis
SCRIPT_DIR="$HOME/.config/nvim/scripts"
chmod +x "$SCRIPT_DIR/compile_java_debug.sh" 2>/dev/null
chmod +x "$SCRIPT_DIR/compile_java_test.sh" 2>/dev/null

# Compilar java-debug
if [ -f "$SCRIPT_DIR/compile_java_debug.sh" ]; then
    echo -e "${GREEN}[INFO]${NC} Compilando java-debug..."
    "$SCRIPT_DIR/compile_java_debug.sh"
else
    echo -e "${RED}[ERRO]${NC} Script compile_java_debug.sh não encontrado em $SCRIPT_DIR"
fi

# Compilar vscode-java-test
if [ -f "$SCRIPT_DIR/compile_java_test.sh" ]; then
    echo -e "${GREEN}[INFO]${NC} Compilando vscode-java-test..."
    "$SCRIPT_DIR/compile_java_test.sh"
else
    echo -e "${RED}[ERRO]${NC} Script compile_java_test.sh não encontrado em $SCRIPT_DIR"
fi

echo -e "\n${GREEN}=== Todas as correções foram aplicadas ===${NC}"
echo -e "${YELLOW}[IMPORTANTE]${NC} Para reinstalar o JDTLS, execute dentro do Neovim:"
echo -e "    :MasonInstall jdtls"
echo -e "${YELLOW}[IMPORTANTE]${NC} Reinicie o Neovim para que as alterações tenham efeito."
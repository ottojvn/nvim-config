#!/bin/bash

# Script simplificado para compilar vscode-java-test
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Diretório do vscode-java-test
TEST_DIR="$HOME/.local/share/nvim/lazy/vscode-java-test"

echo -e "${GREEN}[INFO]${NC} Compilando vscode-java-test..."

# Verificar se o diretório existe
if [ ! -d "$TEST_DIR" ]; then
    echo -e "${RED}[ERRO]${NC} Diretório $TEST_DIR não encontrado!"
    exit 1
fi

# Ir para o diretório e instalar dependências
cd "$TEST_DIR" || exit 1
npm install

# Tentar executar vários scripts de build possíveis
if npm run build-plugin 2>/dev/null; then
    echo -e "${GREEN}[INFO]${NC} Compilado com sucesso usando 'build-plugin'!"
elif npm run build 2>/dev/null; then
    echo -e "${GREEN}[INFO]${NC} Compilado com sucesso usando 'build'!"
elif npm run compile 2>/dev/null; then
    echo -e "${GREEN}[INFO]${NC} Compilado com sucesso usando 'compile'!"
else
    echo -e "${YELLOW}[AVISO]${NC} Nenhum script de build encontrado. Verificando estrutura do projeto..."
    
    # Verificar se existe um diretório server com pom.xml
    if [ -d "$TEST_DIR/server" ] && [ -f "$TEST_DIR/server/pom.xml" ]; then
        echo -e "${GREEN}[INFO]${NC} Encontrado diretório server com pom.xml, compilando com Maven..."
        cd server && mvn clean package -DskipTests
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[INFO]${NC} Compilação com Maven concluída com sucesso!"
        else
            echo -e "${RED}[ERRO]${NC} Falha na compilação com Maven."
            exit 1
        fi
    else
        echo -e "${RED}[ERRO]${NC} Não foi possível determinar como compilar este projeto."
        exit 1
    fi
fi

# Verificar se os JARs foram gerados
JARS=$(find "$TEST_DIR" -name "*.jar" | grep -v "node_modules")
if [ -n "$JARS" ]; then
    echo -e "${GREEN}[INFO]${NC} JAR(s) encontrado(s):"
    echo "$JARS"
    
    # Garantir que exista o diretório server
    mkdir -p "$TEST_DIR/server"
    
    # Copiar todos os JARs para o diretório server
    for jar in $JARS; do
        if [[ "$jar" != *"server/"* ]]; then
            echo -e "${GREEN}[INFO]${NC} Copiando $jar para $TEST_DIR/server/"
            cp "$jar" "$TEST_DIR/server/"
        fi
    done
    
    echo -e "${GREEN}[INFO]${NC} Compilação concluída com sucesso!"
    echo -e "${GREEN}[INFO]${NC} Reinicie o Neovim para usar as extensões Java."
else
    echo -e "${YELLOW}[AVISO]${NC} Nenhum JAR encontrado após a compilação. Isso pode indicar um problema."
fi
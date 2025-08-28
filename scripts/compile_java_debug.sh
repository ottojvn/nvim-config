#!/bin/bash

# Script simplificado para compilar java-debug
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Diretório do java-debug
DEBUG_DIR="$HOME/.local/share/nvim/lazy/java-debug"

echo -e "${GREEN}[INFO]${NC} Compilando java-debug..."

# Verificar se o diretório existe
if [ ! -d "$DEBUG_DIR" ]; then
    echo -e "${RED}[ERRO]${NC} Diretório $DEBUG_DIR não encontrado!"
    exit 1
fi

# Verificar JDK
if ! command -v java &> /dev/null; then
    echo -e "${RED}[ERRO]${NC} Java não encontrado. Verifique se o JDK está instalado e no PATH."
    exit 1
fi

# Ir para o diretório
cd "$DEBUG_DIR" || exit 1

# Verificar se o wrapper do Maven está presente
if [ ! -f "./mvnw" ]; then
    echo -e "${YELLOW}[AVISO]${NC} Maven wrapper (mvnw) não encontrado. Tentando usar Maven do sistema..."
    if command -v mvn &> /dev/null; then
        MVN_CMD="mvn"
    else
        echo -e "${RED}[ERRO]${NC} Nem Maven wrapper nem Maven do sistema encontrado. Não é possível compilar."
        exit 1
    fi
else
    chmod +x ./mvnw
    MVN_CMD="./mvnw"
fi

# Compilar
echo -e "${GREEN}[INFO]${NC} Compilando com $MVN_CMD clean install -DskipTests..."
$MVN_CMD clean install -DskipTests

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[SUCESSO]${NC} Compilação concluída com sucesso!"
    
    # Verificar o JAR
    JAR_FILE=$(find "$DEBUG_DIR" -name "com.microsoft.java.debug.plugin-*.jar")
    if [ -n "$JAR_FILE" ]; then
        echo -e "${GREEN}[INFO]${NC} JAR encontrado: $JAR_FILE"
        echo -e "${GREEN}[INFO]${NC} Compilação concluída com sucesso!"
    else
        echo -e "${YELLOW}[AVISO]${NC} JAR não encontrado após compilação bem-sucedida. Verifique a estrutura do projeto."
    fi
else
    echo -e "${RED}[ERRO]${NC} Falha na compilação."
    exit 1
fi

echo -e "${GREEN}[INFO]${NC} Reinicie o Neovim para usar as extensões Java."
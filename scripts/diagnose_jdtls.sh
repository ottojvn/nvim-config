#!/bin/bash

# Script para diagnosticar problemas com JDTLS
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Diagnóstico do JDTLS ===${NC}"

# Verificar Java
echo -e "${BLUE}[1] Verificando instalação do Java...${NC}"
if ! command -v java &> /dev/null; then
    echo -e "${RED}[ERRO]${NC} Java não encontrado. Instale o JDK."
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
echo -e "${GREEN}[OK]${NC} Java encontrado: $JAVA_VERSION"

# Verificar variáveis de ambiente Java
echo -e "${BLUE}[2] Verificando variáveis de ambiente Java...${NC}"
if [ -z "$JAVA_HOME" ]; then
    echo -e "${YELLOW}[AVISO]${NC} JAVA_HOME não definido. Recomendado definir para o JDK correto."
else
    echo -e "${GREEN}[OK]${NC} JAVA_HOME: $JAVA_HOME"
    
    # Verificar se JAVA_HOME é válido
    if [ ! -d "$JAVA_HOME" ]; then
        echo -e "${RED}[ERRO]${NC} O diretório JAVA_HOME não existe: $JAVA_HOME"
    fi
fi

# Verificar instalação do JDTLS
echo -e "${BLUE}[3] Verificando instalação do JDTLS...${NC}"
JDTLS_PATH="$HOME/.local/share/nvim/mason/packages/jdtls"

if [ ! -d "$JDTLS_PATH" ]; then
    echo -e "${RED}[ERRO]${NC} JDTLS não encontrado em $JDTLS_PATH"
    echo -e "          Verifique se o Mason instalou o JDTLS corretamente."
else
    echo -e "${GREEN}[OK]${NC} JDTLS encontrado em $JDTLS_PATH"
    
    # Verificar componentes essenciais
    LAUNCHER_JAR=$(find "$JDTLS_PATH/plugins" -name "org.eclipse.equinox.launcher_*.jar" | head -1)
    if [ -z "$LAUNCHER_JAR" ]; then
        echo -e "${RED}[ERRO]${NC} Launcher JAR não encontrado em $JDTLS_PATH/plugins"
    else
        echo -e "${GREEN}[OK]${NC} Launcher JAR: $LAUNCHER_JAR"
    fi
    
    CONFIG_DIR="$JDTLS_PATH/config_linux"
    if [ ! -d "$CONFIG_DIR" ]; then
        echo -e "${RED}[ERRO]${NC} Diretório de configuração não encontrado: $CONFIG_DIR"
    else
        echo -e "${GREEN}[OK]${NC} Diretório de configuração encontrado"
    fi
fi

# Verificar extensões Java
echo -e "${BLUE}[4] Verificando extensões Java...${NC}"

# Java Debug
DEBUG_DIR="$HOME/.local/share/nvim/lazy/java-debug"
if [ ! -d "$DEBUG_DIR" ]; then
    echo -e "${YELLOW}[AVISO]${NC} java-debug não encontrado em $DEBUG_DIR"
else
    echo -e "${GREEN}[OK]${NC} java-debug encontrado"
    
    DEBUG_JAR=$(find "$DEBUG_DIR" -name "com.microsoft.java.debug.plugin-*.jar" | head -1)
    if [ -z "$DEBUG_JAR" ]; then
        echo -e "${YELLOW}[AVISO]${NC} JAR do java-debug não encontrado. Tente compilar novamente."
        echo -e "          Execute: ~/.config/nvim/scripts/compile_java_debug.sh"
    else
        echo -e "${GREEN}[OK]${NC} JAR do java-debug: $DEBUG_JAR"
    fi
fi

# Java Test
TEST_DIR="$HOME/.local/share/nvim/lazy/vscode-java-test"
if [ ! -d "$TEST_DIR" ]; then
    echo -e "${YELLOW}[AVISO]${NC} vscode-java-test não encontrado em $TEST_DIR"
else
    echo -e "${GREEN}[OK]${NC} vscode-java-test encontrado"
    
    TEST_JARS=$(find "$TEST_DIR/server" -name "*.jar" 2>/dev/null)
    if [ -z "$TEST_JARS" ]; then
        echo -e "${YELLOW}[AVISO]${NC} JARs do vscode-java-test não encontrados. Tente compilar novamente."
        echo -e "          Execute: ~/.config/nvim/scripts/compile_java_test.sh"
    else
        JAR_COUNT=$(echo "$TEST_JARS" | wc -l)
        echo -e "${GREEN}[OK]${NC} $JAR_COUNT JARs do vscode-java-test encontrados"
    fi
fi

# Verificar logs
echo -e "${BLUE}[5] Verificando logs do LSP...${NC}"
LSP_LOG="$HOME/.local/state/nvim/lsp.log"

if [ ! -f "$LSP_LOG" ]; then
    echo -e "${YELLOW}[AVISO]${NC} Arquivo de log LSP não encontrado: $LSP_LOG"
else
    echo -e "${GREEN}[OK]${NC} Arquivo de log LSP encontrado"
    
    # Verificar erros específicos
    FATAL_ERRORS=$(grep -i "fatal" "$LSP_LOG" | tail -10)
    if [ -n "$FATAL_ERRORS" ]; then
        echo -e "${RED}[ERRO]${NC} Erros fatais encontrados no log:"
        echo "$FATAL_ERRORS"
    fi
    
    EXIT_ERRORS=$(grep -i "exit code" "$LSP_LOG" | tail -5)
    if [ -n "$EXIT_ERRORS" ]; then
        echo -e "${RED}[ERRO]${NC} Erros de saída encontrados no log:"
        echo "$EXIT_ERRORS"
    fi
    
    # Checar memória no log
    MEMORY_ERRORS=$(grep -i "outofmemory\|memory" "$LSP_LOG" | tail -5)
    if [ -n "$MEMORY_ERRORS" ]; then
        echo -e "${RED}[ERRO]${NC} Possíveis erros de memória detectados:"
        echo "$MEMORY_ERRORS"
        echo -e "${YELLOW}[SUGESTÃO]${NC} Aumente os parâmetros -Xmx nas opções do Java"
    fi
fi

# Sugestões
echo -e "\n${BLUE}=== Sugestões para resolver problemas comuns ===${NC}"

# Se Java 17+
if [[ "$JAVA_VERSION" =~ ^1[7-9] || "$JAVA_VERSION" =~ ^[2-9][0-9] ]]; then
    echo -e "${YELLOW}[SUGESTÃO]${NC} Você está usando Java $JAVA_VERSION, que requer flags adicionais:"
    echo "    --add-opens java.base/sun.nio.fs=ALL-UNNAMED"
    echo "    --add-opens java.base/java.io=ALL-UNNAMED"
fi

echo -e "${YELLOW}[SUGESTÃO]${NC} Aumente a memória disponível para o JDTLS:"
echo "    -Xms1g -Xmx2g"

echo -e "${YELLOW}[SUGESTÃO]${NC} Se persistirem os problemas, tente:"
echo "1. Remover diretório de workspace: rm -rf ~/.local/share/nvim/jdtls-workspace"
echo "2. Reinstalar JDTLS com Mason: :MasonInstall jdtls"
echo "3. Recompilar as extensões Java: scripts/compile_java_debug.sh e scripts/compile_java_test.sh"
echo "4. Verificar permissões dos diretórios: chmod -R u+rw ~/.local/share/nvim"

echo -e "\n${GREEN}Diagnóstico concluído.${NC}"
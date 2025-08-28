#!/bin/bash

# Script para verificar a localização dos arquivos de configuração
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

NVIM_CONFIG="/home/ottojvn/.config/nvim"
CHEZMOI_CONFIG="/home/ottojvn/.local/share/chezmoi/private_dot_config/nvim"

echo -e "${BLUE}=== Verificando localização dos arquivos de configuração ===${NC}"

# Locais possíveis para os arquivos
POSSIBLE_PATHS=(
  "$NVIM_CONFIG/lua/options.lua"
  "$NVIM_CONFIG/options.lua"
  "$CHEZMOI_CONFIG/lua/options.lua"
  "$CHEZMOI_CONFIG/options.lua"
)

# Verificar cada possível localização
echo -e "${BLUE}[INFO]${NC} Procurando por options.lua..."
for path in "${POSSIBLE_PATHS[@]}"; do
  if [ -f "$path" ]; then
    echo -e "${GREEN}[ENCONTRADO]${NC} $path"
    OPTIONS_PATH="$path"
  else
    echo -e "${RED}[AUSENTE]${NC} $path"
  fi
done

# Se encontrou o arquivo, sugerir o caminho correto
if [ -n "$OPTIONS_PATH" ]; then
  echo -e "\n${GREEN}[SOLUÇÃO]${NC} Arquivo options.lua encontrado em: $OPTIONS_PATH"
  
  # Determinar o caminho relativo correto
  if [[ "$OPTIONS_PATH" == *"/lua/options.lua" ]]; then
    echo -e "${YELLOW}[SUGESTÃO]${NC} Use 'require(\"lua.options\")' no init.lua"
  elif [[ "$OPTIONS_PATH" == *"/options.lua" ]]; then
    echo -e "${YELLOW}[SUGESTÃO]${NC} Use 'require(\"options\")' no init.lua"
  fi
else
  echo -e "\n${RED}[ERRO]${NC} Arquivo options.lua não encontrado em nenhum local esperado!"
  echo -e "${YELLOW}[SUGESTÃO]${NC} Verifique se o arquivo existe ou crie-o"
fi

echo -e "\n${BLUE}=== Verificando a estrutura de diretórios ===${NC}"
echo -e "${BLUE}[INFO]${NC} Estrutura da pasta ~/.config/nvim/:"
find "$NVIM_CONFIG" -type f -name "*.lua" | sort
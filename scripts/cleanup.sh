#!/bin/bash

# Script para remover arquivos desnecessários após incorporação das funcionalidades
# Autor: GitHub Copilot

# Cores para mensagens
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Removendo arquivos desnecessários ===${NC}"

# Lista de arquivos a serem removidos
files_to_remove=(
  # Arquivos de estilo não usados
  "/home/ottojvn/.local/share/chezmoi/private_dot_config/nvim/formatters/eclipse-java-google-style.xml"
  
  # Scripts desnecessários ou obsoletos
  "/home/ottojvn/.local/share/chezmoi/private_dot_config/nvim/scripts/apply_intellij_style.sh"
  "/home/ottojvn/.local/share/chezmoi/private_dot_config/nvim/scripts/check_java_format.sh"
  
  # Este próprio script (será removido por último)
  "/home/ottojvn/.local/share/chezmoi/private_dot_config/nvim/scripts/cleanup.sh"
)

# Remover cada arquivo
for file in "${files_to_remove[@]}"; do
  if [ -f "$file" ]; then
    rm -f "$file"
    echo -e "${GREEN}[Removido]${NC} $file"
  else
    echo -e "${RED}[Não encontrado]${NC} $file"
  fi
done

echo -e "\n${GREEN}=== Limpeza concluída! ===${NC}"
echo -e "Os arquivos desnecessários foram removidos.\n"
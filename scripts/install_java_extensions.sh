#!/bin/bash

# Script de instalação das extensões Java (deprecated)
# Este script foi substituído pela instalação automática via Lazy.nvim
# Veja o arquivo: lua/plugins/configs/java_extensions.lua

echo "Este script está depreciado!"
echo "As extensões Java Debug e Test agora são instaladas automaticamente pelo gerenciador de plugins Lazy.nvim."
echo "Basta reiniciar o Neovim para que elas sejam instaladas."
echo ""
echo "Se você deseja instalar manualmente, você pode executar:"
echo "git clone https://github.com/microsoft/java-debug ~/.local/share/java-debug"
echo "cd ~/.local/share/java-debug && ./mvnw clean install"
echo ""
echo "git clone https://github.com/microsoft/vscode-java-test ~/.local/share/vscode-java-test"
echo "cd ~/.local/share/vscode-java-test && npm install && npm run build-server"
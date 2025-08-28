-- Verificando se há código adicional no arquivo de origem do chezmoi
local handle = io.open('/home/ottojvn/.local/share/chezmoi/private_dot_config/nvim/init.lua', 'r')
local content = ''
if handle then
  content = handle:read('*all')
  handle:close()
end
print(content)
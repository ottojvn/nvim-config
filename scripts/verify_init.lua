-- Carregar configurações básicas e verificar se há mais código no arquivo original
local handle = io.open('/home/ottojvn/.config/nvim/init.lua', 'r')
local content = ''
if handle then
  content = handle:read('*all')
  handle:close()
end
print(content)
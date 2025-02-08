fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'AliOG1337'
description 'A professional ESX script that creates sleeping peds for offline players. (edited by iSentrie)'
version '1.1.0'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'es_extended',
    'oxmysql'
}

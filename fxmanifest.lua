fx_version "adamant"
game "gta5"
lua54 'yes'

name         'azakit_pocketbikes'
version      '1.0.0'
author 'Azakit'
description 'Enables bicycle spawning via item use.'

client_scripts {
    'config.lua',
    'client/*'
}

server_scripts {
    'config.lua',
    'server/*'
}

shared_scripts {
	'@es_extended/imports.lua',   -- Uncomment if using ESX
}
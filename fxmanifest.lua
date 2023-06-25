fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'


author 'SavSin'
description 'A banking system'

client_scripts {
  'client/main.lua'
}

shared_script {
  "config.lua",
  'languages/*.lua',
  'locale.lua',
}

server_scripts {
  "@oxmysql/lib/MySQL.lua",
  "server/main.lua",
}

ui_page {
  "ui/shim.html"
}

files {
  "ui/shim.html",
  "ui/dist/js/*.*",
  "ui/dist/css/*.*",
  "ui/dist/fonts/*.*"
}

dependencies {
  'vorp_core',
  'oxmysql'
}

version '1.0.0'

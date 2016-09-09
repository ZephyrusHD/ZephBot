
::RBNACL_LIBSODIUM_GEM_LIB_PATH = "libsodium.dll"

require 'yaml'
require 'discordrb'


#Load Config File
$CONFIG = YAML.load_file('config.yaml')

#Start bot
@bot = Discordrb::Commands::CommandBot.new token: $CONFIG['token'], application_id: $CONFIG['appid'], prefix: $CONFIG['prefix']
p "Bot Startup Complete"

#Set important fixy things before requires
::RBNACL_LIBSODIUM_GEM_LIB_PATH = "libsodium.dll"
ENV["SSL_CERT_FILE"] = "cacert.pem"

require 'yaml'
require 'discordrb'
require 'logging'

#new filename
logfile = "logs/" + Time.new.strftime("%Y-%m-%d %H_%M_%S") + ".log"

#Config output streams /before/ we make the logger
Logging.appenders.stdout(:layout => Logging.layouts.basic(:format_as => :string))
Logging.appenders.file(logfile)

#start logger
@logger = Logging.logger("ZephBot")

#Set logger level
@logger.level = :debug

#Add outputs to logger
@logger.add_appenders logfile,'stdout'

#Load Config File
$CONFIG = YAML.load_file('config.yaml')

#Start bot
@bot = Discordrb::Commands::CommandBot.new token: $CONFIG['token'], 
		application_id: $CONFIG['appid'], prefix: $CONFIG['prefix']
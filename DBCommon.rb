#Set important fixy things before requires

if Gem::Platform.local.os != "linux"
	::RBNACL_LIBSODIUM_GEM_LIB_PATH = "libsodium.dll"
end



ENV["SSL_CERT_FILE"] = "cacert.pem"

require 'yaml'
require 'discordrb'
require 'logging'


#List of servers
@servers = { 
	"avant" => "rr3.re-renderreality.net:25565", 
	"infinity" => "rr3.re-renderreality.net:25566" 
	#{}"vanilla"=> "rr3.re-renderreality.net:25570"

}

#test
#List of ranks
@ranks = { 

	"Wood\s\s\s\s" 	=> "\s\s0",
	"Stone\s\s\s" 	=> "\s12" ,
	"Iron\s\s\s\s" 	=> "\s20" ,
	"Bronze\s\s" 	=> "\s40" ,
	"Silver\s\s"	=> "\s60" ,
	"Gold\s\s\s\s" 	=>  "100" ,
	"Redstone" 		=>  "140" ,
	"Diamond\s" 	=>  "180" ,
	"Obsidian" 		=>  "220" ,
	"Bedrock\s" 	=>  "260"
}

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
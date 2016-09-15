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
#List of old ranks

=begin
@ranks = { 

	# ok no do the string thing
	"Wood\s\s\s\s" 	=> "\s\s0", #+0
	"Stone\s\s\s" 	=> "\s12" , #+12
	"Iron\s\s\s\s" 	=> "\s20" , #+8
	"Bronze\s\s" 	=> "\s40" , #+20
	"Silver\s\s"	=> "\s60" , #+20
	"Gold\s\s\s\s" 	=>  "100" , #+40
	"Redstone" 		=>  "140" , #+40
	"Diamond\s" 	=>  "200" , #+60	180
	"Obsidian" 		=>  "260" , #+60      220
	"Bedrock\s" 	=>  "340" , #+80       260

	"Wood+"			=> 
}
=end

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
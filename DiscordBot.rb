#TestDiscordBot

::RBNACL_LIBSODIUM_GEM_LIB_PATH = "libsodium.dll"

require 'discordrb'
require 'yaml'
require 'rocketleague'
require 'open-uri'
require 'sqlite3'
require 'steam-api'
require 'openssl'
require 'lol'

#Load Config File
$CONFIG = YAML.load_file('config.yaml')

#Start bot
bot = Discordrb::Commands::CommandBot.new token: $CONFIG['token'], application_id: $CONFIG['appid'], prefix: $CONFIG['prefix']
p "Bot Startup Complete"

#sqlite3 shit
db = SQLite3::Database.new "discord.db"
p "SQLite3 Database loaded"

#League api setup
ra = Lol::Client.new $CONFIG['leagueapi'], {region: "na"}
p "League API loaded"

#Register API key from config
Steam.apikey = $CONFIG['steamapi']
p "Steam API loaded"

#define function to reset SQLite3 variables bc I suck and idk how else to
def reset_sql_vars()
	$id_SQL 		= nil #DISCORDID
	$un_SQL 		= nil #DISCORDUN
	$mc_SQL 		= nil #MCUN
	$steam_SQL 		= nil #STEAMID
	$blizz_SQL 		= nil #BLIZZID
	$lol_SQL  		= nil #LOLID
	nil
end


#On startup
bot.ready do |event|

	#Perms
	bot.set_user_permission(109517845678809088, 101)	#Zeph
	bot.set_role_permission(210829888066813965, 100)	#Owner
	bot.set_role_permission(210832404636631040,  99)	#Admin
	bot.set_role_permission(210830743771938817,  50)	#Mod
	bot.set_role_permission(210832674623848460,  50)	#Staff
	bot.set_role_permission(211539951974612992,  50)	#Media Manager
	bot.set_role_permission(212054054296092672,	 25)	#Veteran
	bot.set_role_permission(210829146903937024,	  1)	#@everyone

	#Status. "Playing..."
	bot.game = ($CONFIG['status'])

	#avatar
	event.bot.profile.avatar = open("http://i.imgur.com/2UzHz5T.png")
end

#Ping Command
bot.command(:ping, description: 'Responds with response time.', usage: "ping") do |event|
	testVar = "#{((Time.now - event.timestamp) * 1000).to_i}ms."
	event.respond(testVar)

	#Console Output
	puts Time.now.to_s + " Ping Completed: " + testVar
end

#Random Command
bot.command(:random, description: "Responds with a number between arg1 and arg2",
usage: "random arg1 arg2", min_arg: 2, max_args: 2) do |event, min, max|

  result = rand(min.to_i .. max.to_i)
  event.respond(result)

  #Console Output
  puts "Min: " + min.to_s + " Max: " + max.to_s + " Result: " + result.to_s
end

#Prune Command
bot.command([:prune, :purge], description: "Prunes last 100 messages in this channel. Admin or Higher only.",
	required_permissions: [:manage_messages], usage: "prune|purge",
	permission_level: 99) do |event|
	if event.bot.profile.on(event.server).permission?(:manage_messages, event.channel)
		break unless event.channel.name == "bot"
		event.channel.prune(100)
	end
end

#Server info Command
bot.command(:serverinfo, description: "Lists server info for the Re-Render Reality Community!", 
	usage: "serverinfo") do |event|
	event << "»"
	event << "Name: Re-Render Reality!"
	event << "Main IP: rr3.re-renderreality.net"
	event << "Avant 3 Port: 25565"
	event << "Infinity Port: 25566"
	event << "			"
	event << "Current Events: "
	event << "Pookie pls gimmie"
end

#Perm Test Command
bot.command(:test, help_available: false, permission_level: 100) do |event|
  'You are allowed to use this command!'
end

#List Roles Command
bot.command(:listroles, description: "Print role IDs in console", usage: "listroles", permission_level: 101) do |event|
	start = 0
	num = 11
	while start < num do
		first = event.server.roles[start].id.to_s
		second = event.server.roles[start].name.to_s
		p first + " | " + second
		start += 1
		sleep(1)
	end
end

#Eval Command
bot.command(:eval, description: "Run any code you want!!!", usage: "eval *Literally any code*", permission_level: 101) do |event, *code|
	p Time.now.to_s + " " + event.user.name
  break unless event.user.id == 109517845678809088 # Replace number with your ID

  begin
    eval code.join(' ')
  rescue
    'An error occured 😞'
  end
end

#Check how many people are on
bot.command :online, description: "Check how many people are currently on <X> server", usage: "online Avant|Infinity|Vanilla" do |event, server| 
	begin
		p Time.now.to_s + " " + event.user.name + " made a request"
		serv_url = "rr3.re-renderreality.net"
		egg = false

		server = server.downcase()
		case server
			when "avant"
				serv_url = "rr3.re-renderreality.net:25565"
			when "infinity"
				serv_url = "rr3.re-renderreality.net:25566"
			when "vanilla"
				serv_url = "rr3.re-renderreality.net:25570"
			when "your_mom"
				 serv_url = "rr3.re-renderreality.net:25566"
				 egg = true
			else
				serv_url = server
		end


		if egg == false
		serv_url.delete! '()\'\"{};!@#$%^&*|,'

		file = File.read('staff.json')
		serv = JSON.parse(RestClient.get("https://mcapi.ca/query/" + serv_url + "/list"))
		staff = JSON.parse(file)
		p serv
		p serv['Players']['list'] & staff['Staff']


		event << "»"
		event << "Status: **Online**"
		event << "Players: " + "**" + serv['Players']['online'].to_s + "**" + "/" + serv['Players']['max'].to_s

		x = 0
		playerson = serv['Players']['online']
		while x < playerson do
			if  staff['Staff'].include?(serv['Players']['list'][x].to_s) 
				event << "**" + serv['Players']['list'][x] + "**"
			else
				event << serv['Players']['list'][x]
			end

			p "element " + x.to_s + " complete" 
			x += 1
			sleep(0.1)
		end

		else
			event << "»"
			event << "Status: **Getting Fucked**"
			event << "Players: " + "**" + "2" + "**" + "/" + "∞"
			event << "**AvaNight**"
			event << "***Harambe***"
		end

	rescue => e
		if e.message.include?("\"Status\": false")
			event.respond("I couldn't find that server. Sorry!")
			p "Server not found. Don't freak out!!!"
		else
			event.respond("<@109517845678809088> Something done fk'd up")
			event.respond("BAD REQUEST!\n```\n"+e.inspect+"\n```")
		end
	end
end

#Events
bot.command :events, description: "Look at all of these events we're hosting!!!", usage: "events" do |event|
	event << "»"
	event << "-Re-Render Reality Event list-"
	event << "Pookie pls gimmie"
	event << ""
	event << ""
end


#lmgtfy
bot.command([:lmgtfy, :google], description: "Googles whatever you ask it to", usage: "lmgtfy|google <text>" ) do |event, *text|
	event << "http://lmgtfy.com/?q=#{text.join('+')}"
end





#Configure command
bot.command([:configure, :config], description: "Use this to configure Zephbot! \nExample: ;config Minecraft ZephyrusHD",
					usage: $CONFIG['prefix'] + "config <list> <your_username_here>") do |event, game, *info|
	reset_sql_vars
	#info.delete! '()\"{};!@$%^&*|,'

	#Prep vars for registering/checking
	$id_SQL		= event.user.id
	$un_SQL 	= event.user.name

	db.execute("INSERT OR IGNORE INTO players(DISCORDID, DISCORDUN)
				VALUES (?, ?)", [$id_SQL, $un_SQL])

	if !event.channel.private?
		p Time.now.to_s + " " + event.user.name + " ran this in a public channel"
		event.respond("Please configure me in private! I'll message you to make it easy :)")
		event.user.pm("Hey there! Run ;help config to see how to use this command!")
	else
		p Time.now.to_s + " " + event.user.name + " ran this in a private channel"

		if game == nil

			#If no game is provided
			event.respond("Thank you for configuring me. I can be re-configured at any time :) ")

		else

			#Downcase for readability
			game = game.downcase()

			case game
				when "minecraft"
					$mc_SQL = info
					if $mc_SQL == ""
						event.respond("Oops! You didn't specify a username. Try " + $CONFIG['prefix'] + "help config to see how to use this command.")
					else
						begin
							event.respond("Minecraft Username set to " + info.join(" "))
							uuid = JSON.parse(RestClient.get("http://minecraft-techworld.com/admin/api/uuid?action=uuid&username=" + info.join("")))
							
							#Format uuid string
							uuidstring = uuid['output']
							uuidstring.delete! '-'

							db.execute("UPDATE players SET MCUN = ?, MCUUID = ? WHERE DISCORDID = ?", [$mc_SQL, uuidstring, $id_SQL])
							#event.server(210829146903937024).member(event.user.id).add_role(212053760971767808)
							bot.server(210829146903937024).member(event.user.id).add_role(212053760971767808)

						rescue => e
							event.respond("stop trying 2 break my bot pls")
						end
					end

				when "steam"
					$steam_SQL = info.join(" ")
					if $steam_SQL == "" 
						event.respond("Oops! You didn't specify a username. Try " + $CONFIG['prefix'] + "help config to see how to use this command.")
					else
						event.respond("Steam Username set to " + info.join(" "))
						sid = Steam::User.vanity_to_steamid(info.join(""))
						p sid
						db.execute("UPDATE players SET STEAMID = ?, STEAM64 = ? WHERE DISCORDID = ?", [$steam_SQL, sid, $id_SQL])
					end

				when "blizzard"
					$blizz_SQL = info.join(" ")
					if $blizz_SQL == "" 
						event.respond("Oops! You didn't specify a username. Try " + $CONFIG['prefix'] + "help config to see how to use this command.")
					else
						event.respond("Blizzard Username set to " + info.join(" "))
						db.execute("UPDATE players SET BLIZZID = ? WHERE DISCORDID = ?", [$blizz_SQL, $id_SQL])
					end

				when "league"
					$lol_SQL = info.join(" ")
					if $lol_SQL == "" 
						event.respond("Oops! You didn't specify a username. Try " + $CONFIG['prefix'] + "help config to see how to use this command.")
					else
						event.respond("Summoner Name set to " + info.join(" "))
						db.execute("UPDATE players SET LOLID = ? WHERE DISCORDID = ?", [$lol_SQL, $id_SQL])
					end

				when "list"
					event.respond("Minecraft, Steam, Blizzard, League")

				else
					event.respond("Sorry! That's not a valid game. Please ;config list to see avaliable games!")
				end


		#if game == nil end
		end

	#is pm end
	end

	#Fixes [] printout
	nil
#End of command
end


#serv = JSON.parse(RestClient.get("http://minecraft-techworld.com/admin/api/uuid?action=uuid&username=" + username))


bot.command:skin do |event, name|
	if name == nil
	#Your skin
		mcun = db.execute("SELECT MCUN FROM players WHERE DISCORDID = ?", [event.user.id])
		event.respond("https://mcapi.ca/skin/2d/" + mcun.join(""))
	else
	#if name input WAS provided
		mcun = db.execute("SELECT MCUN FROM players WHERE DISCORDUN = ? OR MCUN = ?", [name, name])
		#But that player isn't registered
		if mcun.to_s == "[]"
			event.respond("Sorry, That player isn't registered!")
		else
		#But that player IS registered
			event.respond("https://mcapi.ca/skin/2d/" + mcun.join(""))	
		end
	end
end



bot.command(:steam) do |event, arg, *input|
	case arg.downcase()
		when "level"
			begin

			if input.to_s == "[]"
				id = db.execute("SELECT STEAM64 FROM players WHERE DISCORDID = ?", [event.user.id])
				level = Steam::Player.steam_level(id.join("") )
				event.respond("Your steam level is **" + level.to_s + "**")
			else
				id = db.execute("SELECT STEAM64 FROM players WHERE DISCORDUN = ? OR STEAMID = ?", [input.join(""), input.join("")])
				level = Steam::Player.steam_level(id.join("") )
				event.respond( input.join(" ") + "'s steam level is **" + level.to_s + "**")
			end

			rescue => e
				event.respond("Sorry, I couldn't find that player. Are they registered?")
			end

	end

end

bot.command :league do |event|
	nil
end


bot.command(:ban) do |event|
	while true do 
		event.respond(";BAN EPIIC_THUNDERCAT")
		sleep(1)
	end
end


bot.command(:package) do |event|
	file = File.read('staff.json')
	staff = JSON.parse(file)
	mcun = db.execute("SELECT MCUN FROM players WHERE DISCORDID = ?", [event.user.id])

	if staff['Staff'].include?(mcun.join("")) 
		url = "https://www.dropbox.com/home?preview=Staff+Installation.zip"
		event.user.pm("Hey there! Here's the URL for the latest staff download: " + url)
	else
		url = "https://www.dropbox.com/s/7eqhrwywihni734/Players.zip?dl=0"
		event.user.pm("Hey there! Here's the URL for the latest player download: " + url)
	end
end


bot.command :kappa do |event|
	event.channel.send_message(" 
		For sen is love, 
		For sen is life, 
		For sen's hair looks very nice, 
		For sen is sexy, 
		And he rock, 
		I just wanna suck his... 
		Swedish meatballs,
			Love, alex the seal",
		tts = true)

end

bot.command :voice	do |event|
	bot.voice_connect(event.user.voice_channel.id)
	voice_bot = event.voice
	voice_bot.volume = 0.1
	voice_bot.play_file("songs/nyan.mp3")
end

bot.command :volume do |event, vol|
	voice_bot = event.voice
	voice_bot.volume = vol.to_f
end

bot.command :stop do |event|
	voice_bot = event.voice
	voice_bot.stop_playing
	end

#Actually /run/ the bot
bot.run





#z!eval i=0; num=20; while $1 < $num do; p event.server.roles[$i].id; $i +=1; end;


=begin
z!eval 
start = 0;
	num = 11;
	while start < num do;
		first = event.server.roles[start].id.to_s;
		second = event.server.roles[start].name.to_s;
		event.respond( first + " | " + second);
		start += 1;
		sleep(1);
	end;
=end
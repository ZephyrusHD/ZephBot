require 'rocketleague'
require 'steam-api'
require 'lol'

require_relative 'DBCommon'
require_relative 'DBSQL'



#League api setup
ra = Lol::Client.new $CONFIG['leagueapi'], {region: "na"}
p "League API loaded"

#Register API key from config
Steam.apikey = $CONFIG['steamapi']
p "Steam API loaded"


@bot.command:skin do |event, name|
	if name == nil
	#Your skin
		mcun = @db.execute("SELECT MCUN FROM players WHERE DISCORDID = ?", [event.user.id])
		event.respond("https://mcapi.ca/skin/2d/" + mcun.join(""))
	else
	#if name input WAS provided
		mcun = @db.execute("SELECT MCUN FROM players WHERE DISCORDUN = ? OR MCUN = ?", [name, name])
		#But that player isn't registered
		if mcun.to_s == "[]"
			event.respond("Sorry, That player isn't registered!")
		else
		#But that player IS registered
			event.respond("https://mcapi.ca/skin/2d/" + mcun.join(""))	
		end
	end
end


@bot.command(:steam) do |event, arg, *input|
	case arg.downcase()
		when "level"
			begin

			if input.to_s == "[]"
				id = @db.execute("SELECT STEAM64 FROM players WHERE DISCORDID = ?", [event.user.id])
				level = Steam::Player.steam_level(id.join("") )
				event.respond("Your steam level is **" + level.to_s + "**")
			else
				id = @db.execute("SELECT STEAM64 FROM players WHERE DISCORDUN = ? OR STEAMID = ?", [input.join(""), input.join("")])
				level = Steam::Player.steam_level(id.join("") )
				event.respond( input.join(" ") + "'s steam level is **" + level.to_s + "**")
			end

			rescue => e
				event.respond("Sorry, I couldn't find that player. Are they registered?")
			end

	end

end


@bot.command :league do |event|
	nil
end


#Configure command
@bot.command([:configure, :config], description: "Use this to configure Zephbot! \nExample: ;config Minecraft ZephyrusHD",
					usage: $CONFIG['prefix'] + "config <list> <your_username_here>") do |event, game, *info|
	reset_sql_vars
	#info.delete! '()\"{};!@$%^&*|,'

	#Prep vars for registering/checking
	$id_SQL		= event.user.id
	$un_SQL 	= event.user.name

	@db.execute("INSERT OR IGNORE INTO players(DISCORDID, DISCORDUN)
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

							@db.execute("UPDATE players SET MCUN = ?, MCUUID = ? WHERE DISCORDID = ?", [$mc_SQL, uuidstring, $id_SQL])
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
						@db.execute("UPDATE players SET STEAMID = ?, STEAM64 = ? WHERE DISCORDID = ?", [$steam_SQL, sid, $id_SQL])
					end

				when "blizzard"
					$blizz_SQL = info.join(" ")
					if $blizz_SQL == "" 
						event.respond("Oops! You didn't specify a username. Try " + $CONFIG['prefix'] + "help config to see how to use this command.")
					else
						event.respond("Blizzard Username set to " + info.join(" "))
						@db.execute("UPDATE players SET BLIZZID = ? WHERE DISCORDID = ?", [$blizz_SQL, $id_SQL])
					end

				when "league"
					$lol_SQL = info.join(" ")
					if $lol_SQL == "" 
						event.respond("Oops! You didn't specify a username. Try " + $CONFIG['prefix'] + "help config to see how to use this command.")
					else
						event.respond("Summoner Name set to " + info.join(" "))
						@db.execute("UPDATE players SET LOLID = ? WHERE DISCORDID = ?", [$lol_SQL, $id_SQL])
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

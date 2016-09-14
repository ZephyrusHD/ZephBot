require_relative 'DBCommon'
require 'RubyMinecraft'

@bot.bucket :minecraft, limit: 5, time_span: 10, delay: 2

#sql?
#List of servers


#init server string
serverNamesConcat = String.new
@servers.each do |key, value|
	serverNamesConcat += "|"+key.to_s
end
#trim leading |
serverNamesConcat[0] = ''


def secondsToTime(time)
	min,	sec = time.divmod(60)
	hr,		min = min.divmod(60)
	day,	hr 	= hr.divmod(24)
	week, 	day = day.divmod(7)

	array = [week,day,hr,min,sec]
	return array
end


#Serverinfo Command
@bot.command(:serverinfo, bucket: :minecraft, rate_limit_message: "Avaliable in %time% seconds!", description: "Lists server info", 
	usage: "serverinfo") do |event|
	@logger.debug event.user.name + " :serverinfo"
	event << "»"
	event << "Name: Re-Render Reality!"
	event << "Main IP: rr3.re-renderreality.net"
	event << "Avant 3 Port: 25565"
	event << "Infinity Port: 25566"
	event << "			"
	event << "Current Events: "
	event << "Pookie pls gimmie"
end


#Online Command
@bot.command :online, bucket: :minecraft, rate_limit_message: "Avaliable in %time% seconds!", description: "Check how many people are currently on the specified server", usage: "online "+serverNamesConcat do |event, server| 
	@logger.debug event.user.name + " :online " + server.to_s
	begin
		serv_url = "rr3.re-renderreality.net"

		if server == nil then
            event << "Please specify a server!"
            return
        end

		server = server.downcase()

		#list servers
		if server == "list"	then 
			event << "»"
			@servers.each do |key, value|
				event << (key + " | " + value)
			end
			return
		end

		# harambe tax
		if server == "your_mom" then
			event << "»\nStatus: **Getting Fucked**\nPlayers:  **2**/∞\n**AvaNight**\n***Harambe***"
			return
		end

		# map lookup
		if @servers.has_key?(server) then
			serv_url = @servers[server]
		else
			serv_url = server
		end

		serv_url.delete! '()\'\"{};!@#$%^&*|,'

		file = File.read('staff.json')
		serv = JSON.parse(RestClient.get("https://mcapi.ca/query/" + serv_url + "/list"))
		staff = JSON.parse(file)

		msg = "»\n"
		msg += "Status: **Online**\n"
		msg += "Players: " + "**" + serv['Players']['online'].to_s + "**" + "/" + serv['Players']['max'].to_s + "\n"

		x = 0
		playerson = serv['Players']['online']
		while x < playerson do
			if  staff['Staff'].include?(serv['Players']['list'][x].to_s) 
				msg += "**" + serv['Players']['list'][x] + "**\n"
			else
				msg += serv['Players']['list'][x] + "\n"
			end
			
			x += 1
			#sleep(0.1)
		end

		event << msg

	rescue => e
		if e.message.include?("\"Status\": false")
			event.respond("I couldn't find that server. Sorry!")
		elsif e.message.include?("unexpected return")
			nil
		else
			event.respond("Something went wrong.")
			@logger.error e
		end
	end
end


#Package Command
@bot.command(:package, bucket: :minecraft, rate_limit_message: "Avaliable in %time% seconds!", description: "PM's the user the download package", usage: "package") do |event|
	@logger.debug event.user.name + " :package"
	file = File.read('staff.json')
	staff = JSON.parse(file)
	mcun =@db.execute("SELECT MCUN FROM players WHERE DISCORDID = ?", [event.user.id])

	if staff['Staff'].include?(mcun.join("")) 
		url = "https://www.dropbox.com/home?preview=Staff+Installation.zip"
		event.user.pm("Hey there! Here's the URL for the latest staff download: " + url)
	else
		url = "https://www.dropbox.com/s/7eqhrwywihni734/Players.zip?dl=0"
		event.user.pm("Hey there! Here's the URL for the latest player download: " + url)
	end
end


#Rcon Command
@bot.command(:rcon, bucket: :minecraft, rate_limit_message: "Avaliable in %time% seconds!", permission_level: 50) do |event, *arg|
	@logger.debug event.user.name + " :rcon " + arg.join(" ")
	rcon = RCON::Minecraft.new("rr3.re-renderreality.net", 25576);
	rcon.auth($CONFIG['rconpass'])

	if arg.join("") == "[]"
		event.respond("Please enter a command")
	else
		rcon.command(arg.join(" "))
	end
end


#Playtime Command
@bot.command(:playtime) do |event, arg|
	case arg
		when nil
			time = @db.execute("SELECT TIMEPLAYED FROM players WHERE DISCORDID = ?", [event.user.id])
			time = time.join("")
			time = time.to_i
			timeArray = secondsToTime(time)
			event.respond("»\n" + "You have played a total of: \n" + timeArray[0].to_s + " Weeks\n" + timeArray[1].to_s + 
				" Days\n" + timeArray[2].to_s + " Hours\n" + timeArray[3].to_s + 
				" Minutes\n" + timeArray[4].to_s + " Seconds.")

		when "top"
				timeArray = @db.execute("SELECT TIMEPLAYED, MCUN FROM players ORDER BY -TIMEPLAYED LIMIT 25")
				event << "»"
				x = 1
				event << "```"

				timeArray.each do |key, value|
					#For Name Spacing
					array = secondsToTime(key)
					stringArray = value.scan /\w/
					needToBe = 17 - stringArray.length

					(1..needToBe).each do |thing|
						stringArray << "\s"
					end

					#For Rank Spacing
					rank = x.to_s
					rank = rank.scan /\w/
					needToBe = 4 - rank.length
					(1..needToBe).each do |thing|
						rank << "\s"
					end

					#For Time Spacing
					y = 0 
					while y < 5
						if array[y] < 10
							array[y] = "0" + array[y].to_s 
						end
						y = y + 1
					end

					event << rank.join("") + "| " + stringArray.join("") + "\t " + array[0].to_s + "W " + array[1].to_s + "D " + 
					array[2].to_s + "H " + array[3].to_s + "M " + array[4].to_s + "S "
					
					x = x + 1
				end

				event << "```"
				nil

		when "harambe"
			event.respond("Harambe did not get enough time in this world before he was taken from us.")

		when "your_mom"
			event.respond("AvaNight played your mom last night.")

		else
			time = @db.execute("SELECT TIMEPLAYED FROM players WHERE DISCORDUN = ? OR MCUN = ?", [arg, arg])
			p time.to_s
			if time == "[]"
				event.respond("I couldn't find that player, or they haven't played!")
			else
				time = time.join()
				time = time.to_i
				timeArray = secondsToTime(time)
				event.respond("»\n" + "You have played a total of: \n" + timeArray[0].to_s + " Weeks\n" + timeArray[1].to_s + 
				" Days\n" + timeArray[2].to_s + " Hours\n" + timeArray[3].to_s + 
				" Minutes\n" + timeArray[4].to_s + " Seconds.")
			end


	end
end
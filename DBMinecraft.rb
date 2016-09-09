require_relative 'DBCommon'



#TODO: load these from elsewhere?
#sql?
servers = { "avant" => "rr3.re-renderreality.net:25565", "infinity" => "rr3.re-renderreality.net:25566", "vanilla"=> "rr3.re-renderreality.net:25570" }

#init server string
serverNamesConcat = String.new
servers.each do |key, value|
	serverNamesConcat += "|"+key.to_s
end
#trim leading |
serverNamesConcat[0] = ''


#Server info Command
@bot.command(:serverinfo, description: "Lists server info for the Re-Render Reality Community!", 
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


#Check how many people are on
@bot.command :online, description: "Check how many people are currently on <X> server", usage: "online "+serverNamesConcat do |event, server| 
	begin
		p Time.now.to_s + " " + event.user.name + " made a request"
		serv_url = "rr3.re-renderreality.net"

		if server == nil then
            event << "Please specify a server!"
            return
        end

		server = server.downcase()

		# harambe tax
		if server == "your_mom" then
			event << "»\nStatus: **Getting Fucked**\nPlayers:  **2**/∞\n**AvaNight**\n***Harambe***"
			return
		end

		# map lookup
		if servers.has_key?(server) then
			serv_url = servers[server]
		else
			serv_url = server
		end

		serv_url.delete! '()\'\"{};!@#$%^&*|,'

		file = File.read('staff.json')
		serv = JSON.parse(RestClient.get("https://mcapi.ca/query/" + serv_url + "/list"))
		staff = JSON.parse(file)
		p serv
		p serv['Players']['list'] & staff['Staff']

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

			p "element " + x.to_s + " complete" 
			x += 1
			sleep(0.1)
		end

		event << msg

	rescue => e
		if e.message.include?("\"Status\": false")
			event.respond("I couldn't find that server. Sorry!")
			p "Server not found. Don't freak out!!!"
		elsif e.message.include?("unexpected return")
			nil
		else
			event.respond("<@109517845678809088> Something done fk'd up")
			event.respond("BAD REQUEST!\n```\n"+e.inspect+"\n```")
		end
	end
end


@bot.command(:package) do |event|
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
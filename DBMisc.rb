require_relative 'DBCommon'


#Events Command
@bot.command :events, description: "Lists events", usage: "events" do |event|
	@logger.debug event.user.name + " :event"
	event << "»"
	event << "-Re-Render Reality Event list-"
	event << "Pookie pls gimmie"
	event << ""
	event << ""
end


#Lmgtfy Command
@bot.command([:lmgtfy, :google], description: "Googles whatever you ask it to", usage: "lmgtfy <text>" ) do |event, *text|
	@logger.debug event.user.name + " :lmgtfy " + text.join()
	event.respond("http://lmgtfy.com/?q=#{text.join('+')}")
end

#List Roles Command
@bot.command(:listroles, description: "Print role IDs", usage: "listroles", permission_level: 101) do |event|
	@logger.debug event.user.name + " :listroles"
	start = 0
	num = event.server.roles.length
	out = "»\n"
	while start < num do
		first = event.server.roles[start].id.to_s
		second = event.server.roles[start].name.to_s
		out = out + first + " | " + second + "\n"
		start += 1
	end
	out.delete! '@'
	event.respond(out)
end


#Ping Command
@bot.command(:ping, description: 'Responds with... Something', usage: "ping") do |event|
	@logger.debug event.user.name + " :ping"
	testVar = "#{((Time.now - event.timestamp) * 1000).to_i}ms."
	event.respond(testVar)
end


#Random Command
@bot.command(:random, description: "Responds with a number between two numbers",
usage: "random <x> <y>", min_arg: 2, max_args: 2) do |event, min, max|
	@logger.debug event.user.name + " :random " + min.to_s + " " + max.to_s
	result = min.to_i < max.to_i ? rand(min.to_i .. max.to_i) : rand(max.to_i .. min.to_i)
	event.respond(result)
end


#Prune Command
@bot.command([:prune, :purge], description: "Prunes last 100 messages in this channel.", 
			usage: "prune|purge", permission_level: 99) do |event, num|
	@logger.debug event.user.name + " :prune " + num.to_s
	if num == nil
		num = 100
	end
	event.channel.prune(num)
end


#Ban Command
@bot.command(:ban, description: "Spams with Banning Epiic_Thundercat", usage: "ban") do |event|
	@logger.debug event.user.name + " :ban"
	for i in 0..10 do 
		event.respond(";BAN EPIIC_THUNDERCAT")
		sleep(1)
	end
end


#Kappa Command
@bot.command(:kappa, description: "Sends TTS Kappa poem", usage: "kappa") do |event|
	@logger.debug event.user.name + " :kappa"
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
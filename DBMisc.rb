require_relative 'DBCommon'


#Events
@bot.command :events, description: "Look at all of these events we're hosting!!!", usage: "events" do |event|
	event << "»"
	event << "-Re-Render Reality Event list-"
	event << "Pookie pls gimmie"
	event << ""
	event << ""
end


#lmgtfy
@bot.command([:lmgtfy, :google], description: "Googles whatever you ask it to", usage: "lmgtfy|google <text>" ) do |event, *text|
	event << "http://lmgtfy.com/?q=#{text.join('+')}"
end


#Perm Test Command
@bot.command(:test, help_available: false, permission_level: 100) do |event|
  'You are allowed to use this command!'
end


#List Roles Command
@bot.command(:listroles, description: "Print role IDs in console", usage: "listroles", permission_level: 101) do |event|
	start = 0
	num = event.server.roles.length
	out = ""
	while start < num do
		first = event.server.roles[start].id.to_s
		second = event.server.roles[start].name.to_s
		out = out + first + " | " + second + "\n"
		start += 1
	end
	p out
end

#Ping Command
@bot.command(:ping, description: 'Responds with response time.', usage: "ping") do |event|
	testVar = "#{((Time.now - event.timestamp) * 1000).to_i}ms."
	event.respond(testVar)

	#Console Output
	puts Time.now.to_s + " Ping Completed: " + testVar
end


#Random Command
@bot.command(:random, description: "Responds with a number between arg1 and arg2",
usage: "random arg1 arg2", min_arg: 2, max_args: 2) do |event, min, max|

  result = min.to_i < max.to_i ? rand(min.to_i .. max.to_i) : rand(max.to_i .. min.to_i)
  event.respond(result)

  #Console Output
  puts "Min: " + min.to_s + " Max: " + max.to_s + " Result: " + result.to_s
end


#Prune Command
@bot.command([:prune, :purge], description: "Prunes last 100 messages in this channel. Admin or Higher only.",
	required_permissions: [:manage_messages], usage: "prune|purge",
	permission_level: 99) do |event|
	if event.bot.profile.on(event.server).permission?(:manage_messages, event.channel)
		break unless event.channel.name == "bot"
		event.channel.prune(100)
	end
end


#kek
@bot.command(:ban) do |event|
	for i in 0..10 do 
		event.respond(";BAN EPIIC_THUNDERCAT")
		sleep(1)
	end
end


#kek
@bot.command :kappa do |event|
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
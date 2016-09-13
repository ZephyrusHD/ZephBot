require_relative 'DBCommon'

require_relative 'DBMinecraft'
require_relative 'DBApis'
require_relative 'DBMusic'
require_relative 'DBMisc'


startTime = nil
@logger.debug ("Start time nil")


#On startup
@bot.ready do |event|
	#Perms
	@bot.set_user_permission(109517845678809088, 	101)	#Zeph
	@bot.set_role_permission(210829888066813965,	100)	#Owner
	@bot.set_role_permission(210832404636631040,	 99)	#Admin
	@bot.set_role_permission(210830743771938817, 	 50)	#Mod
	@bot.set_role_permission(210832674623848460, 	 49)	#Staff
	@bot.set_role_permission(211539951974612992, 	 49)	#Media Manager
	@bot.set_role_permission(212054054296092672,	 25)	#Veteran
	@bot.set_role_permission(210829146903937024,	  1)	#@everyone

	@bot.game = ($CONFIG['status'])

	event.bot.profile.avatar = open($CONFIG['avatarurl'])

	#Create inital time for heartbeat
	startTime = Time.new
	@logger.debug("Time Init")

	#@db.execute("U")
end


#Every heartbeat
@bot.heartbeat do |event|
	newTime = Time.new	
	time_elapsed = newTime.to_i - startTime.to_i

	#Do only if time isn't weird
	if time_elapsed >= 600 || time_elapsed <=5
		nil
	else
		@logger.debug("Pitter Patter: " + time_elapsed.to_s)


		@servers.each do |key, value|
			serv = JSON.parse(RestClient.get("https://mcapi.ca/query/" + value + "/list"))
			playerson = serv['Players']['list']
			
			if playerson == false
				nil
			else
				playerson.each do |player|
					@db.execute("UPDATE players SET TIMEPLAYED = TIMEPLAYED + ? WHERE MCUN = ?", [time_elapsed, player])
				end
			end
			
		end
	end
	#Do these last
	startTime = Time.at(newTime.to_i)
	nil
end


#Eval Command
@bot.command(:eval, description: "Run any code you want!!!", usage: "eval *code here*") do |event, *code|
	@logger.warn event.user.name + " :eval " + code.join()

	if event.server.id.to_s == "222813624320655360" then 
   		@bot.set_user_permission(110907958824538112, 	101)	#coldie perms on his server only
    end

	break unless event.user.id == 109517845678809088 || (event.server.id.to_s == "222813624320655360" && event.user.id == 110907958824538112)  # Replace number with your ID
 		begin
    		eval code.join(' ')
  		rescue => e
    		event.respond("You suck.")
    		@logger.error e
 		 end
end


#Actually /run/ the bot
#@bot.debug = true
#Gateway message serves as better indication when bot is running
#becuase there is a delay when this message is ran to when the bot is able to accept commands
@bot.run
require_relative 'DBCommon'

require_relative 'DBMinecraft'
require_relative 'DBApis'
require_relative 'DBMusic'
require_relative 'DBMisc'


#On startup
@bot.ready do |event|
	#Perms
	@bot.set_user_permission(109517845678809088, 	101)	#Zeph
	@bot.set_role_permission(210829888066813965,	100)	#Owner
	@bot.set_role_permission(210832404636631040,	 99)	#Admin
	@bot.set_role_permission(210830743771938817, 	 50)	#Mod
	@bot.set_role_permission(210832674623848460, 	 50)	#Staff
	@bot.set_role_permission(211539951974612992, 	 50)	#Media Manager
	@bot.set_role_permission(212054054296092672,	 25)	#Veteran
	@bot.set_role_permission(210829146903937024,	  1)	#@everyone

	#Status. "Playing..."
	@bot.game = ($CONFIG['status'])

	#Avatar
	event.bot.profile.avatar = open("http://i.imgur.com/2UzHz5T.png")
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

#Gateway message serves as better indication when bot is running
#becuase there is a delay when this message is ran to when the bot is able to accept commands
@bot.run
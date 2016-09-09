require_relative 'DBCommon'

require_relative 'DBMinecraft'
require_relative 'DBApis'
require_relative 'DBMusic'
require_relative 'DBMisc'


#On startup
@bot.ready do |event|

	#Perms
	@bot.set_user_permission(109517845678809088, 	101)	#Zeph
	if @bot.profile.username == "coldieBot" then #for testing
   		@bot.set_user_permission(110907958824538112, 	101)	#coldie
    end
	@bot.set_role_permission(210829888066813965,	100)	#Owner
	@bot.set_role_permission(210832404636631040,	 99)	#Admin
	@bot.set_role_permission(210830743771938817, 	 50)	#Mod
	@bot.set_role_permission(210832674623848460, 	 50)	#Staff
	@bot.set_role_permission(211539951974612992, 	 50)	#Media Manager
	@bot.set_role_permission(212054054296092672,	 25)	#Veteran
	@bot.set_role_permission(210829146903937024,	  1)	#@everyone

	#Status. "Playing..."
	@bot.game = ($CONFIG['status'])

	#avatar
	event.bot.profile.avatar = open("http://i.imgur.com/2UzHz5T.png")
end


#Eval Command
@bot.command(:eval, description: "Run any code you want!!!", usage: "eval *Literally any code*", permission_level: 101) do |event, *code|
	p Time.now.to_s + " " + event.user.name
  break unless event.user.id == 109517845678809088 || (@bot.profile.username == "coldieBot" && event.user.id == 110907958824538112)  # Replace number with your ID
  begin
    eval code.join(' ')
  rescue
    'An error occured 😞'
  end
end


#Actually /run/ the bot
@bot.run

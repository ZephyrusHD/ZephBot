require_relative 'DBCommon'


#Meme Command
@bot.command( :meme, description: "Play a meme from the master meme database", 
	usage: "meme <song_name>")	do |event, song|
	@logger.debug event.user.name + " :meme " + song.to_s
	if song == nil
		event.respond("Please provide a song, or run ```meme list```")
	else
		song.downcase!()
		begin
			#connect bot to command issuer's voice channel
			@bot.voice_connect(event.user.voice_channel.id)
			voice_bot = event.voice
			
			#Create array of every .mp3 in the songs dir
			songArray = Dir["songs/*.mp3"]

			#Check if song == something in songArray
			#There has to be better way to do this?
			songArray.each do |value|
				if value.include? (song)
					voice_bot.volume = 0.1
					voice_bot.play_file(value)
					return 
				end
			end

			if song == "list"
				event << "»"
				songArray = Dir["songs/*.mp3"]
				songArray.each do |value|
					value.slice! "songs/"
					value.slice! ".mp3"
					event << value
				end
			else
				event.respond("Sorry! Couldn't find that song. Try running the list command?")
			end

		rescue => e
			if e.message.include?("undefined method")
				event.respond("Are you in a voice channel?")
			elsif e.message.include?("unexpected return")
				#Let song end quietly
				nil
			else
				event.respond(e)
				event.respond("w0t")
			end
		end

	end

	nil
end


#Volume Command
@bot.command(:volume, description: "Changes ZephBot's volume", usage: "volume <0-100>") do |event, vol|
	@logger.debug event.user.name + " :volume " + vol.to_s
	voice_bot = event.voice
	voice_bot.volume = (vol.to_f/100).abs

	nil
end


#Stop Command
@bot.command(:stop, description: "Stops ZephBot's playback", usage: "stop") do |event|
	@logger.debug event.user.name + " :stop"
	voice_bot = event.voice
	voice_bot.stop_playing
	#Be quiet
	nil
end


#Leave command
@bot.command(:leave, description: "Forces ZephBot to leave the channel", usage: "leave") do |event|
	@logger.debug event.user.name + " :leave"
	begin
		voice_bot = event.voice
		voice_bot.destroy
	rescue => e
		event.respond("Bot not in voice channel (Probably)")
	end
	#Be quiet
	nil
end
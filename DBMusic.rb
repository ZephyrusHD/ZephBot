require_relative 'DBCommon'


@bot.command( :meme, description: "Play a meme from the master meme database", usage: "meme <song_name>|list")	do |event, song|
	if song == nil
		event.respond("Please provide a song, or list!")
	else
		#make sure song name is lowercase
		song.downcase!()

		begin
			#connect bot to command issuer's voice channel
			@bot.voice_connect(event.user.voice_channel.id)
			voice_bot = event.voice
			voice_bot.volume = 0.1

			songArray = Dir["songs/*.mp3"]

			songArray.each do |value|
				if value.include? (song)
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
				event.respond("Song Stopped")
			else
				event.respond(e)
				event.respond("w0t")
			end
		end

	end

	nil
end


@bot.command :volume do |event, vol|
	voice_bot = event.voice
	voice_bot.volume = vol.to_f
	nil
end


@bot.command :stop do |event|
	voice_bot = event.voice
	voice_bot.stop_playing
	nil
end

@bot.command :leave do |event|
	begin
		voice_bot = event.voice
		voice_bot.destroy
	rescue => e
		event.respond("Error: Bot not in voice channel")
	end
	nil
end
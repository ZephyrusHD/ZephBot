require_relative 'DBCommon'

require 'youtube-dl'

#Global options
DOWNLOAD_OPTIONS = {
	extract_audio: true,
	audio_format: 'mp3',
	format: :bestaudio
}



#Song Command
@bot.command([:meme, :song], description: "Play a meme from the master meme database", 
	usage: "meme <song_name>")	do |event, song, name, *saveas|
	@logger.debug event.user.name + " :meme " + song.to_s
	if song == nil
		event.respond("Please provide a song, or run ```meme list```")
	else
		song.downcase!()
		begin		
			#Create array of every .mp3 in the songs dir
			#songArray = Dir["songs/*.mp3"]
			songArray = Dir["songs/*.mp3"]

			case song
				when "play"
					#Check if song == something in songArray
					#There has to be better way to do this?
					songArray.each do |value|
						if value.include? (name)
							#connect bot to command issuer's voice channel
							@bot.voice_connect(event.user.voice_channel.id)
							voice_bot = event.voice

							#Set volume to something resonable and play file
							voice_bot.volume = 0.1
							voice_bot.play_file(value)
							return 
						end
					end
					#This point will only be reached if name wasn't in songArray
					event.respond("Sorry! Couldn't find that song. Try running the list command?")

				when "list"
					event << "»"
					#songArray = Dir["songs/*.mp3"]
					songArray.each do |value|
						value.slice! "songs/"
						value.slice! ".mp3"
						event << value
					end

				when "dl", "download", "get"
					if name == nil
						event.respond("Please provide a song!")
					else
						saveas = saveas.join(" ")
						p saveas
						#pls remember to sanatize input
						if saveas == ""
							event.respond("Please provide a name to save this song as")
						else
							download_options = DOWNLOAD_OPTIONS.clone
							download_options[:output] = "songs/" + saveas + ".mp3"
							vid_id = name
							YoutubeDL.download("https://www.youtube.com/watch?v=" + vid_id, download_options)
							event.respond("Song Download complete. Saved as " + saveas)
						end
					end

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


#===================================================================#
#                    YOUTUBE MUSIC PLAYER SECTION					#
# Credit to PoVa/sapphire_bot for helping me figure out what to do! #
#===================================================================#



@bot.command(:songdl ) do |event, song, name|
@logger.debug event.user.name + " :song " + song.to_s + " " + name.to_s
	if song == nil
		nil
	else

	end
end
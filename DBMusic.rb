
#===================================================================#
#                    YOUTUBE MUSIC PLAYER SECTION					#
# Credit to PoVa/sapphire_bot for helping me figure out what to do! #
#===================================================================#



require_relative 'DBCommon'

require 'youtube-dl'

#Global options
DOWNLOAD_OPTIONS = {
	extract_audio: true,
	audio_format: 'mp3',
	format: :bestaudio
}

songArray = Dir["songs/*.mp3"]

#Song Command
@bot.command([:meme, :song], description: "Play a song!", 
	usage: "song <command> <url> <name>")	do |event, song, name, saveas|
	@logger.debug event.user.name + " :song " + song.to_s + " " + name + " " + saveas.to_s
	if song == nil
		event.respond("Please provide a song, or run ```song list```")
	else
		song.downcase!()
		begin		
			#Update array of every .mp3 in the songs dir
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

							#voice_bot.adjust_average = true
							#voice_bot.adjust_debug = false
							#voice_bot.adjust_interval = 2	#2
							#voice_bot.adjust_offset = 1		#1

							#voice_bot.length_override = 20		#1
							voice_bot.volume = 0.1
							
							#voice_bot.play_io(open(value))
							

							#Set volume to something resonable and play file
							#voice_bot.volume = 0.0
							voice_bot.play_dca("songs/BlocParty.dca")
							#voice_bot.play_file("songs/nyancat.mp3")
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
						#pls remember to sanatize input
						if saveas == nil
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
				@logger.error e
			elsif e.message.include?("unexpected return")
				#Let song end quietly
				nil
			else
				@logger.error e
				event.respond("w0t")
			end
		end

	end

	nil
end


#Queue Command
@bot.command(:queue) do |event, action, song|
	@logger.debug event.user.name + " :queue " + action + " " + song
	#queueFile = File.open("queue.txt", )
	if action == nil
		event.respond("Please provide an action")
	else
		case action
			when "list"
				event << "»"
				File.readlines("queue.txt").each do |line|
					line.slice!("\n")
					event << line
				end
				nil

			when "clear" #Just del file
				event.respond("Queue cleared")
				queueFile = File.open("queue.txt", "r+")
					queueFile.close

			when "add"
				if song == nil
					event.respond("Please provide a song!")
				else
					songArray.each do |value|
						if value.include? (song)
							queueFile = File.open("queue.txt", "a")
							queueFile.syswrite(song + "\n")
							queueFile.close
							event.respond(song + " added to queue")
							return
						end
					end
					event.respond("Couldn't add to queue")


				end

			when "remove"
				event.respond("Song removed")
				queueFile = File.open("queue.txt", "r+")
					queueFile.close

		end
	end


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

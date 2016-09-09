require_relative 'DBCommon'

::RBNACL_LIBSODIUM_GEM_LIB_PATH = "libsodium.dll"



@bot.command :voice	do |event|
	bot.voice_connect(event.user.voice_channel.id)
	voice_bot = event.voice
	voice_bot.volume = 0.1
	voice_bot.play_file("songs/nyan.mp3")
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
end
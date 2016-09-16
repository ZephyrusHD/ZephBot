require_relative 'DBCommon'
require 'open-uri'
require 'json'
require 'redd'

@w = Redd.it(:script, $CONFIG['redid'], $CONFIG['redsec'], $CONFIG['redditUN'], $CONFIG['redditPW'], user_agent: $CONFIG['useragent'])

def doReddit()
	#Do on a new thread
	Thread.new{
		string = $CONFIG['redjson']
		cancer = open(string, 'User-Agent' => $CONFIG['useragent']).read
		json = JSON.parse(open(string, 'User-Agent' => $CONFIG['useragent']).read)

		
		@w.authorize!

		#@logger.info("Collect $200")

		x = 0
		y = 1
		begin

		while x < y
			newjson = json['data']['children'][x]

			if newjson != nil
				@bot.channel(225517579496718336).send_message("@Owner»\n" + "New Messgae from: " + newjson['data']['author'].to_s + "\n" + "Subject: " + newjson['data']['subject'].to_s + "\n" + newjson['data']['body'].to_s)
				y = y + 1
			end


			x = x + 1
		end

		if x == y
			@w.read_all_messages
			#@logger.info("All Reddit messages read.")
		end

		rescue => e
			event.debug(e)
		end
	}
end



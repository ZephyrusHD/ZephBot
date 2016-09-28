require_relative 'DBCommon'
require 'RubyMinecraft'

/* @ranks is an instance hash of the ranks used by RRR
it is used to determine the current rank a player should be. */
@ranks = { 
	/* Base Ranks */
	"Wood" 		=>	 "0"	, #0		
	"Stone" 	=> 	"10"	, #10		
	"Iron" 		=> 	"20"	, #10		
	"Bronze" 	=> 	"40" 	, #20	
	"Silver"	=> 	"60" 	, #20	
	"Gold" 		=>  "90" 	, #30	
	"Redstone" 	=>  "120" 	, #30	
	"Diamond" 	=>  "160" 	, #40	
	"Obsidian" 	=>  "200" 	, #40	
	"Bedrock" 	=>  "250" 	, #50	
	
	/* First Prestige */
	"Wood+"		=>	"300"	, #50	
	"Stone+"	=>	"320"	, #20	
	"Iron+"		=>	"340"	, #20	
	"Bronze+"	=>	"370"	, #30	
	"Silver+"	=>	"400"	, #30	
	"Gold+"		=>	"440"	, #40	
	"Redstone+"	=>	"480"	, #40	
	"Diamond+"	=>	"530"	, #50	
	"Obsidian+"	=>	"580"	, #50	
	"Bedrock+"	=>	"640"	, #60	
	
	/* Second Prestige */
	"Wood++"	=>	"700"	, #60	
	"Stone++"	=>	"730"	, #30	
	"Iron++"	=>	"760"	, #30	
	"Bronze++"	=>	"800"	, #40	
	"Silver++"	=>	"840"	, #40	
	"Gold++"	=>	"890"	, #50	
	"Redstone++"=>	"930"	, #50	
	"Diamond++"	=>	"990"	, #60	
	"Obsidian++"=>	"1050"	, #60	
	"Bedrock++"	=>	"1120"	, #70	
	
	/* Third Prestige */
	"Wood+++"	=>	"1190"	, #70	
	"Stone+++"	=>	"1230"	, #40	
	"Iron+++"	=>	"1270"	, #40	
	"Bronze+++"	=>	"1320"	, #50	
	"Silver+++"	=>	"1370"	, #50	
	"Gold+++"	=>	"1430"	, #60	
	"Redstone+++"=>	"1490"	, #60	
	"Diamond+++"=>	"1560"	, #70	
	"Obsidian+++"=>	"1630"	, #70	
	"Bedrock+++"=>	"1710"	  #80	


}

# Ran when ranks need to be updated
def doRanks()

	Thread.new{
		begin
		
		# Minecraft.new(Server IP as string, RCON port);
		rcon = RCON::Minecraft.new("rr3.re-renderreality.net", 25576);
		rcon.auth($CONFIG['rconpass'])
		
		# Query the database for player play times
		time_players = @db.execute("SELECT TIMEPLAYED, MCUN FROM players")
		
		# Cycle through every player checking time played
		time_players.each do |seconds, user|
		
			# x = hours player has played
			x = (seconds / 3600.0)
			
			new_rank = nil
			
			/*  If player's hours played is less than the current
				rank being checked, move on to the next once
				we find a rank where they have more hours then the rank
				requires, set new_rank to the rank they have more hours than */
			catch :exit do
				@ranks.each do |rank, hrs|
					if x < hrs.to_f
						throw :exit if true
					elsif
						new_rank = rank
					end
				end
			end
			
			# Gets the current rank of the player and then formats it properly
			old_rank = @db.execute("SELECT RANK FROM players WHERE MCUN = ?", [user])
			old_rank = old_rank.join("")
			old_rank.delete!("[[\"")
			old_rank.delete!("\"]]")

			# Inputs staff list and converts it to a JSON object.
			file = File.read('staff.json')
			staff = JSON.parse(file)
			
			# Check if player is not staff.
			if staff['Staff'].include?(user)
				nil
			else
				/* If the rank that the player's play time coresponds to is not their current rank,
				set their current rank in the database and on the server to the new rank we determined above. */
				if old_rank.to_s != new_rank.to_s
					# Sets the new rank in the database
					@db.execute("UPDATE players SET RANK = ? WHERE MCUN = ?", [new_rank,user])
					# Sets the new rank on the server
					rcon.command("p user " + user.to_s + " group set " + new_rank.to_s)
					# Print the rank change to the debug console
					p "p user " + user.to_s + " group set " + new_rank.to_s
				end
			end
		end
		nil
	# Catches errors and prints them to the debug console
	rescue => e 
		p e
	end
	}
end
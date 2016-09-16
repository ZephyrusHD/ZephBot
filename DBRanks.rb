require_relative 'DBCommon'
require 'RubyMinecraft'

@ranks = { 

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

def doRanks()

	Thread.new{
		begin
		rcon = RCON::Minecraft.new("rr3.re-renderreality.net", 25576);
		rcon.auth($CONFIG['rconpass'])

		time_players = @db.execute("SELECT TIMEPLAYED, MCUN FROM players")
		time_players.each do |seconds, user|

			x = (seconds / 3600.0)
			new_rank = nil

			catch :exit do
				@ranks.each do |rank, hrs|
					if x < hrs.to_f
						throw :exit if true
					elsif
						new_rank = rank
					end
				end
			end
			old_rank = @db.execute("SELECT RANK FROM players WHERE MCUN = ?", [user])

			old_rank = old_rank.join("")
			old_rank.delete!("[[\"")
			old_rank.delete!("\"]]")

			file = File.read('staff.json')
			staff = JSON.parse(file)
			
			#check for not staff
			if staff['Staff'].include?(user)
				nil
			else
				if old_rank.to_s != new_rank.to_s
					@db.execute("UPDATE players SET RANK = ? WHERE MCUN = ?", [new_rank,user])
					rcon.command("p user " + user.to_s + " group set " + new_rank.to_s)
					p "p user " + user.to_s + " group set " + new_rank.to_s
				end
			end
		end
		nil
	rescue => e 
		p e
	end
	}
end
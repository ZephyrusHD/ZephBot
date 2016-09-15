require_relative 'DBCommon'

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
	"Obsidian++"=>	"1500"	, #60	
	"Bedrock++"	=>	"1570"	  #70	


}

p @ranks
def doRanks()
	begin
	Thread.new{

		#Get EVERY player from sql 
		x = 45#hours <=
		new_rank = nil
		p "Got to doRanks"
		catch :exit do
			p "In Catch"
			@ranks.each do |rank, hrs|s
				if x < hrs
					new_rank = rank
					p new_rank.to_s
					throw :exit
				end
				p "Not correct rank"
			end
		end
		p new_rank.to_s

		

	}
	rescue => e
		p e
	end
end
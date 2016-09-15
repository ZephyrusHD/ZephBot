require_relative 'DBCommon'

def doRanks()
	Thread.new{
		@ranks.each do |key, value|
			event << key.to_s + " | " + value.to_s
		end


		

	}
end
require 'sqlite3'
require 'open-uri'
require 'openssl'



#sqlite3 shit
@db = SQLite3::Database.new "discord.db"
p "SQLite3 Database loaded"


#define function to reset SQLite3 variables bc I suck and idk how else to
def reset_sql_vars()
	$id_SQL 		= nil #DISCORDID
	$un_SQL 		= nil #DISCORDUN
	$mc_SQL 		= nil #MCUN
	$steam_SQL 		= nil #STEAMID
	$blizz_SQL 		= nil #BLIZZID
	$lol_SQL  		= nil #LOLID
	nil
end
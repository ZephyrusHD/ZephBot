require_relative 'DBCommon'
require 'gmail'

def doGmail()
	Thread.new{
		gmail = Gmail.new($CONFIG['gmail'], $CONFIG['gmailpw'])
		new_emails = gmail.inbox.count(:unread, :from => "notify@google.com")

		if new_emails.to_s != "0"
			@bot.channel(225517579496718336).send_message("<@117329036996378628> New response on Google Docs!")
			gmail.inbox.emails(:unread, :from => "notify@google.com").each do |email|
				email.mark(:read)
				email.archive!
				@logger.debug("Email read and archived!")
			end
		end
		gmail.logout
	}
end
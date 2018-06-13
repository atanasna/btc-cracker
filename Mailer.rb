require 'erb'
require 'pony'

class Mailer
	def initialize()
	end

	def send(to, subject, body)
		Pony.mail({
			:to => to,
			:from => "btc-cracker@aws-vm",
			:subject => subject,
			:body => body,
			:via => :smtp,
			:via_options => {
				:address              => 'smtp.gmail.com',
				:port                 => '587',
				:enable_starttls_auto => true,
				:user_name            => 'venelopy.vivs',
				:password             => '8909240463',
				:authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
				:domain               => "aws-vm" # the HELO domain provided by the client to the server
			}
		})
	end
end
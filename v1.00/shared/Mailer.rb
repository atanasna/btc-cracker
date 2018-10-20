require 'net/smtp'

class Mailer
    def initialize
  
    end

    def send_email(to,opts={})
        opts[:server]      ||= "localhost"
        opts[:from]        ||= "email@example.com"
        opts[:from_alias]  ||= "Example Emailer"
        opts[:subject]     ||= "You need to see this"
        opts[:body]        ||= "Important stuff!"
    
        msg = "From: #{opts[:from_alias]} <#{opts[:from]}>\nTo: <#{to}>\nSubject: #{opts[:subject]}\n\n#{opts[:body]}"

        Net::SMTP.start(opts[:server]) do |smtp|
            smtp.send_message msg, opts[:from], to
        end
    end
end
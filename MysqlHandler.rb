require 'mysql2'

class MysqlHandler
	def initialize
		$client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "passport", :database => 'btc_cracker')	
	end

	def add_account(address,key)
		$client.query("INSERT INTO accounts (acc_address,acc_key,checked) VALUES(\"#{address}\", \"#{key}\",0)")
	end

	def get_first() 
		$client.query("select * from accounts where checked=0 limit 1")
	end
	def delete_first()
		$client.query("delete from accounts where checked=0 limit 1")
	end
end


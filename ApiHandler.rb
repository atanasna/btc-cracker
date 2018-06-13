require 'rest-client'
require 'json'
#3Cbq7aT1tY8kMxWLbitaG7yT6bPbKChq64
class ApiHandler 

	def initialize
	    @url = "http://127.0.0.1:3001/insight-api"
  	end  

	def get_balance(address)
		url = @url+"/addr/"+address
		#\puts url 
		res = JSON.parse(RestClient.get url)
		return res["balance"].to_f
	end

	def get_txs_all(address)
		url = @url+"/addr/"+address 
		return JSON.parse(RestClient.get url)["transactions"]
	end

	def get_txs_out(address)
		txs = get_txs_all(address)
		results = Array.new
		txs.each do |tx|
			url = @url + "/tx/" + tx
			tx_body = JSON.parse(RestClient.get url)
			if tx_body["vin"].to_s.include? address
				results.push tx
			end
		end

		return results
	end

	def get_txs_in(address)
		txs = get_txs_all(address)
		results = Array.new
		txs.each do |tx|
			url = @url + "/tx/" + tx
			tx_body = JSON.parse(RestClient.get url)
			if tx_body["vout"].to_s.include? address
				results.push tx
			end
		end

		return results
	end
end

require 'net/http'
require 'json'
require '../BitcoinWallet.rb'

def create_agent data
    uri = URI('https://jsonplaceholder.typicode.com/todos/1')
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = data.to_json
    res = http.request(req)
    puts "response #{res.body}"
rescue => e
    puts "failed #{e}"
end

wallets = Array.new
wallets.push BitcoinWallet.new "a1","k1"
wallets.push BitcoinWallet.new "a2","k2"
wallets.push BitcoinWallet.new "a3","k3"
wallets.push BitcoinWallet.new "a4","k4"

create_agent wallets
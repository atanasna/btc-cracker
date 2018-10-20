load "../shared/Logging.rb"
load "../shared/Statistics.rb"
load "../shared/TimeDuration.rb"
load "../shared/BitcoinWallet.rb"
require 'json'
require "set"
require 'socket'

class BtcCrackerServer
    include Logging
    include StatisticsServer

    def initialize port,filename
        @port = port
        LOG_SERVER_MAIN.info "Starting in Server Mode [port:#{port}]"
    end

    def start
        server = TCPServer.open("",@port)

        thr = Thread.new do
            while true
                client = server.accept
                data = JSON.parse(client.gets)
                if data["type"] == "wallet"
                    wallet_data = data["wallet"]
                    wallet = BitcoinWallet.new wallet_data["address"], wallet_data["key"], wallet_data["empty"]
                end
                if data["type"] == "type"
                end 
                
                STATISTICS_SERVER.nonempty_wallets.push Hash[:addr, wallet.address, :key, wallet.key] 
            end
        end
        
        while true do
            if thr.status != "run" and thr.status != "sleep"
                puts "ERROR: The main Process is in status: #{thr.status}"
                break           
            end
            print_server_stats
            sleep(0.2)
        end
    end
end

p = BtcCrackerServer.new 52000,"btc-dormand-accs.txt"
p.start
load "../shared/Logging.rb"
load "../shared/Statistics.rb"
load "../shared/TimeDuration.rb"
load "../shared/BitcoinWallet.rb"
require 'json'
require "set"
require 'socket'

class BtcCrackerServer
    include Logging
    include Statistics

    def initialize port,filename
        @port = port
        LOG_SERVER_MAIN.info "Starting in Server Mode [port:#{port}]"
    
        @dormant_addresses = SortedSet.new
        open(filename).each do |line|
            @dormant_addresses.add line.strip
        end
    end

    def start
        server = TCPServer.open("",@port)

        thr = Thread.new do
            while true
                client = server.accept
                data = JSON.parse(client.gets)
                STATISTICS_SERVER.received_wallets_cnt += data.size       
                data.each do |wallet_json|
                    wallet = BitcoinWallet.new wallet_json["address"], wallet_json["key"]
                    if @dormant_addresses.include?(wallet.address)
                        #puts "#{addr}, #{key}"
                        LOG_SERVER_MAIN.info "YEEEAH - addr:#{wallet.address} | key:#{wallet.key}"
                        LOG_RESULTS.info "YEEEAH - addr:#{wallet.address} | key:#{wallet.key}"
                        STATISTICS_SERVER.nonempty_wallets.push Hash[:addr, wallet.address, :key, wallet.key]
                        STATISTICS_SERVER.nonempty_wallets_cnt +=1
                    end
                    STATISTICS_SERVER.checked_wallets_cnt += 1
                end
            end
        end
        
        while true do
            if thr.status != "run" and thr.status != "sleep"
                puts "ERROR: The main Process is in status: #{thr.status}"
                break           
            end
            write_server_statistics
            sleep(0.2)
        end
    end
end

p = BtcCrackerServer.new 52000,"btc-dormand-accs.txt"
p.start
load "../shared/Logging.rb"
load "../shared/Statistics.rb"
load "../shared/TimeDuration.rb"
load "../shared/BitcoinWallet.rb"
#load "../shared/BtcCrackerClientStatisticsMock.rb"
load "BitcoinAddrGenerator.rb"
require 'net/http'
require 'socket'
require "set"
require 'json'

class BtcCrackerClient
    include Logging
    include StatisticsClient

    def initialize filename, host, port
        @id = rand(1000000)
        @host = host
        @port = port
        @filename = filename

        @btc_wallet_gen = BitcoinAddressGenerator.new

        @dormant_addresses = SortedSet.new
        open(filename).each do |line|
            @dormant_addresses.add line.strip
        end

        LOG_CLIENT_MAIN.info "Starting in Client Mode [host:#{host}, port:#{port}]"
    end

    def start threads_num
        #Thread for generating and checking addresses
        threads_num.times do
            Thread.new do
                while true do

                    wallet = @btc_wallet_gen.generate_wallet
                    #checker
                    #if STATISTICS_CLIENT.generated_wallets_cnt % 18000 ==0
                    #    wallet = BitcoinWallet.new "114ghYuRAqBvpCfjKAMp8KvQ9kLrQP7yEv", "nasko"
                    #end

                    STATISTICS_CLIENT.generated_wallets_cnt +=1
                    check_wallet_balance wallet
                    if wallet.empty == false
                        
                        LOG_CLIENT_MAIN.info "YEEEAH - addr:#{wallet.address} | key:#{wallet.key}"
                        LOG_RESULTS.info "YEEEAH - addr:#{wallet.address} | key:#{wallet.key}"
                        STATISTICS_CLIENT.nonempty_wallets.push Hash[:addr, wallet.address, :key, wallet.key]
                        send_wallet wallet
                    end
                end
            end
        end
        #Thread for sending the statisics to the server
        Thread.new do
            send_stats
            sleep(5)
        end

        #Printing the stats
        while true do
            STATISTICS_CLIENT.running_threads = Thread.list.length - 1
            print_client_stats
            #send_stats
            sleep(0.2)
        end
    end

    private
    def check_wallet_balance wallet
        if @dormant_addresses.include?(wallet.address)
            #puts "#{addr}, #{key}"
            wallet.empty = false
        end
    end
    
    def send_wallet wallet
        begin
            s = TCPSocket.open(@host, @port)
            request = "{\"type\":\"wallet\", \"wallet\":#{wallet.to_json}}"
            s.print(request)
            s.close
            #STATISTICS_CLIENT.sent_wallets_cnt += 1
        ensure
            LOG_CLIENT_MAIN.error "Something went wrong when sending the wallet to server #{@host}:#{@port}"
        end
    end
    
    def send_stats 
        stats = BtcCrackerClientStatisticsMock.new @id, STATISTICS_CLIENT.time_start, STATISTICS_CLIENT.time_elapsed, STATISTICS_CLIENT.running_threads, STATISTICS_CLIENT.generated_wallets_cnt, STATISTICS_CLIENT.wallets_per_second, STATISTICS_CLIENT.nonempty_wallets.lenght
        
        begin
            s = TCPSocket.open(@host, @port)
            request = "{\"type\":\"stats\", \"stats\":#{stats.to_json}}"
            s.print(request)
            s.close
        ensure
            LOG_CLIENT_MAIN.error "Something went wrong when sending the statistics to server #{@host}:#{@port}"
        end
    end
end

client = BtcCrackerClient.new "../shared/btc-dormand-accs.txt", "127.0.0.1", 52000
client.start(5)
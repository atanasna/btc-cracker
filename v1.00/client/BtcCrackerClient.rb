load "../shared/Logging.rb"
load "../shared/Statistics.rb"
load "../shared/TimeDuration.rb"
load "../shared/BitcoinWallet.rb"
load "BitcoinAddrGenerator.rb"
require 'net/http'
require 'socket'
require 'json'

class BtcCrackerClient
    include Logging
    include Statistics

    def initialize host, port, batch_size
        @host = host
        @port = port
        @batch_size = batch_size
        LOG_CLIENT_MAIN.info "Starting in Client Mode [host:#{host}, port:#{port}, batch_size:#{batch_size}]"
    end

    def start threads_num
        threads_num.times do
            Thread.new do
                wallets = Array.new
                btc_wallet_generator = BitcoinAddressGenerator.new
                while true do 
                    wallets.push btc_wallet_generator.generate_wallet
                    # checker
                    #if STATISTICS_CLIENT.generated_wallets_cnt % 18000 == 0
                    #    wallets.push BitcoinWallet.new "1ENLWfW8jjQRWAyX4Qs3ZuLeyksEgjC8tW","nasko#{rand(12000)}"
                    #end
                    STATISTICS_CLIENT.generated_wallets_cnt +=1

                    if wallets.size == @batch_size
                        send_wallets wallets
                        STATISTICS_CLIENT.sent_wallets_cnt += wallets.size
                        wallets = Array.new
                    end
                end
            end
        end

        while true do
            STATISTICS_CLIENT.running_threads = Thread.list.length - 1
            write_client_statistics
            sleep(0.2)
        end
    end

    private
    def send_wallets wallets
        s = TCPSocket.open(@host, @port)
        request = wallets.to_json
        s.print(request)
        s.close
    end
end

client = BtcCrackerClient.new "127.0.0.1", 52000, 100
client.start(10)
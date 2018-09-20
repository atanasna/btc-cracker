load "Logging.rb"
load "Statistics.rb"
load "BitcoinAddrCracker.rb"

class Program
    include Logging
    include Statistics

    def initialize
        @bitcoin_cracker = BitcoinAddrCracker.new
        LOG_MAIN.info "Starting the Program"
    end

    def start
        @bitcoin_cracker.bruteforce_from_file_threaded("btc-dormand-accs.txt", 1)
        while true do
            write_statistics
            sleep(0.2)
        end
    end
end

p = Program.new
p.start
require "set"

load "BitcoinAddrGenerator.rb"
load "helpers/TimeDuration.rb"
load "helpers/Logging.rb"
load "helpers/Statistics.rb"

class BitcoinAddrCracker
    include Logging
    include Statistics
    
	def initialize
        @gen = BitcoinAddressGenerator.new
	end

    def bruteforce_from_file(filename)
        dormant_wallets = SortedSet.new
        open(filename).each do |line|
            dormant_wallets.add line.strip
        end

        while true do  
            wallet = BitcoinWallet.new @gen.get_public_key.strip,@gen.get_private_key
            if dormant_wallets.include?(addr)
                #puts "#{addr}, #{key}"
                LOG_MAIN.info "YEEEAH - addr:#{addr} | key:#{key}"
                LOG_RESULTS.info "YEEEAH - addr:#{addr} | key:#{key}"
                STATISTICS.nonempty_wallets.push Hash[:addr, addr, :key, key]
                STATISTICS.nonempty_wallets_cnt +=1
            end
            STATISTICS.checked_wallets_cnt += 1
        end
    end

	def bruteforce_all
		while true do
            addr,key = generate_address
            balance = $api.get_balance(addr)

            if balance != 0
                LOG_MAIN.info "YEEEAH - addr:#{addr} | key:#{key} | balance:#{balance}"
                LOG_RESULTS.info "YEEEAH - addr:#{addr} | key:#{key} | balance:#{balance}"
                STATISTICS.nonempty_wallets.push Hash[:addr, addr, :key, key]
                STATISTICS.nonempty_wallets_cnt +=1
            end  
            STATISTICS.checked_wallets_cnt += 1
		end
	end

    def bruteforce_from_file_threaded(addresses_filename, threads_number)
        treads = Array.new
        threads_number.times do
            treads.push Thread.new {bruteforce_from_file(addresses_filename)}
        end
    end

    def bruteforce_all_threaded(threads_number)
        treads = Array.new
        threads_number.times do
            treads.push Thread.new {bruteforce_all}
        end
    end
end

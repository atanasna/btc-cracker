require "set"

load "BitcoinAddrGenerator.rb"
load "TimeDuration.rb"
load "ApiHandler.rb"
load "Logging.rb"
load "Statistics.rb"

class BitcoinAddrCracker
    include Logging
    include Statistics
    
	def initialize
        @gen = BitcoinAddressGenerator.new
        @api = ApiHandler.new
	end

    def generate_address
        @gen.generate_address
        addr = @gen.get_public_key.strip
        key = @gen.get_private_key
        return addr,key
    end

    def check_balances
        i = 0
        open('myfile.out', 'a') do |f|
            $dormant_wallets.each do |addr|
                begin
                    balance = $api.get_balance(addr)
                    if balance > 0.1
                        puts "#{i}: addr:#{addr} | balance:#{balance}"
                        f << "#{i}: addr:#{addr} | balance:#{balance}\n"
                    end
                    i+=1
                rescue
                    puts "Problem with #{addr}"
                end
            end
        end
    end

    def bruteforce_from_file(filename)
        dormant_wallets = SortedSet.new
        open(filename).each do |line|
            dormant_wallets.add line.strip
        end

        while true do  
            addr,key = generate_address

            if dormant_wallets.include?(addr)
                puts "#{addr}, #{key}"
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

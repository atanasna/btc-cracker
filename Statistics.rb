module Statistics
    STATISTICS = Struct.new(
        :time_start,
        :time_elapsed,
        :wallets_per_second,
        :seconds_per_wallet,
        :checked_wallets_cnt,
        :nonempty_wallets_cnt,
        :nonempty_wallets
    ).new(Time.now,0.0,0.0,0.0,0,0,Array.new)

    private
    def write_statistics
        update_statistics
        system("clear")
        puts "------------ Statistics: General ------------"
        puts "Starting Time:".ljust(18) + "#{STATISTICS.time_start}".bold
        puts "Running Time:".ljust(18) + "#{STATISTICS.time_elapsed}".bold
        puts ""
        puts "------------ Statistics: Wallets ------------"
        puts "Wallets/second:".ljust(28) + "#{STATISTICS.wallets_per_second.round(2)}".bold
        puts "Seconds/wallet:".ljust(28) + "#{STATISTICS.seconds_per_wallet.round(2)*1000}".bold + "ms"
        puts "Checked wallets count:".ljust(28) + "#{STATISTICS.checked_wallets_cnt}".yellow.bold
        puts "Non-Empty wallets count:".ljust(28) + "#{STATISTICS.nonempty_wallets_cnt}".green.bold
        puts "Non-Empty wallets:".ljust(28) + "#{STATISTICS.nonempty_wallets}".bold
    end

    def update_statistics
        time_elapsed = TimeDuration.new((Time.now - STATISTICS.time_start)*1000)
        time_elapsed_formated = time_elapsed.format("d:h:m:s")
        STATISTICS.time_elapsed = "#{time_elapsed_formated[0]}d #{time_elapsed_formated[1]}h #{time_elapsed_formated[2]}m #{time_elapsed_formated[3]}s"

        STATISTICS.wallets_per_second = STATISTICS.checked_wallets_cnt/(time_elapsed.raw)
        STATISTICS.seconds_per_wallet = 1/(STATISTICS.wallets_per_second)
    end
end
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

    STATISTICS_SERVER = Struct.new(
        :time_start,
        :time_elapsed,
        :received_wallets_cnt,
        :checked_wallets_cnt,
        :wallets_per_second,
        :nonempty_wallets_cnt,
        :nonempty_wallets
    ).new(Time.now,0.0,0.0,0.0,0,0,Array.new)

    STATISTICS_CLIENT = Struct.new(
        :time_start,
        :time_elapsed,
        :generated_wallets_cnt,
        :sent_wallets_cnt,
        :wallets_per_second,
    ).new(Time.now,0.0,0.0,0.0)

    private


    def write_server_statistics
        update_server_statistics
        system("clear")
        puts "============== SERVER MODE =================="
        puts "------------ Statistics: General ------------"
        puts "Starting Time:".ljust(18) + "#{STATISTICS_SERVER.time_start}".bold
        puts "Running Time:".ljust(18) + "#{STATISTICS_SERVER.time_elapsed}".bold
        puts ""
        puts "------------ Statistics: Wallets ------------"
        puts "Received wallets count:".ljust(28) + "#{STATISTICS_SERVER.received_wallets_cnt}".yellow
        puts "Checked wallets count:".ljust(28) + "#{STATISTICS_SERVER.checked_wallets_cnt}".yellow.bold
        puts "Wallets/second:".ljust(28) + "#{STATISTICS_SERVER.wallets_per_second.round(2)}".bold
        
        puts "Non-Empty wallets count:".ljust(28) + "#{STATISTICS_SERVER.nonempty_wallets_cnt}".green.bold
        puts "Non-Empty wallets:".ljust(28) + "#{STATISTICS_SERVER.nonempty_wallets}".bold
    end

    def update_server_statistics
        time_elapsed = TimeDuration.new((Time.now - STATISTICS_SERVER.time_start)*1000)
        time_elapsed_formated = time_elapsed.format("d:h:m:s")
        STATISTICS_SERVER.time_elapsed = "#{time_elapsed_formated[0]}d #{time_elapsed_formated[1]}h #{time_elapsed_formated[2]}m #{time_elapsed_formated[3]}s"

        STATISTICS_SERVER.wallets_per_second = STATISTICS_SERVER.checked_wallets_cnt/(time_elapsed.raw)
    end


    def write_client_statistics
        update_client_statistics
        system("clear")
        puts "=============== CLIENT MODE ================="
        puts "------------ Statistics: General ------------"
        puts "Starting Time:".ljust(18) + "#{STATISTICS_CLIENT.time_start}".bold
        puts "Running Time:".ljust(18) + "#{STATISTICS_CLIENT.time_elapsed}".bold
        puts ""
        puts "------------ Statistics: Wallets ------------"
        puts "Generated Wallets:".ljust(28) + "#{STATISTICS_CLIENT.generated_wallets_cnt}".yellow.bold
        puts "Sent Wallets:".ljust(28) + "#{STATISTICS_CLIENT.sent_wallets_cnt}".green.bold
        puts "Wallets/second:".ljust(28) + "#{STATISTICS_CLIENT.wallets_per_second.round(2)}".bold
    end


    def update_client_statistics
        time_elapsed = TimeDuration.new((Time.now - STATISTICS_CLIENT.time_start)*1000)
        time_elapsed_formated = time_elapsed.format("d:h:m:s")
        STATISTICS_CLIENT.time_elapsed = "#{time_elapsed_formated[0]}d #{time_elapsed_formated[1]}h #{time_elapsed_formated[2]}m #{time_elapsed_formated[3]}s"

        STATISTICS_CLIENT.wallets_per_second = STATISTICS_CLIENT.generated_wallets_cnt/(time_elapsed.raw)
    end
end
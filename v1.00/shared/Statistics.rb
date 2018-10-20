module StatisticsServer
    STATISTICS_SERVER = Struct.new(
        :time_start,
        :time_elapsed,
        :nonempty_wallets_cnt,
        :nonempty_wallets
    ).new(Time.now,0.0,0,Array.new)

    private
    def print_server_stats
        update_server_stats
        system("clear")
        puts "============== SERVER MODE =================="
        puts "------------ Statistics: General ------------"
        puts "Starting Time:".ljust(18) + "#{STATISTICS_SERVER.time_start}".bold
        puts "Running Time:".ljust(18) + "#{STATISTICS_SERVER.time_elapsed}".bold
        puts ""
        puts "------------ Statistics: Wallets ------------"
        puts "Non-Empty wallets count:".ljust(28) + "#{STATISTICS_SERVER.nonempty_wallets_cnt}".green.bold
        puts "Non-Empty wallets:".ljust(28) + "#{STATISTICS_SERVER.nonempty_wallets}".bold
    end

    def update_server_stats
        time_elapsed = TimeDuration.new((Time.now - STATISTICS_SERVER.time_start)*1000)
        time_elapsed_formated = time_elapsed.format("d:h:m:s")
        STATISTICS_SERVER.time_elapsed = "#{time_elapsed_formated[0]}d #{time_elapsed_formated[1]}h #{time_elapsed_formated[2]}m #{time_elapsed_formated[3]}s"
        STATISTICS_SERVER.nonempty_wallets_cnt = STATISTICS_SERVER.nonempty_wallets.size
    end
end

module StatisticsClient
    STATISTICS_CLIENT = Struct.new(
        :time_start,
        :time_elapsed,
        :running_threads,
        :generated_wallets_cnt,
        :wallets_per_second,
        :nonempty_wallets
    ).new(Time.now,0.0,0,0,0.0,Array.new)

    private
    def print_client_stats
        update_client_stats
        system("clear")
        puts "=============== CLIENT MODE ================="
        puts "------------ Statistics: General ------------"
        puts "Starting Time:".ljust(18) + "#{STATISTICS_CLIENT.time_start}".bold
        puts "Running Time:".ljust(18) + "#{STATISTICS_CLIENT.time_elapsed}".bold
        puts "Running Threads:".ljust(18) + "#{STATISTICS_CLIENT.running_threads}".bold
        puts ""
        puts "------------ Statistics: Wallets ------------"
        puts "Generated Wallets:".ljust(28) + "#{STATISTICS_CLIENT.generated_wallets_cnt}".yellow.bold
        puts "Wallets/second:".ljust(28) + "#{STATISTICS_CLIENT.wallets_per_second.round(2)}".bold
        puts "Non-Empty wallets:".ljust(28) + "#{STATISTICS_CLIENT.nonempty_wallets}".bold
    end

    def update_client_stats
        time_elapsed = TimeDuration.new((Time.now - STATISTICS_CLIENT.time_start)*1000)
        time_elapsed_formated = time_elapsed.format("d:h:m:s")
        STATISTICS_CLIENT.time_elapsed = "#{time_elapsed_formated[0]}d #{time_elapsed_formated[1]}h #{time_elapsed_formated[2]}m #{time_elapsed_formated[3]}s"
        STATISTICS_CLIENT.wallets_per_second = STATISTICS_CLIENT.generated_wallets_cnt/(time_elapsed.raw)
    end
end
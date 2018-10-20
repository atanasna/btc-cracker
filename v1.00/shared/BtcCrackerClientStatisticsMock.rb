class BtcCrackerClientStatisticsMock
    attr_accessor time_elapsed, generated_wallets_cnt, wallets_per_second, nonempty_wallets

    def initialize id, time_start, time_elapsed, running_threads, generated_wallets_cnt, wallets_per_second, nonempty_wallets_cnt
        @id = id
        @time_start = time_start
        @time_elapsed = time_elapsed
        @running_threads = running_threads
        @generated_wallets_cnt = generated_wallets_cnt
        @wallets_per_second = wallets_per_second
        @nonempty_wallets_cnt = nonempty_wallets_cnt
    end

    def to_json(*args)
        {
            "id" => @id, 
            "time_start" => @time_start, 
            "time_elapsed" => @time_elapsed,
            "running_threads" => @running_threads,
            "generated_wallets_cnt" => @generated_wallets_cnt,
            "wallets_per_second" => @wallets_per_second,
            "nonempty_wallets_cnt" => @nonempty_wallets_cnt,
        }.to_json(*args)
    end

    def self.from_json json
        self.new json["id"], 
            json["time_start"], 
            json["time_elapsed"], 
            json["running_threads"],
            json["generated_wallets_cnt"],
            json["wallets_per_second"],
            json["nonempty_wallets_cnt"]
    end
end

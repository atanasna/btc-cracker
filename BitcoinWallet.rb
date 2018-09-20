class BitcoinWallet
    attr_reader :address
    attr_reader :key

    def initialize(address,key)
        @address = address
        @key = key
    end

    def to_json(*args)
        {"address" => @address, "key" => @key}.to_json(*args)
    end

    def self.from_json json
        self.new json["address"], json["key"]
    end
end
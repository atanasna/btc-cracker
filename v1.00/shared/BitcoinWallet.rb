class BitcoinWallet
    attr_reader :address, :key
    attr_accessor :empty

    def initialize(address,key, empty=true)
        @address = address
        @key = key
        @empty = empty
    end

    def to_json(*args)
        {"address" => @address, "key" => @key, "empty" => @empty}.to_json(*args)
    end

    def self.from_json json
        self.new json["address"], json["key"], json["empty"]
    end
end

#wallets = Array.new
#wallets.push BitcoinWallet.new "a1","k1"
#wallets.push BitcoinWallet.new "a2","k2"
#wallets.push BitcoinWallet.new "a3","k3"
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

#wallets = Array.new
#wallets.push BitcoinWallet.new "a1","k1"
#wallets.push BitcoinWallet.new "a2","k2"
#wallets.push BitcoinWallet.new "a3","k3"
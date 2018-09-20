require 'openssl'
load "../shared/BitcoinWallet.rb"

class BitcoinAddressGenerator
	ADDRESS_VERSION = '00'
	PRIV_KEY_VERSION = '80'

	def initialize
		$private_key_hex
		$public_key_hex
		$pub_key_hash
		$public_key
        $private_key
	end

	def generate_address
    	# Bitcoin uses the secpr256k1 curve
		curve = OpenSSL::PKey::EC.new('secp256k1')

		# Now we generate the public and private key together
		curve.generate_key
		$private_key_hex = curve.private_key.to_s(16)
		$public_key_hex = curve.public_key.to_bn.to_s(16)
		$pub_key_hash = public_key_hash($public_key_hex)
		$public_key = generate_address_from_public_key_hash(public_key_hash($public_key_hex))
		$private_key = wif($private_key_hex)
        
	end

    def generate_wallet
        generate_address
        return BitcoinWallet.new $public_key.strip, $private_key.strip
    end

	def generate_address_from_public_key_hash(pub_key_hash)
		pk = ADDRESS_VERSION + pub_key_hash
		encode_base58(pk + checksum(pk))
	end

	def int_to_base58(int_val, leading_zero_bytes=0)
		alpha = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
		base58_val, base = '', alpha.size
		while int_val > 0
		  int_val, remainder = int_val.divmod(base)
		  base58_val = alpha[remainder] + base58_val
		end
		base58_val
	end

	def encode_base58(hex)
		leading_zero_bytes = (hex.match(/^([0]+)/) ? $1 : '').size / 2
		("1"*leading_zero_bytes) + int_to_base58( hex.to_i(16) )
	end

	def checksum(hex)
		sha256(sha256(hex))[0...8]
	end

	# RIPEMD-160 (160 bit) hash
	def rmd160(hex)
		Digest::RMD160.hexdigest([hex].pack("H*"))
	end

	def sha256(hex)
		Digest::SHA256.hexdigest([hex].pack("H*"))
	end

	# Turns public key into the 160 bit public key hash
	def public_key_hash(hex)
		rmd160(sha256(hex))
	end


	def wif(hex)
	  data = PRIV_KEY_VERSION + hex
	  encode_base58(data + checksum(data))
	end
	def get_public_key
		return $public_key
	end

	def get_private_key
		return $private_key
	end
end

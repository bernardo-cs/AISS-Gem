module Aiss

	class CcSignature
		attr_accessor :cert_path_in, :cert_path_out, :nonce_path_in,
		 :nonce_path_out, :nonce_cyphered_path_in, :nonce_cyphered_path_out

		def initialize 
			@cert_path_in = "./files/temp/certs/bern.cert"
			@nonce_cyphered_path_in = "./files/temp/certs/nonce_cyphered_64.txt"
			@nonce_path_in = "./files/temp/certs/nonce.zip"

			@cert_path_out = "./files/temp/certs_out/bern.cert"
			@nonce_path_out = "./files/temp/certs_out/nonce.zip"
			@nonce_cyphered_path_out = "./files/temp/certs_out/nonce_cyphered_64.txt"

			@authenticator_jar_path = "./files/jars/authenticator.jar"
			@authenticator_verifier_jar_path = "./files/jars/authenticator_verifier.jar"
		end

		def call_cc_sign
			out = `java -jar #{@authenticator_jar_path} #{@cert_path_in} #{@nonce_cyphered_path_in} #{@nonce_path_in}`
			while out.match(/malloc: \*\*\* error for object/)
			 	sleep 4
			 	out = `java -jar #{@authenticator_jar_path} #{@cert_path_in} #{@nonce_cyphered_path_in} #{@nonce_path_in}`
			end
			return out
		end

		def call_cc_verify_sign
			puts "verificando assinatura...."
			out = `java -jar #{@authenticator_verifier_jar_path} #{@cert_path_out} #{@nonce_cyphered_path_out} #{@nonce_path_out}`
			while out.match(/malloc: \*\*\* error for object/)
				out = `java -jar #{@authenticator_verifier_jar_path} #{@cert_path_out} #{@nonce_cyphered_path_out} #{@nonce_path_out}`
				sleep 4
			end
			return out
		end

		def clean_up
			File.delete(@cert_path_in) if File.exist?(@cert_path_in)
			File.delete(@nonce_cyphered_path_in) if File.exist?(@nonce_cyphered_path_in)
			File.delete(@nonce_path_in) if File.exist?(@nonce_path_in)

			File.delete(@cert_path_out) if File.exist?(@cert_path_out)
			File.delete(@nonce_path_out) if File.exist?(@nonce_path_out)
			File.delete(@nonce_cyphered_path_out) if File.exist?(@nonce_cyphered_path_out)
		end

	end
end
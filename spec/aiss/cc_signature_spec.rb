require 'spec_helper'

describe Aiss::CcSignature do 
	before :each do 
		@cc_signature = Aiss::CcSignature.new
		@nonce_path = "./files/testes/nonce.txt"
		@cyphered_nonce_path = "./files/testes/nonce_cyphered_64.txt"
		@cert = "./files/testes/bern.cert"

		@cc_signature.cert_path_in = @cert
		@cc_signature.nonce_cyphered_path_in = @cyphered_nonce_path
		@cc_signature.nonce_path_in = @nonce_path
	end

	describe "#call_cc_sign" do
		it 'should create a cert file, nonce and signed nonce file encoded in base 64' do
			File.delete(@cyphered_nonce_path) if File.exist?(@cyphered_nonce_path)
			File.delete(@cert) if File.exist?(@cert)

			@cc_signature.call_cc_sign

			File.exist?(@nonce_path).should be_true
			File.exist?(@cyphered_nonce_path).should be_true
			File.exist?(@cert).should be_true
		end
	end

	describe '#call_cc_verify_sign' do
		before :each do
			File.delete(@cyphered_nonce_path) if File.exist?(@cyphered_nonce_path)
			File.delete(@cert) if File.exist?(@cert)

			@cc_signature.cert_path_out = @cert
			@cc_signature.nonce_cyphered_path_out = @cyphered_nonce_path
			@cc_signature.nonce_path_out = @nonce_path

			@cc_signature.call_cc_sign
		end

		it 'should be able to verify the signatures' do
			@cc_signature.call_cc_verify_sign.should match(/Assinatura verificada com sucesso/)
		end

		after :each do
			File.delete(@cyphered_nonce_path) if File.exist?(@cyphered_nonce_path)
			File.delete(@cert) if File.exist?(@cert)
		end

	end

end
require 'spec_helper'

describe Aiss::MailAiss do
	before :each do
		key = '42#3b%c$dxyT,7a5=+5fUI3fa7352&^:'
	
		@aes = FastAES.new(key)
		@file = "./files/mail_body.txt"
		@mail = Aiss::MailAiss.new	
	end

	describe '#send_mail_aiss' do
		it 'should send an email as the teacher asked us to: cyphered, zipped, in base 64 and with the content signed' do
			@mail.send_mail_aiss 'senhor.seguranca@gmail.com', 'teste derradeiro de aiis', 'ola gostava de saber como te chamas'
			sleep 4
			@mail.convert_aiss_mail(@mail.retrieve_last_mail)[:body].should match(/#{'ola gostava de saber como te chamas'}/)
		end
	end

	describe '#convert_received_emails' do
		it 'should receive a lot of emails and dont screw himself' do
			@mail.send_mail_aiss 'senhor.seguranca@gmail.com', 'teste derradeiro de aiis', 'ola gostava de saber como te chamas'
			sleep 4
			converted_emails = @mail.convert_received_emails
			converted_emails.size.should >= 1
		end
	end
end

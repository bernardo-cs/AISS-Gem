require 'mail'
require 'fast-aes'
require 'base64'

module Aiss
	class MailAiss

		def initialize *args
			case args.size
				when 2
					#setting up email
					@options = { :address              => "smtp.gmail.com",
					            :port                 => 587,
					            :domain               => 'your.host.name',
					            :user_name            => args[0],
					            :password             => args[1],
					            :authentication       => 'plain',
					            :enable_starttls_auto => true  }

					key = '42#3b%c$dxyT,7a5=+5fUI3fa7352&^:'
					@aes = FastAES.new(key)

					options = @options
					Mail.defaults do
					 delivery_method :smtp, options
					 retriever_method :pop3, :address    => "pop.gmail.com",
		              :port       => 995,
		              :user_name  => args[0],
		              :password   => args[1],
		              :enable_ssl => true
					end
					@temp = './files/temp/body.zip'
					@temp_folder = './files/temp/'

				when 0
					#setting up email
					@options = { :address              => "smtp.gmail.com",
					            :port                 => 587,
					            :domain               => 'your.host.name',
					            :user_name            => 'senhor.seguranca@gmail.com',
					            :password             => 'segurancaemprimeirolugarnot',
					            :authentication       => 'plain',
					            :enable_starttls_auto => true  }

					key = '42#3b%c$dxyT,7a5=+5fUI3fa7352&^:'
					@aes = FastAES.new(key)

					options = @options
					Mail.defaults do
					 delivery_method :smtp, options
					 retriever_method :pop3, :address    => "pop.gmail.com",
		              :port       => 995,
		              :user_name  => 'senhor.seguranca@gmail.com',
		              :password   => 'segurancaemprimeirolugarnot',
		              :enable_ssl => true
					end
					@temp = './files/temp/body.zip'
					@temp_folder = './files/temp/'
				else
					error
			end
		end

		#se isto funcionar todos os outros metodos sao apagados
		def send_mail_aiss to,subject,text_body
			mail = Mail.new 
			mail.to = to
	    mail.from = @options[:user_name]
	    mail.subject = subject
	    mail.body = "Ola," + 
	    		"por razoes de seguranca este email so pode ser visto \n" + 
	    		"na ultima versao do tanderbard. \n" + 
	    		"Podes encontra-la aqui: http://goo.gl/1bLTJ \n" +
	    		"\n" +
	    		"Cumprimentos, \n" +
	    		"Equipa AISS - Tecnico Lisboa - Bernardo & Guilherme" +
	    		"\n"

	    time1 = Time.new
	    f = File.new(@temp_folder + 'body_text.txt', 'wb')
	    f.write(text_body + "_:_ " + @options[:user_name]+ "_:_ " + time1.inspect)
	    f.close

	    zipper = Aiss::FastZip.new
	    zipper.quick_zip(@temp_folder + 'body_text.zip', 'body_text.txt', @temp_folder)

	    signer = Aiss::CcSignature.new
	    signer.nonce_path_in = @temp_folder + 'body_text.zip'
	    out = signer.call_cc_sign

	    byte_utils = Aiss::ByteUtils.new
	    mail.header['Aiss-Content'] = byte_utils.file_to_string_cypher_base64 @temp_folder + 'body_text.zip'
	    mail.header['Aiss-Certificate'] = File.read(signer.cert_path_in)
	    mail.header['Aiss-CypheredNonce'] = File.read(signer.nonce_cyphered_path_in)

	    signer.clean_up
	    mail.deliver
		end

		def convert_aiss_mail mail
			signer = Aiss::CcSignature.new
			byte_utils = Aiss::ByteUtils.new
			ziper = Aiss::FastZip.new

			#save files
			zipped_content_string = mail.header['Aiss-Content'].decoded
			puts "--------- aiss conten received com gsub-------"
			p zipped_content_string.gsub!(/=0A/,"\n")
			byte_utils.base64_decypher_string_to_file(zipped_content_string, signer.nonce_path_out)
			
			cert = File.open(signer.cert_path_out,'wb')
			nonce_cyphered = File.open(signer.nonce_cyphered_path_out,'wb')
			cert.write mail.header['Aiss-Certificate']
			nonce_cyphered.write mail.header['Aiss-CypheredNonce']

			cert.close
			nonce_cyphered.close

			out = signer.call_cc_verify_sign
			puts "----passou na verificacao------"
			puts out

			ziper.quick_unzip(signer.nonce_path_out,@temp_folder )
			content = File.read(@temp_folder + 'body_text.txt')
			mail_content = {}
			stuff = content.split("_:_")

			mail_content[:body] = stuff[0]
			mail_content[:signer_email] = stuff[1]
			mail_content[:date]  = stuff[2]
			mail_content[:from] = mail.header[:from].decoded
			mail_content[:to] = mail.header[:to].decoded
			mail_content[:subject] = mail.header[:subject].decoded
			if out.match(/Assinatura verificada com sucesso/) 
				mail_content[:authenticated] = 'true'
			else
				mail_content[:authenticated] = 'false'
			end

			signer.clean_up
			return mail_content
		end

		def convert_received_emails
			mails_converted = []
			retrieve_all_emails.each do |mail|
				converted_mail = {}
				if mail.header['Aiss-Certificate']
					#o mail foi assinado
					converted_mail = convert_aiss_mail(mail)
				else
					converted_mail[:from] = mail.header[:from].decoded
					converted_mail[:to] = mail.header[:to].decoded
					converted_mail[:subject] = mail.header[:subject].decoded
					if (mail.body.multipart?)
						converted_mail[:body] = mail.body.parts[0].decoded
					else
						converted_mail[:body] = mail.body.decoded
					end
				end
				mails_converted << converted_mail
			end
			return mails_converted
		end

		def retrieve_last_mail
			Mail.last
		end

		def retrieve_all_emails
			Mail.all
		end

	end
end
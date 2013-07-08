# coding: utf-8
require 'base64'

module Aiss
	class ByteUtils
		def initialize
			key = '42#3b%c$dxyT,7a5=+5fUI3fa7352&^:'
			@aes = FastAES.new(key)
		end

		def cypher_box ficheiro_input, ficheiro_output
			`./files/c/./cifra -c #{ficheiro_input} #{ficheiro_output}`
		end

		def decypher_box ficheiro_input, ficheiro_output
			`./files/c/./cifra -d #{ficheiro_input} #{ficheiro_output}`
		end

		def convert_file_string in_file_path
			byteArray = File.open(in_file_path,'rb').bytes.to_a
			str = ""
			byteArray.each do |byte|  
				str << byte.chr
			end
			return str
		end

		def convert_string_file in_string, out_file_path
			byteArray = in_string.bytes.to_a
			File.open(out_file_path, 'wb' ) do |output|
     		byteArray.each do | byte |
          output.print byte.chr
     		end
     		#five bytes are lost in the process, zip always end with five 
     		# zero bytes (I hope...)
     		output.print 0x00.chr
     		output.print 0x00.chr
     		output.print 0x00.chr
     		output.print 0x00.chr
     		output.print 0x00.chr
			end

			#para apagar -> abaixo
			puts "---tirado do mail mail.zip bytes-----"
			p File.open(out_file_path,'rb').bytes.to_a

		end

		#Passa um ficheiro para uma string em base 64
		def file_to_string_cypher_base64 in_file_path
			Base64.encode64(@aes.encrypt(self.convert_file_string(in_file_path)))
		end

		#passa uma string de base64 para um ficheiro
		def base64_decypher_string_to_file in_64_string, out_file_path
			self.convert_string_file @aes.decrypt(Base64.decode64(in_64_string)), out_file_path
		end

		#Passa um ficheiro para uma string em base 64, usa caixa do professor
		def file_to_string_cypherbox_base64 in_file_path
			out = './files/temp/cyphered'
			cypher_box(in_file_path,out)
			Base64.encode64(self.convert_file_string(out))

			File.delete(out) if File.exist?(out)
		end

		#passa uma string de base64 para um ficheiro, usa caixa do professor
		def base64_decypherbox_string_to_file in_64_string, out_file_path
			input = './files/temp/cyphered_temp'
			convert_string_file(Base64.decode64(in_64_string),input)
			decypher_box(input,out_file_path)
		end
	end
end
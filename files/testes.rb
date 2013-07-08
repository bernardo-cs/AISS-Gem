require 'base64'
byteArray = File.open("mail_body.zip",'rb').bytes.to_a
puts "---- first byte array-----"
p byteArray
str = ""
byteArray.each do |byte|  
	str << byte.chr
end
puts "---bytearray em string ----"
puts str
str_base64 = Base64.encode64(str)

byteArray = Base64.decode64(str_base64).bytes.to_a
puts "---- second byte array-----"
p byteArray

File.open( 'fia.zip', 'w' ) do |output|
     byteArray.each do | byte |
          output.print byte.chr
     end
end
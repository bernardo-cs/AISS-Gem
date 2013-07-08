puts "----certificado enviado no mail-----"
byteArray = File.open("body_text.zip",'rb').bytes.to_a
p byteArray

puts "----certificado sacado do mail-----"
byteArray = File.open("nonce.zip",'rb').bytes.to_a
p byteArray


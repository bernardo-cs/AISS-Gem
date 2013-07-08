puts "----nonce enviado no mail-----"
byteArray = File.open("nonce_64.txt",'rb').bytes.to_a
p byteArray

puts "----nonce cifrada-----"
byteArray = File.open("nonce_cyphered_64.txt",'rb').bytes.to_a
p byteArray

puts "----nonce cifrada-----"
byteArray = File.open("bern.cert",'rb').bytes.to_a
p byteArray

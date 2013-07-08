package pt.ul.ist.aiss;

import java.io.IOException;
import org.apache.commons.codec.binary.Base64;

public class Base64Encoding {
	public Base64Encoding() {
	}
    public static void main(String args[]) throws IOException {
        String orig = "original String before base64 encoding in Java";

        //encoding  byte array into base 64
        byte[] encoded = Base64.encodeBase64(orig.getBytes());     
      
        System.out.println("Original String: " + orig );
        System.out.println("Base64 Encoded String : " + new String(encoded));
      
        //decoding byte array into base64
        byte[] decoded = Base64.decodeBase64(encoded);      
        System.out.println("Base 64 Decoded  String : " + new String(decoded));

        
        //testes aos novos metodos
        String teste = "A minha nova string de teste";
        System.out.println(teste);
        System.out.println(encodeStringTo64(teste));
        System.out.println(decodeStringFrom64(encodeStringTo64(teste)));
    }
    
    public static String encodeStringTo64(String input){
		byte[] encoded = Base64.encodeBase64(input.getBytes());
		String encoded_string = new String(encoded);
		return encoded_string;	
    }
    
    public static String decodeStringFrom64(String input){
    	byte[] decoded = Base64.decodeBase64(input.getBytes());
    	return new String(decoded);
    	
    }

}
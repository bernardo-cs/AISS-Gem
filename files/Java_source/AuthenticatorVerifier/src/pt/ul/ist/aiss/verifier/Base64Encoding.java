package pt.ul.ist.aiss.verifier;

import java.io.IOException;
import org.apache.commons.codec.binary.Base64;

public class Base64Encoding {
	public Base64Encoding() {
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
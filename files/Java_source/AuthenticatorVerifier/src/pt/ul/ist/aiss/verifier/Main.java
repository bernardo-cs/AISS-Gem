package pt.ul.ist.aiss.verifier;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PublicKey;
import java.security.SignatureException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;
import java.util.Arrays;


import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;

public class Main {
	
	public static void main(String args[]){
		
		String cert_path = args[0];
		String cyphered_nonce_path = args[1];
		String nonce_path = args[2];
		
		/**
		 * Ler as nonces de ficheiros
		 */
		String nonce = new String();
		try {
			nonce = FileUtils.readFileToString(new File(nonce_path));
		} catch (IOException e2) {
			System.out.println("Erro a ler nonce do ficheiro");
			e2.printStackTrace();
		}

		//System.out.println("nonce" + Arrays.toString(nonce.getBytes()));
		
		FileInputStream in = null;
		byte[] cyphered_key = null;
		try {
			cyphered_key = FileUtils.readFileToByteArray(new File(cyphered_nonce_path));
			cyphered_key = Base64.decodeBase64(cyphered_key);
		} catch (Exception e2) {
			System.out.println("nao conseguiu ler a chave");
			e2.printStackTrace();
		}
		//System.out.println("cypheredNonce" + Arrays.toString(cyphered_key));
		/**
		 * Ler a chave publica de um ficheiro
		 */
		
		X509Certificate crt = null;
		try {
			
			byte[] cert_bytes_64 = FileUtils.readFileToByteArray(
					new File(cert_path));
			byte[] cert_bytes = Base64.decodeBase64(cert_bytes_64);
			//System.out.println("pubKey" + Arrays.toString(cert_bytes));
			CertificateFactory cf = CertificateFactory.getInstance("X509");
			crt = (X509Certificate) cf.generateCertificate(new ByteArrayInputStream(cert_bytes));
		} catch (Exception e1) {
			System.out.println("nao conseguiu criar o certificado");
			e1.printStackTrace();
		}
		
		PublicKey pubKey = crt.getPublicKey();
		
		//System.out.println("pubKey" + Arrays.toString(pubKey.getEncoded()));
		//System.out.println("nonce" + Arrays.toString(nonce.getBytes()));
		//System.out.println("cypheredNonce" + Arrays.toString(cyphered_key));
		boolean result = false;
		 try {
			result = CryptoManagement.verifySignature(pubKey, nonce, cyphered_key);
		} catch (Exception e) {
			System.out.println("Erro a verificar a assinatura");
			e.printStackTrace();
		} 
		 
		if(result){
			System.out.println("Assinatura verificada com sucesso");
		}else {
			System.out.println("Assinatura nao verificada");
		}
		
	}

}

package pt.ul.ist.aiss;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.nio.charset.Charset;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.SignatureException;
import java.util.Arrays;

import javax.security.cert.CertificateEncodingException;
import javax.security.cert.X509Certificate;

import pteidlib.PteidException;
import sun.security.pkcs11.wrapper.PKCS11Exception;

public class Main {

	public static void main(String args[]){
		X509Certificate myCert = null;
		
		String cert_path_out = args[0];
		String cyphered_nonce_path_out = args[1];
		String nonce_in_path = args[2];
		
		
		
		try {
			myCert = CryptoManagement.getCertFromCC();
		} catch (PteidException e) {
			// TODO Auto-generated catch block
			System.out.println("Erro a retirar a chave publica de Autenticação do CC");
			System.out.println("Experimente desligar e voltar a ligar o leitor de cartoes,");
			System.out.println("e retirar e voltar a inserir o cartão");
			e.printStackTrace();
		}

		String nonce = new String();
		try {
			nonce = FileUtils.readFileToString(new File(nonce_in_path));
		} catch (IOException e2) {
			System.out.println("Erro a ler nonce do ficheiro");
			e2.printStackTrace();
		}
		
		byte[] cyphered_nonce = null ;
		try {
			cyphered_nonce = CryptoManagement.getCypheredNonceFromCC(nonce);
		} catch (Exception e) {
			System.out.println("Erro a gerar a hash do nonce no CC");
			e.printStackTrace();
		}
		
		// Passar tudo para ficheiros e tentar voltar a ler tudo de ficheiros para ter a certeza que esta nice :D
//		try {
//			FileUtils.writeStringToFile(new File(nonce_out_path), 
//					Base64Encoding.encodeStringTo64(nonce));
//		} catch (IOException e) {
//			System.out.println("Erro a escrever a hash do nonce no CC");
//			e.printStackTrace();
//		}

		
		try {
			FileUtils.writeByteArrayToFile(new File(cyphered_nonce_path_out),
					Base64.encodeBase64(cyphered_nonce));
		} catch (IOException e3) {
			System.out.println("Nao consegue escrever a private_key");
			e3.printStackTrace();
		}

		
		/**
		 * Gravar o certificado num ficheiro
		 */
		byte[] key_bytes = null;
		try {
			key_bytes = myCert.getEncoded();
		} catch (CertificateEncodingException e1) {
			System.out.println("erro a fazer decode do certificado");
			e1.printStackTrace();
		}
		try {
			FileUtils.writeByteArrayToFile(new File(cert_path_out), Base64.encodeBase64(key_bytes));
		} catch (IOException e1) {
			System.out.println("Erro a escrever a chave publica para um ficheiro");
			e1.printStackTrace();
		}

		
		/**
		 * Debug
		 */
		//System.out.println("pubKey" + Arrays.toString(myCert.getPublicKey().getEncoded()));
		//System.out.println("nonce" + Arrays.toString(nonce.getBytes()));
		//System.out.println("cypheredNonce" + Arrays.toString(cyphered_nonce));
		
		try {
			System.out.println(String.valueOf(CryptoManagement.verifySignature(myCert.getPublicKey(), nonce, cyphered_nonce)));
		} catch (InvalidKeyException e) {
			System.out.println("ola");
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			System.out.println("ola2");
			e.printStackTrace();
		} catch (SignatureException e) {
			System.out.println("ola3");
			e.printStackTrace();
		}
	}
}

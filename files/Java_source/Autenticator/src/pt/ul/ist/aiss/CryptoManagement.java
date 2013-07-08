package pt.ul.ist.aiss;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.Signature;
import java.security.SignatureException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;

import javax.security.cert.CertificateException;
import javax.security.cert.X509Certificate;

import pteidlib.PTEID_Certif;
import pteidlib.PTEID_ID;
import pteidlib.PteidException;
import pteidlib.pteid;

import sun.security.pkcs11.wrapper.CK_ATTRIBUTE;
import sun.security.pkcs11.wrapper.CK_C_INITIALIZE_ARGS;
import sun.security.pkcs11.wrapper.CK_MECHANISM;
import sun.security.pkcs11.wrapper.CK_SESSION_INFO;
import sun.security.pkcs11.wrapper.PKCS11;
import sun.security.pkcs11.wrapper.PKCS11Constants;
import sun.security.pkcs11.wrapper.PKCS11Exception;

public class CryptoManagement {

	public CryptoManagement(){

	}
	public static String getNonce(){
		String userName = new String();
		
		try {
			pteid.Init("");
		} catch (PteidException e1) {
			System.out.println("Erro a iniciar o CC tipo 1");
			e1.printStackTrace();
		}

		try {
			pteid.SetSODChecking(false);
		} catch (PteidException e1) {
			System.out.println("Erro a iniciar o CC tipo 2");
			e1.printStackTrace();
		}

		int cardtype = 0;
		try {
			cardtype = pteid.GetCardType();
		} catch (PteidException e1) {
			System.out.println("Erro a iniciar o CC tipo 3: nao consegue ler o tipo do cartao");
			e1.printStackTrace();
		}
		switch (cardtype)
		{
		case pteid.CARD_TYPE_IAS07:
			System.out.println("IAS 0.7 card\n");
			break;
		case pteid.CARD_TYPE_IAS101:
			System.out.println("IAS 1.0.1 card\n");
			break;
		case pteid.CARD_TYPE_ERR:
			System.out.println("Unable to get the card type\n");
			break;
		default:
			System.out.println("Unknown card type\n");
		}

		// Read ID Data
		PTEID_ID idData=null;
		try {
			idData = pteid.GetID();
		} catch (PteidException e) {
			System.out.println("Erro a tentar ir buscar o nome ao CC");
			e.printStackTrace();
		}
		if (null != idData)
		{
			userName = idData.name;
		}
		
		//vai buscar a data de hoje
		DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		return "_:_ " + userName + " _:_ " + dateFormat.format(cal.getTime());
		
	}

	public static X509Certificate getCertFromCC() throws PteidException{
		try {
			System.loadLibrary("pteidlibj");
		}
		catch (UnsatisfiedLinkError e){
			System.err.println("error loading library");
			System.exit(1);
		}

		pteid.Init("");
		pteid.SetSODChecking(false);
		PTEID_Certif[] certs = pteid.GetCertificates();

		X509Certificate cert = null;
		try {
			cert = X509Certificate.getInstance(certs[0].certif);
		} catch (CertificateException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		return cert;
	}

	public static byte[] getCypheredNonceFromCC(String nonce) throws ClassNotFoundException, SecurityException, NoSuchMethodException, IllegalArgumentException, IllegalAccessException, InvocationTargetException, PKCS11Exception{
		/**
		 * get Pkcs11 session
		 */
		PKCS11 pkcs11 = null;
		String javaVersion = System.getProperty("java.version");
		String osName = System.getProperty("os.name");
		String libName = "libbeidpkcs11.so";
		if (-1 != osName.indexOf("Windows"))
			libName = "pteidpkcs11.dll";
		else if (-1 != osName.indexOf("Mac"))
			libName = "pteidpkcs11.dylib";
		Class pkcs11Class = Class.forName("sun.security.pkcs11.wrapper.PKCS11");
		if (javaVersion.startsWith("1.5."))
		{
			Method getInstanceMethode = pkcs11Class.getDeclaredMethod("getInstance", new Class[] { String.class, CK_C_INITIALIZE_ARGS.class, boolean.class });
			pkcs11 = (PKCS11)getInstanceMethode.invoke(null, new Object[] { libName, null, false });
		}
		else
		{
			Method getInstanceMethode = pkcs11Class.getDeclaredMethod("getInstance", new Class[] { String.class, String.class, CK_C_INITIALIZE_ARGS.class, boolean.class });
			pkcs11 = (PKCS11)getInstanceMethode.invoke(null, new Object[] { libName, "C_GetFunctionList", null, false });
		}

		long p11_session = pkcs11.C_OpenSession(0, PKCS11Constants.CKF_SERIAL_SESSION, null, null);

		//Open the PKCS11 session

		// Token login 
		pkcs11.C_Login(p11_session, 1, null);
		CK_SESSION_INFO info = pkcs11.C_GetSessionInfo(p11_session);

		// Get available keys 
		CK_ATTRIBUTE[] attributes = new CK_ATTRIBUTE[1];
		attributes[0] = new CK_ATTRIBUTE();
		attributes[0].type = PKCS11Constants.CKA_CLASS;
		attributes[0].pValue = new Long(PKCS11Constants.CKO_PRIVATE_KEY);

		pkcs11.C_FindObjectsInit(p11_session, attributes);
		long[] keyHandles = pkcs11.C_FindObjects(p11_session, 5);

		// points to auth_key 
		long signatureKey = keyHandles[0];		//test with other keys to see what you get
		pkcs11.C_FindObjectsFinal(p11_session);


		// initialize the signature method 
		CK_MECHANISM mechanism = new CK_MECHANISM();
		mechanism.mechanism = PKCS11Constants.CKM_SHA1_RSA_PKCS;
		mechanism.pParameter = null;
		pkcs11.C_SignInit(p11_session, mechanism, signatureKey);

		/**
		 * Assina o nonce
		 */
		byte[] signed_nonce = pkcs11.C_Sign(p11_session, nonce.getBytes());
		//System.out.println("nonce acabada de assinar" + Arrays.toString(signed_nonce));
		return signed_nonce;
	}

	public static boolean verifySignature(PublicKey myPublicKey, String nonce, byte[] signed_nonce) throws InvalidKeyException, NoSuchAlgorithmException, SignatureException{
		Signature signature = Signature.getInstance("SHA1withRSA");
		signature.initVerify(myPublicKey);
		signature.update(nonce.getBytes());
		boolean ok = signature.verify(signed_nonce);

		return ok;
	}
}

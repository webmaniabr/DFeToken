import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.regex.Pattern;
import org.json.JSONObject;

public class SecureToken {
    
    public static String createSecureTokenDFe(String password, String uuid) throws Exception {
        // Remove all non-numeric characters from the password
        password = password.replaceAll("[^0-9]", "");

        // Generate the key using SHA-256
        String keySource = password + ":" + uuid;
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] key = digest.digest(keySource.getBytes(StandardCharsets.UTF_8));

        // Generate the IV
        SecureRandom random = new SecureRandom();
        byte[] iv = new byte[16];
        random.nextBytes(iv);

        // Encrypt the current time
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKeySpec secretKeySpec = new SecretKeySpec(key, "AES");
        IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);
        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);

        long currentTime = System.currentTimeMillis() / 1000L;
        String timeString = Long.toString(currentTime);
        byte[] timeBytes = timeString.getBytes(StandardCharsets.UTF_8);
        byte[] encryptedData = cipher.doFinal(timeBytes);

        // Prepare the token data
        JSONObject tokenData = new JSONObject();
        tokenData.put("data", Base64.getEncoder().encodeToString(encryptedData));
        tokenData.put("iv", Base64.getEncoder().encodeToString(iv));

        String tokenJson = tokenData.toString();
        return Base64.getUrlEncoder().encodeToString(tokenJson.getBytes(StandardCharsets.UTF_8));
    }

    public static void main(String[] args) {
        try {
            String password = "00.000.000/0000-00"; // CPF/CNPJ do tomador
            String uuid = "00000000-0000-0000-0000-000000000000"; // UUID da nota fiscal
            String key = "00000000000000000000000000000000000000000000"; // Chave da nota fiscal
            String token = createSecureTokenDFe(password, uuid);
            String url = "https://nfe.webmaniabr.com/danfe/" + key + "/?token=" + token;

            System.out.println(url);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

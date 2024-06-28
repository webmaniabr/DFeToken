using System;
using System.Security.Cryptography;
using System.Text;
using Newtonsoft.Json;

public class SecureToken
{
    public static string CreateSecureTokenDFe(string password, string uuid)
    {
        password = System.Text.RegularExpressions.Regex.Replace(password, "[^0-9]", "");
        using (SHA256 sha256 = SHA256.Create())
        {
            string keySource = password + ":" + uuid;
            byte[] key = sha256.ComputeHash(Encoding.UTF8.GetBytes(keySource));
            using (Aes aes = Aes.Create())
            {
                aes.Key = key;
                aes.GenerateIV();
                byte[] iv = aes.IV;
                aes.Mode = CipherMode.CBC;
                aes.Padding = PaddingMode.PKCS7;
                using (ICryptoTransform encryptor = aes.CreateEncryptor(aes.Key, iv))
                {
                    string timeString = DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString();
                    byte[] timeBytes = Encoding.UTF8.GetBytes(timeString);
                    byte[] encryptedData = encryptor.TransformFinalBlock(timeBytes, 0, timeBytes.Length);
                    var tokenData = new
                    {
                        data = Convert.ToBase64String(encryptedData),
                        iv = Convert.ToBase64String(iv)
                    };
                    string tokenJson = JsonConvert.SerializeObject(tokenData);
                    return Uri.EscapeDataString(Convert.ToBase64String(Encoding.UTF8.GetBytes(tokenJson)));
                }
            }
        }
    }

    public static void Main()
    {
        string password = "00.000.000/0000-00"; // CPF/CNPJ do tomador
        string uuid = "00000000-0000-0000-0000-000000000000"; // UUID da nota fiscal
        string key = "00000000000000000000000000000000000000000000"; // Chave da nota fiscal
        string token = CreateSecureTokenDFe(password, uuid);
        string url = $"https://nfe.webmaniabr.com/danfe/{key}/?token={token}";

        Console.WriteLine(url);
    }
}

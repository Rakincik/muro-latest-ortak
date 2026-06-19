using System;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

class Program
{
    static async Task Main(string[] args)
    {
        // 1. Secret ve URL'leri tanımla
        var secret = "DJcEz4jbbLaA4WeBdGQ3tva0n8UXCrdm0ZVU42Ubc";
        var bbbUrl = "https://canli.monopoluzem.com.tr/bigbluebutton/api";
        var callbackUrl = "https://online.monopoluzem.com.tr/api/v1/bbb/webhook/events"; // /events eklendi

        // 2. QueryString oluştur
        var qs = "callbackURL=" + Uri.EscapeDataString(callbackUrl);

        // 3. Checksum hesapla (bbb-webhooks modülü SHA1 kullanır!)
        var dataToHash = "hooks/create" + qs + secret;
        var bytes = Encoding.UTF8.GetBytes(dataToHash);
        var hash = SHA1.HashData(bytes);
        var checksum = Convert.ToHexString(hash).ToLowerInvariant();

        // 4. İsteği gönder
        var url = $"{bbbUrl}/hooks/create?{qs}&checksum={checksum}";
        
        Console.WriteLine($"Webhook kayıt URL'i:\n{url}\n");

        using var client = new HttpClient();
        try
        {
            var response = await client.GetAsync(url);
            var content = await response.Content.ReadAsStringAsync();
            
            Console.WriteLine($"HTTP Status: {response.StatusCode}");
            Console.WriteLine($"Response:\n{content}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Hata oluştu: {ex.Message}");
        }
    }
}

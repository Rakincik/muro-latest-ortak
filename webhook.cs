using System;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

class Program {
    static async Task Main() {
        var secret = "HMAeOSDnwXfzjoocaiCS2AEj2zTZE9PwS6HPqgkXk";
        var bbbUrl = "https://bbb.gikart.com.tr/bigbluebutton/api";
        var callbackUrl = "https://api-muro.on7medya.com/api/v1/bbb/webhook";
        var qs = "callbackURL=" + Uri.EscapeDataString(callbackUrl);
        var data = "hooks/create" + qs + secret;
        var bytes = Encoding.UTF8.GetBytes(data);
        var hash = SHA256.HashData(bytes);
        var checksum = Convert.ToHexString(hash).ToLowerInvariant();
        var url = $"{bbbUrl}/hooks/create?{qs}&checksum={checksum}";
        
        Console.WriteLine($"URL: {url}");
        using var client = new HttpClient();
        var response = await client.GetAsync(url);
        var content = await response.Content.ReadAsStringAsync();
        Console.WriteLine($"Response: {content}");
    }
}

using System;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

class Program {
    static async Task Main() {
        var sharedSecret = "muro-webhook-secret-2024";
        var endpointUrl = "https://api-muro.on7medya.com/api/v1/bbb/webhook";
        var rawBody = "[\n  {\n    \"event\": \"{\\\"data\\\":{\\\"id\\\":\\\"rap-publish-ended\\\",\\\"attributes\\\":{\\\"meeting\\\":{\\\"externalMeetingId\\\":\\\"monopol_b1f37028-b263-4240-84b9-184140401d8a\\\"},\\\"recordId\\\":\\\"edb31878a6bc7710af814bf06b262e7d2348bd25-1781818721158\\\"}}}\"\n  }\n]";
        
        var dataToHash = endpointUrl + rawBody + sharedSecret;
        var hashBytes = SHA256.HashData(Encoding.UTF8.GetBytes(dataToHash));
        var checksum = Convert.ToHexString(hashBytes).ToLowerInvariant();
        
        var requestUrl = $"{endpointUrl}?checksum={checksum}";
        Console.WriteLine($"Requesting: {requestUrl}");
        
        using var client = new HttpClient();
        var content = new StringContent(rawBody, Encoding.UTF8, "application/json");
        var response = await client.PostAsync(requestUrl, content);
        
        var resText = await response.Content.ReadAsStringAsync();
        Console.WriteLine($"Status: {response.StatusCode}");
        Console.WriteLine($"Response: {resText}");
    }
}

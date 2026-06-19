using System;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;

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
var client = new HttpClient();
var response = client.GetAsync(url).Result;
var content = response.Content.ReadAsStringAsync().Result;
Console.WriteLine($"Response: {content}");

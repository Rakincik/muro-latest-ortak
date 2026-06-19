using System;
using System.Security.Cryptography;
using System.Text;

var sharedSecret = "muro-webhook-secret-2024";
var endpointUrl = "http://localhost:5293/api/v1/bbb/webhook/events";
var rawBody = "{\"events\":[{\"eventType\":\"recording-ready\",\"meetingId\":\"monopol_b1f37028-b263-4240-84b9-184140401d8a\",\"sessionId\":\"b1f37028-b263-4240-84b9-184140401d8a\",\"recordingUrl\":\"https://bbb.gikart.com.tr/presentation/edb31878a6bc7710af814bf06b262e7d2348bd25-1781818721158/presentation/\"}]}";

var dataToHash = endpointUrl + rawBody + sharedSecret;
var hashBytes = SHA256.HashData(Encoding.UTF8.GetBytes(dataToHash));
var checksum = Convert.ToHexString(hashBytes).ToLowerInvariant();

var base64 = Convert.ToBase64String(Encoding.UTF8.GetBytes(rawBody));
Console.WriteLine($"Checksum: {checksum}");
Console.WriteLine($"Base64: {base64}");

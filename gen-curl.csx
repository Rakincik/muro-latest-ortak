using System;
using System.Security.Cryptography;
using System.Text;

var sharedSecret = "muro-webhook-secret-2024";
var endpointUrl = "http://localhost:5293/api/v1/bbb/webhook/events";
var rawBody = "[{\"event\":\"{\\\"data\\\":{\\\"id\\\":\\\"rap-publish-ended\\\",\\\"attributes\\\":{\\\"meeting\\\":{\\\"externalMeetingId\\\":\\\"monopol_b1f37028-b263-4240-84b9-184140401d8a\\\"},\\\"recordId\\\":\\\"edb31878a6bc7710af814bf06b262e7d2348bd25-1781818721158\\\"}}}\"}]";

var dataToHash = endpointUrl + rawBody + sharedSecret;
var hashBytes = SHA256.HashData(Encoding.UTF8.GetBytes(dataToHash));
var checksum = Convert.ToHexString(hashBytes).ToLowerInvariant();

Console.WriteLine($"Checksum: {checksum}");
Console.WriteLine($"curl -X POST \"{endpointUrl}?checksum={checksum}\" -H \"Content-Type: application/json\" -d '{rawBody}'");

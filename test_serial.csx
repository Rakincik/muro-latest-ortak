using System;
using System.Text.Json;
using System.Security.Cryptography;
using System.Text;

public record PurchaseWebhookRequest(
    string TenantCode,
    string PackageIdentifier,
    string UserEmail,
    string UserFirstName,
    string UserLastName,
    string UserPhone,
    string OrderId,
    DateTime PaidAt
);

var request = new PurchaseWebhookRequest(
    "derece",
    "017",
    "test_student_dereceuzem@example.com",
    "Test",
    "Öğrenci",
    "5551234567",
    "test_order_1785317109823",
    DateTime.Parse("2026-07-29T09:25:09.823Z").ToUniversalTime()
);

var json = JsonSerializer.Serialize(request);
Console.WriteLine("C# Serialized JSON:");
Console.WriteLine(json);

var secret = "MuroDemo_Webhook2026!";
using (var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(secret)))
{
    var hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(json));
    var expected = Convert.ToHexString(hash).ToLowerInvariant();
    Console.WriteLine("\nExpected Signature (C#):");
    Console.WriteLine(expected);
}

using System;
using System.Text.Json;

var rawBody = "[{\"event\":\"{\\\"data\\\":{\\\"id\\\":\\\"rap-publish-ended\\\",\\\"attributes\\\":{\\\"meeting\\\":{\\\"externalMeetingId\\\":\\\"monopol_b1f37028-b263-4240-84b9-184140401d8a\\\"},\\\"recordId\\\":\\\"edb31878a6bc7710af814bf06b262e7d2348bd25-1781818721158\\\"}}}\"}]";

try {
    var bbbArray = JsonDocument.Parse(rawBody).RootElement;
    foreach (var item in bbbArray.EnumerateArray()) {
        if (item.TryGetProperty("event", out var eventStrProp)) {
            var eventStr = eventStrProp.GetString();
            Console.WriteLine(eventStr);
            var doc = JsonDocument.Parse(eventStr);
            Console.WriteLine("Parsed eventStr successfully");
        }
    }
} catch (Exception ex) {
    Console.WriteLine(ex.ToString());
}

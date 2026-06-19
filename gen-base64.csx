using System;
using System.Text;

var payload = "[{\"event\":\"{\\\"data\\\":{\\\"id\\\":\\\"rap-publish-ended\\\",\\\"attributes\\\":{\\\"meeting\\\":{\\\"externalMeetingId\\\":\\\"monopol_b1f37028-b263-4240-84b9-184140401d8a\\\"},\\\"recordId\\\":\\\"edb31878a6bc7710af814bf06b262e7d2348bd25-1781818721158\\\"}}}\"}]";
var base64 = Convert.ToBase64String(Encoding.UTF8.GetBytes(payload));
Console.WriteLine(base64);

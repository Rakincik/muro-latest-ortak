const crypto = require('crypto');
const secret = 'MuroDemo_Webhook2026!';

// JS String with escaped unicode character sequence exactly matching C#
const rawJson = '{"TenantCode":"derece","PackageIdentifier":"017","UserEmail":"test_student_dereceuzem@example.com","UserFirstName":"Test","UserLastName":"\\u00D6\\u011Frenci","UserPhone":"5551234567","OrderId":"test_order_1785317109823","PaidAt":"2026-07-29T09:25:09.823Z"}';

const sig = crypto.createHmac('sha256', secret).update(rawJson).digest('hex');
console.log("Expected: 6b134696af2436d1d13f1601adcaab9d6638a5252661aae69a0df72dfb66d614");
console.log("Calculated: " + sig);

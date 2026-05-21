using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using MURO.Infrastructure.Persistence;
using Microsoft.Extensions.DependencyInjection;
using System.Collections.Generic;

var services = new ServiceCollection();
services.AddDbContext<MuroDbContext>(opts => opts.UseNpgsql(""Host=localhost;Port=5432;Database=muro_dev;Username=muro_user;Password=muro_pass_2024""));
var provider = services.BuildServiceProvider();
var db = provider.GetRequiredService<MuroDbContext>();

var tenant = db.Tenants.FirstOrDefault(t => t.Id == Guid.Parse(""11111111-1111-1111-1111-111111111111""));
if (tenant != null) {
    Console.WriteLine(""Features JSON: "" + tenant.Features);
    
    // Add it if missing
    var featuresStr = tenant.Features ?? ""{}"";
    var featuresObj = System.Text.Json.JsonSerializer.Deserialize<Dictionary<string, object>>(featuresStr) ?? new Dictionary<string, object>();
    featuresObj[""exams""] = true;
    tenant.Features = System.Text.Json.JsonSerializer.Serialize(featuresObj);
    db.SaveChanges();
    Console.WriteLine(""Added 'exams': true to tenant features."");
} else {
    Console.WriteLine(""Tenant not found"");
}

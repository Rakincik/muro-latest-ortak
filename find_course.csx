using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using MURO.Infrastructure.Persistence;

var optionsBuilder = new DbContextOptionsBuilder<MuroDbContext>();
optionsBuilder.UseNpgsql("Host=31.214.152.143;Port=5434;Database=muro_prod;Username=muro_user;Password=MuroDb2026!Pr0d");
using var db = new MuroDbContext(optionsBuilder.Options);

var courses = db.Courses.Where(c => c.Title.Contains("HUKUK") || c.Title.Contains("HUKUK YOÐUN")).Select(c => new { c.Id, c.Title, c.TenantId }).Take(10).ToList();
foreach(var c in courses) {
    Console.WriteLine($"ID: {c.Id} | Title: {c.Title} | Tenant: {c.TenantId}");
}

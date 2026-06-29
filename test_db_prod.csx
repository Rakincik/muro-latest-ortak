using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using MURO.Infrastructure.Persistence;

var optionsBuilder = new DbContextOptionsBuilder<MuroDbContext>();
optionsBuilder.UseNpgsql("Host=31.214.152.143;Port=5434;Database=muro_prod;Username=muro_user;Password=MuroDb2026!Pr0d");
using var db = new MuroDbContext(optionsBuilder.Options);

var assets = db.MediaAssets.OrderByDescending(a => a.CreatedAt).Take(5).ToList();
Console.WriteLine("Recent assets:");
foreach (var a in assets)
{
    Console.WriteLine($"ID: {a.Id}\nTitle: {a.Title}\nFilePath: {a.FilePath}\nHlsPath: {a.HlsPath}\nStatus: {a.Status}\nCreatedAt: {a.CreatedAt}\n---");
}

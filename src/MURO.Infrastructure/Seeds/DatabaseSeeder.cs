using Microsoft.EntityFrameworkCore;
using MURO.Domain.Entities;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Seeds;

public static class DatabaseSeeder
{
    public static async Task SeedAsync(MuroDbContext db)
    {
        // ── Admin user ────────────────────────────────────────────────────────
        var adminEmail = "admin@monopol.com.tr";
        var admin = await db.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Email == adminEmail);
        if (admin == null)
        {
            admin = new User
            {
                Id           = Guid.NewGuid(),
                FirstName    = "Monopol",
                LastName     = "Admin",
                Email        = adminEmail,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("123456"),
                Role         = UserRole.Admin,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(admin);
        }
        else
        {
            admin.PasswordHash = BCrypt.Net.BCrypt.HashPassword("123456");
            admin.IsActive     = true;
            admin.Role         = UserRole.Admin;
            db.Users.Update(admin);
        }

        // ── Demo user ─────────────────────────────────────────────────────────
        var studentEmail = "ogrenci@demo.com";
        var student = await db.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Email == studentEmail);
        if (student == null)
        {
            student = new User
            {
                Id           = Guid.NewGuid(),
                FirstName    = "Demo",
                LastName     = "Öğrenci",
                Email        = studentEmail,
                PasswordHash = "123456",
                Role         = UserRole.Student,
                StudentType  = StudentType.Active,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(student);
        }
        else
        {
            student.PasswordHash = "123456";
            student.IsActive     = true;
            db.Users.Update(student);
        }

        await db.SaveChangesAsync();
    }
}

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
                Username     = adminEmail,
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
                Username     = studentEmail,
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

        // ── Rüstem SuperAdmin ────────────────────────────────────────────────
        var rustemEmail = "rustemakincik@on7yazilim.com";
        var rustem = await db.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Email == rustemEmail);
        if (rustem == null)
        {
            rustem = new User
            {
                Id           = Guid.NewGuid(),
                FirstName    = "Rüstem",
                LastName     = "Akıncık",
                Email        = rustemEmail,
                Username     = rustemEmail,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("123456"),
                Role         = UserRole.SuperAdmin,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(rustem);
        }
        else
        {
            rustem.PasswordHash = BCrypt.Net.BCrypt.HashPassword("123456");
            rustem.IsActive     = true;
            rustem.Role         = UserRole.SuperAdmin;
            db.Users.Update(rustem);
        }

        // ── Osman SuperAdmin ────────────────────────────────────────────────
        var osmanEmail = "osmanbadilli@on7yazilim.com";
        var osman = await db.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Email == osmanEmail || u.Email == "osmanbadilli");
        if (osman == null)
        {
            osman = new User
            {
                Id           = Guid.NewGuid(),
                FirstName    = "Osman",
                LastName     = "Badıllı",
                Email        = osmanEmail,
                Username     = osmanEmail,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("osman6363"),
                Role         = UserRole.SuperAdmin,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(osman);
        }
        else
        {
            osman.PasswordHash = BCrypt.Net.BCrypt.HashPassword("osman6363");
            db.Users.Update(osman);
        }

        // ── Volkan SuperAdmin ────────────────────────────────────────────────
        var volkanEmail = "volkancetin@on7yazilim.com";
        var volkan = await db.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Email == volkanEmail || u.Email == "volkancetin");
        if (volkan == null)
        {
            volkan = new User
            {
                Id           = Guid.NewGuid(),
                FirstName    = "Volkan",
                LastName     = "Çetin",
                Email        = volkanEmail,
                Username     = volkanEmail,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("vc0606"),
                Role         = UserRole.SuperAdmin,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(volkan);
        }
        else
        {
            volkan.PasswordHash = BCrypt.Net.BCrypt.HashPassword("vc0606");
            db.Users.Update(volkan);
        }

        await db.SaveChangesAsync();
    }
}
